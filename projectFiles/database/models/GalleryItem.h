//
//  GalleryItem.h
//  DMProject
//
//  Created by Dima Avvakumov on 10.02.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FileItem, GalleryName;

@interface GalleryItem : NSManagedObject

@property (nonatomic) int32_t galleryItemID;
@property (nonatomic) int32_t order;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) GalleryName *gallery;
@property (nonatomic, retain) FileItem *image;

@end
