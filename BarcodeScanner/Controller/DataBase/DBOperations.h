//
//  DBOperations.h
//


#import <Foundation/Foundation.h>
#import "Database.h"
#import "MyReportObject.h"


@interface DBOperations : NSObject

+(DBOperations *)dbOperationsObject;
+(void)resetDatabase;


//Common Data
-(BOOL)recordExistOrNot:(NSString *)query;
-(NSString *)checkImageIdExistence:(NSString *)msgId
;

-(NSMutableArray *)getAllMyReports;

-(NSInteger)insertIntoMyReport:(MyReportObject *)myReportObject;
-(NSInteger)deleteParticularReport:(NSString *)strId;
-(int )getLastCId;
-(NSDictionary *)getParticularReport:(int)intCId;
-(NSInteger)updateIntoConversation:(MyReportObject *)UserProfileObject whereMRId:(int)intMRId;

@end
