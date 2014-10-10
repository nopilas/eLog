//
//  CreateUseController.h
//  eLog
//
//  Created by nopilas on 2014-08-25.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface CreateUserViewController : UIViewController <NSURLConnectionDataDelegate>


- (IBAction)CreateUser:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *Login;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *RepeatPassword;

@property (nonatomic, strong) NSMutableArray * jsonArray;
@property (nonatomic, strong) NSMutableArray * boatArray;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void) connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
