//
//  DBManager.m
//  eLog
//
//  Created by nopilas on 2014-09-10.
//  Copyright (c) 2014 nopilas. All rights reserved.
//
#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"eLog.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];

    //[filemgr removeItemAtPath:databasePath error:nil];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char * errMsg;
            char *sql_stmt1 = "CREATE TABLE IF NOT EXISTS Boat (No integer primary key, Name text, Color text)";
            if (sqlite3_exec(database, sql_stmt1, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            char *sql_stmt2 = "CREATE TABLE IF NOT EXISTS Customer (Id integer primary key, Login text, Password text, licenceHolder text, lobsterLicence text, vesselName text, vesselNumber text, zone text)";
            if (sqlite3_exec(database, sql_stmt2, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            char *sql_stmt3 = "CREATE TABLE IF NOT EXISTS Daily (Id integer, LineNo integer, soakDays integer, market integer, sculpin integer, cunner integer, rockCrab integer, hauledTraps integer, canner integer, Date DateTime, Sent integer)";
            if (sqlite3_exec(database, sql_stmt3, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            
            sqlite3_close(database);
            return  isSuccess;
        }
        else
        {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveDataUserInfo:(int)idUser licenceHolder:(NSString*)licenceHolder lobsterlicence:(NSString*)lobsterLicence vesselName:(NSString *)vesselName vesselNumber:(NSString *)vesselNumber zone:(NSString *)zone;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE Customer SET licenceHolder = \"%@\", lobsterLicence = \"%@\", vesselName = \"%@\", vesselNumber = \"%@\", zone = \"%@\" WHERE Id = \"%d\"",licenceHolder,lobsterLicence, vesselName, vesselNumber, zone, idUser];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            return YES;
        }
        else
        {
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}

- (BOOL) saveDataCustomer:(int)Id login:(NSString*)login password:(NSString*)password;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Customer (id, login, password) VALUES                              (\"%d\", \"%@\", \"%@\")",Id, login, password];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            return YES;
        }
        else
        {
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}

- (BOOL) saveDataDaily:(int)idUser lineNo:(int)lineNo soakDays:(int)soakDays market:(int)market sculpin:(int)sculpin cunner:(int)cunner rockCrab:(int)rockCrab hauledTraps:(int)hauledTraps canner:(int)canner Date:(NSString*)Date;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Daily (Id, LineNo, soakDays, market, sculpin, cunner, rockCrab, hauledTraps, canner, Date, Sent) VALUES (\"%d\", \"%d\", \"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\", \"%@\", 0)",idUser, lineNo, soakDays, market, sculpin, cunner, rockCrab, hauledTraps, canner, Date];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        //char* errMsg;
        //sqlite3_exec(database, insert_stmt, NULL, NULL, &errMsg);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            return YES;
        }
        else
        {
            sqlite3_reset(statement);
            return NO;
        }
        
    }
    return NO;
}


- (NSArray*) SelectListCustomer
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT login FROM Customer"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *login = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:login];
                sqlite3_reset(statement);
                return resultArray;
            }
            else
            {
                sqlite3_reset(statement);
                NSLog(@"Not found");
                return nil;
            }
        }
    }
    return nil;
}

- (int) SelectCustomerInfo:(NSString *)login password:(NSString *)password
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT id FROM Customer WHERE login = \"%@\" AND password = \"%@\"", login, password];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *Id = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:Id];
                sqlite3_reset(statement);
                return [Id intValue];
            }
            else
            {
                sqlite3_reset(statement);
                NSLog(@"Not found");
                return -1;
            }
            
        }
    }
    return -1;
}

- (NSArray*) SelectDailyInfo:(int)login
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LineNo, soakDays, market, sculpin, canner, rockCrab, hauledTraps, cunner, Date FROM Daily WHERE Sent = 0 AND id = \"%d\" ", login];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
               
                int lineNo =  sqlite3_column_int(statement, 0);
                int soakDays = sqlite3_column_int(statement, 1);
                int market = sqlite3_column_int(statement, 2);
                int sculpin = sqlite3_column_int(statement, 3);
                int canner =  sqlite3_column_int(statement, 4);
                int rockCrab = sqlite3_column_int(statement, 5);
                int hauledTraps = sqlite3_column_int(statement, 6);
                int cunner = sqlite3_column_int(statement, 7);
                NSString *date = [[NSString alloc]initWithUTF8String:  (const char *) sqlite3_column_text(statement, 8)];
                
                NSArray *keys = [NSArray arrayWithObjects:@"id", @"lineNo", @"soakDays", @"market", @"sculpin", @"cunner", @"rockCrab", @"hauledTraps", @"canner", @"date", nil];
                NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", login], [NSString stringWithFormat:@"%d",lineNo], [NSString stringWithFormat:@"%d",soakDays], [NSString stringWithFormat:@"%d",market], [NSString stringWithFormat:@"%d",sculpin], [NSString stringWithFormat:@"%d",cunner], [NSString stringWithFormat:@"%d",rockCrab], [NSString stringWithFormat:@"%d",hauledTraps], [NSString stringWithFormat:@"%d",canner], date,  nil];
                NSDictionary *trackDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                                
                [resultArray addObject:trackDictionary];
                sqlite3_reset(statement);
                return resultArray;
            }
        }
        else
            sqlite3_reset(statement);
    }
    return nil;
}

@end