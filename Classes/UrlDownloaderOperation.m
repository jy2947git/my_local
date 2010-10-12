#import "UrlDownloaderOperation.h"

@interface UrlDownloaderOperation ()

- (void)finish;

@end

@implementation UrlDownloaderOperation

@synthesize url = _url;
@synthesize statusCode = _statusCode;
@synthesize data = _data;
@synthesize error = _error;
@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;
@synthesize userInfo;
@synthesize delegate;



- (id)initWithUrl:(NSURL *)url userInfo:(NSDictionary*)ui delegate:(id)d
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _url = [url copy];
    _isExecuting = NO;
    _isFinished = NO;
    
	self.userInfo=ui;
	self.delegate=d;
    return self;
}

- (void)dealloc
{
	[userInfo release];
    [_url release];
    [_connection release];
    [_data release];
    [_error release];
    [super dealloc];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSLog(@"opeartion for <%@> started.", _url);
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //NSURLRequest * request = [NSURLRequest requestWithURL:_url];
	NSURLRequest *request = [NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:120];
    _connection = [[NSURLConnection alloc] initWithRequest:request
                                                  delegate:self];
    if (_connection == nil)
        [self finish];
}

- (void)finish
{
    NSLog(@"operation for <%@> finished. "
          @"status code: %d, error: %@, data size: %u",
          _url, _statusCode, _error, [_data length]);
    
    [_connection release];
    _connection = nil;

    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];

    _isExecuting = NO;
    _isFinished = YES;

    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    [_data release];
    _data = [[NSMutableData alloc] init];

    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    _statusCode = [httpResponse statusCode];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[delegate downloadOperationFinishedWithData:_data userInfo:self.userInfo];
    [self finish];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _error = [error copy];
	[delegate downloadOperationFinishedWithError:_error userInfo:self.userInfo];
    [self finish];
}

@end
