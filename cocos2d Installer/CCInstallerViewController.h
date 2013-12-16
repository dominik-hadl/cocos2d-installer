//
//  CCInstallerViewController.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 DynamicDust s.r.o. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CCTemplateInstaller.h"

typedef NS_ENUM(NSInteger, CCInstallerButton)
{
    CCInstallerButtonContinue,
    CCInstallerButtonInstall
};

@interface CCInstallerViewController : NSViewController

@property (nonatomic, strong) CCTemplateInstaller *installer;

+ (instancetype)setupController;

- (IBAction)buttonPressed:(NSButton *)sender;

@end
