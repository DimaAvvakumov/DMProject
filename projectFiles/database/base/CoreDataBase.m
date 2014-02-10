//
//  CoreDataBase.m
//  DMProject
//
//  Created by Dima Avvakumov on 18.09.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "CoreDataBase.h"

@interface CoreDataBase ()

@property (strong, nonatomic) NSMutableDictionary *mocDictionary;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (assign, nonatomic) BOOL isPhone;

@end

@implementation CoreDataBase

- (id) init {
    self = [super init];
    if (self) {
        self.mocDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
        
        UIUserInterfaceIdiom ideom = [[UIDevice currentDevice] userInterfaceIdiom];
        self.isPhone = (ideom == UIUserInterfaceIdiomPhone);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadExit) name: NSThreadWillExitNotification  object:nil];
    }
    
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) contextDidSave: (NSNotification *) notification {
    if ([[_mocDictionary allValues] containsObject: notification.object]) {
        SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
        [_managedObjectContext performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
    }
}

- (void) threadExit {
    NSString *threadKey = [NSString stringWithFormat:@"%p", [NSThread currentThread]];
    
    [_mocDictionary removeObjectForKey: threadKey];
}

- (NSManagedObjectContext *) managedObjectContext {
    NSThread *thread = [NSThread currentThread];
    NSString *threadKey = [NSString stringWithFormat:@"%p", thread];
    
    NSManagedObjectContext *threadContext = [_mocDictionary objectForKey: threadKey];
    if ( threadContext == nil ) {
        // create a context for this thread
        threadContext = [[NSManagedObjectContext alloc] init];
        [threadContext setPersistentStoreCoordinator: [self persistentStoreCoordinator]];
        // set merge policy
        NSMergePolicy *policy = [[NSMergePolicy alloc] initWithMergeType: NSOverwriteMergePolicyType];
        // NSMergePolicy *policy = [[NSMergePolicy alloc] initWithMergeType: NSMergeByPropertyObjectTrumpMergePolicyType];
        [threadContext setMergePolicy: policy];
        
        // cache the context for this thread
        [_mocDictionary setObject:threadContext forKey:threadKey];
    }
    
    if ([thread isMainThread]) {
        self.managedObjectContext = threadContext;
    }
    
    return threadContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSString *modelName = [self managedObjectModelName];
    NSString *fullModelName = [NSString stringWithFormat: @"%@.momd", modelName];
    
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: fullModelName];
    NSURL *fileUrl = [NSURL fileURLWithPath: filePath];
    
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: fileUrl];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
	
    NSArray *_cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([_cachePaths count] > 0) ? [_cachePaths objectAtIndex:0] : @"";
    
    NSString *suffix = (_isPhone) ? @"_iPhone" : @"_iPad";
    
    NSString *dbName = [self persistentStoreCoordinatorName];
    NSString *dbFile = [NSString stringWithFormat: @"%@%@.sqlite", dbName, suffix];
    
    NSString *storePath = [basePath stringByAppendingPathComponent: dbFile];
    
	NSURL *storeUrl = [NSURL fileURLWithPath: storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
	NSError *error;
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
	
    return _persistentStoreCoordinator;
}

- (BOOL) saveContext {
    NSError *error;
    if ([self.managedObjectContext save:&error] == NO) {
        NSLog(@"Some error while save context: %@", error);
        //        NSLog(@"Some error while save context");
        return NO;
    }
    
    return YES;
}

- (void) resetContext {
    [self.managedObjectContext reset];
}

- (void) removeObjectFromContext: (NSManagedObject *) object {
    [self.managedObjectContext deleteObject: object];
}

#pragma mark - methods to replace

- (NSString *) managedObjectModelName {
    return @"projectDatabaseModel";
}

- (NSString *) persistentStoreCoordinatorName {
    return @"projectStore";
}

#pragma - help methods

- (id) itemFromEntity: (NSString *) entityName whereField: (NSString *) field isEqualToInteger: (NSInteger) value {
    
    NSString *query = [NSString stringWithFormat:@"%@ = %%d", field];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query, value];
    
    return [self itemFromEntity:entityName withPredicate:predicate];
}

- (id) itemFromEntity: (NSString *) entityName whereField: (NSString *) field isEqualToString:(NSString *)value {
    
    NSString *query = [NSString stringWithFormat:@"%@ = %%@", field];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query, value];
    
    return [self itemFromEntity:entityName withPredicate:predicate];
}

- (id) itemFromEntity: (NSString *) entityName withPredicate: (NSPredicate *) predicate {
    return [self itemFromEntity:entityName withPredicate:predicate andSortDescriptors:nil];
}

- (id) itemFromEntity: (NSString *) entityName withPredicate: (NSPredicate *) predicate andSortDescriptors:(NSArray *)sortDescriptors {
    NSEntityDescription *entry = [NSEntityDescription entityForName:entityName inManagedObjectContext: self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: entry];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    if (sortDescriptors) {
        [fetchRequest setSortDescriptors: sortDescriptors];
    }

    NSError *fetchError;
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if (!fetchResults) {
        // This is a serious error and should advise the user to restart the application
        NSLog(@"Restart apps");
    }
    
    if ([fetchResults count] == 0) {
        return nil;
    }
    
    return [fetchResults objectAtIndex: 0];
}

- (NSArray *) itemsFromEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors {
    
    NSRange range = NSMakeRange(0, 0);
    return [self itemsFromEntity:entityName withPredicate:predicate sortDescriptors:sortDescriptors andRange:range];
}

- (NSArray *) itemsFromEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors andRange:(NSRange)range {
    
    NSEntityDescription *entry = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: entry];
    
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }

    if (sortDescriptors) {
        [fetchRequest setSortDescriptors: sortDescriptors];
    }
    
    if (range.length > 0) {
        [fetchRequest setFetchLimit: range.length];
        [fetchRequest setFetchOffset: range.location];
    }
    
    NSError *fetchError;
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if (!fetchResults) {
        // This is a serious error and should advise the user to restart the application
        NSLog(@"Restart apps");
    }
    
    if ([fetchResults count] == 0) {
        return nil;
    }
    
    return fetchResults;
}

@end
