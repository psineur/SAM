//
//  SAMTaskViewController.m
//  SAM
//
//  Created by Stepan Generalov on 17.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMTaskViewController.h"
#import "SAMDefines.h"
#import <BlocksKit.h>

@interface SAMTaskViewController ()

@property (strong, nonatomic) IBOutlet NSTextField *mainLabel;

@end

@implementation SAMTaskViewController

// TODO: common method for all controllers
+ (instancetype) viewController
{
    return [[self alloc] initWithNibName: NSStringFromClass(self) bundle:nil];
}

- (void) loadView
{
    [super loadView];

    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(197.0f/255.0f, 106.0f/255.0f, 1.0f, 1.0f)];
    [self.view setWantsLayer:YES];
    [self.view setLayer:viewLayer];

    [self updateLayout];
    [self addObserverForKeyPath:@"model.name" task:^(SELFTYPE sender)
     {
         [sender updateLayout];
     }];
}

// TODO: common method for userStory & task
- (void) updateLayout
{
    static const CGFloat kMaxLabelHeight = 10000.0f;

    if (!self.mainLabel)
        return;

    // Calculate new size for notes label
    NSRect oldFrameNotes = [self.mainLabel frame];
    NSRect newFrameNotes = oldFrameNotes;
    NSRect notesFrame = [self.mainLabel frame];
    newFrameNotes.size.height = kMaxLabelHeight;
    newFrameNotes.size = [[self.mainLabel cell] cellSizeForBounds:newFrameNotes];
    if(NSHeight(newFrameNotes) > NSHeight(oldFrameNotes))
        notesFrame.size.height += (NSHeight(newFrameNotes) - NSHeight(oldFrameNotes));

    // Resize whole user story view to fit notes label
    CGFloat newHeight = MAX( self.view.frame.size.height + notesFrame.size.height - oldFrameNotes.size.height, self.view.frame.size.height);
    CGRect newFrame = self.view.frame;
    newFrame.size.height = newHeight;
    self.view.frame = newFrame;
    [self.view display];

    // Update notes label last to ensure origin is set ok
    self.mainLabel.frame = notesFrame;
    [self.mainLabel display];
}

@end