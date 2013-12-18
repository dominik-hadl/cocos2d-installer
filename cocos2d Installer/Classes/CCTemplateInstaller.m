//
//  CCTemplateInstaller.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 Dominik Hadl. All rights reserved.
// -----------------------------------------------------------
#import "CCTemplateInstaller.h"
#import "Reachability.h"
// -----------------------------------------------------------

@implementation CCTemplateInstaller

// -----------------------------------------------------------
#pragma mark - Class Methods -
// -----------------------------------------------------------

+ (NSNumber *)installerVersion
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

// -----------------------------------------------------------

+ (NSNumber *)cocosVersion
{
    return @3.0;
}

// -----------------------------------------------------------
#pragma mark - Init & Dealloc -
// -----------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Couldn't initialise CCTemplateInstaller.");
    
    self.logFilePath = [NSTemporaryDirectory() stringByAppendingString:@"/cocos2d-installer/cocos2d_installer.log"];
    _templatesFolderPath = [NSHomeDirectory() stringByAppendingString:@"/Library/Developer/Xcode/Templates"];
    _filesDownloadStatus = CCTemplateInstallerDownloadStatusNotDownloaded;
    
    return self;
}

// -----------------------------------------------------------
#pragma mark - Delegate Setup -
// -----------------------------------------------------------

- (void)setDelegate:(id<CCTemplateInstallerDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
        
        _delegateRespondsTo.progressValueDidChange = [_delegate respondsToSelector:@selector(progressValueDidChange:)];
        _delegateRespondsTo.progressStringDidChange = [_delegate respondsToSelector:@selector(progressStringDidChange:)];
    }
}

// -----------------------------------------------------------
#pragma mark - Current Install Status -
// -----------------------------------------------------------

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

// -----------------------------------------------------------
#pragma mark - Install Methods -
// -----------------------------------------------------------

- (bool)install
{
    bool success = [self installTemplates];
    if (self.shouldInstallDocumentation)
        success = success & [self installDocumentation];
    return success;
}

// -----------------------------------------------------------

- (bool)installTemplates
{
    if (_filesDownloadStatus == CCTemplateInstallerDownloadStatusNotDownloaded)
    {
        [self downloadAllDependencies];

        while (_filesDownloadStatus == CCTemplateInstallerDownloadStatusInProgress)
        {
            
        };
        if (_filesDownloadStatus == CCTemplateInstallerDownloadStatusFailed) return NO;
    }
    if (![self createTemplatesFolderIfNotExists]) return NO;
/*  
    if (![self installDependency:CCTemplateInstallerDependencyCocos2d]) return NO;
    if (![self installDependency:CCTemplateInstallerDependencyKazmath]) return NO;
    if (![self installDependency:CCTemplateInstallerDependencyObjectAL]) return NO;
    if (![self installDependency:CCTemplateInstallerDependencyObjectiveChipmunk]) return NO;
    if (![self installDependency:CCTemplateInstallerDependencyXcodeTemplates]) return NO;
*/
    [self deleteLogFile];
    return YES;
}

// -----------------------------------------------------------

- (void)downloadAllDependencies
{
    NSURL *url = [NSURL URLWithString:@"https://github.com/cocos2d/cocos2d-iphone/archive/develop-v3.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:request delegate:self];
    download.deletesFileUponFailure = YES;
    
    _filesDownloadStatus = CCTemplateInstallerDownloadStatusInProgress;
}

// -----------------------------------------------------------

- (bool)createTemplatesFolderIfNotExists
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:_templatesFolderPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

// -----------------------------------------------------------

- (bool)installDependency:(CCTemplateInstallerDependency)dependency
{
    switch (dependency)
    {
        case CCTemplateInstallerDependencyCocos2d:
        {
            self.progressString = @"Installing cocos2d library";
            bool success = [self runCommand:@""];
            self.progress += 10;
            return success;
        }
        case CCTemplateInstallerDependencyKazmath:
            return [self runCommand:@""];
        case CCTemplateInstallerDependencyObjectAL:
            return [self runCommand:@""];
        case CCTemplateInstallerDependencyObjectiveChipmunk:
            return [self runCommand:@""];
        case CCTemplateInstallerDependencyXcodeTemplates:
            return [self runCommand:@""];
    }
    return YES;
}

// -----------------------------------------------------------

- (bool)installDocumentation
{
    bool success = [self runCommand:@""];
    
    
    
    
    if (success) [self deleteLogFile];
    return success;
}

// -----------------------------------------------------------
#pragma mark - Run Shell Commands -
// -----------------------------------------------------------

- (bool)runCommand:(NSString *)command
{
    NSLog(@"Running a command - %@.", command);
    // Setup the task (command)
    NSTask *task = [NSTask new];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:@[@"-c", [NSString stringWithFormat:@"%@", command]]];
    
    // Setup the pipe
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    
    // Run the command
    [task launch];
    
    // Get the output
    NSData *data = [file readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    [self saveToLogFile:output];
    bool success = ([task terminationStatus] == 0);
    if (!success) [self moveLogFileToDesktop];
    return success;
}

// -----------------------------------------------------------
#pragma mark - Installation Logging -
// -----------------------------------------------------------

- (void)saveToLogFile:(NSString *)stringToSave
{
    NSLog(@"Saved new data to log file.");
    if (!_logFile)
    {
        [[NSFileManager defaultManager] createFileAtPath:self.logFilePath
                                                contents:[stringToSave dataUsingEncoding:NSUTF8StringEncoding]
                                              attributes:nil];
        _logFile = [NSFileHandle fileHandleForWritingAtPath:self.logFilePath];
        NSAssert(_logFile, @"Couldn't create log file handle");
        return;
    }
    [_logFile seekToEndOfFile];
    [_logFile writeData:[stringToSave dataUsingEncoding:NSUTF8StringEncoding]];
}

// -----------------------------------------------------------

- (void)moveLogFileToDesktop
{
    NSLog(@"Log file moved to Desktop.");
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:self.logFilePath
                                            toPath:[NSHomeDirectory() stringByAppendingString:@"/Desktop/cocos2d_installer.log"]
                                             error:&error];
    if (error)
    {
        // Handle error
    }
    _logFile = nil;
}

// -----------------------------------------------------------

- (void)deleteLogFile
{
    NSLog(@"Log file deleted.");
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.logFilePath
                                               error:&error];
    if (error)
    {
        // Handle error
    }
    _logFile = nil;
}

// -----------------------------------------------------------
#pragma mark - Progress -
// -----------------------------------------------------------

- (void)setProgress:(float)progress
{
    if (progress > 100) progress = 100;
    else if (progress < 0) progress = 0;
    _progress = progress;
    
    if (_delegateRespondsTo.progressValueDidChange)
        [_delegate progressValueDidChange:_progress];
}

// -----------------------------------------------------------

- (void)setProgressString:(NSString *)progressString
{
    
}

// -----------------------------------------------------------
#pragma mark - NSURLDownload Delegate -
// -----------------------------------------------------------

- (void)downloadDidBegin:(NSURLDownload *)download
{
    
}

// -----------------------------------------------------------

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    [download setDestination:[[NSTemporaryDirectory() stringByAppendingString:@"cocos2d-installer/"] stringByAppendingString:filename]
              allowOverwrite:YES];
}

// -----------------------------------------------------------

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    _maxProgress = [response expectedContentLength];
}

// -----------------------------------------------------------

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    
}

// -----------------------------------------------------------

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    _filesDownloadStatus = CCTemplateInstallerDownloadStatusFailed;
}

// -----------------------------------------------------------

- (void)downloadDidFinish:(NSURLDownload *)download
{
    _filesDownloadStatus = CCTemplateInstallerDownloadStatusSuccess;
}

// -----------------------------------------------------------
@end
// -----------------------------------------------------------