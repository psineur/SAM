//
//  SAMSettingsViewController.h
//  SAM
//
//  Created by Stepan Generalov on 15.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SAMSettingsViewController : NSViewController

@property(strong, nonatomic) NSString *APIToken;
@property(strong, nonatomic) NSString *workspaceID;

@end
