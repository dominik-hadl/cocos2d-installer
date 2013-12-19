//
//  CCIntroView.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 DynamicDust s.r.o. All rights reserved.
//

#import "CCIntroView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CCIntroView

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)playIntroAnimation
{
    [_titleLabel setAlphaValue:0.0f];
    [_infoLabel setAlphaValue:0.0f];
    [_continueButton setAlphaValue:0.0f];
    
    CABasicAnimation *logoAnim = [CABasicAnimation animationWithKeyPath:@"frameOrigin"];
    logoAnim.fromValue = [NSValue valueWithPoint:(NSPoint){_logoView.frame.origin.x, _logoView.frame.origin.x - 85}];
    logoAnim.toValue = [NSValue valueWithPoint:(NSPoint){_logoView.frame.origin.x, _logoView.frame.origin.y}];
    logoAnim.duration = 1.0f;
    logoAnim.delegate = self;
    logoAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_logoView setAnimations:[NSDictionary dictionaryWithObjectsAndKeys:logoAnim, @"frameOrigin", nil]];
    [_logoView.animator setFrameOrigin:(NSPoint){_logoView.frame.origin.x, _logoView.frame.origin.y}];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [[NSAnimationContext currentContext] setDuration:1.0f];
    [[_titleLabel animator] setAlphaValue:1.0f];
    [[_infoLabel animator] setAlphaValue:1.0f];
    [[_continueButton animator] setAlphaValue:1.0f];
}

@end
