//
//  SalesTableViewController.m
//  mylocal
//
//  Created by You, Jerry on 10/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SalesTableViewController.h"
#import "SalesTableViewCell.h"
#import "GlobalHeader.h"
#import "CoreLocation/CLLocation.h"
#import "LocalItemDetailViewController.h"
#import "mylocalAppDelegate.h"
#import "ImageInfo.h"
#import "DownloaderQueue.h"
#import "UrlDownloaderOperation.h"
#import "JSON.h"
#import "SaleDetailViewController.h"
#import "LocalImageCache.h"
#import "Sale.h"
#define MetersOfOneMile 1609.344

//private methods
@interface SalesTableViewController ()
CLLocationDistance getDistanceBetween(CLLocation *c1, CLLocation *c2);
- (NSArray *)sortedSalesFrom:(NSArray*)sales;
-(void)downloadImagesForOnScreenRows;
-(void)startImageDownload:(Sale*)sale forIndexPath:(NSIndexPath*)indexPath;
-(void)dowloadSaleItemsFromLocation:(CLLocation *)location;
- (void)getImageForSale:(Sale*)sale atCell:(SalesTableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath;
@end

@implementation SalesTableViewController
@synthesize saleCell,entries, imageDownloadsInProgress, queue, currentLocation, lastQueryLocation, refreshSalesTimer;

#pragma mark -
#pragma mark View lifecycle

BOOL isRunning;
- (void)viewDidLoad {
    [super viewDidLoad];
	isRunning=YES;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.title=NSLocalizedString(@"Search",@"Search");
	NSMutableArray *a = [[NSMutableArray alloc] init];
	self.entries=a;
	[a release];
	UIBarButtonItem *addSaleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonWasPressed)];
	self.navigationItem.rightBarButtonItem = addSaleButton;
	[addSaleButton release];

	DownloaderQueue *q = [[DownloaderQueue alloc] init];
	self.queue=q;
	[q release];
	
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];;
	
	//start updating location
	[[MyCLController sharedInstance] registerListener:self];
	[[MyCLController sharedInstance] startUpdateLocation];
	//set timer to check sales every minute
	if (refreshSalesTimer!=nil) {
		[refreshSalesTimer invalidate];
	}
	refreshSalesTimer = [NSTimer scheduledTimerWithTimeInterval:120.0 //refresh after 120 seconds
														 target:self
													   selector:@selector(timedRefreshSales:)
													   userInfo:nil
														repeats:YES];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if ([self.entries count]==0) {
		return 1; //show information cell to tell user either "we are downloading" or "there is no sale"
	}else {
		return [self.entries count];
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"saleCell";
    static NSString *InfoCellIdentifier = @"informationItemCell";
	
	if ([self.entries count]==0) {
		//no sales, maybe we are still downloading them or maybe there is no sale in database at all
		UITableViewCell *infocell = [tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier];
		if (infocell==nil) {
			infocell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoCellIdentifier];
		}
		if (isRunning) {
			//still in the process of downloading, display the information
			infocell.textLabel.text=@"Downloading...";
		}else {
			//download finished, just no result
			infocell.textLabel.text=@"It appears there is no sale nearny you. Please check later.";
		}
		return infocell;
	}else {
		//display the customized cell, also begin to download icon lazily in background
		saleCell = (SalesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (saleCell == nil) {
			//load the custim table-view-cell from nib file, this may appears strange. Actually when the iOS load the xib file
			//it will load everything defined, and associate it to the outlet defined in the TableViewController which is the
			//saleCell (because we set the owner of the xib to be the TVC, and associate the TVCellView with the saleCell outlet
			[[NSBundle mainBundle] loadNibNamed:@"SalesTableViewCell" owner:self options:nil];
		}
		//assign the Sale to the saleCell
		Sale *sale = [self.entries objectAtIndex:indexPath.row];
		[saleCell setSale:sale];
		//note the distance is controller by the TableViewControoler
		[saleCell setDistance:getDistanceBetween(self.currentLocation, [[[CLLocation alloc] initWithLatitude:[sale.latitude doubleValue] longitude:[sale.longitude doubleValue]] autorelease])/MetersOfOneMile];
		[self getImageForSale:sale atCell:saleCell withIndexPath:indexPath];
		return saleCell;
	}
		 
}

- (void)getImageForSale:(Sale*)sale atCell:(SalesTableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath{
	if (sale.icon) {
		cell.icon.image=sale.icon;
	}else{
		UIImage *localImage = [LocalImageCache getImageFromKey:sale.iconImageBlobKey];
		if (localImage) {
			sale.icon=localImage;
			cell.icon.image=sale.icon;
			return;
		}else {
			//use placeholder image and queue download task
			cell.icon.image=[UIImage imageNamed:@"Placeholder.png"];
			if (self.tableView.dragging == NO && self.tableView.decelerating==NO) {
				[self startImageDownload:sale forIndexPath:indexPath];
			}
		}
	}
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//Override to load images when scrolling is finished
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	[self downloadImagesForOnScreenRows];
}
//Override to load images when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (!decelerate) {
		[self downloadImagesForOnScreenRows];
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[[MyCLController sharedInstance] stopUpdateLocation];
	[[MyCLController sharedInstance] deregisterListener:self];
	if (refreshSalesTimer!=nil) {
		[refreshSalesTimer invalidate];
	}
}


- (void)dealloc {
	[refreshSalesTimer release];
	[queue release];
	[saleCell release];
	[entries release];
	[imageDownloadsInProgress release];
    [super dealloc];
}

-(void)dowloadSaleItemsFromLocation:(CLLocation *)location{

	NSString *latitudeString = [NSString stringWithFormat:@"%.6f",location.coordinate.latitude];
	NSString *longitudeString = [NSString stringWithFormat:@"%.6f",location.coordinate.longitude];
	NSString *messageString = [NSString stringWithFormat:@"token=%@&command=browse&start=0&end=100&latitude=%@&longitude=%@",requestToken,latitudeString,longitudeString];
	DebugLog(@"request:%@", messageString);
    //NSString *encodedMessageString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)messageString, CFSTR(""), CFSTR(" %\"?=&+<>;:-"),  kCFStringEncodingUTF8);
	NSString *urlString = [NSString stringWithFormat:@"http://%@/yardsale?%@",serverHost, messageString];
	NSString *urlEncodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	//start the downloading
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"sales",@"identifier",urlEncodedString,@"url",location, @"currentLocation", nil];
	UrlDownloaderOperation *operation = [[UrlDownloaderOperation alloc] initWithUrl:[NSURL URLWithString:urlEncodedString]   userInfo:userInfo delegate:self];
	[self.queue enqueue:operation];
	[operation release];
	
}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
CLLocationDistance getDistanceBetween(CLLocation *c1, CLLocation *c2){
	if ([c1 respondsToSelector:@selector(distanceFromLocation:)]) {
		//backward compatible to 3.1.2
		return [c1 distanceFromLocation:c2];
	}else if ([c1 respondsToSelector:@selector(getDistanceFrom:)]) {
		return [c1 getDistanceFrom:c2];
	}
	return 0;
}

- (NSArray *)sortedSalesFrom:(NSArray*)sales {
    return [sales sortedArrayUsingComparator:(NSComparator)^(id data1, id data2){
        Sale *itemData1 = (Sale*)data1;
		Sale *itemData2 = (Sale*)data2;
		CLLocation *me = currentLocation;
		CLLocationDistance distanceInMeter1;
		CLLocationDistance distanceInMeter2;
		
		distanceInMeter1 = getDistanceBetween(me,
											  [[[CLLocation alloc] initWithLatitude:[itemData1.latitude doubleValue] longitude:[itemData1.longitude doubleValue]] autorelease]);
		distanceInMeter2 = getDistanceBetween(me,
											  [[[CLLocation alloc] initWithLatitude:[itemData2.latitude doubleValue] longitude:[itemData2.longitude doubleValue]] autorelease]);
		
		if (distanceInMeter1 < distanceInMeter2)
			return NSOrderedAscending;
		else if (distanceInMeter1 > distanceInMeter2)
			return NSOrderedDescending;
		else
			return NSOrderedSame;
	}];
}


//call the icon-downloader to download images of the visible rows lazily behind of the scene
-(void)downloadImagesForOnScreenRows{
	
	if ([self.entries count]>0) {
		NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
		for (NSIndexPath *indexPath in visiblePaths) {
			Sale *sale = [self.entries objectAtIndex:indexPath.row];
			DebugLog(@"downloading icon image for sale %@ at %@", [sale saleId], indexPath);
			[self getImageForSale:sale atCell:(SalesTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath] withIndexPath:indexPath];
		}
	}
}
//download icon image of given row
-(void)startImageDownload:(Sale*)sale forIndexPath:(NSIndexPath*)indexPath{
	if (sale.icon!=nil) {
		//we already have the image. This happens when the user scroll the table view which trigger to downloadImagesOnVisibleScreen
		return;
	}else if (sale.iconImageBlobKey!=nil){
		//download image
		if ([imageDownloadsInProgress objectForKey:sale.saleId]) {
			DebugLog(@"already in process, skip");
			return;
		}
		DebugLog(@"downloading icon image for sale %@ at %i %i", [sale saleId], indexPath.row, indexPath.section);
		[imageDownloadsInProgress setObject:[NSNumber numberWithBool:YES] forKey:sale.saleId];
		NSString *urlString =  [NSString stringWithFormat:@"http://%@/BlobDataServlet?blobKey=%@",serverHost, sale.iconImageBlobKey];
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"icon",@"identifier", indexPath, @"indexPath", sale.iconImageBlobKey,@"blobKey",  nil];
		//DownloadOperation *queryImageOperation = [[DownloadOperation alloc] initWithUserInfo:userInfo url:urlString delegate:self];
		UrlDownloaderOperation *operation = [[UrlDownloaderOperation alloc] initWithUrl:[NSURL URLWithString:urlString]   userInfo:userInfo delegate:self];
		[self.queue enqueue:operation];
		[operation release];
	}else {
		DebugLog(@"sale.iconImageBlobKey is null, no image for display");
		return;
	}


//	
//		//first query the image url of the sale
//		DebugLog(@"trying to query the images of the sale");
//		NSString *messageString = [NSString stringWithFormat:@"token=%@&command=images&id=%@",requestToken,sale.saleId];
//		NSString *urlString = [NSString stringWithFormat:@"http://%@/yardsale?%@",serverHost, messageString];
//		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"imagesOfSale",@"identifier", indexPath, @"indexPath", nil];
//		//DownloadOperation *queryImageOperation = [[DownloadOperation alloc] initWithUserInfo:userInfo url:urlString delegate:self];
//		UrlDownloaderOperation *operation = [[UrlDownloaderOperation alloc] initWithUrl:[NSURL URLWithString:urlString]   userInfo:userInfo delegate:self];
//		[self.queue enqueue:operation];
//		[operation release];
//		return;
//	

	
}

#pragma mark DownloaderDelegate implementation

- (void)downloadOperationFinishedWithData:(NSData*)theData userInfo:(NSDictionary*)userInfo{
	NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
	if ([[userInfo valueForKey:@"identifier"] isEqualToString:@"icon"]) {
		Sale *sale = [self.entries objectAtIndex:indexPath.row];
		[imageDownloadsInProgress removeObjectForKey:sale.saleId];
		//refresh the icon image of the particular row
		UIImage *image = [UIImage imageWithData:theData];
		sale.icon=image;
		//save to local
		[LocalImageCache saveImage:image withKey:[userInfo valueForKey:@"blobKey"]];
		//redisplay cell
		SalesTableViewCell *cell = (SalesTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
		if (!cell) {
			DebugLog(@"didnt find the cell!");
		}else {
			cell.icon.image=sale.icon;
		}
	}else {
		
		NSString *replyString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
		NSDictionary *result = [replyString JSONValue];
		DebugLog(@"reply:%@", replyString);
		if ([[result valueForKey:@"status"] isEqualToString:@"good"]) {
			if ([[userInfo valueForKey:@"identifier"] isEqualToString:@"sales"]) {
				isRunning=NO;
				//process sales data, and populdate the entries
				NSArray *data = [result objectForKey:@"data"]; //array of dictionary of Sale
				NSMutableArray *sales = [[NSMutableArray alloc] init];
				for (NSDictionary *saledic in data) {
					Sale *sale = [[[Sale alloc] init] autorelease];
					[sale fromDictionary:saledic];
					[sales addObject:sale];
				}
				//reload
				//order by distance
				NSArray *sortedSales =[self sortedSalesFrom:sales];
				[self.entries removeAllObjects];
				[self.entries addObjectsFromArray:sortedSales];
				[self.tableView reloadData];
				[sales release];
			}else if ([[userInfo valueForKey:@"identifier"] isEqualToString:@"imagesOfSale"]) {
				NSString *replyString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
				DebugLog(@"reply:%@", replyString);
				NSArray *data = [result objectForKey:@"data"]; //array of dictionary of ImageInfo
				Sale *sale = [self.entries objectAtIndex:indexPath.row];
				for (NSDictionary *imageInfoDic in data) {
					ImageInfo *image = [[[ImageInfo alloc] init] autorelease];
					[image fromDictionary:imageInfoDic];
					//fill the sale
					[sale.images addObject:image];
				}
			}
		}
	}


	
}
- (void)downloadOperationFinishedWithError:(NSError*)error userInfo:(NSDictionary*)userInfo{
	NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
	isRunning=NO;
	NSLog(@"failed to download %@ %@",[userInfo valueForKey:@"identifier"], [error localizedDescription]);
	if ([[userInfo valueForKey:@"identifier"] isEqualToString:@"icon"]) {
		Sale *sale = [self.entries objectAtIndex:indexPath.row];
		[imageDownloadsInProgress removeObjectForKey:sale.saleId];
	}
	//reload
	[self.tableView reloadData];
	//requeue the request...
}


#pragma mark MyCLControllerDelegate implementation Location update
-(void)newLocationUpdateWithLocation:(CLLocation *)location{
	self.currentLocation=location;
	if (lastQueryLocation==nil || [lastQueryLocation distanceFromLocation:location]>100) {
		//only requery server when user moved beyond 100 meters
		self.lastQueryLocation=location;
		[self dowloadSaleItemsFromLocation:self.currentLocation];
	}
	
	
	
}

-(void)newError:(NSString *)text{
	//failed to locate
	DebugLog(@"Failed with location manager %@", text);
}

-(void)addButtonWasPressed{
	SaleDetailViewController *vc = [[SaleDetailViewController alloc] initWithNibName:@"SaleDetailViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}

- (void)timedRefreshSales:(NSTimer*)timer{
	//enqueue a sales-download task
	[self dowloadSaleItemsFromLocation:self.currentLocation];
}
@end

