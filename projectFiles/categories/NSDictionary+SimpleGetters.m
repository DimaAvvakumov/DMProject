//
//  NSDictionary+SimpleGetters.m
//  DMProject
//
//  Created by Dima Avvakumov on 20.12.12.
//  Copyright (c) 2012 Dima Avvakumov. All rights reserved.
//

#import "NSDictionary+SimpleGetters.h"

@implementation NSDictionary (SimpleGetters)

- (NSString *) stringForKey: (id) key {
    NSString *string = [self objectForKey: key];
    if (string == nil) {
        return @"";
    }
    if ([string isKindOfClass: [NSString class]]) {
        return string;
    }
    if ([string isKindOfClass: [NSNumber class]]) {
        NSNumber *number = (NSNumber *) string;
        return [number stringValue];
    }
    
    return @"";
}

- (NSString *) stringForKeyOrNil:(id)key {
    NSString *string = [self objectForKey: key];
    if (string == nil) {
        return nil;
    }
    if ([string isKindOfClass: [NSString class]]) {
        return string;
    }
    if ([string isKindOfClass: [NSNumber class]]) {
        NSNumber *number = (NSNumber *) string;
        return [number stringValue];
    }
    
    return nil;
}

- (NSNumber *) numberForKey: (id) key {
    id number = [self objectForKey: key];
    if (number != nil) {
        if ([number isKindOfClass: [NSNumber class]]) {
            return number;
        }
        if ([number isKindOfClass: [NSString class]]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
            [f setLocale: locale];
            [f setNumberStyle: NSNumberFormatterDecimalStyle];
            NSNumber *fNumber = [f numberFromString: number];
            
            if (fNumber != nil) {
                return fNumber;
            }
        }
    }
    
    return [NSNumber numberWithInt: 0];
}

- (BOOL) boolForKey: (id) key {
    NSNumber *value = [self numberForKey: key];
    return [value boolValue];
}

- (CGRect) rectForKey:(id)key {
    id obj = [self objectForKey: key];
    if (obj && [obj isKindOfClass: [NSString class]]) {
        return CGRectFromString((NSString *) obj);
    }
    //    if ([obj isKindOfClass: [NSDictionary class]]) {
    //        NSString *family = [DeviceManager family];
    //        return CGRectFromString([self stringFromDictionary: (NSDictionary *) obj forKey: family]);
    //    } else if ([obj isKindOfClass: [NSString class]]) {
    //        return CGRectFromString((NSString *) obj);
    //    }
    return CGRectZero;
}

- (CGPoint) pointForKey: (id) key {
    id obj = [self objectForKey: key];
    if (obj && [obj isKindOfClass: [NSString class]]) {
        return CGPointFromString((NSString *) obj);
    }
    return CGPointZero;
}

- (CGSize) sizeForKey: (id) key {
    id obj = [self objectForKey: key];
    if (obj && [obj isKindOfClass: [NSString class]]) {
        return CGSizeFromString((NSString *) obj);
    }
    return CGSizeZero;
}

- (NSRange) rangeForKey: (id) key {
    id obj = [self objectForKey: key];
    if (obj && [obj isKindOfClass: [NSString class]]) {
        return NSRangeFromString(obj);
    }
    return NSMakeRange(0, 0);
}

- (UIColor *) colorForKey:(id)key {
    NSString *colorString = [[self stringForKey: key] lowercaseString];
    
    // check hex
    NSError *error = nil;
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"^#([0-9a-f]{1,2})([0-9a-f]{1,2})([0-9a-f]{1,2})$" options:0 error:&error];
    if (error) {
        NSLog(@"Regexp error: %@", error);
        return [UIColor blackColor];
    }
    NSTextCheckingResult *regMatch = [regExp firstMatchInString:colorString options:0 range:NSMakeRange(0, [colorString length])];
    if (regMatch) {
        NSRange firstRange = [regMatch rangeAtIndex: 1];
        NSRange secondRange = [regMatch rangeAtIndex: 2];
        NSRange threeRange = [regMatch rangeAtIndex: 3];
        
        unsigned int r, g, b;
        [[NSScanner scannerWithString:[colorString substringWithRange:firstRange]] scanHexInt:&r];
        [[NSScanner scannerWithString:[colorString substringWithRange:secondRange]] scanHexInt:&g];
        [[NSScanner scannerWithString:[colorString substringWithRange:threeRange]] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    }
    
    NSArray *colorComponents = [colorString componentsSeparatedByString: @","];
    if ([colorComponents count] == 3) {
        CGFloat r = [[colorComponents objectAtIndex:0] floatValue];
        CGFloat g = [[colorComponents objectAtIndex:1] floatValue];
        CGFloat b = [[colorComponents objectAtIndex:2] floatValue];
        
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    } else if ([colorComponents count] == 4) {
        CGFloat r = [[colorComponents objectAtIndex:0] floatValue];
        CGFloat g = [[colorComponents objectAtIndex:1] floatValue];
        CGFloat b = [[colorComponents objectAtIndex:2] floatValue];
        CGFloat a = [[colorComponents objectAtIndex:3] floatValue];
        
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    }
    
    return [UIColor clearColor];
}


@end
