//
//  CoreDataManager.m
//  DMProject
//
//  Created by Dima Avvakumov on 18.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "CoreDataManager.h"

#define CoreData_EntityName_NodeItem @"NodeItem"
#define CoreData_EntityName_NodeFiles @"NodeFiles"
#define CoreData_EntityName_NodeCategory @"NodeCategory"
#define CoreData_EntityName_FileItem @"FileItem"
#define CoreData_EntityName_GalleryName @"GalleryName"
#define CoreData_EntityName_GalleryItem @"GalleryItem"

#define CoreData_EntityName_Banners @"Banners"
#define CoreData_EntityName_BannersLinks @"BannersLinks"

@interface CoreDataManager()

@property (strong, nonatomic) NSDateFormatter *dateFormatterForServer;
@property (strong, nonatomic) NSDateFormatter *dateFormatterForTag;

@end

@implementation CoreDataManager

+ (CoreDataManager *) defaultManager {
    CoreDataManager static *instance = nil;
    if (!instance) {
        instance = [[CoreDataManager alloc] init];
    }
    
    return instance;
}

- (NSString *) managedObjectModelName {
    return @"DMProject";
}

- (NSString *) persistentStoreCoordinatorName {
    return @"DMProject";
}

- (NSDateFormatter *) dateFormatterForServer {
    if (_dateFormatterForServer) return _dateFormatterForServer;
    
    // NSTimeZone *moscowTimeZone = [NSTimeZone timeZoneWithName:@"Europe/Moscow"];
    NSTimeZone *moscowTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Yekaterinburg"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [dateFormatter setTimeZone:moscowTimeZone];
    
    self.dateFormatterForServer = dateFormatter;
    return _dateFormatterForServer;
}

- (NSDateFormatter *) dateFormatterForTag {
    if (_dateFormatterForTag) return _dateFormatterForTag;
    
    // NSTimeZone *moscowTimeZone = [NSTimeZone timeZoneWithName:@"Europe/Moscow"];
    NSTimeZone *ekbTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Yekaterinburg"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    [dateFormatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [dateFormatter setTimeZone:ekbTimeZone];
    
    self.dateFormatterForTag = dateFormatter;
    return _dateFormatterForTag;
}

#pragma mark - Node item

- (NodeItem *) nodeByID: (NSInteger) itemID {
    return [self itemFromEntity:CoreData_EntityName_NodeItem whereField:@"nodeID" isEqualToInteger:itemID];
}

- (NodeItem *) insertNewNodeItem {
    return (NodeItem *) [NSEntityDescription insertNewObjectForEntityForName: CoreData_EntityName_NodeItem inManagedObjectContext:self.managedObjectContext];
}

- (NodeItem *) parseNodeItem:(NSDictionary *)itemInfo {
    if (!itemInfo || ![itemInfo isKindOfClass: [NSDictionary class]]) return nil;
    
    NSDateFormatter *dateFormatter = [self dateFormatterForServer];
    NSDateFormatter *tagDF = [self dateFormatterForTag];

    NSInteger nodeID = [[itemInfo numberForKey: @"id"] integerValue];
    NSInteger type = [[itemInfo numberForKey: @"type_id"] integerValue];
    NSString *title = [itemInfo stringForKey: @"title"];
    NSString *titleSub = [itemInfo stringForKey: @"titleSub"];
    NSString *pre = [itemInfo stringForKey: @"pre"];
    NSString *text = [itemInfo stringForKey: @"text"];
    NSInteger order = [[itemInfo numberForKey: @"order"] integerValue];
    NSString *nodeLink = [itemInfo stringForKey: @"link"];
    NSString *dateStr = [itemInfo stringForKey: @"date"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSTimeInterval dateTime = [date timeIntervalSinceReferenceDate];
    NSString *dateUpdatedStr = [itemInfo stringForKey: @"updated"];
    NSTimeInterval dateUpdated = [[dateFormatter dateFromString:dateUpdatedStr] timeIntervalSinceReferenceDate];
    NSString *authorName = [itemInfo stringForKey: @"author_name"];
    NSString *videoLink = [itemInfo stringForKey: @"video_link"];
    BOOL isMedia = [[itemInfo numberForKey: @"is_media"] boolValue];
    
    double geoLongitude = [[itemInfo numberForKey:@"geo_lon"] doubleValue];
    double geoLatitude = [[itemInfo numberForKey:@"geo_lat"] doubleValue];
    
    // date tag
    NSString *dateTag = [tagDF stringFromDate: date];
    
    NodeItem *item = [self nodeByID:nodeID];
    if (item == nil) {
        item = [self insertNewNodeItem];
    } else {
        if (item.dateUpdated == dateUpdated) {
            return item;
        }
    }
    item.nodeID = nodeID;
    item.type = type;
    item.title = title;
    item.titleSub = titleSub;
    item.pre = pre;
    item.text = text;
    item.link = nodeLink;
    item.date = dateTime;
    item.dateTag = dateTag;
    item.dateUpdated = dateUpdated;
    item.order = order;
    item.authorName = authorName;
    item.imageAuthor = [itemInfo stringForKey:@"image_author"];
    item.imageName = [itemInfo stringForKey:@"image_name"];
    item.geoLatitude = geoLatitude;
    item.geoLongitude = geoLongitude;
    item.videoLink = videoLink;
    item.videoExist = (videoLink && [videoLink length] > 0) ? YES : NO;
    item.isMedia = isMedia;
    
    // image parse
    FileItem *image = [self parseFile:[itemInfo objectForKey:@"image"]];
    if (image) {
        [item setImage:image];
    }
    
    // small image
    FileItem *imageSmall = [self parseFile:[itemInfo objectForKey:@"imageSmall"]];
    if (imageSmall) {
        item.imageSmallPath = imageSmall.filePath;
    }
    
    // category
    NSInteger categoryID = [[itemInfo numberForKey:@"category_id"] integerValue];
    NodeCategory *category = [self nodeCategoryByID:categoryID];
    if (category) {
        [item setCategory:category];
    }
    
    // inner files
    NSArray *innerFiles = [itemInfo objectForKey:@"inner_files"];
    if (innerFiles && [innerFiles isKindOfClass:[NSArray class]]) {
        for (NSDictionary *innerFile in innerFiles) {
            [self parseNodeFile:innerFile forNodeID:nodeID];
        }
    }
    
    // gallery parse
    NSDictionary *galleryItem = [itemInfo objectForKey:@"gallery"];
    if (galleryItem && [galleryItem isKindOfClass:[NSDictionary class]]) {
        GalleryName *galleryName = [self parseGalleryName:galleryItem];
        if (galleryName) {
            item.gallery = galleryName;
        }
    }
    
    return item;
}

- (BOOL) nodeIsDownloaded {
    NodeItem *feedItem = [self itemFromEntity:CoreData_EntityName_NodeItem withPredicate:nil];

    return (feedItem) ? YES : NO;
}

- (NSArray *) nodeItems {
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO];
    NSSortDescriptor *sortType = [NSSortDescriptor sortDescriptorWithKey: @"type" ascending: YES];
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDate, sortType, sortOrder, nil];
    
    return [self itemsFromEntity:CoreData_EntityName_NodeItem withPredicate:nil andSortDescriptors:sortDescriptors];
}

- (NodeItem *) lastNodeItem {
    
    return [self lastNodeItemWithCategory:0 dateTag:nil];
}

- (NodeItem *) lastNodeItemWithCategory: (NSInteger) categoryID dateTag: (NSString *) dateTag {
    
    NSPredicate *predicate = nil;
    NodeCategory *category = nil;
    if (categoryID > 0) {
        category = [self nodeCategoryByID:categoryID];
    }
    
    NSMutableArray *predicateArray = [NSMutableArray arrayWithCapacity:2];
    if (category) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"category = %@", category];
        
        [predicateArray addObject:p];
    }
    if (dateTag) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"dateTag = %@", dateTag];
        
        [predicateArray addObject:p];
    }
    if ([predicateArray count] > 0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }
    
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO];
    NSSortDescriptor *sortType = [NSSortDescriptor sortDescriptorWithKey: @"type" ascending: YES];
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDate, sortType, sortOrder, nil];
    
    return [self itemFromEntity:CoreData_EntityName_NodeItem withPredicate:predicate andSortDescriptors:sortDescriptors];
}

- (NSArray *) nodeItemsWithCategory:(NSInteger)categoryID dateTag:(NSString *)dateTag range:(NSRange)range {
    
    NSPredicate *predicate = nil;
    NodeCategory *category = nil;
    if (categoryID > 0) {
        category = [self nodeCategoryByID:categoryID];
    }
    
    NSMutableArray *predicateArray = [NSMutableArray arrayWithCapacity:2];
    if (category) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"category = %@", category];
        
        [predicateArray addObject:p];
    }
    if (dateTag) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"dateTag = %@", dateTag];
        
        [predicateArray addObject:p];
    }
    if ([predicateArray count] > 0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }

    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO];
    NSSortDescriptor *sortType = [NSSortDescriptor sortDescriptorWithKey: @"type" ascending: YES];
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDate, sortType, sortOrder, nil];

    return [self itemsFromEntity:CoreData_EntityName_NodeItem withPredicate:predicate sortDescriptors:sortDescriptors andRange:range];
}

#pragma mark - Node files

- (NodeFiles *) parseNodeFile: (NSDictionary *) itemInfo forNodeID:(NSInteger)nodeID {
    if (!itemInfo || ![itemInfo isKindOfClass: [NSDictionary class]]) return nil;
    
    NSInteger fileID = [[itemInfo numberForKey: @"id"] integerValue];
    NSString *title = [itemInfo stringForKey: @"title"];
    
    NSString *fileTag = [NSString stringWithFormat:@"%d-%d", (int)nodeID, (int)fileID];
    
    NodeFiles *item = [self nodeFileByTag:fileTag];
    if (item == nil) {
        item = [self insertNewNodeFile];
    } else {
        return item;
    }
    
    item.nodeID = nodeID;
    item.fileTag = fileTag;
    item.title = title;
    
    // image
    FileItem *image = [self parseFile:[itemInfo objectForKey:@"image"]];
    if (image) {
        [item setImage:image];
    } else {
        NSLog(@"Not found image");
        [item setImage:nil];
    }
    
    return item;
}

- (NodeFiles *) nodeFileByTag: (NSString *) tag {
    return [self itemFromEntity:CoreData_EntityName_NodeFiles whereField:@"fileTag" isEqualToString:tag];
}

- (NodeFiles *) insertNewNodeFile {
    return (NodeFiles *) [NSEntityDescription insertNewObjectForEntityForName: CoreData_EntityName_NodeFiles inManagedObjectContext:self.managedObjectContext];
}

- (NSArray *) nodeFileItemsByNodeID: (NSInteger) nodeID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nodeID = %d", nodeID];
    
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey: @"fileTag" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDate, nil];
    
    return [self itemsFromEntity:CoreData_EntityName_NodeFiles withPredicate:predicate andSortDescriptors:sortDescriptors];
}

#pragma mark - Node category

- (NodeCategory *) nodeCategoryByID: (NSInteger) itemID {
    return [self itemFromEntity:CoreData_EntityName_NodeCategory whereField:@"categoryID" isEqualToInteger:itemID];
}

- (NodeCategory *) insertNewNodeCategory {
    return (NodeCategory *) [NSEntityDescription insertNewObjectForEntityForName: CoreData_EntityName_NodeCategory inManagedObjectContext:self.managedObjectContext];
}

- (NodeCategory *) parseNodeCategory: (NSDictionary *) itemInfo {
    if (!itemInfo || ![itemInfo isKindOfClass: [NSDictionary class]]) return nil;
    
    NSInteger categoryID = [[itemInfo numberForKey: @"id"] integerValue];
    NSString *title = [itemInfo stringForKey: @"title"];
    NSInteger order = [[itemInfo numberForKey: @"order"] integerValue];
    NSInteger version = [[itemInfo numberForKey: @"version"] integerValue];
    
    NodeCategory *item = [self nodeCategoryByID:categoryID];
    if (item == nil) {
        item = [self insertNewNodeCategory];
    }
    item.categoryID = categoryID;
    item.title = title;
    item.order = order;
    item.version = version;
    
    return item;
}

- (NSArray *) nodeCategoryItems {
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortOrder, nil];
    
    return [self itemsFromEntity:CoreData_EntityName_NodeCategory withPredicate:nil andSortDescriptors:sortDescriptors];
}

#pragma mark - Files

- (FileItem *) parseFile: (NSDictionary *) fileInfo {
    if (!fileInfo || ![fileInfo isKindOfClass: [NSDictionary class]]) return nil;
    
    NSString *filePath = [fileInfo stringForKey: @"path"];
    NSString *fileHash = [fileInfo stringForKey: @"hash"];
    NSInteger fileSize = [[fileInfo numberForKey: @"size"] integerValue];
    NSInteger fileWidth = [[fileInfo numberForKey: @"width"] integerValue];
    NSInteger fileHeight = [[fileInfo numberForKey: @"height"] integerValue];
    NSString *fileMime = [fileInfo stringForKey: @"mime"];
    
    FileItem *file = [self fileByPath: filePath];
    if (file == nil) {
        file = [self insertNewFile];
    } else {
        if ([file.fileHash isEqualToString: fileHash]) {
            return file;
        }
    }
    
    file.fileHash   = fileHash;
    file.filePath   = filePath;
    file.fileMime   = fileMime;
    file.fileSize   = fileSize;
    file.fileWidth  = fileWidth;
    file.fileHeight = fileHeight;
    
    return file;
}

- (FileItem *) fileByPath:(NSString *)itemPath {
    return [self itemFromEntity:CoreData_EntityName_FileItem whereField:@"filePath" isEqualToString:itemPath];
}

- (FileItem *) insertNewFile {
    return (FileItem *) [NSEntityDescription insertNewObjectForEntityForName: CoreData_EntityName_FileItem inManagedObjectContext:self.managedObjectContext];
}

- (NSArray *) fileItems {
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"fileID" ascending: NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortOrder, nil];
    
    return [self itemsFromEntity:CoreData_EntityName_FileItem withPredicate:nil andSortDescriptors:sortDescriptors];
}

#pragma mark - Gallery

- (GalleryName *) galleryNameByID: (NSInteger) itemID {
    return [self itemFromEntity:CoreData_EntityName_GalleryName whereField:@"galleryID" isEqualToInteger:itemID];
}

- (GalleryName *) insertNewGalleryName {
    return (GalleryName *) [NSEntityDescription insertNewObjectForEntityForName: CoreData_EntityName_GalleryName inManagedObjectContext:self.managedObjectContext];
}

- (GalleryName *) parseGalleryName: (NSDictionary *) itemInfo {
    if (!itemInfo || ![itemInfo isKindOfClass: [NSDictionary class]]) return nil;
    
    NSInteger galleryID = [[itemInfo numberForKey: @"id"] integerValue];
    NSString *title   =  [itemInfo stringForKey: @"title"];
    NSInteger version = [[itemInfo numberForKey:@"version"] integerValue];
    
    GalleryName *item = [self galleryNameByID:galleryID];
    if (item == nil) {
        item = [self insertNewGalleryName];
    } else if (item.version == version) {
        return item;
    }
    item.galleryID = galleryID;
    item.title = title;
    item.version = version;
    
    // parse items
    NSMutableDictionary *actualIds = nil;
    NSArray *galleryItems = [itemInfo objectForKey:@"items"];
    if (galleryItems && [galleryItems isKindOfClass:[NSArray class]]) {
        actualIds = [NSMutableDictionary dictionaryWithCapacity: [galleryItems count]];
        
        for (NSDictionary *galleryItemInfo in galleryItems) {
            GalleryItem *galleryItem = [self parseGalleryItem: galleryItemInfo];
            if (galleryItem) {
                NSString *itemKey = [NSString stringWithFormat:@"%d", galleryItem.galleryItemID];
                [actualIds setObject:itemKey forKey:itemKey];
                
                [item addItemsObject:galleryItem];
            }
        }
    }
    if (actualIds) {
        NSArray *items = [self galleryItemsByGallery:item];
        for (GalleryItem *galleryItem in items) {
            NSString *itemKey = [NSString stringWithFormat:@"%d", galleryItem.galleryItemID];
            if ([actualIds objectForKey:itemKey]) continue;
            
            [item removeItemsObject:galleryItem];
        }
    }
    
    return item;
}

#pragma mark - Gallery item

- (GalleryItem *) galleryItemByID: (NSInteger) itemID {
    return [self itemFromEntity:CoreData_EntityName_GalleryItem whereField:@"galleryItemID" isEqualToInteger:itemID];
}

- (GalleryItem *) insertNewGalleryItem {
    return (GalleryItem *) [NSEntityDescription insertNewObjectForEntityForName: CoreData_EntityName_GalleryItem inManagedObjectContext:self.managedObjectContext];
}

- (GalleryItem *) parseGalleryItem: (NSDictionary *) itemInfo {
    if (!itemInfo || ![itemInfo isKindOfClass: [NSDictionary class]]) return nil;
    
    NSInteger galleryItemID = [[itemInfo numberForKey: @"id"] integerValue];
    NSString *title  =  [itemInfo stringForKey: @"title"];
    NSInteger order = [[itemInfo numberForKey:@"order"] integerValue];
    
    GalleryItem *item = [self galleryItemByID:galleryItemID];
    if (item == nil) {
        item = [self insertNewGalleryItem];
    }
    item.galleryItemID = galleryItemID;
    item.text = title;
    item.order = order;
    
    // image
    FileItem *image = [self parseFile:[itemInfo objectForKey:@"image"]];
    if (image) {
        [item setImage:image];
    }
    
    return item;
}

- (NSArray *) galleryItemsByGallery: (GalleryName *) gallery {
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"gallery = %@", gallery];
    
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortOrder, nil];
    
    return [self itemsFromEntity:CoreData_EntityName_GalleryItem withPredicate:predicate andSortDescriptors:sortDescriptors];
}

#pragma mark - banners

- (NSArray *) allBanners {
    return [self itemsFromEntity:CoreData_EntityName_Banners withPredicate:nil andSortDescriptors:nil];
}

- (Banners *) bannerByID: (NSUInteger) itemID {
    return [self itemFromEntity:CoreData_EntityName_Banners whereField:@"bannerID" isEqualToInteger:itemID];
}

- (Banners *) insertNewBanner {
    return (Banners *) [NSEntityDescription insertNewObjectForEntityForName: CoreData_EntityName_Banners inManagedObjectContext:self.managedObjectContext];
}

- (Banners *) parseBannersItem: (NSDictionary *) itemInfo {
    if (!itemInfo || ![itemInfo isKindOfClass: [NSDictionary class]]) return nil;
    
    NSDateFormatter *dateFormatter = [self dateFormatterForServer];
    
    NSInteger bannerID = [[itemInfo numberForKey: @"id"] integerValue];
    NSInteger updated = [[itemInfo numberForKey: @"modified"] intValue];
    
    NSDate *startDate = [dateFormatter dateFromString: [itemInfo stringForKey: @"start_date"]];
    NSDate *endDate = [dateFormatter dateFromString: [itemInfo stringForKey: @"end_date"]];
    
    NSTimeInterval curTime = [[NSDate date] timeIntervalSinceReferenceDate];
    if ([endDate timeIntervalSinceReferenceDate] < curTime) return nil;
    
    NSError *error = nil;
    NSRegularExpression *replaceProtocol = [NSRegularExpression regularExpressionWithPattern:@"^(http://|https://|ftp://)" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Regular error: %@", error);
        return nil;
    }
    NSRegularExpression *replaceSuffix = [NSRegularExpression regularExpressionWithPattern:@"\\?[0-9]+$" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Regular error: %@", error);
        return nil;
    }
    
    NSString *pathLandscape = [itemInfo stringForKey: @"pathLandscape"];
    NSString *pathPortrait = [itemInfo stringForKey: @"pathPortrait"];
    
    NSString *pathLandscapeClean = [replaceProtocol stringByReplacingMatchesInString:pathLandscape options:0 range:NSMakeRange(0, [pathLandscape length]) withTemplate:@""];
    pathLandscapeClean = [replaceSuffix stringByReplacingMatchesInString:pathLandscapeClean options:0 range:NSMakeRange(0, [pathLandscapeClean length]) withTemplate:@""];
    
    NSString *pathPortraitClean = [replaceProtocol stringByReplacingMatchesInString:pathPortrait options:0 range:NSMakeRange(0, [pathPortrait length]) withTemplate:@""];
    pathPortraitClean = [replaceSuffix stringByReplacingMatchesInString:pathPortraitClean options:0 range:NSMakeRange(0, [pathPortraitClean length]) withTemplate:@""];
    
    Banners *item = [self bannerByID: bannerID];
    if (item != nil) {
        if (item.updated == updated) return item;
    } else {
        item = [self insertNewBanner];
    }

    item.bannerID = bannerID;
    item.bannerType = [[itemInfo numberForKey: @"type"] intValue];
    item.bannerEnabled = [[itemInfo numberForKey: @"enabled"] boolValue];
    item.startDate = [startDate timeIntervalSinceReferenceDate];
    item.endDate = [endDate timeIntervalSinceReferenceDate];
    item.updated = updated;
    item.pathLandscape = pathLandscapeClean;
    item.pathPortrait  = pathPortraitClean;
    item.showTime = [[itemInfo numberForKey: @"show_time"] floatValue];
    item.waitTime = [[itemInfo numberForKey: @"wait_time"] floatValue];
    item.link = nil;
    item.order = [[itemInfo numberForKey: @"order"] intValue];
    item.showAction = [itemInfo stringForKey: @"show_action"];
    item.fileSizeLandscape = [[itemInfo numberForKey: @"fileSizeLandscape"] intValue];
    item.fileSizePortrait = [[itemInfo numberForKey: @"fileSizePortrait"] intValue];
    
    // parse banners links
    NSArray *bannersLinks = [itemInfo objectForKey: @"urls"];
    if (bannersLinks && [bannersLinks isKindOfClass: [NSArray class]]) {
        for (NSDictionary *bannerLinkInfo in bannersLinks) {
            BannersLinks *bannerLink = [self parseBannersLink: bannerLinkInfo];
            
            [item addLinkItemsObject: bannerLink];
        }
    }
    
    return item;
}

- (Banners *) findBannerByType: (BannersType) type {
    NSArray *items = [self allBannersByType: type];
    if (items == nil) return nil;
    
    return [items objectAtIndex: 0];
}

- (NSArray *) allBannersByType: (BannersType) type {
    // predicate
    NSDate *currentDate = [NSDate date];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(bannerType = %d) AND (startDate < %@) AND (endDate > %@)", type, currentDate, currentDate];
    
    // sort order
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortOrder, nil];
    
    return [self itemsFromEntity:CoreData_EntityName_Banners withPredicate:predicate andSortDescriptors:sortDescriptors];
}

- (BannersLinks *) bannerLinkByID: (NSUInteger) itemID {
    return [self itemFromEntity:CoreData_EntityName_BannersLinks whereField:@"linkID" isEqualToInteger:itemID];
}

- (BannersLinks *) parseBannersLink: (NSDictionary *) itemInfo {
    if (!itemInfo || ![itemInfo isKindOfClass: [NSDictionary class]]) return nil;
    
    NSInteger linkID = [[itemInfo numberForKey: @"id"] integerValue];
    NSString *frameLandscape = [itemInfo stringForKey: @"frame_landscape"];
    NSString *framePortrait = [itemInfo stringForKey: @"frame_portrait"];
    NSString *link = [itemInfo stringForKey: @"url"];
    NSString *action = [itemInfo stringForKey: @"open_action"];
    
    BannersLinks *item = [self bannerLinkByID:linkID];
    if (item == nil) {
        item = [self insertNewBannerLink];
    }
    
    item.linkID = linkID;
    item.frameLandscape = frameLandscape;
    item.framePortrait = framePortrait;
    item.link = link;
    item.action = action;
    
    return item;
}

- (BannersLinks *) insertNewBannerLink {
    return (BannersLinks *) [NSEntityDescription insertNewObjectForEntityForName: CoreData_EntityName_BannersLinks inManagedObjectContext:self.managedObjectContext];
}

#pragma mark - Node search

- (NSArray *) searchNodesWithWords:(NSArray *)words inRange:(NSRange)range {
    NSMutableArray *subpredicates = [NSMutableArray array];
    
    for(NSString *term in words) {
        if([term length] == 0) { continue; }
        NSPredicate *p = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ or pre CONTAINS[cd] %@ or text CONTAINS[cd] %@ or titleSub CONTAINS[cd] %@", term, term, term, term];
        [subpredicates addObject:p];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO];
    NSSortDescriptor *sortType = [NSSortDescriptor sortDescriptorWithKey: @"type" ascending: YES];
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDate, sortType, sortOrder, nil];
    
    return [self itemsFromEntity:CoreData_EntityName_NodeItem withPredicate:predicate sortDescriptors:sortDescriptors andRange:range];
    
//    // predicate
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ or pre CONTAINS[cd] %@ or text CONTAINS[cd] %@", string, string, string];
//    
//    // sort order
//    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortOrder, nil];
//    
//    return [self itemsFromEntity:CoreData_EntityName_NodeItem withPredicate:predicate sortDescriptors:sortDescriptors andRange:range];

}

#pragma mark - Media items

- (NSArray *) mediaNodesWithRange: (NSRange) range {
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"isMedia = 1"];
    
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO];
    NSSortDescriptor *sortType = [NSSortDescriptor sortDescriptorWithKey: @"type" ascending: YES];
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDate, sortType, sortOrder, nil];
    
    return [self itemsFromEntity:CoreData_EntityName_NodeItem withPredicate:predicate sortDescriptors:sortDescriptors andRange:range];
}

- (NodeItem *) lastMediaItem {
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"isMedia = 1"];
    
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO];
    NSSortDescriptor *sortType = [NSSortDescriptor sortDescriptorWithKey: @"type" ascending: YES];
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"order" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDate, sortType, sortOrder, nil];
    
    return [self itemFromEntity:CoreData_EntityName_NodeItem withPredicate:predicate andSortDescriptors:sortDescriptors];
}

@end
