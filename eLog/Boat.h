//
//  Boat.h
//  eLog
//
//  Created by nopilas on 2014-08-26.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Boat : NSObject

@property (strong, nonatomic) NSString *boatNo;
@property (strong, nonatomic) NSString *boatName;
@property (strong, nonatomic) NSString *boatColor;

#pragma  mark -
#pragma  mark Class Methods

- (id)initWithBoatNo: (NSString *)cNo andBoatName: (NSString *)cName andBoatColor:(NSString *)cColor;
@end
