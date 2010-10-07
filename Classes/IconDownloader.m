
#import "IconDownloader.h"


#define kAppIconHeight 48


@implementation IconDownloader

@synthesize url;
@synthesize downloadedImage;
@synthesize identifier;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark
- (id)initWithUrl:(NSString*)encodedUrlString delegate:(id)del{
	self=[self init];
	self.url=encodedUrlString;
	self.delegate=del;
	return self;
}

- (void)dealloc
{
    [url release];
	[downloadedImage release];
    [identifier release];
    
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

- (void)startDownload
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.activeDownload = [NSMutableData data];
	DebugLog(@"downloading %@...", self.url);
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:self.url]] delegate:self];
    self.imageConnection = conn;
	

    [conn release];
}

- (void)cancelDownload
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	DebugLog(@"download error %@", [error localizedDescription]);
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
	//call the delegate to notify the error
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:url, @"url", identifier, @"identifier", nil];
	[delegate downloadFinishedWithError:error userInfo:[userInfo copy]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	DebugLog(@"Download finished");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
	{
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.downloadedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.downloadedImage = image;
    }
    
    self.activeDownload = nil;
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:url, @"url", identifier, @"identifier", nil];
	
    [delegate downloadFinishedWithUserInfo:[userInfo copy]];
}


@end

