//
//  AppDelegate.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 Dominik Hadl. All rights reserved.
// -----------------------------------------------------------
#import "AppDelegate.h"
// -----------------------------------------------------------

@implementation AppDelegate

// -----------------------------------------------------------

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.installerViewController = [CCInstallerViewController setupController];
    [self.window setContentView:self.installerViewController.view];
}

// -----------------------------------------------------------
@end
// -----------------------------------------------------------