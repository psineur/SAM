//
//  SAMUserStory.m
//  SAM
//
//  Created by Stepan Generalov on 16.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMUserStory.h"

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

        // TODO: fetch notes
        // TODO: fetch tasks (subtasks in term of Asana) & setup parent-child relationship

    }

    return self;
}

- (NSString *) description
{
    return [NSString stringWithFormat: @"%@, <%p>: id=%@, name=%@",[self class], self, self.id, self.name];
}

@end
