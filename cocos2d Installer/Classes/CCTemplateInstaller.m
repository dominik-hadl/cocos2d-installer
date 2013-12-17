//
//  CCTemplateInstaller.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 DynamicDust s.r.o. All rights reserved.
//

#import "CCTemplateInstaller.h"

typedef NS_ENUM(NSInteger, CCTemplateInstallerDependency)
{
    CCTemplateInstallerDependencyCocos2d,
    CCTemplateInstallerDependencyKazmath,
    CCTemplateInstallerDependencyObjectAL,
    CCTemplateInstallerDependencyObjectiveChipmunk,
    CCTemplateInstallerDependencyXcodeTemplates
};

@implementation CCTemplateInstaller

+ (NSNumber *)installerVersion
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

+ (NSNumber *)cocosVersion
{
    return @3.0;
}

- (CCInstallationStatus)installationStatus
{
    // 1. Check if installed
    return CCInstallationStatusNotInstalled;
    
    // 2. Check what version
    float installedVersion = 0.0f;
    float downloadedVeresion = [[CCTemplateInstaller cocosVersion] floatValue];
    if (downloadedVeresion == installedVersion) return CCInstallationStatusCurrentVersionInstalled;
    else if (downloadedVeresion > 0) return CCInstallationStatusOlderVersionInstalled;
    else if (downloadedVeresion < 0) return CCInstallationStatusNewerVersionInstalled;
    
    // Otherwise unknown... files present, but probably damaged in some way
    return CCInstallationStatusUnknown;
}

- (bool)installTemplates
{
    if (![self installDependency:CCTemplateInstallerDependencyCocos2d]) return NO;
    if (![self installDependency:CCTemplateInstallerDependencyKazmath]) return NO;
    if (![self installDependency:CCTemplateInstallerDependencyObjectAL]) return NO;
    if (![self installDependency:CCTemplateInstallerDependencyObjectiveChipmunk]) return NO;
    if (![self installDependency:CCTemplateInstallerDependencyXcodeTemplates]) return NO;
    
    return YES;
}

- (bool)installDependency:(CCTemplateInstallerDependency)dependency
{
    switch (dependency) {
        case CCTemplateInstallerDependencyCocos2d:
        case CCTemplateInstallerDependencyKazmath:
        case CCTemplateInstallerDependencyObjectAL:
        case CCTemplateInstallerDependencyObjectiveChipmunk:
        case CCTemplateInstallerDependencyXcodeTemplates: break;
    }
    return YES;
}

- (bool)installDocumentation
{
    
    return YES;
}

@end
