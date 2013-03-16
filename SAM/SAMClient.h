//
//  SAMClient.h
//  SAM
//
//  Created by Stepan Generalov on 15.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "AFHTTPClient.h"

@interface SAMClient : AFHTTPClient

+ (instancetype) sharedClient;

@property(nonatomic, copy) NSString *APIToken;

/**
 * @param path Array of strings, which will be used to create path with [NSString pathWithComponents: ]
 */
- (void) get: (NSArray *) pathComponents block: (void(^)(NSDictionary *)) aBlock;

@end
