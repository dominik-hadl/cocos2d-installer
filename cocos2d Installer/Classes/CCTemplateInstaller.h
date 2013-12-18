//
//  CCTemplateInstaller.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 Dominik Hadl. All rights reserved.
// -----------------------------------------------------------
#import <Foundation/Foundation.h>
// -----------------------------------------------------------

typedef NS_ENUM(NSInteger, CCInstallationStatus)
{
    CCInstallationStatusNotInstalled,
    CCInstallationStatusCurrentVersionInstalled,
    CCInstallationStatusOlderVersionInstalled,
    CCInstallationStatusNewerVersionInstalled,
    CCInstallationStatusUnknown
};

// -----------------------------------------------------------

typedef NS_ENUM(NSInteger, CCTemplateInstallerDependency)
{
    CCTemplateInstallerDependencyCocos2d,
    CCTemplateInstallerDependencyKazmath,
    CCTemplateInstallerDependencyObjectAL,
    CCTemplateInstallerDependencyObjectiveChipmunk,
    CCTemplateInstallerDependencyXcodeTemplates
};

// -----------------------------------------------------------

typedef NS_ENUM(NSInteger, CCTemplateInstallerDownloadStatus)
{
    CCTemplateInstallerDownloadStatusNotDownloaded,
    CCTemplateInstallerDownloadStatusSuccess,
    CCTemplateInstallerDownloadStatusInProgress,
    CCTemplateInstallerDownloadStatusFailed
};

// -----------------------------------------------------------

@protocol CCTemplateInstallerDelegate <NSObject>
- (void)progressValueDidChange:(float)newValue;
- (void)progressStringDidChange:(NSString *)newString;
@end

// -----------------------------------------------------------

@interface CCTemplateInstaller : NSObject <NSURLDownloadDelegate>
{
    NSFileHandle                            *_logFile;
    NSString                                *_templatesFolderPath;
    CCTemplateInstallerDownloadStatus        _filesDownloadStatus;
    float                                    _maxProgress;
    
    struct {
        unsigned int progressValueDidChange:1;
        unsigned int progressStringDidChange:1;
    } _delegateRespondsTo;
}

// -----------------------------------------------------------
#pragma mark - Properties -
// -----------------------------------------------------------

@property (nonatomic, assign) bool                              shouldInstallDocumentation;
@property (nonatomic, strong) NSString                         *logFilePath;
@property (nonatomic, assign, readonly) float                   progress;
@property (nonatomic, strong, readonly) NSString               *progressString;
@property (nonatomic, weak) id <CCTemplateInstallerDelegate>    delegate;

// -----------------------------------------------------------
#pragma mark - Class Methods -
// -----------------------------------------------------------

+ (NSNumber *)installerVersion;
+ (NSNumber *)cocosVersion;

// -----------------------------------------------------------
#pragma mark - Instance Methods -
// -----------------------------------------------------------

- (CCInstallationStatus)installationStatus;

- (bool)install;

// -----------------------------------------------------------
@end
// -----------------------------------------------------------