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
#import "SAMClient.h"

@interface SAMAppDelegate ()

@property (strong, nonatomic) SAMSettingsViewController *settings;
@property (strong, nonatomic) NSWindow *settingsWindow;
@property (strong, nonatomic) AFHTTPClient *client;

@end

@implementation SAMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.settings = [[SAMSettingsViewController alloc] init];
    [SAMClient sharedClient].APIToken = self.settings.APIToken;
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
    // Update settings.
    [SAMClient sharedClient].APIToken = self.settings.APIToken;

    // Start fetching data.
    NSString *path = API(@"workspaces", self.settings.workspaceID, @"projects");
    [[SAMClient sharedClient] getPath: path block:^(NSDictionary *jsonObject)
     {
         NSArray *data = jsonObject[@"data"];
         NSDictionary *sprintBacklog = [data match: ^(NSDictionary *project)
                                        {
                                            if ([project[@"name"] isEqualToString:@"Sprint Backlog"])
                                                return YES;

                                            return NO;
                                        }];
         [[SAMClient sharedClient] getPath: API(@"projects", [sprintBacklog[@"id"] stringValue], @"tasks")
                 block: ^(NSDictionary *sprint)
          {
              NSLog(@"user stories = %@", sprint[@"data"]);
          }];
     }];
}

@end
