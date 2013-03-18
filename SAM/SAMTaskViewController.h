//
//  SAMTaskViewController.h
//  SAM
//
//  Created by Stepan Generalov on 17.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SAMTask.h"

@interface SAMTaskViewController : NSViewController

@property(strong, nonatomic) SAMTask *model;

+ (instancetype) viewController;

@end
