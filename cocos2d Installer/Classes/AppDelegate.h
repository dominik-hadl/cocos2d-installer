//
//  AppDelegate.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 Dominik Hadl. All rights reserved.
// -----------------------------------------------------------
#import <Cocoa/Cocoa.h>
#import "CCInstallerViewController.h"
// -----------------------------------------------------------

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) CCInstallerViewController *installerViewController;

// -----------------------------------------------------------
@end
// -----------------------------------------------------------