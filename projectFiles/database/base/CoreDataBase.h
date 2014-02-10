//
//  CoreDataBase.h
//  DMProject
//
//  Created by Dima Avvakumov on 18.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataBase : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (BOOL) saveContext;
- (void) resetContext;
- (void) removeObjectFromContext: (NSManagedObject *) object;

- (id) itemFromEntity: (NSString *) entityName whereField: (NSString *) field isEqualToInteger: (NSInteger) value;
- (id) itemFromEntity: (NSString *) entityName whereField: (NSString *) field isEqualToString: (NSString *) value;
- (id) itemFromEntity: (NSString *) entityName withPredicate: (NSPredicate *) predicate;
- (id) itemFromEntity: (NSString *) entityName withPredicate: (NSPredicate *) predicate andSortDescriptors: (NSArray *) sortDescriptors;

- (NSArray *) itemsFromEntity: (NSString *) entityName withPredicate: (NSPredicate *) predicate andSortDescriptors: (NSArray *) sortDescriptors;
- (NSArray *) itemsFromEntity: (NSString *) entityName withPredicate: (NSPredicate *) predicate sortDescriptors: (NSArray *) sortDescriptors andRange: (NSRange) range;

@end
