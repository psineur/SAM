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

typedef enum {
    kSAMTaskStatusPending = 0,    //< didn't yet get info about status
    
    kSAMTaskStatusPlanned = 1,    //< info updated, nobody assigned yet
    kSAMTaskStatusInProgress = 2, //< info updated, assignee exist
    kSAMTaskStatusComplete = 3,   //< task marked as complete
} SAMTaskStatus;

/**
 * @todo add estimate property
 * @todo add state property
 */
@interface SAMTask : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (weak, nonatomic) SAMUserStory *parent;
@property (assign, nonatomic) SAMTaskStatus status;

+ (instancetype) taskWithDictionary: (NSDictionary *) dict client: (SAMClient *) client;
- (instancetype) initWithDictionary: (NSDictionary *) dict client: (SAMClient *) client;

@end
