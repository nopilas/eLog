//
//  GlobalView.m
//  eLog
//
//  Created by nopilas on 2014-09-13.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import "GlobalView.h"
#import "Reachability.h"

@interface GlobalView ()


@end

@implementation GlobalView

int idUserGlobal;

+(void)textFieldDidBeginEditing:(UITextField *)textField UIview:(UIViewController *)UIview distance:(int)distance
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = UIview.view.frame;
    frame.origin.y = distance;
    [UIview.view setFrame:frame];
    [UIView commitAnimations];
}

+(void)closeKeyboard:(UIViewController *)UIview
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = UIview.view.frame;
    frame.origin.y = 0;
    [UIview.view setFrame:frame];
    [UIView commitAnimations];
}

-(BOOL)isInternetActive
{
    Reachability *internet = [Reachability reachabilityWithHostName:@"www.google.com"];
    if ( [internet isReachable])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(NSData*)jsonHttp:(NSDictionary *)dictionnary address:(NSString *)address error:(NSError *)requestError
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dictionnary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);  // To verify the jsonString.
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:address] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:jsonData];
    
    NSURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&requestError];
    return returnData;
    
}
@end

