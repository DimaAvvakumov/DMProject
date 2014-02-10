//
//  CoreDataManager.h
//  DMProject
//
//  Created by Dima Avvakumov on 18.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataBase.h"

typedef enum {
    BannersTypeSplash = 1,
    BannersTypeSmall  = 0,
    BannersTypeFeed   = 0,
    BannersTypePull   = 0
} BannersType;

#import "ColorToDataTransformer.h"
#import "ArrayToDataTransformer.h"

#import "NodeItem.h"
#import "NodeFiles.h"
#import "NodeCategory.h"
#import "FileItem.h"
#import "GalleryName.h"
#import "GalleryItem.h"

#import "Banners.h"
#import "BannersLinks.h"

@interface CoreDataManager : CoreDataBase

#pragma mark - Init methods
+ (id) defaultManager;

#pragma mark - Node item

- (NodeItem *) nodeByID: (NSInteger) itemID;
- (NodeItem *) insertNewNodeItem;
- (NodeItem *) parseNodeItem: (NSDictionary *) itemInfo;
- (BOOL) nodeIsDownloaded;
- (NSArray *) nodeItems;

- (NodeItem *) lastNodeItem;
- (NodeItem *) lastNodeItemWithCategory: (NSInteger) categoryID dateTag: (NSString *) dateTag;

- (NSArray *) nodeItemsWithCategory: (NSInteger) categoryID dateTag: (NSString *) dateTag range: (NSRange) range;

#pragma mark - Node files

- (NodeFiles *) parseNodeFile: (NSDictionary *) itemInfo forNodeID: (NSInteger) nodeID;
- (NodeFiles *) nodeFileByTag: (NSString *) tag;
- (NodeFiles *) insertNewNodeFile;
- (NSArray *) nodeFileItemsByNodeID: (NSInteger) nodeID;

#pragma mark - Node category

- (NodeCategory *) nodeCategoryByID: (NSInteger) itemID;
- (NodeCategory *) insertNewNodeCategory;
- (NodeCategory *) parseNodeCategory: (NSDictionary *) itemInfo;
- (NSArray *) nodeCategoryItems;

#pragma mark - Files

- (FileItem *) parseFile: (NSDictionary *) itemInfo;
- (FileItem *) fileByPath: (NSString *) itemPath;
- (FileItem *) insertNewFile;
- (NSArray *) fileItems;

#pragma mark - Gallery

- (GalleryName *) galleryNameByID: (NSInteger) itemID;
- (GalleryName *) insertNewGalleryName;
- (GalleryName *) parseGalleryName: (NSDictionary *) itemInfo;

#pragma mark - Gallery item

- (GalleryItem *) galleryItemByID: (NSInteger) itemID;
- (GalleryItem *) insertNewGalleryItem;
- (GalleryItem *) parseGalleryItem: (NSDictionary *) itemInfo;
- (NSArray *) galleryItemsByGallery: (GalleryName *) gallery;

#pragma mark - banners
- (NSArray *) allBanners;
- (Banners *) bannerByID: (NSUInteger) itemID;
- (Banners *) insertNewBanner;
- (Banners *) parseBannersItem: (NSDictionary *) itemInfo;
- (Banners *) findBannerByType: (BannersType) type;
- (NSArray *) allBannersByType: (BannersType) type;

- (BannersLinks *) bannerLinkByID: (NSUInteger) itemID;
- (BannersLinks *) parseBannersLink: (NSDictionary *) itemInfo;
- (BannersLinks *) insertNewBannerLink;

#pragma mark - Node search

- (NSArray *) searchNodesWithWords: (NSArray *) words inRange: (NSRange) range;

#pragma mark - Media items

- (NSArray *) mediaNodesWithRange: (NSRange) range;
- (NodeItem *) lastMediaItem;

@end
