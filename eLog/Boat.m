//
//  Boat.m
//  eLog
//
//  Created by nopilas on 2014-08-26.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import "Boat.h"

@implementation Boat
@synthesize boatNo, boatName, boatColor;

- (id) initWithBoatNo: (NSString *)cNo andBoatName: (NSString *)cName andBoatColor:(NSString *)cColor
{
    self = [super init];
    if ( self)
    {
        boatNo = cNo;
        boatName = cName;
        boatColor = cColor;
    }
    return self;
}
@end
