//
//  SAMSprintBacklog.m
//  SAM
//
//  Created by Stepan Generalov on 16.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMSprintBacklog.h"

@implementation SAMSprintBacklog

+ (instancetype) sprintBacklogWithProjectId: (NSNumber *) projectId client: (SAMClient *) client
{
    return [[self alloc] initWithId: projectId client: client];
}

- (instancetype) initWithId: (NSNumber *) projectId client: (SAMClient *) client
{
    self = [super init];
    if ( self )
    {
        self.userStories = [NSMutableArray array];

        [client get: @[@"projects", [projectId stringValue], @"tasks"]
              block: ^(NSDictionary *response)
         {
             NSArray *userStoriesJSON = [NSArray arrayWithArray: response[@"data"]];
             self.userStories = [NSMutableArray arrayWithCapacity: [userStoriesJSON count]];

             [userStoriesJSON enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL *stop)
              {
                  SAMUserStory *userStory = [SAMUserStory userStoryWithDictionary: obj client: client];
                  if (userStory)
                      [self.userStories addObject: userStory];
              }];

         }];
    }

    return self;
}

- (NSString *) description
{
    return [NSString stringWithFormat: @"%@, <%p>: userStories=%@",[self class], self, self.userStories];
}

@end
