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
    [self.installer prepareInstall];
    return self;
}


- (void)buttonPressed:(NSButton *)sender
{
    switch (sender.tag) {
        case CCInstallerButtonContinue:
            NSLog(@"Continue!");
            
            break;
        case CCInstallerButtonInstall:
            NSLog(@"Install!");
            
            break;
    }
}

@end
