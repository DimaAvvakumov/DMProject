//
//  ColorToDataTransformer.m
//  DMProject
//
//  Created by Dima Avvakumov on 24.08.13.
//  Copyright (c) 2013 East Media Ltd. All rights reserved.
//

#import "ColorToDataTransformer.h"

@implementation ColorToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
	return data;
}


- (id)reverseTransformedValue:(id)value {
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData: value];
	return color;
}

@end
