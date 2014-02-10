//
//  Banners.h
//  DMProject
//
//  Created by Dima Avvakumov on 10.02.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BannersLinks;

@interface Banners : NSManagedObject

@property (nonatomic) BOOL bannerEnabled;
@property (nonatomic) int32_t bannerID;
@property (nonatomic) int16_t bannerType;
@property (nonatomic) NSTimeInterval endDate;
@property (nonatomic) int32_t fileSizeLandscape;
@property (nonatomic) int32_t fileSizePortrait;
@property (nonatomic, retain) NSString * link;
@property (nonatomic) int32_t order;
@property (nonatomic, retain) NSString * pathLandscape;
@property (nonatomic, retain) NSString * pathPortrait;
@property (nonatomic, retain) NSString * showAction;
@property (nonatomic) float showTime;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) int32_t updated;
@property (nonatomic) float waitTime;
@property (nonatomic, retain) NSSet *linkItems;
@end

@interface Banners (CoreDataGeneratedAccessors)

- (void)addLinkItemsObject:(BannersLinks *)value;
- (void)removeLinkItemsObject:(BannersLinks *)value;
- (void)addLinkItems:(NSSet *)values;
- (void)removeLinkItems:(NSSet *)values;

@end
