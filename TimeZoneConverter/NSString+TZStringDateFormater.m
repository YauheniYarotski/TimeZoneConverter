//
//  NSString+TZStringDateFormater.m
//  TimeZoneConverter
//
//  Created by Yauheni Yarotski on 6/1/15.
//  Copyright (c) 2015 Yauheni Yarotski. All rights reserved.
//

#import "NSString+TZStringDateFormater.h"

@implementation NSString (TZStringDateFormater)

+ (NSString*)localizedStringFromDate:(NSDate*)date
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.formatterBehavior = [NSDateFormatter defaultFormatterBehavior];
    format.dateStyle = NSDateFormatterMediumStyle;
    format.timeStyle = NSDateFormatterShortStyle;
    NSString* dateString = [format stringFromDate:date];
    return dateString;
}

+ (NSString*)localizedStringFromDate:(NSDate*)date timeZone:(NSTimeZone*)timeZome
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.formatterBehavior = [NSDateFormatter defaultFormatterBehavior];
    format.dateStyle = NSDateFormatterMediumStyle;
    format.timeStyle = NSDateFormatterShortStyle;
    format.timeZone = timeZome;
    NSString* dateString = [format stringFromDate:date];
    return dateString;
}

+ (NSDate*)dateFromLocalizedString:(NSString*)dateString timeZone:(NSTimeZone*)timeZome
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.formatterBehavior = [NSDateFormatter defaultFormatterBehavior];
    format.dateStyle = NSDateFormatterMediumStyle;
    format.timeStyle = NSDateFormatterShortStyle;
    format.timeZone = timeZome;
    NSDate* date = [format dateFromString:dateString];
    return date;
}

+ (NSString*)timeIntervalFromComponents:(NSDateComponents*)components
{
    NSString* days = @"";
    NSString* hours = @"";
    NSString* minutes = @"";

    if (ABS(components.day) == 1) {
        days = [NSString stringWithFormat:NSLocalizedString(@" %li day", @"Word DAY in singular"), ABS(components.day)];
    } else if (components.day != 0) {
        days = [NSString stringWithFormat:NSLocalizedString(@" %li days", @"Word DAY in plural"), ABS(components.day)];
    }

    if (ABS(components.hour) == 1) {
        hours = [NSString stringWithFormat:NSLocalizedString(@" %li hour", @"Word HOUR in singular"), ABS(components.hour)];
    } else if (components.hour != 0) {
        hours = [NSString stringWithFormat:NSLocalizedString(@" %li hours", @"Word HOUR in plural"), ABS(components.hour)];
    }

    if (ABS(components.minute) == 1) {
        minutes =
            [NSString stringWithFormat:NSLocalizedString(@" %li minute", @"Word minute in singular"), ABS(components.minute)];
    } else if (components.minute != 0) {
        minutes =
            [NSString stringWithFormat:NSLocalizedString(@" %li minutes", @"Word minute in plural"), ABS(components.minute)];
    }

    NSString* intervalSting =
        [NSString stringWithFormat:@"%@%@%@", days, hours, minutes];
    NSString* resutString = @"";

    if (components.day == 0 & components.hour == 0 & components.minute == 0) {
        resutString = NSLocalizedString(@"Now", @"Word NOW");
    } else if (components.day < 0 || components.hour < 0 || components.minute < 0) {
        resutString = [NSString stringWithFormat:NSLocalizedString(@"Was%@ ago", @"Word WAS"), intervalSting];
    } else {
        resutString = [NSString stringWithFormat:NSLocalizedString(@"In%@", @"Just leave empty in russian"), intervalSting];
    }

    return resutString;
}

@end
