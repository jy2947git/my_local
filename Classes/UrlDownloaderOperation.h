#import <Foundation/Foundation.h>
@protocol UrlDownloaderOperationDelegate;


@interface UrlDownloaderOperation : NSOperation
{
    NSURL * _url;
    NSURLConnection * _connection;
    NSInteger _statusCode;
    NSMutableData * _data;
    NSError * _error;
    NSDictionary *userInfo;
	id<UrlDownloaderOperationDelegate> delegate;
    BOOL _isExecuting;
    BOOL _isFinished;
}

@property (readonly, copy) NSURL * url;
@property (readonly) NSInteger statusCode;
@property (readonly, retain) NSData * data;
@property (readonly, retain) NSError * error;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) id<UrlDownloaderOperationDelegate> delegate;
@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;


- (id)initWithUrl:(NSURL *)url userInfo:(NSDictionary*)ui delegate:(id)d;

@end
@protocol UrlDownloaderOperationDelegate 

- (void)downloadOperationFinishedWithData:(NSData*)data userInfo:(NSDictionary*)userInfo;
- (void)downloadOperationFinishedWithError:(NSError*)error userInfo:(NSDictionary*)userInfo;
@end