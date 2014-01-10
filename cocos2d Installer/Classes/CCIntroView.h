//
//  CCIntroView.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 DynamicDust s.r.o. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CCIntroView : NSView

@property (nonatomic, weak) IBOutlet NSImageView    *logoView;
@property (nonatomic, weak) IBOutlet NSTextField    *infoLabel;
@property (nonatomic, weak) IBOutlet NSTextField    *titleLabel;
@property (nonatomic, weak) IBOutlet NSButton       *continueButton;
@property (nonatomic, weak) IBOutlet NSTableView    *blogTable;

- (void)playIntroAnimation;

@end
