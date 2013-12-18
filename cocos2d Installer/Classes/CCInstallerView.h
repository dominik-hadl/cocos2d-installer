//
//  CCInstallerView.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 DynamicDust s.r.o. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CCInstallerView : NSView

@property (nonatomic, weak) IBOutlet NSButton            *documentationCheckbox;
@property (nonatomic, weak) IBOutlet NSTextField         *statusText;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;

@end
