//
//  SAMUserStory.m
//  SAM
//
//  Created by Stepan Generalov on 16.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMUserStory.h"
#import "SAMTask.h"

@implementation SAMUserStory

+ (instancetype) userStoryWithDictionary: (NSDictionary *) dict client: (SAMClient *) client
{
    return [[self alloc] initWithDictionary: dict client: client];
}

- (instancetype) initWithDictionary: (NSDictionary *) dict client: (SAMClient *) client
{
    self = [super init];
    if (self)
    {
        if (![dict isKindOfClass: [NSDictionary class]])
        {
            // TODO: report problem in client
            return nil;
        }

        self.id = [dict[@"id"] stringValue];
        self.name = dict[@"name"];

        // Fetch notes.
        [client get:@[@"tasks", self.id] block: ^(NSDictionary *response)
         {
             self.notes = response[@"data"][@"notes"];
             if ([self.notes isKindOfClass:[NSString class]])
             {
                 self.notes = [self.notes stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
             }
             else
             {
                 // TODO: report a problem to client
             }
         }];
        
        
        // Fetch tasks (subtasks in term of Asana)
        [client get: @[@"tasks", self.id, @"subtasks"]
              block: ^(NSDictionary *response)
         {
             NSArray *tasksJSON = [NSArray arrayWithArray: response[@"data"]];
             self.tasks = [NSMutableArray arrayWithCapacity: [tasksJSON count]];

             [tasksJSON enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL *stop)
              {
                  SAMTask *task = [SAMTask taskWithDictionary: obj client: client];
                  task.parent = self;
                  if (task)
                      [self.tasks addObject: task];
              }];
         }];

    }

    return self;
}

- (NSString *) description
{
    return [NSString stringWithFormat: @"%@, <%p>: id=%@, name=%@",[self class], self, self.id, self.name];
}

@end
