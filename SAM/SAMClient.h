//
//  SAMClient.h
//  SAM
//
//  Created by Stepan Generalov on 15.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "AFHTTPClient.h"

#define API(first, ...) [NSString pathWithComponents: @[ first, __VA_ARGS__ ]]

@interface SAMClient : AFHTTPClient

+ (instancetype) sharedClient;

@property(nonatomic, copy) NSString *APIToken;

- (void) getPath: (NSString *) path block: (void(^)(NSDictionary *)) aBlock;

@end
