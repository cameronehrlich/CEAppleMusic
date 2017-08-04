//
//  CEAppleMusic.h
//
//
//  Created by Cameron Ehrlich on 2/20/17.
//  Copyright © 2017. All rights reserved.
//

@import StoreKit;

typedef NS_ENUM(NSInteger, AMStatus) {
    AMStatusNotDetermined   = SKCloudServiceAuthorizationStatusNotDetermined,
    AMStatusDenied          = SKCloudServiceAuthorizationStatusDenied,
    AMStatusRestricted      = SKCloudServiceAuthorizationStatusRestricted,
    AMStatusAuthorized      = SKCloudServiceAuthorizationStatusAuthorized,
};

typedef NS_OPTIONS(NSUInteger, AMCapability) {
    AMCapabilityNone                 = SKCloudServiceCapabilityNone,
    AMCapabilityPlayback             = SKCloudServiceCapabilityMusicCatalogPlayback,
    AMCapabilitySubscriptionEligible = SKCloudServiceCapabilityMusicCatalogSubscriptionEligible,
    AMCapabilityAddToLibrary         = SKCloudServiceCapabilityAddToCloudMusicLibrary,
};

@interface CEAppleMusic : SKCloudServiceController

+ (AMStatus)status;
+ (AMCapability)capability;

+ (BOOL)enabled;

+ (void)requestStatus:(void(^)(AMStatus status))handler;
+ (BOOL)capableOf:(AMCapability)capability;

+ (void)connect:(void (^)(BOOL granted, AMStatus status, AMCapability capability))handler;

@end
