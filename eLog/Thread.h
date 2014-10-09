//
//  Thread.h
//  eLog
//
//  Created by nopilas on 2014-10-08.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Thread : NSObject
+(Thread*)getSharedInstance;

-(void)startThread;

@end
