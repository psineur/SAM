//
//  SAMAppDelegate.m
//  SAM
//
//  Created by Stepan Generalov on 15.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMAppDelegate.h"

@implementation SAMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (IBAction) fullscreenPressed: (id) sender
{
    [self.window setFrame: self.window.screen.frame display: YES];
}

@end
