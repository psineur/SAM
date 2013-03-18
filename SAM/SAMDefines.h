//
//  SAMDefines.h
//  SAM
//
//  Created by Stepan Generalov on 17.03.13.
//  Copyright (c) 2013 Stepan Generalov. All rights reserved.
//

#ifndef SAM_SAMDefines_h
#define SAM_SAMDefines_h

#pragma mark Code Snippets / Helpers

#define SELFTYPE __typeof(&*self)

#pragma mark - Background Colors

#define SAM_COLOR(__R__, __G__, __B__) CGColorCreateGenericRGB(__R__ / 255.0f, __G__ / 255.0f, __B__ / 255.0f, 1.0f)

#define SAM_COLOR_CORKBOARD()        SAM_COLOR(160, 100, 0)
#define SAM_COLOR_USERSTORY()        SAM_COLOR(237, 237, 237)
#define SAM_COLOR_TASK()             SAM_COLOR(197, 106, 255) 
#define SAM_COLOR_TASK_IN_PROGRESS() SAM_COLOR(255, 205, 145)
#define SAM_COLOR_TASK_COMPLETE()    SAM_COLOR(140, 205, 150)

#endif
