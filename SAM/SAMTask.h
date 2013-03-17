//
//  SAMTask.h
//  SAM
//
//  Created by Stepan Generalov on 16.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SAMClient;
@class SAMUserStory;

/**
 * @todo add estimate property
 * @todo add state property
 */
@interface SAMTask : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (weak, nonatomic) SAMUserStory *parent;

+ (instancetype) taskWithDictionary: (NSDictionary *) dict client: (SAMClient *) client;
- (instancetype) initWithDictionary: (NSDictionary *) dict client: (SAMClient *) client;

@end
