//
//  StartupController.m
//  eLog
//
//  Created by nopilas on 2014-09-10.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import "StartupViewController.h"
#import "DBManager.h"

@interface StartupViewController ()

@end

@implementation StartupViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)StartButton:(id)sender
{
    //[self resetKeychain];
    if ( [[DBManager getSharedInstance]SelectListCustomer] != nil)
    {
        [self performSegueWithIdentifier:@"Segue.push.start.login" sender:self];
    }
    else
    {
         [[DBManager getSharedInstance ]createDB];
        [self performSegueWithIdentifier:@"Segue.push.start.create" sender:self];
    }
}
/*
-(void)resetKeychain {
    [self deleteAllKeysForSecClass:kSecClassGenericPassword];
    [self deleteAllKeysForSecClass:kSecClassInternetPassword];
    [self deleteAllKeysForSecClass:kSecClassCertificate];
    [self deleteAllKeysForSecClass:kSecClassKey];
    [self deleteAllKeysForSecClass:kSecClassIdentity];
}

-(void)deleteAllKeysForSecClass:(CFTypeRef)secClass {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:(__bridge id)secClass forKey:(__bridge id)kSecClass];
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef) dict);
    NSAssert(result == noErr || result == errSecItemNotFound, @"Error deleting keychain data (%ld)", result);
}
 */
@end
