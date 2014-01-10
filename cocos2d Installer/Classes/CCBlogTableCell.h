//
//  CCBlogTableCell.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 10/01/14.
//  Copyright (c) 2014 Dominik Hadl. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CCBlogTableCell : NSTextFieldCell
{
    NSString *_month;
    NSString *_day;
}

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSURL *link;

@end
