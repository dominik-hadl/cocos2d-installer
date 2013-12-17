//
//  CCTemplateInstaller.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 DynamicDust s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CCInstallationStatus)
{
    CCInstallationStatusNotInstalled,
    CCInstallationStatusCurrentVersionInstalled,
    CCInstallationStatusOlderVersionInstalled,
    CCInstallationStatusNewerVersionInstalled,
    CCInstallationStatusUnknown
};

@interface CCTemplateInstaller : NSObject
{
    NSMutableData *_logData;
}

@property (nonatomic, strong) NSString *logFilePath;

+ (NSNumber *)installerVersion;
+ (NSNumber *)cocosVersion;

- (CCInstallationStatus)installationStatus;

- (bool)installTemplates;
- (bool)installDocumentation;

@end
