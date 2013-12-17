//
//  CCInstallerViewController.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 DynamicDust s.r.o. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CCTemplateInstaller.h"

#import "CCIntroView.h"
#import "CCInstallerView.h"

typedef NS_ENUM(NSInteger, CCInstallerButton)
{
    CCInstallerButtonBack,
    CCInstallerButtonContinue,
    CCInstallerButtonInstall,
};

@interface CCInstallerViewController : NSViewController
{
    // Installer Views
    IBOutlet CCIntroView *__weak     _introView;
    IBOutlet CCInstallerView *__weak _installView;
    IBOutlet NSView *__weak          _resultView;
}

@property (nonatomic, strong) CCTemplateInstaller *installer;

+ (instancetype)setupController;

- (IBAction)buttonPressed:(NSButton *)sender;

@end
