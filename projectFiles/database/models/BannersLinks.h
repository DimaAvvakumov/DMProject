//
//  BannersLinks.h
//  DMProject
//
//  Created by Dima Avvakumov on 10.02.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Banners;

@interface BannersLinks : NSManagedObject

@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSString * frameLandscape;
@property (nonatomic, retain) NSString * framePortrait;
@property (nonatomic, retain) NSString * link;
@property (nonatomic) int32_t linkID;
@property (nonatomic, retain) Banners *banner;

@end
