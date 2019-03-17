//
//  Database.h
//  App Builder
//
//  Created by Gazelle on 2/10/14.
//  Copyright (c) 2014 Kaidoora. All rights reserved.
//

#import "sqlite3.h"

@interface Database : NSObject
{
    NSString* DatabaseName;
    sqlite3* database;
}

-(bool) Update: (NSString*) table Where: (NSString*) whereclause Set: (NSMutableDictionary*) setstatement;
-(bool) Exist;
-(bool) ExistiOS;
-(bool) OpenDatabase;
-(bool) CreateTable: (NSString*) tablename Cols:(NSMutableDictionary*) values;
-(id) initWithDBName: (NSString*) dbname;
-(bool) InsertInto: (NSString*) tablename Values: (NSMutableArray*) valueInfo;
-(void) CloseDatabase;
-(NSMutableArray*) SelectFrom:(NSString*) what From: (NSString*) table Statement: (NSString*) statement;
-(bool) Delete: (NSString*) table URL: (NSString*) urlToDeleted;
@end
