//
//  SAMUserStoryViewController.m
//  SAM
//
//  Created by Stepan Generalov on 17.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import "SAMUserStoryViewController.h"
#import "SAMDefines.h"
#import <BlocksKit.h>

@interface SAMUserStoryViewController ()

@property (strong, nonatomic) IBOutlet NSTextField *notesLabel;

@end

@implementation SAMUserStoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) loadView
{
    [super loadView];

    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.7, 0.7, 0.7, 1.0)];
    [self.view setWantsLayer:YES];
    [self.view setLayer:viewLayer];


    [self updateLayout];
    [self addObserverForKeyPath:@"model.notes" task:^(SELFTYPE sender)
     {
         [sender updateLayout];
     }];
}

- (void) updateLayout
{
    static const CGFloat kMaxLabelHeight = 10000.0f;

    if (!self.notesLabel)
        return;

    // Calculate new size for notes label
    NSRect oldFrameNotes = [self.notesLabel frame];
    NSRect newFrameNotes = oldFrameNotes;
    NSRect notesFrame = [self.notesLabel frame];
    newFrameNotes.size.height = kMaxLabelHeight;
    newFrameNotes.size = [[self.notesLabel cell] cellSizeForBounds:newFrameNotes];
    if(NSHeight(newFrameNotes) > NSHeight(oldFrameNotes))
        notesFrame.size.height += (NSHeight(newFrameNotes) - NSHeight(oldFrameNotes));

    // Resize whole user story view to fit notes label
    CGFloat newHeight = MAX( self.view.frame.size.height + notesFrame.size.height - oldFrameNotes.size.height, self.view.frame.size.height);
    CGRect newFrame = self.view.frame;
    newFrame.size.height = newHeight;
    self.view.frame = newFrame;
    [self.view display];

    // Update notes label last to ensure origin is set ok
    self.notesLabel.frame = notesFrame;
    [self.notesLabel display];
}

@end
