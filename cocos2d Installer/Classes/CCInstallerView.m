//
//  CCInstallerView.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 DynamicDust s.r.o. All rights reserved.
//

#import "CCInstallerView.h"

@implementation CCInstallerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)playInstallingAnimation
{
    [_documentationCheckbox setEnabled:NO];
    
    // Prepare
    [_progressIndicator setHidden:NO];
    [_progressIndicator setMaxValue:100.0f];
    [_progressIndicator setIndeterminate:YES];
    [_progressIndicator setAlphaValue:0.0f];
    
    // Fade out buttons
    [[NSAnimationContext currentContext] setDuration:0.5f];
    [[_installButton animator] setAlphaValue:0.0f];
    [[_backButton animator] setAlphaValue:0.0f];
    
    // Show the progress indicator
    [[NSAnimationContext currentContext] setDuration:0.5f];
    [[_progressIndicator animator] setAlphaValue:1.0f];
    [[NSAnimationContext currentContext] setCompletionHandler:^()
    {
        [[NSAnimationContext currentContext] setDuration:1.0f];
        [[_statusText animator] setFrameOrigin:
         (NSPoint){_statusText.frame.origin.x, _statusText.frame.origin.y - 20}];
    }];
}

@end
