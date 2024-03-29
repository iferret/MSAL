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

#import "MSIDAADAuthority.h"
#import "MSIDB2CAuthority.h"
#import "MSIDCIAMAuthority.h"
#import "MSIDADFSAuthority.h"
#import "MSIDAuthority+Internal.h"

@implementation NSString (MSIDTestUtil)

- (MSIDAuthority *)aadAuthority
{
    __auto_type authorityUrl = [[NSURL alloc] initWithString:self];
    __auto_type authority = [[MSIDAADAuthority alloc] initWithURL:authorityUrl rawTenant:nil context:nil error:nil];
    
    return authority;
}

- (MSIDAuthority *)b2cAuthority
{
    __auto_type authorityUrl = [[NSURL alloc] initWithString:self];
    __auto_type authority = [[MSIDB2CAuthority alloc] initWithURL:authorityUrl validateFormat:NO context:nil error:nil];
    
    return authority;
}

- (MSIDAuthority *)ciamAuthority
{
    __auto_type authorityUrl = [[NSURL alloc] initWithString:self];
    __auto_type authority = [[MSIDCIAMAuthority alloc] initWithURL:authorityUrl validateFormat:NO context:nil error:nil];
    
    return authority;
}

- (MSIDAuthority *)adfsAuthority
{
    __auto_type authorityUrl = [[NSURL alloc] initWithString:self];
    __auto_type authority = [[MSIDADFSAuthority alloc] initWithURL:authorityUrl validateFormat:NO context:nil error:nil];
    
    return authority;
}

- (NSURL *)msidUrl
{
    return [[NSURL alloc] initWithString:self];
}

- (NSData *)msidData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end
