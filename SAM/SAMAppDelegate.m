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
#import "SAMSprintBacklog.h"
#import "SAMUserStory.h"

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
    [[SAMClient sharedClient] get: @[@"workspaces", self.settings.workspaceID, @"projects"]
                            block: ^(NSDictionary *jsonObject)
     {
         NSArray *data = jsonObject[@"data"];
         NSDictionary *sprintBacklog = [data match: ^(NSDictionary *project)
                                        {
                                            if ([project[@"name"] isEqualToString:@"Sprint Backlog"])
                                                return YES;

                                            return NO;
                                        }];

         SAMSprintBacklog *backlog = [SAMSprintBacklog sprintBacklogWithProjectId: sprintBacklog[@"id"] client: [SAMClient sharedClient]];

         // Log stuff after 5 secs, when it should be updated already
         double delayInSeconds = 5.0;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             NSLog(@"SprintBacklog = %@", backlog);
         });

         
         
     }];
}

@end
