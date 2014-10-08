//
//  GlobalView.h
//  eLog
//
//  Created by nopilas on 2014-09-13.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int idUserGlobal;
extern NSMutableArray *longitudeGlobal;
extern NSMutableArray *latitudeGlobal;
extern UIViewController *location;


@interface GlobalView : NSObject 
-(BOOL)isInternetActive;
-(NSData*) jsonHttp:(NSDictionary*)dictionnary address:(NSString *)address error:(NSError *)requestError;
+(void)textFieldDidBeginEditing:(UITextField *)textField UIview:(UIViewController *)UIview distance:(int)distance;
+(void)closeKeyboard:(UIViewController *)UIview;
@end