//
//  MyConDatabase.m
//  MyCon
//
//  Created by    on 20/02/14.
//  Copyright (c) 2014   . All rights reserved.
//

#import "Database.h"
#import "Utilities.h"

static Database *_databaseObject;

@implementation Database
@synthesize database = _database;

+(Database *)databaseObject
{
    if(_databaseObject == nil)
    {
        _databaseObject = [[Database alloc]init];
    }
    return _databaseObject;
}

+(void)resetDatabase
{
    _databaseObject = nil;
    _databaseObject.database=nil;
    
}

-(id)init
{
    if(self = [super init]){
        NSFileManager *fileManager;
        NSError *error;
        BOOL success, isDirectory;
        
        fileManager = [NSFileManager defaultManager];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Chat"];
        
        NSString *path = [Utilities documentsPath:@"BrandReport"];

        //Does directory already exist?
        
        if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory] || !isDirectory)
        {
            if (![fileManager createDirectoryAtPath:path
                                           withIntermediateDirectories:NO
                                                            attributes:nil
                                                                 error:&error])
            {
                NSLog(@"Create directory error.:: %@", error);
            }
        }
        
        NSString *writablePath = [path stringByAppendingPathComponent:@"BrandReport.sqlite"];
        
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BrandReport.sqlite"];
        
        success = [fileManager fileExistsAtPath:writablePath];
        NSLog(@"writablePath %@",writablePath);
        NSLog(@"bundlePath %@",bundlePath);
        
        if(!success) {
            success = [fileManager copyItemAtPath:bundlePath toPath:writablePath error:&error];
        }
        
        if (!success) {
            NSLog(@"error: %@",[error localizedDescription]);
        }
        
        if(sqlite3_open([writablePath UTF8String], &_database) != SQLITE_OK){
            NSLog(@"Failed to open database");
        }
    }
    return self;
}
@end
