//
//  SAMSettingsViewController.m
//  SAM
//
//  Created by Stepan Generalov on 15.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMSettingsViewController.h"

NSString *const apiTokenDefaultsKey = @"apiToken";
NSString *const workspaceIDDefaultsKey = @"workspaceId";

@interface SAMSettingsViewController ()

@property(strong, nonatomic) NSString *APITokenPrivate;
@property(strong, nonatomic) NSString *workspaceIDPrivate;

@end

@implementation SAMSettingsViewController

@dynamic APIToken;
- (NSString *) APIToken
{
    return self.APITokenPrivate;
}

- (void) setAPIToken:(NSString *)APIToken
{
    self.APITokenPrivate = APIToken;
    [[NSUserDefaults standardUserDefaults] setObject: APIToken forKey: apiTokenDefaultsKey];
}

@dynamic workspaceID;
- (NSString *) workspaceID
{
    return self.workspaceIDPrivate;
}

- (void) setWorkspaceID:(NSString *)workspaceID
{
    self.workspaceIDPrivate = workspaceID;
    [[NSUserDefaults standardUserDefaults] setObject: workspaceID forKey: workspaceIDDefaultsKey];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.APIToken = [[NSUserDefaults standardUserDefaults] objectForKey: apiTokenDefaultsKey];
        self.workspaceID = [[NSUserDefaults standardUserDefaults] objectForKey: workspaceIDDefaultsKey];
    }
    
    return self;
}

@end
