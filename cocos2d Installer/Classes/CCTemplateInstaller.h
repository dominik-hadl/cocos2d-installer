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
    CCInstallationStatusInstalled,
    CCInstallationStatusOlderVersionInstalled,
    CCInstallationStatusInstalling,
    CCInstallationStatusUnknown
};

// -----------------------------------------------------------

typedef NS_ENUM(NSInteger, CCTemplateInstallerDependency)
{
    CCTemplateInstallerDependencyCocos2d,
    CCTemplateInstallerDependencyCocos2dUI,
    CCTemplateInstallerDependencyKazmath,
    CCTemplateInstallerDependencyObjectAL,
    CCTemplateInstallerDependencyCCBReader,
    CCTemplateInstallerDependencyObjectiveChipmunk,
    CCTemplateInstallerDependencyXcodeTemplates,
    CCTemplateInstallerDependencyCount
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

extern NSString *const kCCCocos2dDownloadURL;
extern NSString *const kCCChipmunkDownloadURL;

// -----------------------------------------------------------
#pragma mark - CCTemplateInstaller Delegate -
// -----------------------------------------------------------
@class CCTemplateInstaller;

@protocol CCTemplateInstallerDelegate <NSObject>
@required
- (void)installer:(CCTemplateInstaller *)installer didFinishDownloadingWithSuccess:(bool)success;
- (void)installer:(CCTemplateInstaller *)installer didFinishInstallingWithSuccess:(bool)success;
@optional
- (void)installer:(CCTemplateInstaller *)installer progressValueDidChange:(float)newValue;
- (void)installer:(CCTemplateInstaller *)installer progressStringDidChange:(NSString *)newString;
- (void)installerDidBeginDownloading:(CCTemplateInstaller *)installer;
- (void)installerDidBeginInstalling:(CCTemplateInstaller *)installer;
@end

// -----------------------------------------------------------

@interface CCTemplateInstaller : NSObject <NSURLDownloadDelegate>
{
    NSFileHandle                           *_logFile;
    NSString                               *_templatesFolderPath;
    NSString                               *_cocos2dDownloadDestination;
    NSString                               *_chipmunkDownloadDestination;
    CCTemplateInstallerDownloadStatus       _filesDownloadStatus;
    float                                   _expectedDataLength;
    float                                   _downloadedDataLength;
    bool                                    _chipmunkDownloaded;
    bool                                    _cocos2dDownloaded;
    
    struct {
        unsigned int progressValueDidChange:1;
        unsigned int progressStringDidChange:1;
        unsigned int didFinishDownloadingWithSuccess:1;
        unsigned int didFinishInstallingWithSuccess:1;
        unsigned int didBeginDownloading:1;
        unsigned int didBeginInstalling:1;
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

- (void)install;
- (void)quit;

// -----------------------------------------------------------
@end
// -----------------------------------------------------------