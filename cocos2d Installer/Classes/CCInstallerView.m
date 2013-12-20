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

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context)
     {
         [context setDuration:0.5f];
         [[_installButton animator] setAlphaValue:0.0f];
         [[_backButton animator] setAlphaValue:0.0f];
     }
                        completionHandler:^()
     {
         [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context)
          {
              [_progressIndicator setHidden:NO];
              [_progressIndicator setMaxValue:100.0f];
              [_progressIndicator setAlphaValue:0.0f];
              [context setDuration:0.5f];
              [[_progressIndicator animator] setAlphaValue:1.0f];
          }
                             completionHandler:nil];

     }];
}

@end
