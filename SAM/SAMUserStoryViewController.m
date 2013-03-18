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
#import "SAMTaskViewController.h"

@interface SAMUserStoryViewController ()

@property (strong, nonatomic) IBOutlet NSTextField *notesLabel;
@property (strong, nonatomic) NSMutableArray *taskViewControllers;

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
    [self updateTasks];
    [self addObserverForKeyPath:@"model.notes" task:^(SELFTYPE sender)
     {
         [sender updateLayout];
     }];
    [self addObserverForKeyPath:@"model.tasks" task: ^(SELFTYPE sender)
     {
         [sender updateTasks];
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

#pragma mark Tasks Views

- (void) updateTasks
{
    [[self.taskViewControllers valueForKeyPath:@"view"] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.taskViewControllers = [NSMutableArray arrayWithCapacity: self.model.tasks.count];

    for (SAMTask *task in self.model.tasks)
    {
        NSViewController *vc = [self taskViewControllerWithModel: task];
        [self.taskViewControllers addObject: vc];
        [self.view addSubview: vc.view];
    }
}

- (NSViewController *) taskViewControllerWithModel: (SAMTask *) task
{
    static const CGFloat margin = 3;
    static CGFloat x = 0;
    static CGFloat y = 0;

    SAMTaskViewController *vc = [SAMTaskViewController viewController];
    vc.model = task;

    // Origin is bottom left, before each view position will be incremented, so
    // first setup position is row = 0, column = - 1
    if (![self.taskViewControllers count])
    {
        x = - vc.view.frame.size.width - margin;
        y = - vc.view.frame.size.height - margin;
    }

    // Increment X, and if this is 3rd task - goto next line (reset X & increment Y)
    x += vc.view.frame.size.width + margin;
    if (x >= 2 * (vc.view.frame.size.width + margin))
    {
        x = 0;
        y -= vc.view.frame.size.height + margin;
    }
    

    vc.view.frame = CGRectMake( x, y, vc.view.frame.size.width, vc.view.frame.size.height);

    return vc;
}

@end
