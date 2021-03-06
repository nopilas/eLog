//
//  UserInfoViewController.h
//  eLog
//
//  Created by nopilas on 2014-10-01.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *licenceHolder;
@property (weak, nonatomic) IBOutlet UITextField *lobsterLicence;
@property (weak, nonatomic) IBOutlet UITextField *vesselName;
@property (weak, nonatomic) IBOutlet UITextField *vesselNumber;
- (IBAction)saveUserInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *zone;
//- (void) retrieveData;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void) connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
-(void) connectionDidFinishLoading:(NSURLConnection *)connection;
@end

