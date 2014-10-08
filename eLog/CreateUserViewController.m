//
//  CreateUseController.m
//  eLog
//
//  Created by nopilas on 2014-08-25.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import "CreateUserViewController.h"
#import "KeychainItemWrapper.h"
#import "Boat.h"
#import "Foundation/Foundation.h"
#import "DBManager.h"
#import "GlobalView.h"
#import "Reachability.h"

NSString *userId;


@interface CreateUserViewController ()

@end

@implementation CreateUserViewController

@synthesize jsonArray, boatArray;


NSData *receivedData;;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

-(IBAction)saisieReturn:(id)sender
{
    [sender resignFirstResponder];
    [GlobalView closeKeyboard:self];
    
    UITextField *field = (UITextField*)sender;
    if( field == self.RepeatPassword)
    {
        [self CreateUser:nil];
    }
}

// The callback method for an alertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:index];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Login", nil)])
    {
        [self performSegueWithIdentifier:@"Segue.push.alert" sender:self];
    }
}

- (IBAction)CreateUser:(id)sender
{
    if ([_Login.text isEqualToString:@""] || [_Password.text isEqualToString:@""] || [_RepeatPassword.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Please fill all the field",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![_Password.text isEqualToString: _RepeatPassword.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"The password mismatch",nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        
        /*l'usagé a bien été crée. On va insérer ses informations dans le SQLITE*/
        NSArray *keys = [NSArray arrayWithObjects:@"login", @"password", nil];
        NSArray *objects = [NSArray arrayWithObjects:_Login.text, _Password.text, nil];
        NSDictionary *trackDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        GlobalView *gv = [[GlobalView alloc] init ];
        
        NSError *requestError = nil;
        NSData * returnData = [gv jsonHttp:trackDictionary address:@"http://nopilas.cuccfree.com/createuser.php" error:requestError];
        
        NSString *returnString;
        
        if (requestError == nil)
        {
            returnString = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
            NSLog(@"returnString: %@", returnString);
        }
        else
        {
            NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[requestError localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        if ([returnString isEqualToString:@"0"] || [returnString isEqualToString:@"0\t"])
        {
            // invalid information
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"User already exist", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [[DBManager getSharedInstance ]saveDataCustomer:[returnString intValue] login: _Login.text password:
             _Password.text] ;
             
            //KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"LoginData" accessGroup:nil];
            
            //[keychain setObject:[_Login text] forKey:(__bridge id)(kSecAttrAccount)];
            //[keychain setObject:returnString forKey:(__bridge id)(kSecAttrComment)];
            
            idUserGlobal = [returnString intValue];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"User created successfully",nil) delegate:self cancelButtonTitle:@"Login" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
}
@end
