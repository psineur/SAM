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

    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.8, 0.9, 0.0, 1.0)];
    [self.mainView setWantsLayer: YES];
    [self.mainView setLayer: viewLayer];

    [self.mainView addSubview: [self userStoryViewWithModel: [SAMUserStory userStoryWithDictionary:@{@"name":@"ahaha", @"id": @(1)} client:nil]]];
    [self.mainView addSubview: [self userStoryViewWithModel: [SAMUserStory userStoryWithDictionary:@{@"name":@"ololo", @"id": @(2)} client:nil]]];
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
             [self showSomething: backlog];
         });

         
         
     }];
}

- (void) showSomething: (SAMSprintBacklog *) backlog
{
    [self.mainView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];

    for (SAMUserStory *userStory in backlog.userStories)
    {
        [self.mainView addSubview: [self userStoryViewWithModel: userStory]];
    }
}

- (NSView *) userStoryViewWithModel: (SAMUserStory *) userStory
{
    static const CGFloat width = 200;
    static const CGFloat height = 100;
    static const CGFloat margin = 10;

    static CGFloat x = 0;

    if (![self.mainView.subviews count])
        x = - width;

    NSView *view = [[NSView alloc] initWithFrame:CGRectMake( x += width + margin, self.mainView.frame.size.height - height - margin, width, height)];
    NSTextField *label = [[NSTextField alloc] initWithFrame:CGRectMake(0, height - 40, width, 40)];
    label.editable = NO;
    label.bezeled = NO;
    label.drawsBackground = YES;
    label.backgroundColor = [NSColor clearColor];
    label.selectable = NO;
    label.font = [NSFont fontWithName:@"Helvetica Neue Bold" size:12];
    label.stringValue = userStory.name;
    [view addSubview: label];

    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.7, 0.7, 0.7, 1.0)];
    [view setWantsLayer:YES];
    [view setLayer:viewLayer];
    view.autoresizingMask = kCALayerMinYMargin;

    return view;
}
@end
