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

#import <Foundation/Foundation.h>
#import "MSIDAutomationTestRequest.h"
#import "MSIDAutomationOperationAPIRequestHandler.h"
#import "MSIDAutomationPasswordRequestHandler.h"
#import "MSIDTestAutomationAppConfigurationRequest.h"
#import "MSIDTestsConfig.h"

@class MSIDTestAutomationApplication;

@interface MSIDTestConfigurationProvider : NSObject

@property (nonatomic, strong) NSString *wwEnvironment;
@property (nonatomic) int stressTestInterval;
@property (nonatomic) MSIDTestsConfig *testsConfig;
@property (nonatomic) NSDictionary *jitConfig;

@property (nonatomic, readonly) MSIDAutomationOperationAPIRequestHandler *operationAPIRequestHandler;
@property (nonatomic, readonly) MSIDAutomationPasswordRequestHandler *passwordRequestHandler;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithConfigurationPath:(NSString *)configurationPath
                              testsConfig:(MSIDTestsConfig *)testsConfig;

- (MSIDAutomationTestRequest *)defaultAppRequest:(NSString *)environment
                                  targetTenantId:(NSString *)targetTenantId;

- (MSIDAutomationTestRequest *)defaultAppRequest:(NSString *)environment
                                  targetTenantId:(NSString *)targetTenantId
                                   brokerEnabled:(BOOL)brokerEnabled;

- (NSDictionary *)appInstallForConfiguration:(NSString *)appId;

// Environment configuration
- (NSString *)defaultEnvironmentForIdentifier:(NSString *)environmentIDentifier;
- (NSString *)defaultAuthorityForIdentifier:(NSString *)environmentIdentifier;
- (NSString *)defaultAuthorityForIdentifier:(NSString *)environmentIdentifier tenantId:(NSString *)tenantId;
- (NSString *)b2cAuthorityForIdentifier:(NSString *)environmentIdentifier
                             tenantName:(NSString *)tenantName
                                 policy:(NSString *)policy;
// Fill default params
- (MSIDAutomationTestRequest *)fillDefaultRequestParams:(MSIDAutomationTestRequest *)request
                                              appConfig:(MSIDTestAutomationApplication *)appConfig;

- (NSString *)oidcScopes;
- (NSString *)scopesForEnvironment:(NSString *)environment type:(NSString *)type;
- (NSString *)resourceForEnvironment:(NSString *)environment type:(NSString *)type;

- (void)configureResourceInRequest:(MSIDAutomationTestRequest *)request
               forEnvironment:(NSString *)environment
                                     type:(NSString *)type
                            suportsScopes:(BOOL)suportsScopes;

- (void)configureScopesInRequest:(MSIDAutomationTestRequest *)request
               forEnvironment:(NSString *)environment
                      scopesType:(NSString *)scopesType
                    resourceType:(NSString *)resourceType
                   suportsScopes:(BOOL)suportsScopes;

- (void)configureAuthorityInRequest:(MSIDAutomationTestRequest *)request
                     forEnvironment:(NSString *)environment
                           tenantId:(NSString *)tenantId
                    accountTenantId:(NSString *)accountTenantId
supportsTenantSpecificResultAuthority:(BOOL)supportsTenantSpecificResultAuthority;

@end
