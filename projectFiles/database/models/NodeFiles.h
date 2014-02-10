//
//  NodeFiles.h
//  DMProject
//
//  Created by Dima Avvakumov on 10.02.14.
//  Copyright (c) 2014 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FileItem;

@interface NodeFiles : NSManagedObject

@property (nonatomic, retain) NSString * fileTag;
@property (nonatomic) int32_t nodeID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) FileItem *image;

@end
