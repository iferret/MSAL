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

#import <XCTest/XCTest.h>
#import "MSIDLegacyTokenCacheItem.h"
#import "NSDictionary+MSIDTestUtil.h"
#import "NSKeyedUnarchiver+MSIDExtensions.h"

@interface MSIDLegacyTokenCacheItemTests : XCTestCase

@end

@implementation MSIDLegacyTokenCacheItemTests

- (void)testKeyedArchivingSingleResourceToken_whenAllFieldsSet_shouldReturnSameTokenOnDeserialize
{
    MSIDLegacyTokenCacheItem *cacheItem = [MSIDLegacyTokenCacheItem new];
    cacheItem.accessToken = @"at";
    cacheItem.refreshToken = @"rt";
    cacheItem.idToken = @"id";
    cacheItem.oauthTokenType = @"token type";
    cacheItem.environment = @"login.microsoftonline.com";
    cacheItem.realm = @"contoso.com";
    cacheItem.clientId = @"client";
    cacheItem.credentialType = MSIDLegacySingleResourceTokenType;
    cacheItem.secret = @"at";
    cacheItem.target = @"resource";
    cacheItem.realm = @"contoso.com";
    cacheItem.environment = @"login.microsoftonline.com";

    NSDate *expiresOn = [NSDate date];
    NSDate *cachedAt = [NSDate date];
    NSDate *extExpiresOn = [NSDate date];

    cacheItem.expiresOn = expiresOn;
    cacheItem.extendedExpiresOn = extExpiresOn;
    cacheItem.cachedAt = cachedAt;
    cacheItem.familyId = @"family";
    cacheItem.homeAccountId = @"uid.utid";
    cacheItem.speInfo = @"2";
    NSDictionary *additionalInfo = @{@"test": @"test"};
    cacheItem.additionalInfo = additionalInfo;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cacheItem requiringSecureCoding:YES error:nil];

    XCTAssertNotNil(data);

    NSKeyedUnarchiver *unarchiver = [NSKeyedUnarchiver msidCreateForReadingFromData:data error:nil];
    XCTAssertNotNil(unarchiver);
    
    MSIDLegacyTokenCacheItem *newItem = [unarchiver decodeObjectOfClass:[MSIDLegacyTokenCacheItem class] forKey:NSKeyedArchiveRootObjectKey];

    XCTAssertNotNil(newItem);
    XCTAssertEqualObjects(newItem.accessToken, @"at");
    XCTAssertEqualObjects(newItem.refreshToken, @"rt");
    XCTAssertEqualObjects(newItem.idToken, @"id");
    XCTAssertEqualObjects(newItem.oauthTokenType, @"token type");
    XCTAssertEqualObjects(newItem.environment, @"login.microsoftonline.com");
    XCTAssertEqualObjects(newItem.realm, @"contoso.com");
    XCTAssertEqualObjects(newItem.clientId, @"client");
    XCTAssertEqual(newItem.credentialType, MSIDLegacySingleResourceTokenType);
    XCTAssertEqualObjects(newItem.secret, @"at");
    XCTAssertEqualObjects(newItem.target, @"resource");
    XCTAssertEqualObjects(newItem.realm, @"contoso.com");
    XCTAssertEqualObjects(newItem.environment, @"login.microsoftonline.com");
    XCTAssertEqualObjects(newItem.expiresOn, expiresOn);
    XCTAssertEqualObjects(newItem.extendedExpiresOn, extExpiresOn);
    XCTAssertEqualObjects(newItem.cachedAt, cachedAt);
    XCTAssertEqualObjects(newItem.familyId, @"family");
    XCTAssertEqualObjects(newItem.homeAccountId, @"uid.utid");
    XCTAssertEqualObjects(newItem.speInfo, @"2");
    XCTAssertEqualObjects(newItem.additionalInfo, additionalInfo);
}

- (void)testKeyedArchivingAccessToken_whenAllFieldsSet_shouldReturnSameTokenOnDeserialize
{
    MSIDLegacyTokenCacheItem *cacheItem = [MSIDLegacyTokenCacheItem new];
    cacheItem.accessToken = @"at";
    cacheItem.idToken = @"id";
    cacheItem.oauthTokenType = @"token type";
    cacheItem.environment = @"login.microsoftonline.com";
    cacheItem.realm = @"contoso.com";
    cacheItem.clientId = @"client";
    cacheItem.credentialType = MSIDAccessTokenType;
    cacheItem.secret = @"at";
    cacheItem.target = @"resource";
    cacheItem.realm = @"contoso.com";
    cacheItem.environment = @"login.microsoftonline.com";

    NSDate *expiresOn = [NSDate date];
    NSDate *cachedAt = [NSDate date];
    NSDate *extExpiresOn = [NSDate date];

    cacheItem.expiresOn = expiresOn;
    cacheItem.extendedExpiresOn = extExpiresOn;
    cacheItem.cachedAt = cachedAt;
    cacheItem.homeAccountId = @"uid.utid";
    cacheItem.speInfo = @"2";
    NSDictionary *additionalInfo = @{@"scope": @"user_impersonation",
                                     @"correlation_id": @"97c58ae8-bf7e-438f-8710-2ad89c69ec1c",
                                     @"ext_expires_on": [NSDate date],
                                     @"not_before": @1580181520,
                                     @"url": [NSURL URLWithString:@"https://login.microsoftonline.com/common/oauth2/token"]    };
    cacheItem.additionalInfo = additionalInfo;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cacheItem requiringSecureCoding:YES error:nil];

    XCTAssertNotNil(data);

    NSKeyedUnarchiver *unarchiver = [NSKeyedUnarchiver msidCreateForReadingFromData:data error:nil];
    XCTAssertNotNil(unarchiver);
    
    MSIDLegacyTokenCacheItem *newItem = [unarchiver decodeObjectOfClass:[MSIDLegacyTokenCacheItem class] forKey:NSKeyedArchiveRootObjectKey];

    XCTAssertNotNil(newItem);
    XCTAssertEqualObjects(newItem.accessToken, @"at");
    XCTAssertEqualObjects(newItem.idToken, @"id");
    XCTAssertEqualObjects(newItem.oauthTokenType, @"token type");
    XCTAssertEqualObjects(newItem.realm, @"contoso.com");
    XCTAssertEqualObjects(newItem.environment, @"login.microsoftonline.com");
    XCTAssertEqualObjects(newItem.clientId, @"client");
    XCTAssertEqual(newItem.credentialType, MSIDAccessTokenType);
    XCTAssertEqualObjects(newItem.secret, @"at");
    XCTAssertEqualObjects(newItem.target, @"resource");
    XCTAssertEqualObjects(newItem.realm, @"contoso.com");
    XCTAssertEqualObjects(newItem.environment, @"login.microsoftonline.com");
    XCTAssertEqualObjects(newItem.expiresOn, expiresOn);
    XCTAssertEqualObjects(newItem.extendedExpiresOn, extExpiresOn);
    XCTAssertEqualObjects(newItem.cachedAt, cachedAt);
    XCTAssertEqualObjects(newItem.homeAccountId, @"uid.utid");
    XCTAssertEqualObjects(newItem.speInfo, @"2");
    XCTAssertEqualObjects(newItem.additionalInfo, additionalInfo);
}

- (void)testKeyedArchivingRefreshToken_whenAllFieldsSet_shouldReturnSameTokenOnDeserialize
{
    MSIDLegacyTokenCacheItem *cacheItem = [MSIDLegacyTokenCacheItem new];
    cacheItem.refreshToken = @"rt";
    cacheItem.idToken = @"id";
    cacheItem.oauthTokenType = @"token type";
    cacheItem.environment = @"login.microsoftonline.com";
    cacheItem.realm = @"contoso.com";
    cacheItem.clientId = @"client";
    cacheItem.credentialType = MSIDRefreshTokenType;
    cacheItem.secret = @"rt";
    cacheItem.target = @"resource";
    cacheItem.realm = @"contoso.com";
    cacheItem.environment = @"login.microsoftonline.com";

    NSDate *expiresOn = [NSDate date];
    NSDate *cachedAt = [NSDate date];
    NSDate *extExpiresOn = [NSDate date];

    cacheItem.expiresOn = expiresOn;
    cacheItem.extendedExpiresOn = extExpiresOn;
    cacheItem.cachedAt = cachedAt;
    cacheItem.familyId = @"family";
    cacheItem.homeAccountId = @"uid.utid";
    cacheItem.speInfo = @"2";
    NSDictionary *additionalInfo = @{@"test": @"test"};
    cacheItem.additionalInfo = additionalInfo;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cacheItem requiringSecureCoding:YES error:nil];

    XCTAssertNotNil(data);

    NSKeyedUnarchiver *unarchiver = [NSKeyedUnarchiver msidCreateForReadingFromData:data error:nil];
    XCTAssertNotNil(unarchiver);
    
    MSIDLegacyTokenCacheItem *newItem = [unarchiver decodeObjectOfClass:[MSIDLegacyTokenCacheItem class] forKey:NSKeyedArchiveRootObjectKey];

    XCTAssertNotNil(newItem);
    XCTAssertEqualObjects(newItem.refreshToken, @"rt");
    XCTAssertEqualObjects(newItem.idToken, @"id");
    XCTAssertEqualObjects(newItem.oauthTokenType, @"token type");
    XCTAssertEqualObjects(newItem.realm, @"contoso.com");
    XCTAssertEqualObjects(newItem.environment, @"login.microsoftonline.com");
    XCTAssertEqualObjects(newItem.clientId, @"client");
    XCTAssertEqual(newItem.credentialType, MSIDRefreshTokenType);
    XCTAssertEqualObjects(newItem.secret, @"rt");
    XCTAssertEqualObjects(newItem.target, @"resource");
    XCTAssertEqualObjects(newItem.realm, @"contoso.com");
    XCTAssertEqualObjects(newItem.environment, @"login.microsoftonline.com");
    XCTAssertEqualObjects(newItem.extendedExpiresOn, extExpiresOn);
    XCTAssertEqualObjects(newItem.expiresOn, expiresOn);
    XCTAssertEqualObjects(newItem.cachedAt, cachedAt);
    XCTAssertEqualObjects(newItem.familyId, @"family");
    XCTAssertEqualObjects(newItem.homeAccountId, @"uid.utid");
    XCTAssertEqualObjects(newItem.speInfo, @"2");
    XCTAssertEqualObjects(newItem.additionalInfo, additionalInfo);
}

- (void)testEqualityForLegacyTokenCacheItems_WhenEitherOfTheComparedPropertiesInTheObject_IsNil
{
    MSIDLegacyTokenCacheItem *cacheItem1 = [MSIDLegacyTokenCacheItem new];
    cacheItem1.accessToken = @"at";
    cacheItem1.refreshToken = @"rt";
    cacheItem1.idToken = @"id";
    cacheItem1.oauthTokenType = @"token type";
    cacheItem1.environment = @"login.microsoftonline.com";
    cacheItem1.realm = @"contoso.com";
    
    MSIDLegacyTokenCacheItem *cacheItem2 = [MSIDLegacyTokenCacheItem new];
    cacheItem2.accessToken = @"at";
    cacheItem2.refreshToken = @"rt";
    cacheItem2.idToken = @"id";
    cacheItem2.oauthTokenType = nil;
    cacheItem2.environment = @"login.microsoftonline.com";
    cacheItem2.realm = @"contoso.com";
    XCTAssertNotEqualObjects(cacheItem1, cacheItem2);
}

@end
