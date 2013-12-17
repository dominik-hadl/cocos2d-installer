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
    IBOutlet CCIntroView *_introView;
    IBOutlet CCInstallerView *_installView;
    IBOutlet NSView *_resultView;
}

@property (nonatomic, strong) CCTemplateInstaller *installer;

+ (instancetype)setupController;

- (IBAction)buttonPressed:(NSButton *)sender;

@end
