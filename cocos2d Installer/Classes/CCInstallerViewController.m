//
//  CCInstallerViewController.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 Dominik Hadl. All rights reserved.
// -----------------------------------------------------------
#import "CCInstallerViewController.h"
// -----------------------------------------------------------

@implementation CCInstallerViewController

// -----------------------------------------------------------
#pragma mark - Class Methods -
// -----------------------------------------------------------

+ (instancetype)setupController
{
    return [[CCInstallerViewController alloc] initWithNibName: @"CCInstallerViewController"
                                                       bundle: [NSBundle mainBundle]];
}

// -----------------------------------------------------------
#pragma mark - Init & Dealloc -
// -----------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSAssert(self, @"Couldn't initialise CCInstallerViewController.");
    
    
    _installer = [[CCTemplateInstaller alloc] init];
    _installer.delegate = self;
    [self.view addSubview:_introView];
    [_introView playIntroAnimation];
    
    return self;
}

// -----------------------------------------------------------
#pragma mark - Button Callbacks -
// -----------------------------------------------------------

- (void)buttonPressed:(NSButton *)sender
{
    switch (sender.tag)
    {
        case CCInstallerButtonContinue:
        {
            [_installView setAlphaValue:0.0f];
            
            [[NSAnimationContext currentContext] setDuration:1.0f];
            [[_introView animator] setAlphaValue:0.0f];
            
            [[NSAnimationContext currentContext] setCompletionHandler:^(){
                [[NSAnimationContext currentContext] setDuration:1.0f];
                [self.view replaceSubview:_introView with:_installView];
                [[_installView animator] setAlphaValue:1.0f];
            }];
            
            break;
        }
        case CCInstallerButtonInstall:
            NSLog(@"Installing templates...");
            
            if (_installer.installationStatus == CCInstallationStatusInstalling) return;
            
            _installer.shouldInstallDocumentation = (_installView.documentationCheckbox.state == NSOnState);
            [_installer install];
            
            [_installView playInstallingAnimation];
            
            break;
        case CCInstallerButtonBack:
            if ([self.view.subviews containsObject:_installView])
            {
                [_introView setAlphaValue:0.0f];
                
                [[NSAnimationContext currentContext] setDuration:1.0f];
                [[_installView animator] setAlphaValue:0.0f];
                
                [[NSAnimationContext currentContext] setCompletionHandler:^(){
                    [[NSAnimationContext currentContext] setDuration:1.0f];
                    [self.view replaceSubview:_installView with:_introView];
                    [[_introView animator] setAlphaValue:1.0f];
                }];
            }
            else if ([self.view.subviews containsObject:_resultView])
            {
                [self.view replaceSubview:_resultView with:_installView];
            }
            break;
    }
}

// -----------------------------------------------------------
#pragma mark - CCTemplateInstaller Delegate -
// -----------------------------------------------------------

- (void)installer:(CCTemplateInstaller *)installer didFinishDownloadingWithSuccess:(bool)success
{
    if (success)
    {
        // Downloading succeeded
    }
    else
    {
        // Downloading failed
    }
}

- (void)installer:(CCTemplateInstaller *)installer didFinishInstallingWithSuccess:(bool)success
{
    if (success)
    {
        // Install succeeded
    }
    else
    {
        // Install failed
    }
}

- (void)installer:(CCTemplateInstaller *)installer progressValueDidChange:(float)newValue
{
    [_installView.progressIndicator setDoubleValue:newValue];
}

- (void)installer:(CCTemplateInstaller *)installer progressStringDidChange:(NSString *)newString
{
    [_installView.statusText setStringValue:newString];
}

- (void)installerDidBeginDownloading:(CCTemplateInstaller *)installer
{
    [_installView.progressIndicator setIndeterminate:NO];
    [_installView.progressIndicator setMaxValue:100.0f];
    [_installView.progressIndicator setDoubleValue:0.0f];
}

- (void)installerDidBeginInstalling:(CCTemplateInstaller *)installer
{
    
}

// -----------------------------------------------------------
@end
// -----------------------------------------------------------