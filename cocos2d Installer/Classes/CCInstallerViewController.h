//
//  CCInstallerViewController.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 Dominik Hadl. All rights reserved.
// -----------------------------------------------------------
#import <Cocoa/Cocoa.h>

// Installer
#import "CCTemplateInstaller.h"

// Views
#import "CCIntroView.h"
#import "CCInstallerView.h"
// -----------------------------------------------------------

typedef NS_ENUM(NSInteger, CCInstallerButton)
{
    CCInstallerButtonBack,
    CCInstallerButtonContinue,
    CCInstallerButtonInstall,
};

// -----------------------------------------------------------

@interface CCInstallerViewController : NSViewController <CCTemplateInstallerDelegate>
{
    // Installer Views
    IBOutlet CCIntroView *__weak     _introView;
    IBOutlet CCInstallerView *__weak _installView;
    IBOutlet NSView *__weak          _resultView;
}

// -----------------------------------------------------------
#pragma mark - Properties -
// -----------------------------------------------------------

@property (nonatomic, strong) CCTemplateInstaller *installer;

// -----------------------------------------------------------
#pragma mark - Class Methods -
// -----------------------------------------------------------

+ (instancetype)setupController;

// -----------------------------------------------------------
#pragma mark - Instance Methods -
// -----------------------------------------------------------

- (IBAction)buttonPressed:(NSButton *)sender;

// -----------------------------------------------------------
@end
// -----------------------------------------------------------