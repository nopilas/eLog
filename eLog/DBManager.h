//
//  DBManager.h
//  eLog
//
//  Created by nopilas on 2014-09-10.
//  Copyright (c) 2014 nopilas. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
- (NSArray*) SelectListCustomer;
- (int) SelectCustomerInfo:(NSString *)login password:(NSString *)password;
- (BOOL) saveDataCustomer:(int)Id login:(NSString*)login password:(NSString*)password;
- (BOOL) saveDataDaily:(int)idUser lineNo:(int)lineNo soakDays:(int)soakDays market:(int)market sculpin:(int)sculpin cunner:(int)cunner rockCrab:(int)rockCrab hauledTraps:(int)hauledTraps canner:(int)canner Date:(NSString*)Date longitude:(double)longitude latitude:(double)latitude;
- (NSArray*) SelectDailyInfo:(int)login;
- (BOOL) saveDataUserInfo:(int)idUser licenceHolder:(NSString*)licenceHolder lobsterlicence:(NSString*)lobsterLicence vesselName:(NSString *)vesselName vesselNumber:(NSString *)vesselNumber zone:(NSString *)zone;
-(BOOL)updateSentDaily:(int)idUser;
- (NSDictionary*) SelectDataUser:(int)login;
@end