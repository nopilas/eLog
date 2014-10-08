//
//  LoginController.m
//  eLog
//
//  Created by nopilas on 2014-08-24.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "DBManager.h"
#import "GlobalView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)BtnLogin:(id)sender
{
    }

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ( [identifier  isEqual: @"login"])
    {
        if ([_userNameTextField.text isEqualToString:@""] || [_passwordTextField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Invalide Information", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

-(IBAction)saisieReturn:(id)sender
{
    [sender resignFirstResponder];
    
    UITextField *field = (UITextField*)sender;
    if( field == self.passwordTextField)
    {
        if ( [self shouldPerformSegueWithIdentifier:@"login" sender:_loginBtn])
            [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"LoginData" accessGroup:nil];
    [_userNameTextField setText:[keychain objectForKey:(id)CFBridgingRelease(kSecAttrAccount)]];
                        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
}

- (void) dismissKeyboard
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
