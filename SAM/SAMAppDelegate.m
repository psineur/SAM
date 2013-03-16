//
//  SAMAppDelegate.m
//  SAM
//
//  Created by Stepan Generalov on 15.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMAppDelegate.h"
#import "SAMSettingsViewController.h"
#import <AFNetworking.h>
#import <BlocksKit.h>

@interface SAMAppDelegate ()

@property (strong, nonatomic) SAMSettingsViewController *settings;
@property (strong, nonatomic) NSWindow *settingsWindow;
@property (strong, nonatomic) AFHTTPClient *client;

@end

@implementation SAMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.settings = [[SAMSettingsViewController alloc] init];
    self.client = [AFHTTPClient clientWithBaseURL: [NSURL URLWithString:@"https://app.asana.com/api/1.0/"]];
    [self.client setAuthorizationHeaderWithUsername: self.settings.APIToken password:@""];

    NSLog(@"API token = %@", self.settings.APIToken);
}

- (IBAction) fullscreenPressed: (id) sender
{
    [self.window setFrame: self.window.screen.frame display: YES];
}

- (IBAction)settingsPressed:(id)sender
{   
    self.settingsWindow =
    [[NSWindow alloc] initWithContentRect: self.settings.view.frame styleMask: NSTitledWindowMask backing: NSBackingStoreBuffered defer: YES];
    _settingsWindow.contentView = self.settings.view;
    [_settingsWindow makeKeyAndOrderFront: self];
}

- (IBAction)refresh:(id)sender
{
#define API(first, ...) [NSString pathWithComponents: @[ first, __VA_ARGS__ ]]

    NSString *path = API(@"workspaces", self.settings.workspaceID, @"projects");
    [self getPath: path block:^(NSDictionary *jsonObject)
     {
         NSArray *data = jsonObject[@"data"];
         NSDictionary *sprintBacklog = [data match: ^(NSDictionary *project)
                                        {
                                            if ([project[@"name"] isEqualToString:@"Sprint Backlog"])
                                                return YES;

                                            return NO;
                                        }];
         [self getPath: API(@"projects", [sprintBacklog[@"id"] stringValue], @"tasks")
                 block: ^(NSDictionary *sprint)
          {
              NSLog(@"user stories = %@", sprint[@"data"]);
          }];
     }];
}

- (void) getPath: (NSString *) path block: (void(^)(NSDictionary *)) aBlock
{
    void (^onError)(id, id) = ^(id error, id additionalStuff)
    {
        NSLog(@"error getting %@ = %@, additional: %@", path, error, additionalStuff);
    };

    [self.client setAuthorizationHeaderWithUsername: self.settings.APIToken password:@""];
    NSURLRequest *request = [self.client requestWithMethod:@"GET" path: path parameters: @{}];
    AFJSONRequestOperation *jsonRequest =
    [AFJSONRequestOperation JSONRequestOperationWithRequest: request
                                                    success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        if (![JSON isKindOfClass:[NSDictionary class]]) {
                                                            onError(@"Dict expected!", JSON );
                                                        }

                                                        aBlock(JSON);
                                                    }
                                                    failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, id error, id JSON) {
                                                        onError(error, JSON);
                                                    }];
    [jsonRequest start];
}

@end
