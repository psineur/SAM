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
    [self.client setAuthorizationHeaderWithUsername: self.settings.APIToken password:@""];
    NSURLRequest *request = [self.client requestWithMethod:@"GET" path:@"workspaces" parameters: @{}];
    AFJSONRequestOperation *test =
    [AFJSONRequestOperation JSONRequestOperationWithRequest: request
                                                    success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        NSLog(@"result = %@", JSON);
                                                    }
                                                    failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, id error, id JSON) {
                                                        NSLog(@"result = %@", JSON);
                                                    }];
    [test start];
}

@end
