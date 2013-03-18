//
//  SAMClient.m
//  SAM
//
//  Created by Stepan Generalov on 15.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMClient.h"
#import <AFNetworking/AFNetworking.h>
#import <BlocksKit.h>

typedef void (^AFFailureBlock)(NSURLRequest *, NSHTTPURLResponse *, id, id);
typedef void (^AFSuccessBlock)(NSURLRequest *, NSHTTPURLResponse *, id);

@interface SAMClient ()
@property(nonatomic, copy) NSString *privateAPIToken;
@property(assign, nonatomic) NSTimeInterval delayForRequests;
@end

@implementation SAMClient

static SAMClient *_sharedClient = nil;
+ (instancetype) sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [self clientWithBaseURL: [NSURL URLWithString: @"https://app.asana.com/api/1.0/"]];
    });

    return _sharedClient;
}

#pragma mark Properties

@dynamic APIToken;
- (NSString *) APIToken
{
    return self.privateAPIToken;
}

- (void) setAPIToken:(NSString *) newToken
{
    self.privateAPIToken = newToken;
    [self setAuthorizationHeaderWithUsername: newToken password:@""];
}

#pragma mark API Access

- (void) get: (NSArray *) pathComponents block: (void(^)(NSDictionary *)) aBlock
{
    NSString *path = [NSString pathWithComponents: pathComponents];

    AFFailureBlock failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, id error, id JSON)
    {
        // If "Too many requests"
        if (response.statusCode == 429)
        {
            self.delayForRequests = 0;
            
            // Try to get delay from response
            self.delayForRequests = MAX(self.delayForRequests, 1.0 );
            @try {
                self.delayForRequests = MAX(self.delayForRequests, [JSON[@"retry_after"] doubleValue]);
            } @catch (NSException *exception) { }

            // Redo same request with delay.
            self.delayForRequests += 0.5;
            [NSObject performBlock: ^()
             {
                 [self get: pathComponents block: aBlock];
             }
                        afterDelay: self.delayForRequests ];
            NSLog(@"SAMClient: %@ need to wait %f seconds", path, self.delayForRequests);
            return;
        }
        self.delayForRequests = 0;

        // TODO: use error reported instead
        NSLog(@"error getting %@ = %@, additional: %@", path, error, JSON);
    };

    AFSuccessBlock success = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        self.delayForRequests = 0;
        
        if (![JSON isKindOfClass:[NSDictionary class]]) {
            failure(request, response, @"Dict expected!", JSON );
            return;
        }

        aBlock(JSON);
    };    

    AFJSONRequestOperation *jsonRequest = [self jsonRequestWithPath:path success:success failure: failure];
    if (self.delayForRequests)
    {
        self.delayForRequests += 0.5;
        [NSObject performBlock: ^()
         {
             [jsonRequest start];
         }
                    afterDelay: self.delayForRequests];
    }
    else
    {
        [jsonRequest start];
    }
}

- (AFJSONRequestOperation *) jsonRequestWithPath: (NSString *)path success: (AFSuccessBlock) success failure: (AFFailureBlock) failure
{
    NSURLRequest *request = [self requestWithMethod:@"GET" path: path parameters: @{}];
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest: request
                                                                                          success: success
                                                                                          failure: failure ];

    return jsonRequest;
}

@end
