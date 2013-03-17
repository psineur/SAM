//
//  SAMUserStory.h
//  SAM
//
//  Created by Stepan Generalov on 16.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAMClient.h"

/**@todo: subclass of task in the future for API */
@interface SAMUserStory : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *notes;

+ (instancetype) userStoryWithDictionary: (NSDictionary *) dict client: (SAMClient *) client;
- (instancetype) initWithDictionary: (NSDictionary *) dict client: (SAMClient *) client;
@end
