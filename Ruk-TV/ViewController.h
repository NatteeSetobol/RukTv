//
//  ViewController.h
//  Ruk-TV
//
//  Created by code on 3/20/14.
//  Copyright (c) 2014 nomication. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OHURLLoader.h"
#import "Toast.h"
#import "Database.h"
#import "VMediaPlayer.h"
#import "VMediaPlayerDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface ViewController : UIViewController <VMediaPlayerDelegate,UISearchBarDelegate, NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    @public
    bool is_loading;
    UISearchBar* searchBar;
    UITableView* channelView;
    NSMutableDictionary* XMLTemp;
    NSMutableArray* Channels;
    NSMutableArray* searchResults;
    Toast* toast;
    NSString* key;
    bool is_searching;
    bool is_downloading;
    MPMoviePlayerViewController* streamTV;
    UIRefreshControl *refreshControl;
    bool is_iOS7;
    int count;
    bool is_menu_out;
    UIView* shadedView ;
    NSMutableArray* filteredChannels;
    Database* Favorites;
    VMediaPlayer* mMPayer;
    UILabel* panel;
    bool isPlaying;
    UIButton* favor;
    UIImageView* logo;
    NSDictionary* channelInfo;
    UIButton *button2;
    NSString* ChannelURL;
}

@property (retain, nonatomic) UISearchBar* searchBar;
@property (retain, nonatomic) UITableView* channelView;
@property (retain, nonatomic) Toast* toast;
@property (retain, nonatomic) NSMutableDictionary* XMLTemp;
@property (retain, nonatomic) NSMutableArray* Channels;
@property (retain, nonatomic) NSString* key;
@property (retain, nonatomic) MPMoviePlayerViewController* streamTV;
@property (retain, nonatomic) NSMutableArray* searchResults;
@property (retain, nonatomic) UIRefreshControl *refreshControl;
@property (retain, nonatomic) UIView* shadedView;
@property (retain, nonatomic) NSMutableArray* filteredChannels;
@property (retain, nonatomic) Database* Favorites;
@property (retain, nonatomic) VMediaPlayer* mMPayer;
@property (retain, nonatomic)  UILabel* panel;
@property (retain, nonatomic) UIButton* favor;
@property (retain, nonatomic) UIImageView* logo;
@property (retain, nonatomic) NSDictionary* channelInfo;
@property (retain, nonatomic)  UIButton *button2;
@property (retain, nonatomic) NSString* ChannelURL;


-(BOOL) LoadChannels: (NSData*) data;
-(BOOL) DownloadXML;
-(id) openmenu: (id) sender;
-(void) goback: (id) sender;
-(id) tapped:(UITapGestureRecognizer*) tap;
-(void) ShowFavoriteChannels:(id)sender;
-(void) display: (bool) show;
-(id) AddToFavorites: (id) sender;

@end
