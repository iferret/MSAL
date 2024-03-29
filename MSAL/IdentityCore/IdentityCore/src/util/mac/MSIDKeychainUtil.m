// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MSIDKeychainUtil.h"
#import "MSIDKeychainUtil+Internal.h"
#import "MSIDKeychainUtil+MacInternal.h"

static NSString *MSIDKeychainAccessGroupEntitlement = @"keychain-access-groups";

@implementation MSIDKeychainUtil

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.teamId = [self getTeamId];
        self.applicationBundleIdentifier = [self getApplicationBundleIdentifier];
    }
    
    return self;
}

+ (MSIDKeychainUtil *)sharedInstance
{
    static MSIDKeychainUtil *singleton = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (NSString *)getTeamId
{
    NSString *keychainTeamId = nil;
    SecCodeRef selfCode = NULL;
    SecCodeCopySelf(kSecCSDefaultFlags, &selfCode);
    
    if (selfCode)
    {
        CFDictionaryRef cfDic = NULL;
        SecCodeCopySigningInformation(selfCode, kSecCSSigningInformation, &cfDic);
        
        if (!cfDic)
        {
            MSID_LOG_WITH_CTX(MSIDLogLevelError, nil, @"Failed to retrieve code signing information");
        }
        else
        {
            NSDictionary *signingDic = CFBridgingRelease(cfDic);
            NSString *appIdPrefix = [self appIdPrefixFromSigningInformation:signingDic];
            keychainTeamId = appIdPrefix ? appIdPrefix : [self teamIdFromSigningInformation:signingDic];
        }
        CFRelease(selfCode);
    }
    
    if (!keychainTeamId)
    {
        MSID_LOG_WITH_CTX(MSIDLogLevelError, nil, @"Failed to retrieve team identifier. Using bundle Identifier instead.");\
        keychainTeamId = [[NSBundle mainBundle] bundleIdentifier];

        if (!keychainTeamId)
        {
            MSID_LOG_WITH_CTX(MSIDLogLevelError, nil, @"Failed to retrieve bundle identifier. Using process name instead.");
            keychainTeamId = [NSProcessInfo processInfo].processName;
        }
    }

    MSID_LOG_WITH_CTX_PII(MSIDLogLevelInfo, nil, @"Using \"%@\" Team ID.", MSID_PII_LOG_MASKABLE(keychainTeamId));
    return keychainTeamId;
}

- (NSString *)getApplicationBundleIdentifier
{
    
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];

    if ([NSString msidIsStringNilOrBlank:bundleId])
    {
        SecCodeRef selfCode = NULL;
        SecCodeCopySelf(kSecCSDefaultFlags, &selfCode);
        
        if (selfCode)
        {
            CFDictionaryRef cfDic = NULL;
            SecCodeCopySigningInformation(selfCode, kSecCSSigningInformation, &cfDic);
            
            if (!cfDic)
            {
                MSID_LOG_WITH_CTX(MSIDLogLevelError, nil, @"Failed to retrieve code signing information");
            }
            else
            {
                NSDictionary *signingDic = CFBridgingRelease(cfDic);
                bundleId = [signingDic objectForKey:(__bridge NSString*)kSecCodeInfoIdentifier];
            }
            CFRelease(selfCode);
        }
    }
    
    return bundleId;
}


- (NSString *)accessGroup:(NSString *)group
{
    if (!group)
    {
        return nil;
    }
    
    if (!self.teamId)
    {
        return nil;
    }
    
    return [[NSString alloc] initWithFormat:@"%@.%@", self.teamId, group];
}

#pragma mark - Signing group prefix

- (NSString *)teamIdFromSigningInformation:(NSDictionary *)signingInformation
{
    return [signingInformation objectForKey:(__bridge NSString*)kSecCodeInfoTeamIdentifier];
}

- (NSString *)appIdPrefixFromSigningInformation:(NSDictionary *)signingInformation
{
    NSDictionary *entitlementsDictionary = [signingInformation msidObjectForKey:(__bridge NSString*)kSecCodeInfoEntitlementsDict ofClass:[NSDictionary class]];
    NSArray *keychainGroups = [entitlementsDictionary msidObjectForKey:MSIDKeychainAccessGroupEntitlement ofClass:[NSArray class]];
    
    NSString *keychainTeamId = nil;
    
    if (keychainGroups && [keychainGroups count])
    {
        NSString *firstGroup = keychainGroups[0];
        NSArray *components = [firstGroup componentsSeparatedByString:@"."];
        
        if ([components count] > 1)
        {
            NSString *bundleSeedID = [components firstObject];
            keychainTeamId = [bundleSeedID length] ? bundleSeedID : nil;
        }
    }
    
    return keychainTeamId;
}

- (BOOL)isAppEntitled
{
    static dispatch_once_t once;
    static BOOL appEntitled = NO;
    
    dispatch_once(&once, ^{
        SecCodeRef selfCode = NULL;
        SecCodeCopySelf(kSecCSDefaultFlags, &selfCode);
        
        if (selfCode)
        {
            CFDictionaryRef cfDic = NULL;
            SecCodeCopySigningInformation(selfCode, kSecCSSigningInformation, &cfDic);
            
            if (!cfDic)
            {
                MSID_LOG_WITH_CTX(MSIDLogLevelError, nil, @"Failed to retrieve code signing information");
            }
            else
            {
                NSDictionary *signingDic = CFBridgingRelease(cfDic);
                NSDictionary *entitlementsDictionary = [signingDic msidObjectForKey:(__bridge NSString*)kSecCodeInfoEntitlementsDict ofClass:[NSDictionary class]];
                NSArray *keychainGroups = [entitlementsDictionary msidObjectForKey:@"keychain-access-groups" ofClass:[NSArray class]];
                
                for (id element in keychainGroups) {
                    if ([element hasSuffix:@"com.microsoft.identity.universalstorage"])
                    {
                        appEntitled = YES;
                        break;
                    }
                }
            }
            
            CFRelease(selfCode);
        }
    });
    
    return appEntitled;
}

@end
