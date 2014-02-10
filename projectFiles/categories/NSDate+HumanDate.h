//
//  NSDate+HumanDate.h
//  DMProject
//
//  Created by Dima Avvakumov on 26.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HumanDate)

- (NSString *) humanDate;
- (NSString *) humanDateWithTimeZone: (NSTimeZone *) timeZone;

- (NSString *) humanDateAndTime;
- (NSString *) humanDateAndTimeWithTimeZone: (NSTimeZone *) timeZone;

- (NSString *) humanTime;
- (NSString *) humanTimeWithTimeZone: (NSTimeZone *) timeZone;

- (NSString *) dayOfWeek;

+ (NSString *) monthNameByIndex: (NSInteger) index;
+ (NSString *) monthName2ByIndex: (NSInteger) index;
+ (NSString *) dayOfWeekByIndex: (NSInteger) index;

@end
