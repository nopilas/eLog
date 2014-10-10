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
extern UIViewController *locationUIView;


@interface GlobalView : NSObject 
-(BOOL)isInternetActive;
-(NSMutableURLRequest*)jsonHttp:(NSDictionary *)dictionnary address:(NSString *)address;
+(void)textFieldDidBeginEditing:(UITextField *)textField UIview:(UIViewController *)UIview distance:(int)distance;
+(void)closeKeyboard:(UIViewController *)UIview;

@end