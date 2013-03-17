//
//  SAMUserStoryViewController.h
//  SAM
//
//  Created by Stepan Generalov on 17.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SAMUserStory.h"

/**
 * View controller responsible for displaying user story.
 * Bindings are done in xib file directly from subviews to model where possible.
 *
 * @todo Resize view to fit notes
 */
@interface SAMUserStoryViewController : NSViewController

@property (strong, nonatomic) SAMUserStory *model;


@end
