//
//  ArrayToDataTransformer.m
//  DMProject
//
//  Created by Dima Avvakumov on 19.09.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import "ArrayToDataTransformer.h"

@implementation ArrayToDataTransformer

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
    NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData: value];
	return items;
}

@end
