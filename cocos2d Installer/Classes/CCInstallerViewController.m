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
    
    
    self.installer = [[CCTemplateInstaller alloc] init];
    [self.view addSubview:_introView];
    
    
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
            NSLog(@"Continue on install view...");
            [self.view replaceSubview:_introView with:_installView];
            break;
        }
        case CCInstallerButtonInstall:
            NSLog(@"Installing templates...");
            
            self.installer.shouldInstallDocumentation = (_installView.documentationCheckbox.state == NSOnState);
            if ([self.installer install])
            {
                NSLog(@"Templates installed succesfully.");
            }
            else
            {
                NSLog(@"Templates installation failed.");
            }
            
            break;
        case CCInstallerButtonBack:
            if ([self.view.subviews containsObject:_installView])
            {
                [self.view replaceSubview:_installView with:_introView];
            }
            else if ([self.view.subviews containsObject:_resultView])
            {
                [self.view replaceSubview:_resultView with:_installView];
            }
            break;
    }
}

// -----------------------------------------------------------
@end
// -----------------------------------------------------------