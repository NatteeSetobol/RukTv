//
//  ViewController.m
//  Ruk-TV
//
//  Created by code on 3/20/14.
//  Copyright (c) 2014 nomication. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize searchBar,channelView,toast,XMLTemp,Channels,key,streamTV,searchResults,refreshControl,shadedView,filteredChannels,Favorites, mMPayer,panel, favor,logo, channelInfo, button2, ChannelURL;


#pragma mark - ViewController call back

-(id) init
{
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float panelX=0.0f;
    float panelY=0.0f;
    float channelListWidth;
    float channelListHeight;
    float channelListX;
    float channelListY;
    float favorX;
    float favorY;
    float logox;
    float logoy;
    float messageX;
    float messageY;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    float tableHeight;
    self.view.tag = 45;
    self.view.multipleTouchEnabled=true;
    streamTV=nil;
    is_searching=false;
    is_downloading=false;
    is_loading=false;
    isPlaying=false;
    mMPayer = [VMediaPlayer sharedInstance];
    [mMPayer setupPlayerWithCarrierView:self.view withDelegate:self];
    
    Channels = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init];

    shadedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 820, 820)];
    shadedView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    [self.view addSubview:shadedView];
    shadedView.tag=79;
    shadedView.hidden = false;
    shadedView.multipleTouchEnabled=false;
    shadedView.userInteractionEnabled=true;
    channelInfo=NULL;
    ChannelURL=NULL;
    
	// Do any additional setup after loading the view, typically from a nib.
   /* if (IS_IPHONE5)
    {
        tableHeight = 456;
    } else {
        tableHeight = 368;
    }
    */
    //Check for iOS7 or iOS 6 and less
    if ([[vComp objectAtIndex:0] intValue] >= 7)
    {
        is_iOS7 = true;
        
    } else if ([[vComp objectAtIndex:0] intValue] == 6)
    {
        is_iOS7 = false;
    }

    //set the width, height and positions based on the iOS version
    if (is_iOS7)
    {
        [[UINavigationBar appearance] setBarTintColor: [UIColor redColor]];
        searchBar.tintColor = [UIColor redColor];

        panelX=75.0f;
        panelY=220.0f;
        
        channelListX=115.0f;
        channelListHeight=336.0f;
        channelListY=200.0f;
        favorX=80.0f;
        favorY=200.0;
        logox=150.0;
        logoy=160.0;
        messageX=120.0f;
        messageY=70.0f;

    } else {
        searchBar.tintColor = [UIColor redColor];
        panelX=75.0f;
        panelY=150.0f;
        channelListHeight = 336.0f;
        channelListX=60.0f;
        channelListY=200.0f;
        favorX=80.0f;
        favorY=130.0;
        logox=150.0;
        logoy=90.0;
        messageX=120.0f;
        messageY=10.0f;

    }
    /******************* NAVIGATION BAR ***************/
    
    [self.navigationController setTitle:@"Ruk-TV"];
    
    /* PULL OUT MENU TAKEN OUT*/

    //ADD TO FAVIORITE BUTTON ON THE NAVIGATION BAR
    button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(12.0, 2.0, 45.0, 40.0)];
    [button2 addTarget:self action:@selector(AddToFavorites:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:[UIImage imageNamed:@"heart-hi.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button3 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    channelInfo=NULL;

    NSArray *actionButtonItems2 = @[button3];
    self.navigationItem.leftBarButtonItems = actionButtonItems2;
    
    
    UIBarButtonItem* BBitem =  [[[UIBarButtonItem alloc] initWithTitle:@"Go Back"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil] autorelease];
    
    if (is_iOS7)
    {
        [self.navigationItem.backBarButtonItem setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTranslucent:false];
        self.navigationController.navigationBar.titleTextAttributes =  @{UITextAttributeTextColor : [UIColor whiteColor]};
    }
    
    self.navigationItem.backBarButtonItem = BBitem;
    self.view.userInteractionEnabled = true;


    /***** CHANNEL PANEL *****/
    
    panel = [[UILabel alloc] initWithFrame:CGRectMake(panelX, panelY, 345, 170)];
	panel.backgroundColor=[UIColor whiteColor];
	panel.layer.cornerRadius = 10;
    panel.layer.masksToBounds = YES;
    panel.multipleTouchEnabled=false;
    
    [self.view addSubview:panel];
    

    channelView = [[UITableView alloc] initWithFrame:CGRectMake(channelListY, channelListX, 90, channelListHeight) style:UITableViewStylePlain];

    channelView.delegate = self;
    channelView.dataSource = self;
    channelView.transform=CGAffineTransformMakeRotation(M_PI/2);
    channelView.pagingEnabled=true;
    channelView.canCancelContentTouches=true;
    self.view.multipleTouchEnabled = true;
    refreshControl = [[UIRefreshControl alloc] init];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh channel list."];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [channelView addSubview:refreshControl];
    [self.view addSubview:channelView];
    
    if (refreshControl)
    {
        [refreshControl release];
        refreshControl=nil;
    }
    
    favor = [[UIButton alloc] initWithFrame:CGRectMake(favorX, favorY, 32.0, 32.0)];
    [favor setFrame:CGRectMake(favorX, favorY, 32.0, 32.0)];

    [favor addTarget:self action:@selector(ShowFavoriteChannels:) forControlEvents:UIControlEventTouchUpInside];
    [favor setImage:[UIImage imageNamed:@"heart-hi.png"] forState:UIControlStateNormal];
    [self.view addSubview:favor];
    

    logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ruktvlogo.png"]];
    [logo setFrame:CGRectMake(logox, logoy, 150.0, 80.0)];
    [self.view addSubview:logo];
    [self display:false];
    
    /******************* Version info check*/
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"ruk.xml"];

    NSMutableURLRequest *req1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.angelfire.com/anime5/picca/info.json"]];
    
    toast = [[Toast alloc] initWithText:@"Checking for channel updates.." Title:@"Ruk-TV" Seconds:-1 x:messageX y: messageY];
    [self.view addSubview:toast];

    
    
    OHURLLoader *loader = [OHURLLoader URLLoaderWithRequest: req1];
    
    
    [loader startRequestWithResponseHandler:^(NSURLResponse* response)
     {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
         //ignore
     } progress:^(NSUInteger receivedBytes, long long expectedBytes)
     {
         
     } completion:^(NSData* serviceResponseJson, NSInteger httpStatusCode)
     {
         

         if (httpStatusCode >= 400)
         {
             /*ERROR*/
             NSString *docDir = [paths objectAtIndex:0];
             docDir = [docDir stringByAppendingPathComponent:@"ruk.xml"];
             if ([[NSFileManager defaultManager] fileExistsAtPath: docDir])
             {
                 NSData* xmlData = [[NSData alloc] initWithContentsOfFile: docDir];
                 // toast = [[Toast alloc] initWithText:@"Loading Channels..." Title:@"Ruk-TV" Seconds:-1 x:messageX y: messageY];
                 isPlaying=false;
                 [self.view addSubview:toast];
                 [self LoadChannels: xmlData ];
                 is_downloading=false;
          
             } else {
                 [toast ToastText:@"Error: Cannot update."];
                 
             }
         }
         
         if(httpStatusCode == 200)
         {
             NSError* error;
             float versionfloat=0.0f;
             NSString* version;
             
             NSDictionary* json = [NSJSONSerialization
                                   JSONObjectWithData: [loader.receivedString dataUsingEncoding:NSUTF8StringEncoding]
                                   options:kNilOptions
                                   error:&error];

             NSString *docdir = [paths objectAtIndex:0];
             docdir = [docdir stringByAppendingPathComponent:@"info.json"];
             
             
             if (json == nil)
             {
                 NSString *docDir = [paths objectAtIndex:0];
                 docDir = [docDir stringByAppendingPathComponent:@"ruk.xml"];
                 if ([[NSFileManager defaultManager] fileExistsAtPath: docDir])
                 {
                     NSData* xmlData = [[NSData alloc] initWithContentsOfFile: docDir];
                     // toast = [[Toast alloc] initWithText:@"Loading Channels..." Title:@"Ruk-TV" Seconds:-1 x:messageX y: messageY];
                     isPlaying=false;
                     [self.view addSubview:toast];
                     [self LoadChannels: xmlData ];
                     is_downloading=false;
                   
                 } else {
                     [toast ToastText:@"Unable to recieve information. Please check your internet connection."];
                     
                 }
                 return ;
             }
             
             version= [json objectForKey:@"Version"];
             versionfloat = [version doubleValue];
             
             NSDictionary* files=[json objectForKey:@"Channel"];
             if (files)
             {
                 ChannelURL = [[NSString alloc] initWithString:[files objectForKey:@"URL1"]];
             }
            // NSLog(@"%@", files);
             
             if ([[NSFileManager defaultManager] fileExistsAtPath: docdir])
             {
                 NSError* error2;
                 
                 NSData* fileData = [[NSData alloc] initWithContentsOfFile:docdir];

                 NSDictionary* jsonhardfile = [NSJSONSerialization
                                       JSONObjectWithData: fileData
                                       options:kNilOptions
                                       error:&error2];
                 
                 NSString* channelversion= [jsonhardfile objectForKey:@"Version"];

                 
                 float channelversionfloat = [channelversion doubleValue];
                
            
                 if (channelversionfloat > versionfloat)
                 {
                     NSError* fileerror;
                     [loader.receivedString writeToFile:docdir atomically:YES encoding:NSUTF8StringEncoding error:&fileerror];
                     is_downloading=true;
                     //toast = [[Toast alloc] initWithText:@"Downloading Channels Infomation..." Title:@"Ruk-TV" Seconds:-1 x:messageX y: messageY];
                     [toast ToastText:@"Downloading Channels Infomation..."];

                     isPlaying=false;
                     [self DownloadXML];
                     
                 } else {
                     NSData* xmlData = [[NSData alloc] initWithContentsOfFile: documentsDirectory];
                    // toast = [[Toast alloc] initWithText:@"Loading Channels..." Title:@"Ruk-TV" Seconds:-1 x:messageX y: messageY];
                     [toast ToastText:@"Loading Channels..."];

                     isPlaying=false;
                     [self.view addSubview:toast];
                     [self LoadChannels: xmlData ];
                     is_downloading=false;
                    // [xmlData release];
                     //xmlData=nil;

                 }
                 
                 if (fileData)
                 {
                     [fileData release];
                     fileData=NULL;
                 }
             } else {
                 is_downloading=true;
                // toast = [[Toast alloc] initWithText:@"Downloading Channels Infomation..." Title:@"Ruk-TV" Seconds:-1 x:messageX y: messageY];
                 [toast ToastText:@"Downloading Channels Infomation..."];

                 [self.view addSubview:toast];
                 
                 isPlaying=false;
                 [self DownloadXML];
                 NSError* fileerror;
                 [loader.receivedString writeToFile:docdir atomically:YES encoding:NSUTF8StringEncoding error:&fileerror];
             }
         }
         
     } errorHandler:^(NSError* error){
         NSString *docDir = [paths objectAtIndex:0];
         docDir = [docDir stringByAppendingPathComponent:@"ruk.xml"];
         if ([[NSFileManager defaultManager] fileExistsAtPath: docDir])
         {
             NSData* xmlData = [[NSData alloc] initWithContentsOfFile: docDir];
            // toast = [[Toast alloc] initWithText:@"Loading Channels..." Title:@"Ruk-TV" Seconds:-1 x:messageX y: messageY];
             isPlaying=false;
             [self.view addSubview:toast];
             [self LoadChannels: xmlData ];
             is_downloading=false;
           
         } else {
             [toast ToastText:@"Unable to recieve information. Please check your internet connection."];

         }

     }];

    Favorites = [[Database alloc] initWithDBName:@"FavoriteChannels"];
    
    if (!Favorites.ExistiOS)
    {
        NSMutableDictionary* columns = [[NSMutableDictionary alloc] init];
        [columns setObject:@"INTEGER PRIMARY KEY" forKey:@"ID"];
        [columns setObject:@"TEXT" forKey:@"Name"];
        [columns setObject:@"TEXT" forKey:@"Icon"];
        [columns setObject:@"TEXT" forKey:@"URL"];

        [Favorites CreateTable:@"Favorites" Cols:columns];
        if (columns)
        {
            [columns release];
            columns=nil;
        }
    } else {

        
    }

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     UITouch *aTouch = [touches anyObject];
    
    if ([[aTouch view] isKindOfClass:[ViewController class]] || aTouch.view.tag == 79 || aTouch.view.tag == 49)
    {
       // CGPoint touch_point = [aTouch locationInView:self.view];
    
        if (self.navigationController.navigationBar.hidden)
        {
             [self display:true];
        } else {
             [self display:false];
        }
    }
}

-(void) display: (bool) show
{
    searchBar.hidden = !show;
    channelView.hidden = !show;
    self.navigationController.navigationBar.hidden =!show;
    panel.hidden=!show;
    favor.hidden = !show;
    logo.hidden = !show;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - Loading

-(BOOL) LoadChannels: (NSData*) data
{
    bool parsingResult=false;
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    
    [parser setDelegate:self];
    parsingResult = [parser parse];
    count=0;
    toast.hidden=true;
    [channelView reloadData];
    [self.refreshControl endRefreshing];

    
    for (int j=0;j< [filteredChannels count];j++)
    {
        for (int i=0; i < [Channels count]; i++)
        {
            NSMutableDictionary* channelData = [Channels objectAtIndex:i];
            NSString* urlcheck = [channelData objectForKey:@"url"];
            NSString* filURL = [filteredChannels objectAtIndex:j];
            
            NSArray* replacer = [filURL componentsSeparatedByString:@" "];
            if ([replacer count] == 1)
            {
                if ([urlcheck isEqualToString:filURL])
                {
                    [Channels removeObjectAtIndex:i];
                
                }
            } else {
                if ([urlcheck isEqualToString:[replacer objectAtIndex:0]])
                {
                    [channelData setObject:[replacer objectAtIndex:1] forKey:@"url"];
                    
                }

            }
            
        }
    }
    
    [channelView reloadData];
    [self display:true];

    
    
    if (data != nil)
    {
        [data release];
        data = nil;
    }
    
    if (parser != nil)
    {
        [parser release];
        parser=nil;
    }
    return parsingResult;
}


-(BOOL) DownloadXML
{
    NSURL  *url;
    NSString *urlData;
    NSError* error;
   NSMutableURLRequest *req1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ChannelURL]];
    url = [NSURL URLWithString:@"http://www.angelfire.com/anime5/picca/ruktv.txt"];
    urlData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    if (urlData)
    {
        NSArray* splitedData = [urlData componentsSeparatedByString:@"\n"];

        filteredChannels = [[NSMutableArray alloc] init];

        for (int i=0;i<[splitedData count];i++)
        {
            NSString* u = [splitedData objectAtIndex:i];
            u = [u stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c",10] withString:@""];
            u = [u stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c",13] withString:@""];

            [filteredChannels addObject:u];        
        }




        OHURLLoader *loader = [OHURLLoader URLLoaderWithRequest: req1];


        [loader startRequestWithResponseHandler:^(NSURLResponse* response)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
            //ignore
        } progress:^(NSUInteger receivedBytes, long long expectedBytes)
        {
            
        } completion:^(NSData* serviceResponseJson, NSInteger httpStatusCode)
        {
            if (httpStatusCode >= 400)
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                documentsDirectory = [documentsDirectory stringByAppendingPathComponent: @"ruk.xml"];
                if ([[NSFileManager defaultManager] fileExistsAtPath: documentsDirectory ])
                {
                    NSData* xmlData = [[NSData alloc] initWithContentsOfFile: documentsDirectory];

                    [self LoadChannels: xmlData ];
                    
                    is_downloading=false;
                    if (xmlData)
                    {
                        [xmlData release];
                        xmlData=nil;
                    }
                }
                toast.hidden=false;
                [toast ToastText:@"Unable to recieve information. Please check your internet connection."];
                if (mMPayer.isPlaying == true)
                {
                    isPlaying=false;
                }
                [self display:true];
                
            }
            
            if(httpStatusCode == 200)
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                documentsDirectory = [documentsDirectory stringByAppendingPathComponent: @"ruk.xml"];
                is_downloading=true;
                if (loader.receivedData == nil)
                {
                    toast.hidden=false;
                    [toast ToastText:@"Unable to recieve information. Please check your internet connection."];
                    isPlaying=false;
                    if (mMPayer.isPlaying == true)
                    {
                        isPlaying=false;
                    }
                    [self display:true];
                } else {
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    [fileManager removeItemAtPath:documentsDirectory error:NULL];
                    [loader.receivedData writeToFile:documentsDirectory atomically:YES];
                    [self LoadChannels:loader.receivedData];
                    

                }
            }
             
        } errorHandler:^(NSError* error){
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            documentsDirectory = [documentsDirectory stringByAppendingPathComponent: @"ruk.xml"];
            if ([[NSFileManager defaultManager] fileExistsAtPath: documentsDirectory ])
            {
                NSData* xmlData = [[NSData alloc] initWithContentsOfFile: documentsDirectory];
                
                [self LoadChannels: xmlData ];
                if (xmlData)
                {
                    [xmlData release];
                    xmlData=nil;
                }
                is_downloading=false;
            }
            toast.hidden=false;
            [toast ToastText:@"Unable to recieve information. Please check your internet connection."];
            if (mMPayer.isPlaying == true)
            {
                isPlaying=false;
            }
            [self display:true];
        }];
    } else {
        toast.hidden=false;
        [toast ToastText:@"This app requires internet connection. Please connect to the internet and try again"];
        if (mMPayer.isPlaying == true)
        {
            isPlaying=false;
        }
        [self display:true];

    }
    return true;
}

/********************************** XML PARSING CALL BACK */
#pragma mark - XML Parsing call back

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{

    if ( [elementName isEqualToString:@"Channel"])
    {
        
        if (toast)
        {
            toast.hidden=false;
            [toast ToastText:[NSString stringWithFormat:@"Loading %i" ,[Channels count]]];
        }
        XMLTemp = [[NSMutableDictionary alloc] init];
        
        return;
    } else {
        key = [[NSString alloc] initWithString:elementName];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Channel"] )
    {
        if (XMLTemp != nil)
        {
            [Channels addObject:XMLTemp];
            [XMLTemp release];
            XMLTemp=nil;
        }
    }
    
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if (key != nil)
    {
        if ([key isEqualToString:@"image"])
        {
            //Download the image
            NSArray* splitURL = [string componentsSeparatedByString:@"/"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSURL  *url;
            NSData *urlData;
            
            documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[splitURL objectAtIndex:[splitURL count] -1]];
            
            if (is_downloading)
            {
                if (![[NSFileManager defaultManager] fileExistsAtPath: documentsDirectory ])
                {
                    url = [NSURL URLWithString:string];
                    urlData = [NSData dataWithContentsOfURL:url];
                    if (urlData)
                    {

                            [urlData writeToFile:documentsDirectory atomically:YES];
                        
                    }
                }
                
                
                
            }
        }

        if (![string isEqualToString:@"-"])
        {
            [XMLTemp setObject:string forKey:key];
        } else {
            [XMLTemp release];
            XMLTemp=nil;
        }
        [key release];
        key = nil;
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    if (tableView == channelView)
    {
        if (is_searching)
        {
            return [searchResults count];
        }
        return [Channels count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == channelView)
    {
        NSDictionary* xmlInfo;
        
        if (is_searching)
        {

            if (indexPath.row < [searchResults count])
            {
                xmlInfo = [searchResults objectAtIndex:indexPath.row];
            } else {
                xmlInfo = [Channels objectAtIndex:indexPath.row];
            }
        
        } else {
            xmlInfo = [Channels objectAtIndex:indexPath.row];
        }
        
        NSString *CellIdentifier = [NSString stringWithString:[xmlInfo objectForKey:@"name"]];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:CellIdentifier] autorelease];
            
            UIView *selectionColor = [[UIView alloc] init];
            selectionColor.backgroundColor = [UIColor redColor];
            cell.selectedBackgroundView = selectionColor;
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator ];
            
            NSArray* splitURL = [[xmlInfo objectForKey:@"image"] componentsSeparatedByString:@"/"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[splitURL objectAtIndex:[splitURL count]-1] ];
            
            
            NSData *urlData = [NSData dataWithContentsOfFile: documentsDirectory];

           if ([[NSFileManager defaultManager] fileExistsAtPath: documentsDirectory ])
           {
                UIImageView* logoView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:urlData]];
                
                logoView.frame = CGRectMake(10, 10, 64, 64);
                logoView.transform =  CGAffineTransformMakeRotation(-M_PI/2);

                [cell.contentView addSubview:logoView];
            
                [logoView release];
                logoView=nil;
          }

        }
    
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == channelView)
    {
    
        return 84;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == channelView)
    {
        NSDictionary* selectedItem;
        if (is_searching)
        {
            selectedItem = [searchResults objectAtIndex:indexPath.row];
            channelInfo = selectedItem;
        } else {
            selectedItem = [Channels objectAtIndex:indexPath.row];
            channelInfo = selectedItem;
        }
        if (selectedItem)
        {
            NSString* selectedURL = [selectedItem objectForKey:@"url"];
            if (selectedURL)
            {

                
                NSArray* moreThanoneURL = [selectedURL componentsSeparatedByString:@";"];
                
                if ([moreThanoneURL count] > 1)
                {
                    selectedURL = [moreThanoneURL objectAtIndex:[moreThanoneURL count]-1];
                }

                
                toast.hidden = false;
                is_loading=true;
                isPlaying=false;
                [toast ToastText:@"Loading...Please Wait"];
                [mMPayer reset];
                [self display:false];

                UIImage*  ICBA;
                
                if ([self isInFavorite:[channelInfo objectForKey:@"url"]])
                {
                    ICBA = [UIImage imageNamed:@"heart-hi2.png"];
                    
                } else {
                    ICBA = [UIImage imageNamed:@"heart-hi.png"];

                }
                
                [button2 setImage:ICBA forState:UIControlStateNormal];

                 
                 self.title = [selectedItem objectForKey:@"name"];
                 [mMPayer setDataSource:[NSURL URLWithString:selectedURL] header:nil];
                 [mMPayer prepareAsync];
                
                 [self display:false];

   
            }
        }
        
    }
}

- (void)refresh
{
    if (!is_searching)
    {
        is_searching=false;
        [channelView reloadData];
        [self.searchBar resignFirstResponder];
        [self.view endEditing:YES];
        self.searchBar.text = @"";
        
        channelInfo = NULL;
        

        toast.hidden=false;
        [toast ToastText:@"Loading Channels..."];
        
        
        is_downloading=true;
        [Channels removeAllObjects];
        [channelView reloadData];
        [self DownloadXML];
    } else {
        [refreshControl endRefreshing];
    }
}
#pragma mark - Search bar delegation

- (void)searchTableList {
    NSString *searchString = searchBar.text;
    
    for (NSDictionary *tempStr in Channels) {
        
        NSComparisonResult result = [ [tempStr objectForKey:@"name"]  compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [searchResults addObject:tempStr];
            [channelView reloadData];
        }
    }

}

#pragma mark - Search bar call backs

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:true];
    is_searching=true;
    [channelView reloadData];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchResults removeAllObjects];
    [channelView reloadData];
    
    if ([searchText length] != 0)
    {
        if([searchText isEqualToString:@"\n"])
        {
            [self.searchBar resignFirstResponder];
            return ;
        }
        is_searching=YES;
        [self searchTableList];
    } else {
        is_searching=NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    is_searching=false;
    [channelView reloadData];
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
    self.searchBar.text = @"";
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}



#pragma mark - Menu call back

-(id) openmenu: (id) sender
{

        
    CGRect startingframe;

    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^() {
        
        
        
        
    } completion:^(BOOL finished) {
        

        
    }];
    return 0;
}
#pragma mark - Favorites
-(void) ShowFavoriteChannels:(id)sender
{
    if (is_searching)
    {
        is_searching=false;
    } else {
        [searchResults removeAllObjects];
        NSMutableArray* resultz = [Favorites SelectFrom:@"*" From:@"Favorites" Statement:@""];
        for (int i=0;i<[resultz count]; i++)
        {
            NSMutableArray* dict = [resultz objectAtIndex:i];

            NSMutableDictionary* favID = [dict objectAtIndex:0];
            NSMutableDictionary* name = [dict objectAtIndex:1];
            NSMutableDictionary* image = [dict objectAtIndex:2];
            NSMutableDictionary* url = [dict objectAtIndex:3];

            NSMutableDictionary* favs = [[NSMutableDictionary alloc] init];
            [favs setObject:[favID objectForKey:@"value" ] forKey:@"id"];
            [favs setObject:[name objectForKey:@"value"] forKey:@"name"];
            [favs setObject: [image objectForKey:@"value"] forKey:@"image"];
            [favs setObject: [url objectForKey:@"value"] forKey:@"url"];

            [searchResults addObject:favs];
            [favs release];
            favs=nil;

        }
        
        is_searching=true;
    }
    [channelView reloadData];
}

#pragma mark - Media Player call back

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    
    toast.hidden=true;
    [player start];
    isPlaying=true;

}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    [player reset];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    toast.hidden=false;
    [toast ToastText:@"This channel can not be view at this time."];
    [self display:true];
    [mMPayer reset];
    is_loading=false;
    if (mMPayer.isPlaying == true)
    {
        isPlaying=false;
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
    
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{


}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    toast.hidden=true;
}



#pragma mark - Other

-(id) AddToFavorites: (id) sender
{
    if (channelInfo == NULL) return NULL;
    UIButton* button = (UIButton*) sender;
    if ([channelInfo objectForKey:@"url"] == nil) return NULL;
    
    NSString* returnID = [self isInFavorite:[channelInfo objectForKey:@"url"]];
    if (returnID)
    {
        Database* database = [[Database alloc] initWithDBName:@"FavoriteChannels"];
        [database Delete:@"Favorites" URL:returnID];
        [database release];
        database=nil;
        UIImage*  ICBA = [UIImage imageNamed:@"heart-hi.png"];
        
        [button setImage:ICBA forState:UIControlStateNormal];
        
        is_searching=false;
        [self ShowFavoriteChannels:nil];
        return NULL;
    }
    
    Database* database = [[Database alloc] initWithDBName:@"FavoriteChannels"];

        
    NSMutableArray* values = [[NSMutableArray alloc] init];
        
    [values addObject:@"NULL"];
    [values addObject:[NSString stringWithFormat:@"'%@'",[channelInfo objectForKey:@"name"]]];
    [values addObject:[NSString stringWithFormat:@"'%@'",[channelInfo objectForKey:@"image"]]];
    [values addObject:[NSString stringWithFormat:@"'%@'",[channelInfo objectForKey:@"url"]]];
    
    
    [database InsertInto:@"Favorites" Values:values];
    [values release];
    values=nil;
    
    
    UIImage*  ICBA = [UIImage imageNamed:@"heart-hi2.png"];
    
    [button setImage:ICBA forState:UIControlStateNormal];

    is_searching=false;
    [self ShowFavoriteChannels:nil];

    if (database)
    {
        [database release];
        database=nil;
    }
    return NULL;
}

-(NSString*) isInFavorite:(NSString*) urlToCheck
{
    Database* database = [[Database alloc] initWithDBName:@"FavoriteChannels"];
    
    NSMutableArray* selectStat = [database SelectFrom:@"*" From:@"Favorites" Statement: @""];
    for (int i=0;i<[selectStat count]; i++)
    {
        NSMutableArray* dict= [selectStat objectAtIndex:i];
        

        NSMutableDictionary* cUrl = [dict objectAtIndex:3];
        
        NSString* ccURL = [cUrl objectForKey:@"value"];
        
        
        if ([ccURL isEqualToString:urlToCheck])
        {
            NSMutableDictionary* cID = [dict objectAtIndex:0];

            return [cID objectForKey:@"value"];
        }
    }
    return NULL;
}

-(void)dealloc
{
    [filteredChannels release];
    filteredChannels=nil;
    
    [channelView release];
    channelView = nil;
    
    [searchBar release];
    searchBar=nil;
    
    [Channels release];
    Channels=nil;
    
    [Favorites release];
    Favorites=nil;
    
    [favor release];
    favor=nil;
    
    [refreshControl release];
    refreshControl=nil;
}

@end
