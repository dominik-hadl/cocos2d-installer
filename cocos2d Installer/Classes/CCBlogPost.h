//
//  CCBlogPost.h
//  cocos2d Installer
//
//  Created by Dominik Hadl on 06/01/14.
//  Copyright (c) 2014 Dominik Hadl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCBlogPost : NSObject <NSCopying>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSURL *link;

- (void)setDateFromString:(NSString *)dateString;

@end
