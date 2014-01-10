//
//  CCBlogPost.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 06/01/14.
//  Copyright (c) 2014 Dominik Hadl. All rights reserved.
//

#import "CCBlogPost.h"

@implementation CCBlogPost

- (id)copyWithZone:(NSZone *)zone
{
    CCBlogPost *post = [[CCBlogPost alloc] init];
    post.title = self.title;
    post.date = self.date;
    post.link = self.link;
    return post;
}

- (void)setDateFromString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss ZZZ"];
    self.date = [formatter dateFromString:dateString];
}

@end
