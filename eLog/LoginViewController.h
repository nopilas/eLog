//
//  LoginController.h
//  eLog
//
//  Created by nopilas on 2014-08-24.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)BtnLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)saisieReturn :(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *createUser;
@end
