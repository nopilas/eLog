//
//  UserInfoViewController.h
//  eLog
//
//  Created by nopilas on 2014-10-01.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *licenceHolder;
@property (weak, nonatomic) IBOutlet UITextField *lobsterLicence;
@property (weak, nonatomic) IBOutlet UITextField *vesselName;
@property (weak, nonatomic) IBOutlet UITextField *vesselNumber;
- (IBAction)saveUserInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *zone;
//- (void) retrieveData;
@end
