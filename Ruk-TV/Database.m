//
//  Database.m
//  App Builder
//
//  Created by Gazelle on 2/10/14.
//  Copyright (c) 2014 Kaidoora. All rights reserved.
//

#import "Database.h"

@implementation Database


-(id) initWithDBName: (NSString*) dbname
{
    self = [self init];

    DatabaseName = [NSString stringWithString:dbname];
    database=nil;
    
    /*
    if ([self Exist])
    {
        NSLog(@"doesn't exist");
        if ([self OpenDatabase])
        {
            
        }
    } else {
        NSLog(@"exist");

    }
    
    NSMutableDictionary* testing = [[NSMutableDictionary alloc] init];
    
    [testing setObject:@"INTEGER PRIMARY KEY" forKey:@"ID"];
    [testing setObject:@"TEXT" forKey:@"Name"];

    [self CreateTable:@"TestTable" Cols:testing];
     */
    return self;
}

-(NSMutableArray*) SelectFrom:(NSString*) what From: (NSString*) table Statement: (NSString*) statement
{
    sqlite3_stmt *selectstmt;
    
    NSMutableArray* results = [[NSMutableArray alloc] init];
    
    NSString* selectStatement = [NSString stringWithFormat:@"select %@ from %@ %@", what, table,statement];
    
    
    NSLog(@"%s", [selectStatement UTF8String]);
    if (database == nil) [self OpenDatabase];
	if (sqlite3_prepare_v2(database, [selectStatement UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)
	{
		while (sqlite3_step(selectstmt) == SQLITE_ROW)
        {
            NSMutableArray* columns = [[NSMutableArray alloc] init];

            NSLog(@"There are %i colums",sqlite3_column_count(selectstmt) );
            for (int i=0;i < sqlite3_column_count(selectstmt);i++)
            {
                int dataType = sqlite3_column_type(selectstmt, i);
                
                switch (dataType)
                {
                    case SQLITE_INTEGER:
                    {
                        int int_value = sqlite3_column_int(selectstmt, i);
                        NSNumber* number = [[NSNumber alloc] initWithInt:int_value];
                        
                        
                        NSMutableDictionary* val = [[NSMutableDictionary alloc] init];
                        
                        [val setObject:number forKey:@"value"];
                        [val setObject:@"NSNumberInt" forKey:@"type"];

                        
                        [columns addObject:val];
                        break;
                    }
                    case SQLITE_FLOAT:
                    {
                        float float_value = sqlite3_column_double(selectstmt, i);
                        NSNumber* floNum = [[NSNumber alloc] initWithFloat:float_value];
                        NSMutableDictionary* val = [[NSMutableDictionary alloc] init];
                        
                        [val setObject:floNum forKey:@"value"];
                        [val setObject:@"NSNumberFloat" forKey:@"type"];
                        
                        
                        [columns addObject:val];
                        break;
                    }
                    case SQLITE_TEXT:
                    {
                        char* char_value = (char*) sqlite3_column_text(selectstmt, i);
                        NSString* charVal = [[NSString alloc] initWithUTF8String:char_value];
                        NSMutableDictionary* val = [[NSMutableDictionary alloc] init];
                        
                        [val setObject:charVal forKey:@"value"];
                        [val setObject:@"NSString" forKey:@"type"];
                        
                        
                        [columns addObject:val];
                        break;
                    }
                }
            }
            
            [results addObject:columns];
        }
        sqlite3_finalize(selectstmt);
        
        [self CloseDatabase];
    }
    return results;
}

-(bool)  OpenDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent: DatabaseName];
    if (sqlite3_open([documentsDirectory UTF8String],&database) == SQLITE_OK)
	{
		return true;
	}
    return false;
}

-(bool) Exist
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:DatabaseName])
    {
        return false;
    }
    return true;
}

-(bool) ExistiOS
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent: DatabaseName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
    {
        return false;
    }
    return true;
}

-(bool) CreateTable: (NSString*) tablename Cols:(NSMutableDictionary*) values
{
    int total;
    int succeed = false;
    sqlite3_stmt *selectstmt;
    
    if (database == nil) [self OpenDatabase];
    
    total = 0;
    
    NSString* command = [NSString stringWithFormat:@"CREATE TABLE %@(", tablename];
    
    for (NSString* key in values)
    {
        total++;
        command = [command stringByAppendingFormat:@"%@ %@", key, [values objectForKey:key]];
        if (total != [values count])
        {
            command = [command stringByAppendingString:@","];
        }
    }
    
    command = [command stringByAppendingString:@")"];

    if (sqlite3_prepare_v2(database,[command UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)
    {
        if(sqlite3_step(selectstmt)==SQLITE_DONE)
        {
            succeed= true;
            NSLog(@"created successfully");
        }
        else if(sqlite3_step(selectstmt) != SQLITE_BUSY)
        {
            succeed= false;
            NSLog(@"Create failed");
        }
        
    } else {
        succeed= false;
    }
    sqlite3_finalize(selectstmt);
    
    [self CloseDatabase];
    
    return succeed;
}

-(bool) InsertInto: (NSString*) tablename Values: (NSMutableArray*) valueInfo
{
    if (database == nil) [self OpenDatabase];
    sqlite3_stmt *selectstmt;
    bool succeed=false;
    NSString* insertString = [NSString stringWithFormat:@"INSERT into %@ VALUES(", tablename];
    
    for (int i =0; i < [valueInfo count];i++)
    {
        insertString = [insertString stringByAppendingFormat:@"%@", [valueInfo objectAtIndex:i]];
        if (i != [valueInfo count]-1)
        {
            insertString = [insertString stringByAppendingString:@","];
        }
    }
    insertString = [insertString stringByAppendingString:@")"];
    
    NSLog(@"Insert is %@", insertString);
    
    if (sqlite3_prepare_v2(database,[insertString UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)
    {
        if(sqlite3_step(selectstmt)==SQLITE_DONE)
        {
            succeed= true;
            NSLog(@"Inserted successfully");
        }
        else if(sqlite3_step(selectstmt) != SQLITE_BUSY)
        {
            succeed= false;
            NSLog(@"Insert failed");
        }
        
    } else {
        succeed= false;
    }
    sqlite3_finalize(selectstmt);
    
    [self CloseDatabase];

    return succeed;
}

-(bool) Update: (NSString*) table Where: (NSString*) whereclause Set: (NSMutableDictionary*) setstatement
{
    sqlite3_stmt *selectstmt;
    bool succeed=false;

    if (database == nil) [self OpenDatabase];
    

    NSString* update = [NSString stringWithFormat: @"UPDATE %@ Set ", table];
    
    for (NSString* key in setstatement)
    {
        update = [update stringByAppendingFormat:@"%@=\"%@\" ",[setstatement objectForKey:key], key ];
        
    }
    
    update = [update stringByAppendingFormat:@"where %@",whereclause];
    
    NSLog(@"%@",update);

    
    if (sqlite3_prepare_v2(database,[update UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)
    {
        if(sqlite3_step(selectstmt)==SQLITE_DONE)
        {
            succeed= true;
            NSLog(@"Update successfully");
        }
        else if(sqlite3_step(selectstmt) != SQLITE_BUSY)
        {
            succeed= false;
            NSLog(@"Update failed");
        }
        
    } else {
        NSLog(@"Update failed");
        succeed= false;
    }
    sqlite3_finalize(selectstmt);
    
    [self CloseDatabase];
    
    return succeed;
}


-(bool) Delete: (NSString*) table URL: (NSString*) urlToDeleted
{
    sqlite3_stmt *selectstmt;
    bool succeed=false;
    
    if (database == nil) [self OpenDatabase];
    
    
    NSString* update = [NSString stringWithFormat: @"DELETE FROM %@ WHERE ID=\"%@\"", table, urlToDeleted];
    

    
    if (sqlite3_prepare_v2(database,[update UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)
    {
        if(sqlite3_step(selectstmt)==SQLITE_DONE)
        {
            succeed= true;
        }/*
        else if(sqlite3_step(selectstmt) != SQLITE_BUSY)
        {
            succeed= false;
            NSLog(@"delete failed");
        }*/
        
    } else {
        NSLog(@"delete failed");
        succeed= false;
    }
    sqlite3_finalize(selectstmt);
    
    [self CloseDatabase];
    
    return succeed;
}


-(void) CloseDatabase
{
    sqlite3_close(database);
    database =  nil;
}

@end
