//
//  NSDate+HumanDate.m
//  DMProject
//
//  Created by Dima Avvakumov on 26.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "NSDate+HumanDate.h"

@implementation NSDate (HumanDate)

- (NSString *) humanDate {
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    return [self humanDateWithTimeZone: timeZone];
}

- (NSString *) humanDateWithTimeZone:(NSTimeZone *)timeZone {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:timeZone];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComp = [calendar components:unitFlags fromDate:self];
    NSDateComponents *todayComp = [calendar components:unitFlags fromDate:[NSDate date]];
    
    if (dateComp.year == todayComp.year && dateComp.month == todayComp.month) {
        if (dateComp.day == todayComp.day) {
            return [NSString stringWithFormat: @"сегодня, %02d:%02d", (int)dateComp.hour, (int)dateComp.minute];
        } else if (dateComp.day + 1 == todayComp.day) {
            return [NSString stringWithFormat: @"вчера"];
        } else if (dateComp.day - 1 == todayComp.day) {
            return [NSString stringWithFormat: @"завтра"];
        }
    }
    
    NSString *month = [NSDate monthNameByIndex: dateComp.month];
    return [NSString stringWithFormat: @"%d %@ %d", (int)dateComp.day, month, (int)dateComp.year];
}

- (NSString *) humanDateAndTime {
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    return [self humanDateAndTimeWithTimeZone:timeZone];
}

- (NSString *) humanDateAndTimeWithTimeZone: (NSTimeZone *) timeZone {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:timeZone];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComp = [calendar components:unitFlags fromDate:self];
    NSDateComponents *todayComp = [calendar components:unitFlags fromDate:[NSDate date]];
    
    if (dateComp.year == todayComp.year && dateComp.month == todayComp.month) {
        if (dateComp.day == todayComp.day) {
            return [NSString stringWithFormat: @"сегодня, %02d:%02d", (int)dateComp.hour, (int)dateComp.minute];
        } else if (dateComp.day + 1 == todayComp.day) {
            return [NSString stringWithFormat: @"вчера, %02d:%02d", (int)dateComp.hour, (int)dateComp.minute];
        } else if (dateComp.day - 1 == todayComp.day) {
            return [NSString stringWithFormat: @"завтра, %02d:%02d", (int)dateComp.hour, (int)dateComp.minute];
        }
    }
    
    NSString *month = [NSDate monthNameByIndex: dateComp.month];
    return [NSString stringWithFormat: @"%d %@ %d, %02d:%02d", (int)dateComp.day, month, (int)dateComp.year, (int)dateComp.hour, (int)dateComp.minute];
}

- (NSString *) humanTime {
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    return [self humanTimeWithTimeZone:timeZone];
}

- (NSString *) humanTimeWithTimeZone:(NSTimeZone *)timeZone {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:timeZone];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComp = [calendar components:unitFlags fromDate:self];
    
    return [NSString stringWithFormat: @"%02d:%02d", (int)dateComp.hour, (int)dateComp.minute];
}

+ (NSString *) monthNameByIndex: (NSInteger) index {
    switch (index) {
        case 1:  { return @"января"; break; }
        case 2:  { return @"февраля"; break; }
        case 3:  { return @"марта"; break; }
        case 4:  { return @"апреля"; break; }
        case 5:  { return @"мая"; break; }
        case 6:  { return @"июня"; break; }
        case 7:  { return @"июля"; break; }
        case 8:  { return @"августа"; break; }
        case 9:  { return @"сентября"; break; }
        case 10: { return @"октября"; break; }
        case 11: { return @"ноября"; break; }
        case 12: { return @"декабря"; break; }
        default:
            break;
    }
    
    return @"Undefined";
}

+ (NSString *) monthName2ByIndex: (NSInteger) index {
    switch (index) {
        case 1:  { return @"январь"; break; }
        case 2:  { return @"февраль"; break; }
        case 3:  { return @"март"; break; }
        case 4:  { return @"апрель"; break; }
        case 5:  { return @"май"; break; }
        case 6:  { return @"июнь"; break; }
        case 7:  { return @"июль"; break; }
        case 8:  { return @"август"; break; }
        case 9:  { return @"сентябрь"; break; }
        case 10: { return @"октябрь"; break; }
        case 11: { return @"ноябрь"; break; }
        case 12: { return @"декабрь"; break; }
        default:
            break;
    }
    
    return @"Undefined";
}

+ (NSString *) dayOfWeekByIndex: (NSInteger) index {
    switch (index) {
        case 1:  { return @"понедельник"; break; }
        case 2:  { return @"вторник"; break; }
        case 3:  { return @"среда"; break; }
        case 4:  { return @"четверг"; break; }
        case 5:  { return @"пятница"; break; }
        case 6:  { return @"суббота"; break; }
        case 7:  { return @"воскресенье"; break; }
        default:
            break;
    }
    
    return @"Undefined";
}

- (NSString *) dayOfWeek {
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    unsigned unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *dateComp = [calendar components:unitFlags fromDate:self];
    
    return [NSDate dayOfWeekByIndex:[dateComp weekday]-1];
}

@end
