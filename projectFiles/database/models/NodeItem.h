//
//  NodeItem.h
//  DMProject
//
//  Created by Dima Avvakumov on 10.02.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FileItem, GalleryName, NodeCategory;

@interface NodeItem : NSManagedObject

@property (nonatomic, retain) NSString * authorName;
@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * dateTag;
@property (nonatomic) NSTimeInterval dateUpdated;
@property (nonatomic) double geoLatitude;
@property (nonatomic) double geoLongitude;
@property (nonatomic, retain) NSString * imageAuthor;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * imageSmallPath;
@property (nonatomic) BOOL isMedia;
@property (nonatomic, retain) NSString * link;
@property (nonatomic) int32_t nodeID;
@property (nonatomic) int32_t order;
@property (nonatomic, retain) NSString * pre;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleSub;
@property (nonatomic) int16_t type;
@property (nonatomic) BOOL videoExist;
@property (nonatomic, retain) NSString * videoLink;
@property (nonatomic, retain) NodeCategory *category;
@property (nonatomic, retain) GalleryName *gallery;
@property (nonatomic, retain) FileItem *image;

@end
