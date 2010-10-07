/*
     helper class to manage downloading of image.
 
  
 */


@protocol IconDownloaderDelegate;

@interface IconDownloader : NSObject
{
	id identifier;
    NSString *url;
	UIImage *downloadedImage;
    id <IconDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIImage *downloadedImage;
@property (nonatomic, retain) id identifier;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;
- (id)initWithUrl:(NSString*)encodedUrlString delegate:(id)del;
- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate 

- (void)downloadFinishedWithUserInfo:(NSDictionary*)userInfo;
- (void)downloadFinishedWithError:(NSError*)error userInfo:(NSDictionary*)userInfo;
@end