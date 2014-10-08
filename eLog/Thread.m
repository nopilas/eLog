//
//  Thread.m
//  eLog
//
//  Created by nopilas on 2014-10-08.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import "Thread.h"
static Thread *sharedInstance = nil;

@implementation Thread
+(Thread*)getSharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance startThread];
    }
    return sharedInstance;
}

-(void)startThread
{
    
}
@end
