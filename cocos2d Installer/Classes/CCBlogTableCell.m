//
//  CCBlogTableCell.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 10/01/14.
//  Copyright (c) 2014 Dominik Hadl. All rights reserved.
//

#import "CCBlogTableCell.h"

@implementation CCBlogTableCell

- (id)copyWithZone:(NSZone *)zone
{
    CCBlogTableCell *cell = [super copyWithZone:zone];
    if (!cell) return nil;
    
    cell.date = nil;
    cell.link = nil;
    [cell setDate:[self date]];
    [cell setLink:[self link]];
    
    return cell;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect dateRect = [self dateRectForBounds:cellFrame];
    NSRect dayRect = [self dateDayRectForBounds:dateRect];
    NSRect monthRect = [self dateMonthRectForBounds:dateRect];
    
    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRect:cellFrame];
    [[NSColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0] set];
    [bgPath fill];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dateRect];
    [[NSColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:1.0] set];
    [path fill];
    
    if (_day.length > 0)
        [_day drawInRect:dayRect withAttributes:nil];
    if (_month.length > 0)
        [_month drawInRect:monthRect withAttributes:nil];
    
    NSRect titleRect = [self titleRectForBounds:cellFrame];
    NSAttributedString *aTitle = [self attributedStringValue];
    if ([aTitle length] > 0) {
        [aTitle drawInRect:titleRect];
    }
}

- (NSRect)titleRectForBounds:(NSRect)theRect
{
    return (NSRect){theRect.origin.x + (theRect.size.width * 0.15) + 10, theRect.origin.y, theRect.size.width * 0.85, theRect.size.height};
}

- (NSRect)dateRectForBounds:(NSRect)bounds
{
    return (NSRect){bounds.origin.x, bounds.origin.y, bounds.size.width * 0.15, bounds.size.height};
}

- (NSRect)dateDayRectForBounds:(NSRect)bounds
{
    return (NSRect){bounds.origin.x, bounds.origin.y + (bounds.size.height * 0.20), bounds.size.width, bounds.size.height * 0.80};
}

- (NSRect)dateMonthRectForBounds:(NSRect)bounds
{
    return (NSRect){bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height * 0.20};
}

- (void)setDate:(NSDate *)date
{
    if (_date != date)
    {
        _date = date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comp = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth)
                                       fromDate:_date];
        _day = [NSString stringWithFormat:@"%i", (int)[comp day]];
        _month = [[[formatter monthSymbols] objectAtIndex:([comp month] - 1)] substringToIndex:3];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSLog(@"link mouse up");
}

@end
