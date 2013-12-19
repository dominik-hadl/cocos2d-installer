//
//  CCResultView.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 19/12/13.
//  Copyright (c) 2013 Dominik Hadl. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CCResultView : NSView
{
    IBOutlet NSImageView *__weak _resultImage;
    IBOutlet NSTextField *__weak _titleText;
}

@property (nonatomic, weak) IBOutlet NSTextField *detailText;

- (void)installFailed;

@end
