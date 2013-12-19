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

NSString *const kCCCocos2dDownloadURL = @"https://github.com/cocos2d/cocos2d-iphone/archive/develop-v3.zip";
NSString *const kCCChipmunkDownloadURL = @"https://github.com/slembcke/Chipmunk2D/archive/master.zip";

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
        
        _delegateRespondsTo.progressValueDidChange = [_delegate respondsToSelector:@selector(installer:progressValueDidChange:)];
        _delegateRespondsTo.progressStringDidChange = [_delegate respondsToSelector:@selector(installer:progressStringDidChange:)];
        _delegateRespondsTo.didFinishDownloadingWithSuccess = [_delegate respondsToSelector:@selector(installer:didFinishDownloadingWithSuccess:)];
        _delegateRespondsTo.didFinishInstallingWithSuccess = [_delegate respondsToSelector:@selector(installer:didFinishInstallingWithSuccess:)];
        _delegateRespondsTo.didBeginDownloading = [_delegate respondsToSelector:@selector(installerDidBeginDownloading:)];
        _delegateRespondsTo.didBeginInstalling = [_delegate respondsToSelector:@selector(installerDidBeginInstalling:)];
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
    if (downloadedVeresion == installedVersion) return CCInstallationStatusInstalled;
    else if (downloadedVeresion > 0) return CCInstallationStatusOlderVersionInstalled;
    
    // Otherwise unknown... files present, but probably damaged in some way
    return CCInstallationStatusUnknown;
}

// -----------------------------------------------------------
#pragma mark - Install Methods -
// -----------------------------------------------------------

- (void)install
{
    self.progress = 0.0f;
    
#if INSTALLER_DEBUG == 0
    if (_filesDownloadStatus == CCTemplateInstallerDownloadStatusNotDownloaded ||
        _filesDownloadStatus == CCTemplateInstallerDownloadStatusFailed)
    {
        [self downloadAllDependencies];
        return;
    }
#else
    _cocos2dDownloadDestination = [NSTemporaryDirectory() stringByAppendingString:@"cocos2d-installer/cocos2d-iphone-develop-v3"];
    _chipmunkDownloadDestination = [NSTemporaryDirectory() stringByAppendingString:@"cocos2d-installer/Chipmunk2D-master"];
#endif
    
    bool success = [self installTemplates];
    if (self.shouldInstallDocumentation)
        success = success & [self installDocumentation];
    
    if (_delegate && _delegateRespondsTo.didFinishInstallingWithSuccess)
        [_delegate installer:self didFinishInstallingWithSuccess:success];
}

// -----------------------------------------------------------

- (bool)installTemplates
{
    if (![self deleteAndCreateTemplatesFolder]) return NO;
  
    for (NSInteger i = 0; i < CCTemplateInstallerDependencyCount; i++)
        if (![self installDependency:i]) return NO;

    [self deleteLogFile];
    return YES;
}

// -----------------------------------------------------------

- (void)downloadAllDependencies
{
    NSURL *url = [NSURL URLWithString:kCCCocos2dDownloadURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:request delegate:self];
    download.deletesFileUponFailure = YES;
    
    NSURL *url2 = [NSURL URLWithString:kCCChipmunkDownloadURL];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    NSURLDownload *download2 = [[NSURLDownload alloc] initWithRequest:request2 delegate:self];
    download2.deletesFileUponFailure = YES;
    
    _filesDownloadStatus = CCTemplateInstallerDownloadStatusInProgress;
    self.progressString = NSLocalizedString(@"DOWNLOAD_START", @"Download of files started.");
}

// -----------------------------------------------------------

- (bool)deleteAndCreateTemplatesFolder
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[_templatesFolderPath stringByAppendingPathComponent:@"cocos2d v3.x"]])
        [[NSFileManager defaultManager] removeItemAtPath:[_templatesFolderPath stringByAppendingPathComponent:@"cocos2d v3.x"]
                                                   error:nil];
    
    return [[NSFileManager defaultManager] createDirectoryAtPath:_templatesFolderPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

// -----------------------------------------------------------

- (bool)installDependency:(CCTemplateInstallerDependency)dependency
{
    NSString *installPath = [_templatesFolderPath stringByAppendingPathComponent:@"cocos2d v3.x"];
    bool success = NO;
    float progressIncrement = (100.0f / (CCTemplateInstallerDependencyCount + (_shouldInstallDocumentation ? 1.0f : 0.0f)));
    switch (dependency)
    {
        case CCTemplateInstallerDependencyCocos2d:
            success = [self copyFilesFromPath:[_cocos2dDownloadDestination stringByAppendingString:@"/cocos2d"]
                                            toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_cocos2d.xctemplate/Libraries/"]];
            success = success & [self copyFilesFromPath:[_cocos2dDownloadDestination stringByAppendingString:@"/LICENSE_cocos2d.txt"]
                                                 toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_cocos2d.xctemplate/Libraries/"]];
            self.progress += progressIncrement;
            return success;
        case CCTemplateInstallerDependencyCocos2dUI:
            success = [self copyFilesFromPath:[_cocos2dDownloadDestination stringByAppendingString:@"/cocos2d-ui"]
                                       toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_cocos2d-ui.xctemplate/Libraries/"]];
            self.progress += progressIncrement;
            return success;
        case CCTemplateInstallerDependencyKazmath:
            success = [self copyFilesFromPath:[_cocos2dDownloadDestination stringByAppendingString:@"/external/kazmath"]
                                            toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_kazmath.xctemplate/Libraries/"]];
            success = success & [self copyFilesFromPath:[_cocos2dDownloadDestination stringByAppendingString:@"/LICENSE_Kazmath.txt"]
                                                 toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_kazmath.xctemplate/Libraries/"]];
            self.progress += progressIncrement;
            return success;
        case CCTemplateInstallerDependencyObjectAL:
            success = [self copyFilesFromPath:[_cocos2dDownloadDestination stringByAppendingString:@"/external/ObjectAL"]
                                            toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_objectal.xctemplate/Libraries/"]];
            self.progress += progressIncrement;
            return success;
        case CCTemplateInstallerDependencyCCBReader:
            success = [self copyFilesFromPath:[_cocos2dDownloadDestination stringByAppendingString:@"/cocos2d-ui/CCBReader"]
                                       toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_ccbreader.xctemplate/Libraries/"]];
            success = success & [self copyFilesFromPath:[_cocos2dDownloadDestination stringByAppendingString:@"/LICENSE_CCBReader.txt"]
                                                 toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_ccbreader.xctemplate/Libraries/"]];
            self.progress += progressIncrement;
            return success;
        case CCTemplateInstallerDependencyObjectiveChipmunk:
            success = [self copyFilesFromPath:[_chipmunkDownloadDestination stringByAppendingString:@"/objectivec"]
                                       toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_chipmunk.xctemplate/Libraries/Chipmunk/"]];
            success = success & [self copyFilesFromPath:[_chipmunkDownloadDestination stringByAppendingString:@"/include"]
                                                 toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_chipmunk.xctemplate/Libraries/Chipmunk/chipmunk/"]];
            success = success & [self copyFilesFromPath:[_chipmunkDownloadDestination stringByAppendingString:@"/src"]
                                                 toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_chipmunk.xctemplate/Libraries/Chipmunk/chipmunk/"]];
            success = success & [self copyFilesFromPath:[_chipmunkDownloadDestination stringByAppendingString:@"/LICENSE.txt"]
                                                 toPath:[installPath stringByAppendingString:@"/Support/Libraries/lib_chipmunk.xctemplate/Libraries/Chipmunk/"]];
            self.progress += progressIncrement;
            return success;
            return YES;
        case CCTemplateInstallerDependencyXcodeTemplates:
            success = [self copyFilesFromPath:[_cocos2dDownloadDestination stringByAppendingString:@"/templates/"]
                                            toPath:installPath];
            self.progress += progressIncrement;
            return success;
        default: return YES;
    };
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

- (bool)copyFilesFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    [[NSFileManager defaultManager] createDirectoryAtPath:toPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    return [self runCommand:
            [NSString stringWithFormat:@"rsync -r --exclude='.*' '%@' '%@'", fromPath, toPath]];
}

// -----------------------------------------------------------
#pragma mark - Installation Logging -
// -----------------------------------------------------------

- (void)saveToLogFile:(NSString *)stringToSave
{
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
    
    if (_delegate && _delegateRespondsTo.progressValueDidChange)
        [_delegate installer:self progressValueDidChange:_progress];
}

// -----------------------------------------------------------

- (void)setProgressString:(NSString *)progressString
{
    _progressString = progressString;
    
    if (_delegate && _delegateRespondsTo.progressStringDidChange)
        [_delegate installer:self progressStringDidChange:_progressString];
}

// -----------------------------------------------------------
#pragma mark - NSURLDownload Delegate -
// -----------------------------------------------------------

- (void)downloadDidBegin:(NSURLDownload *)download
{
    if (_delegate && _delegateRespondsTo.didBeginDownloading)
        [_delegate installerDidBeginDownloading:self];
}

// -----------------------------------------------------------

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingString:@"cocos2d-installer/"]
                              withIntermediateDirectories:YES
                                               attributes:Nil
                                                    error:nil];
    
    NSString *downloadDestination = [[NSTemporaryDirectory() stringByAppendingString:@"cocos2d-installer/"] stringByAppendingString:filename];
    if (download.request.URL.absoluteString == kCCCocos2dDownloadURL)
        _cocos2dDownloadDestination = downloadDestination;
    else
        _chipmunkDownloadDestination = downloadDestination;
    
    [download setDestination:downloadDestination allowOverwrite:YES];
}

// -----------------------------------------------------------

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    _expectedDataLength += [response expectedContentLength];
}

// -----------------------------------------------------------

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    _downloadedDataLength += length;
    self.progress = ((_downloadedDataLength / _expectedDataLength) * 100);
}

// -----------------------------------------------------------

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    NSLog(@"Download did fail with error - %@", error);
    
    // Set file download status
    _filesDownloadStatus = CCTemplateInstallerDownloadStatusFailed;
    
    // Notify delegate
    if (_delegate && _delegateRespondsTo.didFinishDownloadingWithSuccess)
        [_delegate installer:self didFinishDownloadingWithSuccess:NO];
}

// -----------------------------------------------------------

- (void)downloadDidFinish:(NSURLDownload *)download
{
    if (download.request.URL.absoluteString == kCCCocos2dDownloadURL) _cocos2dDownloaded = YES;
    if (download.request.URL.absoluteString == kCCChipmunkDownloadURL) _chipmunkDownloaded = YES;
    
    if (_cocos2dDownloaded && _chipmunkDownloaded)
    {
        // Set file download status
        _filesDownloadStatus = CCTemplateInstallerDownloadStatusSuccess;
        
        // Notify delegate
        if (_delegate && _delegateRespondsTo.didFinishDownloadingWithSuccess)
            [_delegate installer:self didFinishDownloadingWithSuccess:YES];
        
        self.progressString = NSLocalizedString(@"PREPARE_INSTALL", @"Prepare before install... unzip etc.");
        
        // Unzip the files
        [self runCommand:[NSString stringWithFormat:@"tar -xf '%@' -C '%@'",
                          _cocos2dDownloadDestination, [_cocos2dDownloadDestination stringByDeletingLastPathComponent]]];
        [self runCommand:[NSString stringWithFormat:@"tar -xf '%@' -C '%@'",
                          _chipmunkDownloadDestination, [_chipmunkDownloadDestination stringByDeletingLastPathComponent]]];
        
        // Set the new destination
        _cocos2dDownloadDestination = [_cocos2dDownloadDestination stringByDeletingPathExtension];
        _chipmunkDownloadDestination = [_chipmunkDownloadDestination stringByDeletingPathExtension];
        
        // Now install the files
        [self install];
    }
}

// -----------------------------------------------------------
@end
// -----------------------------------------------------------