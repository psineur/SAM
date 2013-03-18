//
//  SAMTask.m
//  SAM
//
//  Created by Stepan Generalov on 16.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMTask.h"
#import "SAMClient.h"

@implementation SAMTask

+ (instancetype) taskWithDictionary: (NSDictionary *) dict client: (SAMClient *) client
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

        // Fetch self to update status
        [client get: @[@"tasks", self.id]
              block: ^(NSDictionary *response)
         {
             NSDictionary *taskJSON = response[@"data"];

             if ([taskJSON isKindOfClass: [NSDictionary class]])
             {
                 if ( [taskJSON[@"assignee"] isKindOfClass:[NSNull class]])
                 {
                     self.status = kSAMTaskStatusPlanned;
                 }
                 else
                 {
                     self.status = kSAMTaskStatusInProgress;
                 }

                 if ([taskJSON[@"completed"] boolValue])
                     self.status = kSAMTaskStatusComplete;
             }
             else
             {
                 // TODO: report a problem
             }
         }];

    }

    return self;
}

- (NSString *) description
{
    return [NSString stringWithFormat: @"%@, <%p>: id=%@, name=%@",[self class], self, self.id, self.name];
}

@end
