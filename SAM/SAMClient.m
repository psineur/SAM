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
        NSLog(@"error getting %@ = %@, additional: %@", path, error, JSON);
    };

    AFSuccessBlock success = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        if (![JSON isKindOfClass:[NSDictionary class]]) {
            failure(request, response, @"Dict expected!", JSON );
            return;
        }

        aBlock(JSON);
    };    

    NSURLRequest *request = [self requestWithMethod:@"GET" path: path parameters: @{}];
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest: request
                                                                                          success: success
                                                                                          failure: failure ];
    [jsonRequest start];
}

// TODO: support "be chill" message
//NSLocalizedDescription=Expected status code in (200-299), got 429}, additional: {
//    errors =     (
//                  {
//                      message = "You have made too many requests recently. Please, be chill.";
//                  }
//                  );
//    "retry_after" = 13;
//}

@end
