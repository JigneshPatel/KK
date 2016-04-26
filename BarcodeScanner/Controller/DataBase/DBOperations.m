//
//  DBOperations.m


#import "DBOperations.h"
#import <sqlite3.h>
#import "Constant.h"
#import "Utilities.h"

static DBOperations  *_dbOperationsObject;
static Database *dbObject;
#define DatabaseName @"BrandReport.sqlite"

@implementation DBOperations

+(DBOperations *)dbOperationsObject
{
    
    _dbOperationsObject = [[DBOperations alloc]init];
    dbObject = [Database databaseObject];
    
    return _dbOperationsObject;
}

+(void)resetDatabase
{
    _dbOperationsObject = nil;
    [Database resetDatabase];
}

#pragma mark Check Image Id

-(NSString *) dataFilePath
{
    
    NSString *documentsDirectory = [Utilities documentsPath:DatabaseName];
    
    return documentsDirectory;
}

-(BOOL)recordExistOrNot:(NSString *)query{
    BOOL recordExist=NO;
    sqlite3 *database = dbObject.database;
    NSInteger retval = 0;
    if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
    {
        sqlite3_stmt *statement;
        retval = sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, Nil);
        if(retval == SQLITE_OK)
        {
            if (sqlite3_step(statement)==SQLITE_ROW)
            {
                recordExist=YES;
            }
            else
            {
                //////NSLog(@"%s,",sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
    }
    return recordExist;
}

#pragma mark Get Last Id

-(int )getLastCId
{
    
    int max = 0;
    sqlite3_stmt *statement;
    sqlite3 *database = dbObject.database;
    
    NSString *query = @"SELECT MAX(MRId) FROM MyReport";
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, Nil) == SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_ROW)
        {
            max = sqlite3_column_int(statement, 0);
        }
    }
    
    return max;
}

-(NSMutableArray *)getAllMyReports
{
    sqlite3_stmt *statement;
    sqlite3 *database = dbObject.database;
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    
    //May20
    NSString *query = @"SELECT  * FROM \"MyReport\"";
    
    const char *zSql  = [query UTF8String];
    
    if(sqlite3_prepare_v2(database, zSql, -1, &statement, Nil) == SQLITE_OK)
    {
        
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary  *dict_Temp = [[NSMutableDictionary alloc]init];
            
            NSString *MRId;
            NSString *MRCode;
            NSString *MRImage;
            NSString *MRManft;
            NSString *MRBrand;
            NSString *MRProduct;
            NSString *MRSize;
            NSString *MRComment;
            NSString *MRAddress;
            NSString *MRLat;
            NSString *MRLong;
            NSString *MRDate;
            NSString *MRStatus;
            
            if((char *)sqlite3_column_text(statement, 0) != NULL)
            {
                MRId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }else{
                MRId = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 1) != NULL)
            {
                MRCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            }else{
                MRCode = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 2) != NULL)
            {
                MRImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            }else{
                MRImage = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 3) != NULL)
            {
                MRManft=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            }else{
                MRManft = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 4) != NULL)
            {
                MRBrand=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            }else{
                MRBrand = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 5) != NULL)
            {
                MRProduct=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            }else{
                MRProduct = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 6) != NULL)
            {
                MRSize=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            }else{
                MRSize = @"";
            }
            if((char *)sqlite3_column_text(statement, 7) != NULL)
            {
                MRComment=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
            }else{
                MRComment = @"";
            }
            if((char *)sqlite3_column_text(statement, 8) != NULL)
            {
                MRAddress=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
            }else{
                MRAddress = @"";
            }
            if((char *)sqlite3_column_text(statement, 9) != NULL)
            {
                MRLat=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            }else{
                MRLat = @"";
            }
            if((char *)sqlite3_column_text(statement, 10) != NULL)
            {
                MRLong=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
            }else{
                MRLong = @"";
            }
            if((char *)sqlite3_column_text(statement, 11) != NULL)
            {
                MRDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
            }else{
                MRDate = @"";
            }
            if((char *)sqlite3_column_text(statement, 12) != NULL)
            {
                MRStatus =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
            }else{
                MRStatus = @"";
            }
            
                        
            [dict_Temp setObject:MRId forKey:@"MRId"];
            [dict_Temp setObject:MRCode forKey:@"MRCode"];
            [dict_Temp setObject:MRImage forKey:@"MRImage"];
            [dict_Temp setObject:MRManft forKey:@"MRManft"];
            [dict_Temp setObject:MRBrand forKey:@"MRBrand"];
            [dict_Temp setObject:MRProduct forKey:@"MRProduct"];
            [dict_Temp setObject:MRSize forKey:@"MRSize"];
            [dict_Temp setObject:MRComment forKey:@"MRComment"];
            [dict_Temp setObject:MRAddress forKey:@"MRAddress"];
            [dict_Temp setObject:MRLat forKey:@"MRLat"];
            [dict_Temp setObject:MRLong forKey:@"MRLong"];
            [dict_Temp setObject:MRDate forKey:@"MRDate"];
            [dict_Temp setObject:MRStatus forKey:@"MRStatus"];
            
            [retval addObject:dict_Temp];
        }
        sqlite3_finalize(statement);
    }
    
    return retval;
}

-(NSInteger)insertIntoMyReport:(MyReportObject *)conversationObject
{
    sqlite3_stmt *statement;
    sqlite3 *database = dbObject.database;
    NSInteger retval = 0;
    
    NSString *queryGroup = @"INSERT INTO \"MyReport\" (MRCode, MRImage, MRManft, MRBrand, MRProduct, MRSize, MRComment, MRAddress, MRLat, MRLong, MRDate, MRStatus) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
    
    retval = sqlite3_prepare_v2(database, [queryGroup UTF8String], -1, &statement, Nil);
    
    if(retval == SQLITE_OK)
    {
        
        if ([conversationObject.code isKindOfClass:[NSNull class]]) {
            conversationObject.code = @"";
        }

        sqlite3_bind_text(statement, 1,[conversationObject.code UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2,[conversationObject.image UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3,[conversationObject.manft UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4,[conversationObject.brand UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5,[conversationObject.product UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6,[conversationObject.size UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7,[conversationObject.comment UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 8,[conversationObject.address UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 9,[conversationObject.lat UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 10,[conversationObject.longt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 11,[conversationObject.date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 12,[conversationObject.status UTF8String], -1, SQLITE_TRANSIENT);
        
    }
    
    if(sqlite3_step(statement) != SQLITE_DONE ) {
        NSLog( @"Save Error in Select_Contact: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(statement);
    return retval;
    
}

-(NSInteger)deleteParticularReport:(NSString *)strId
{
    int intCID = [strId intValue];
    
    sqlite3_stmt *statement;
    sqlite3 *database = dbObject.database;
    NSInteger retval = 0;
    
    NSString *query = @"DELETE from \"MyReport\" where MRId = ?";
    
    retval = sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, Nil);
    
    if(retval == SQLITE_OK)
    {
        
        sqlite3_bind_int(statement, 1, intCID);
    }
    
    if(sqlite3_step(statement) != SQLITE_DONE ) {
        NSLog( @"Save Error in Select_Contact: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(statement);
    
    return retval;
    
}

-(NSDictionary *)getParticularReport:(int)intCId
{
    sqlite3_stmt *statement;
    sqlite3 *database = dbObject.database;
    
    NSMutableDictionary  *dict_Temp = [[NSMutableDictionary alloc]init];
    
    
    NSString *query = @"SELECT  * FROM \"MyReport\" where MRId = ?";
    
    const char *zSql  = [query UTF8String];
    
    
    if(sqlite3_prepare_v2(database, zSql, -1, &statement, Nil) == SQLITE_OK)
    {
        
        sqlite3_bind_int(statement, 1, intCId);
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            NSString *MRId;
            NSString *MRCode;
            NSString *MRImage;
            NSString *MRManft;
            NSString *MRBrand;
            NSString *MRProduct;
            NSString *MRSize;
            NSString *MRComment;
            NSString *MRAddress;
            NSString *MRLat;
            NSString *MRLong;
            NSString *MRDate;
            NSString *MRStatus;
            
            if((char *)sqlite3_column_text(statement, 0) != NULL)
            {
                MRId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }else{
                MRId = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 1) != NULL)
            {
                MRCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            }else{
                MRCode = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 2) != NULL)
            {
                MRImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            }else{
                MRImage = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 3) != NULL)
            {
                MRManft=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            }else{
                MRManft = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 4) != NULL)
            {
                MRBrand=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            }else{
                MRBrand = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 5) != NULL)
            {
                MRProduct=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            }else{
                MRProduct = @"";
            }
            
            if((char *)sqlite3_column_text(statement, 6) != NULL)
            {
                MRSize=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            }else{
                MRSize = @"";
            }
            if((char *)sqlite3_column_text(statement, 7) != NULL)
            {
                MRComment=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
            }else{
                MRComment = @"";
            }
            if((char *)sqlite3_column_text(statement, 8) != NULL)
            {
                MRAddress=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
            }else{
                MRAddress = @"";
            }
            if((char *)sqlite3_column_text(statement, 9) != NULL)
            {
                MRLat=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            }else{
                MRLat = @"";
            }
            if((char *)sqlite3_column_text(statement, 10) != NULL)
            {
                MRLong=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
            }else{
                MRLong = @"";
            }
            if((char *)sqlite3_column_text(statement, 11) != NULL)
            {
                MRDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
            }else{
                MRDate = @"";
            }
            if((char *)sqlite3_column_text(statement, 12) != NULL)
            {
                MRStatus =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
            }else{
                MRStatus = @"";
            }
            
            
            [dict_Temp setObject:MRId forKey:@"MRId"];
            [dict_Temp setObject:MRCode forKey:@"MRCode"];
            [dict_Temp setObject:MRImage forKey:@"MRImage"];
            [dict_Temp setObject:MRManft forKey:@"MRManft"];
            [dict_Temp setObject:MRBrand forKey:@"MRBrand"];
            [dict_Temp setObject:MRProduct forKey:@"MRProduct"];
            [dict_Temp setObject:MRSize forKey:@"MRSize"];
            [dict_Temp setObject:MRComment forKey:@"MRComment"];
            [dict_Temp setObject:MRAddress forKey:@"MRAddress"];
            [dict_Temp setObject:MRLat forKey:@"MRLat"];
            [dict_Temp setObject:MRLong forKey:@"MRLong"];
            [dict_Temp setObject:MRDate forKey:@"MRDate"];
            [dict_Temp setObject:MRStatus forKey:@"MRStatus"];
            
        }
        sqlite3_finalize(statement);
    }
    
    return dict_Temp;
}

#pragma mark Update Conversation

-(NSInteger)updateIntoConversation:(MyReportObject *)conversationObject whereMRId:(int)intMRId
{
    
    sqlite3_stmt *statement;
    sqlite3 *database = dbObject.database;
    NSInteger retval = 0;
    
    NSString *queryGroup = @"UPDATE MyReport SET MRCode = ?,MRImage = ?,MRManft = ?, MRBrand = ? , MRProduct = ? , MRSize = ?, MRComment = ?, MRAddress = ?, MRLat = ?, MRLong = ?, MRDate = ?, MRStatus = ? WHERE MRId = ?";
    
    retval = sqlite3_prepare_v2(database, [queryGroup UTF8String], -1, &statement, Nil);
    
    if(retval == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1,[conversationObject.code UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2,[conversationObject.image UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3,[conversationObject.manft UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4,[conversationObject.brand UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5,[conversationObject.product UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6,[conversationObject.size UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7,[conversationObject.comment UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 8,[conversationObject.address UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 9,[conversationObject.lat UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 10,[conversationObject.longt UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 11,[conversationObject.date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 12,[conversationObject.status UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_int(statement, 13, intMRId);

        
    }
    if(sqlite3_step(statement) != SQLITE_DONE ) {
        NSLog( @"Save Error in updateIntoConversation: %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(statement);
    
    return retval;
    
}

@end
