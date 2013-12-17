//
//  CCInstallerViewController.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 DynamicDust s.r.o. All rights reserved.
//

#import "CCInstallerViewController.h"

@interface CCInstallerViewController ()

@end

@implementation CCInstallerViewController

+ (instancetype)setupController
{
    return [[CCInstallerViewController alloc] initWithNibName: @"CCInstallerViewController"
                                                       bundle: [NSBundle mainBundle]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSAssert(self, @"Couldn't initialise CCInstallerViewController.");
    
    
    self.installer = [[CCTemplateInstaller alloc] init];
    [self.view addSubview:_introView];
    
    
    return self;
}


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
            if ([self.installer installTemplates])
            {
                NSLog(@"Templates installed succesfully.");
            }
            else
            {
                NSLog(@"Templates installation failed.");
            }
            if (_installView.documentationCheckbox.state == NSOnState)
            {
                NSLog(@"Installing documentation...");
                if ([self.installer installDocumentation])
                {
                    NSLog(@"Documentation installed succesfully.");
                }
                else
                {
                    NSLog(@"Documentation installation failed.");
                }
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

@end
