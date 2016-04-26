//
//  MyConDatabase.h
//  MyCon
//
//  Created by    on 20/02/14.
//  Copyright (c) 2014   . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject{
    sqlite3 *_database;
}

@property (nonatomic, assign) sqlite3 *database;

+(Database *)databaseObject;
+(void)resetDatabase;

@end