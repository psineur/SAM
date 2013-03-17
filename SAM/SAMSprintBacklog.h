//
//  SAMSprintBacklog.h
//  SAM
//
//  Created by Stepan Generalov on 16.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAMClient.h"
#import "SAMUserStory.h"

/** Model for project that describes Sprint Backlog.
 * @todo: refactor to SAMProject subclass for more consistent API.
 */
@interface SAMSprintBacklog : NSObject

@property (strong, nonatomic) NSMutableArray *userStories;

+ (instancetype) sprintBacklogWithProjectId: (NSNumber *) projectId client: (SAMClient *) client;
- (instancetype) initWithId: (NSNumber *) projectId client: (SAMClient *) client;
@end
