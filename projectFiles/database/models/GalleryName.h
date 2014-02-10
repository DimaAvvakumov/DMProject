//
//  GalleryName.h
//  DMProject
//
//  Created by Dima Avvakumov on 10.02.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GalleryItem, NodeItem;

@interface GalleryName : NSManagedObject

@property (nonatomic) int32_t galleryID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) int32_t version;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *nodes;
@end

@interface GalleryName (CoreDataGeneratedAccessors)

- (void)addItemsObject:(GalleryItem *)value;
- (void)removeItemsObject:(GalleryItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addNodesObject:(NodeItem *)value;
- (void)removeNodesObject:(NodeItem *)value;
- (void)addNodes:(NSSet *)values;
- (void)removeNodes:(NSSet *)values;

@end
