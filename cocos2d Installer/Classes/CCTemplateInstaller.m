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


- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Couldn't initialise CCTemplateInstaller.");
    
    _logData = [NSMutableData data];
    self.logFilePath = [NSString stringWithFormat:@"/tmp/cocos2d_error.log"];
    
    return self;
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
    switch (dependency)
    {
        case CCTemplateInstallerDependencyCocos2d:
            return [self runCommand:@""];
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

- (bool)installDocumentation
{
    return [self test];
}

- (bool)test
{
    return [self runCommand:@"ls -A"];
}

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
    if (success) [self moveLogFileToDesktop];
    return !success;
}

- (void)saveToLogFile:(NSString *)stringToSave
{
    NSLog(@"Saved new data to log file.");
    //[_logData appendData:[stringToSave dataUsingEncoding:NSUTF8StringEncoding]];
    NSFileHandle *outputFile = [NSFileHandle fileHandleForWritingAtPath:self.logFilePath];
    [outputFile seekToEndOfFile];
    [outputFile writeData:[stringToSave dataUsingEncoding:NSUTF8StringEncoding]];
    [outputFile closeFile];
}

- (void)moveLogFileToDesktop
{
    NSLog(@"Log file moved to Desktop.");
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:self.logFilePath
                                            toPath:NSHomeDirectory()
                                             error:&error];
}

- (void)deleteLogFile
{
    NSLog(@"Log file deleted.");
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.logFilePath
                                               error:&error];
}

@end
