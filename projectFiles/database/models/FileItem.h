//
//  FileItem.h
//  DMProject
//
//  Created by Dima Avvakumov on 10.02.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GalleryItem, NodeFiles, NodeItem;

@interface FileItem : NSManagedObject

@property (nonatomic, retain) NSString * fileHash;
@property (nonatomic) int32_t fileHeight;
@property (nonatomic, retain) NSString * fileMime;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic) int32_t fileSize;
@property (nonatomic) int32_t fileWidth;
@property (nonatomic, retain) NSSet *galleryItems;
@property (nonatomic, retain) NSSet *nodeFiles;
@property (nonatomic, retain) NSSet *nodes;
@end

@interface FileItem (CoreDataGeneratedAccessors)

- (void)addGalleryItemsObject:(GalleryItem *)value;
- (void)removeGalleryItemsObject:(GalleryItem *)value;
- (void)addGalleryItems:(NSSet *)values;
- (void)removeGalleryItems:(NSSet *)values;

- (void)addNodeFilesObject:(NodeFiles *)value;
- (void)removeNodeFilesObject:(NodeFiles *)value;
- (void)addNodeFiles:(NSSet *)values;
- (void)removeNodeFiles:(NSSet *)values;

- (void)addNodesObject:(NodeItem *)value;
- (void)removeNodesObject:(NodeItem *)value;
- (void)addNodes:(NSSet *)values;
- (void)removeNodes:(NSSet *)values;

@end
