//
//  ViewController.m
//  MobileInsights1
//
//  Created by Krishnamurthy, Megha on 10/3/13.
//  Copyright (c) 2013 Krishnamurthy, Megha. All rights reserved.
//

#import "ViewController.h"
#import "ShoppingListDetailItem.h"
#import "JSON.h"
#import "SqlLiteDelegate.h"

@interface ViewController ()
+(void)searchEbayProducts:(NSString *)text;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClick:(id)sender {
  _label1.text = @"Hello ";
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        NSString *songPlaycount = [song valueForProperty: MPMediaItemPropertyLastPlayedDate];
        NSString *songArtist = [song valueForProperty: MPMediaItemPropertyArtist];
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSLog (@"%@ - %@ - %@", songTitle, songArtist, songPlaycount);
        
        SqlLiteDelegate *appDelegate = [SqlLiteDelegate sharedDelegate];
        //TODO: warn the user when no text entered
//        if (![songTitle isEqualToString:@""])
//        {
//            [appDelegate addShoppingListItemToDB:songTitle];
//        }
//        
        NSMutableArray *accesseriesResult =        [self searchEbayProducts:songArtist:@"11450"];
        NSMutableArray *ticketsResult =        [self searchEbayProducts:songArtist:@"173634"];
        NSMutableArray *collectiblesResult =        [self searchEbayProducts:songArtist:@"1"];
        
        break;
    }
}


-(NSMutableArray *)searchEbayProducts:(NSString *)text:(NSString *) categoryId
{
    NSMutableArray *ebaySearchItems = [[NSMutableArray alloc] init];
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    NSString *const EbayAPIKey1 = @"EbayInc45-cdba-4b3a-83d4-36024607a12";
    
    // @TODO add location picker
    
/**    Clothing Shoes and Accessories: 11450
    Concert Tickets: 173634
Collectibles: 1
 **/

    // Build the string to call the Milo API
//	NSString *urlString = [NSString stringWithFormat:@"http://open.api.ebay.com/shopping?appid=%@&version=709&siteid=0&callname=FindAdvancedItems&CategoryId=1&QueryKeywords=%@&responseencoding=JSON", EbayAPIKey1, text];
	NSString *urlString = [NSString stringWithFormat:@"http://open.api.ebay.com/shopping?appid=%@&version=709&siteid=0&callname=FindItems&CategoryId=%@&QueryKeywords=%@&responseencoding=JSON", EbayAPIKey1, categoryId, text];

    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"EbayUrl: %@", urlString);
    
    
    // Create NSURL string from formatted string
	NSURL *url = [NSURL URLWithString:urlString];
    
    // Prepare URL request to download statuses from Twitter
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Perform request and get JSON back as a NSData object
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    /* Return Value
     The downloaded data for the URL request. Returns nil if a connection could not be created or if the download fails.
     */
    if (response == nil) {
        // Check for problems
        if (requestError != nil) {
            NSString *errorIdentifier = [NSString stringWithFormat:@"(%@)[%d]",requestError.domain,requestError.code];
            
            NSLog(@"Error: %@\n\n", errorIdentifier);
                   }
    }
    else
    {
        
        
        
        // Get JSON as a NSString from NSData response
        NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString: %@\n\n", jsonString);
        
        // NSString *jsonString = [jsonString1 substringFromIndex:14];
        // parse the JSON response into an object
        // Here we're using NSArray since we're parsing an array of JSON status objects
        NSDictionary *results = [jsonString JSONValue];
        
        //  NSArray *results = [parser objectWithString:jsonString error:nil];
        
        // Each element in statuses is a single status
        NSArray *products = [results objectForKey:@"Item"];
        NSInteger count = 5;
        // Loop through each entry in the dictionary...
        for (NSDictionary *photo in products)
        {
            
            // Get title of the image
            NSString *title = [photo objectForKey:@"Title"];
            
            NSString *desc = [photo objectForKey:@"Title"];
            
            // NSLog(@"title: %@\n\n", title);
            NSDictionary *offers = [photo objectForKey:@"ConvertedCurrentPrice"];
            // Build the URL to where the image is stored (see the Flickr API)
            NSString *photoURLString =[photo objectForKey:@"GalleryURL"];
            //NSLog(@"photoURLString: %@", photoURLString);
            
            NSString *currentPrice = [NSString stringWithFormat:@"%@%@", @"$", [offers objectForKey:@"Value"]];
            
            NSString *itemId = [photo objectForKey:@"ItemID"];
            //NSLog(@"Price: %@\n\n", currentPrice);
            ShoppingListDetailItem *item = [[ShoppingListDetailItem alloc]
                                            initWithName:desc :photoURLString:title :currentPrice:@"eBay":itemId];
            
            
            
            [ebaySearchItems addObject:item];
            count++;
            break;
            
        }
      }
    /**
     [response release];
     [urlResponse release];
     [requestError release];
     **/
    // NSLog(@"EbayItems->%@\n\n",[ebaySearchItems count]);
    return ebaySearchItems;
}

@end
