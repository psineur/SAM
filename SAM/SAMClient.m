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

    void (^onError)(id, id) = ^(id error, id additionalStuff)
    {
        NSLog(@"error getting %@ = %@, additional: %@", path, error, additionalStuff);
    };

    NSURLRequest *request = [self requestWithMethod:@"GET" path: path parameters: @{}];
    AFJSONRequestOperation *jsonRequest =
    [AFJSONRequestOperation JSONRequestOperationWithRequest: request
                                                    success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        if (![JSON isKindOfClass:[NSDictionary class]]) {
                                                            onError(@"Dict expected!", JSON );
                                                        }

                                                        aBlock(JSON);
                                                    }
                                                    failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, id error, id JSON) {
                                                        onError(error, JSON);
                                                    }];
    [jsonRequest start];
}

@end
