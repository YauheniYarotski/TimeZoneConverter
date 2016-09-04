//
//  NSString+TZStringDateFormater.h
//  TimeZoneConverter
//
//  Created by Yauheni Yarotski on 6/1/15.
//  Copyright (c) 2015 Yauheni Yarotski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TZStringDateFormater)

+ (NSString*)localizedStringFromDate:(NSDate*)date;
+ (NSString*)localizedStringFromDate:(NSDate*)date timeZone:(NSTimeZone*)timeZome;
+ (NSDate*)dateFromLocalizedString:(NSString*)dateString timeZone:(NSTimeZone*)timeZome;
+ (NSString*)timeIntervalFromComponents:(NSDateComponents*)components;

@end
