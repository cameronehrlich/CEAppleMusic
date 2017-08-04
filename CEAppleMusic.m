//
//  CEAppleMusic.m
//
//
//  Created by Cameron Ehrlich on 2/20/17.
//  Copyright © 2017. All rights reserved.
//

#import "CEAppleMusic.h"

@implementation CEAppleMusic

+ (BOOL)enabled
{
    return (AMStatusAuthorized == (AMStatus)[self authorizationStatus]) && [self capableOf:AMCapabilityPlayback];
}

+ (AMStatus)status
{
    return (AMStatus)[super authorizationStatus];
}

+ (AMCapability)capability
{
    __block AMCapability updatedCapabilities = AMCapabilityNone;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [[self new] requestCapabilitiesWithCompletionHandler:^(SKCloudServiceCapability capabilities, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error in %s - %@", __PRETTY_FUNCTION__, error.debugDescription);
        }
        else {
            updatedCapabilities = (AMCapability)capabilities;
        }
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return updatedCapabilities;
}

+ (void)requestStatus:(void(^)(AMStatus status))handler
{
    if (!handler) {
        NSAssert(0, @"You must implement the completeion block on this call.");
    }
    
    [self requestAuthorization:^(SKCloudServiceAuthorizationStatus authStatus) {
        return handler((AMStatus)authStatus);
    }];
}

+ (BOOL)capableOf:(AMCapability)capability
{
    if (capability == AMCapabilityNone) {
        return YES;
    }
    else {
        AMCapability currentCapability = [self capability];
        BOOL capibleOf =  (BOOL)MIN((currentCapability & capability), 1 );
        return capibleOf;
    }
}

+ (void)connect:(void (^)(BOOL granted, AMStatus status, AMCapability capability))handler
{
    if (!handler) {
        NSAssert(0, @"You must implement the completeion block on this call.");
    }
    
    [self requestStatus:^(AMStatus _status) {
        
        AMCapability _capability = [self capability];
        
        switch (_status) {
            case AMStatusDenied: {
                return handler(NO, _status, _capability);
            }
            case AMStatusRestricted: {
                return handler(NO, _status, _capability);
            }
            case AMStatusAuthorized: {
                return handler(YES, _status, _capability);
            }
            case AMStatusNotDetermined: {
                NSAssert(0, @"Should never be able to reach here");
                return handler(NO, _status, _capability);
            }
        }
    }];
}

@end
