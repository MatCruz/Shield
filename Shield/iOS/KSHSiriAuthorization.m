//
//  KSHSiriAuthorization.m
//  Shield
//
//  Created by William Towe on 4/8/17.
//  Copyright © 2019 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "KSHSiriAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <Intents/Intents.h>

@implementation KSHSiriAuthorization

- (void)requestSiriAuthorizationWithCompletion:(KSHRequestSiriAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSSiriUsageDescription"] != nil);
    
    if (self.hasSiriAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHSiriAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
        KSTDispatchMainAsync(^{
            completion((KSHSiriAuthorizationStatus)status,nil);
        });
    }];
}

+ (KSHSiriAuthorization *)sharedAuthorization {
    static KSHSiriAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHSiriAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasSiriAuthorization {
    return self.siriAuthorizationStatus == KSHSiriAuthorizationStatusAuthorized;
}
- (KSHSiriAuthorizationStatus)siriAuthorizationStatus {
    return (KSHSiriAuthorizationStatus)[INPreferences siriAuthorizationStatus];
}

@end
