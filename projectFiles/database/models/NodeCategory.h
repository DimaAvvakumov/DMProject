//
//  NodeCategory.h
//  DMProject
//
//  Created by Dima Avvakumov on 10.02.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NodeItem;

@interface NodeCategory : NSManagedObject

@property (nonatomic) int32_t categoryID;
@property (nonatomic) int32_t order;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) int32_t version;
@property (nonatomic, retain) NSSet *items;
@end

@interface NodeCategory (CoreDataGeneratedAccessors)

- (void)addItemsObject:(NodeItem *)value;
- (void)removeItemsObject:(NodeItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
