//
//  NSString+ApplicationFonts.m
//  DMProject
//
//  Created by Dima Avvakumov on 17.12.12.
//  Copyright (c) 2012 Dima Avvakumov. All rights reserved.
//

#import "NSString+ApplicationFonts.h"

@implementation NSString (ApplicationFonts)

+ (void) printApplicationFonts {
    NSArray *familyNames = [UIFont familyNames];
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily) {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        NSArray *fontNames = [UIFont fontNamesForFamilyName: [familyNames objectAtIndex:indFamily]];
        for (indFont=0; indFont<[fontNames count]; ++indFont) {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

@end
