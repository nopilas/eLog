//
//  DailyViewController.m
//  eLog
//
//  Created by nopilas on 2014-09-29.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import "DailyViewController.h"
#import "DBManager.h"
#import "KeychainItemWrapper.h"
#import "GlobalView.h"
#import "LocationViewController.h"

@interface DailyViewController ()

@end

@implementation DailyViewController

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    [self hauledTraps].delegate = self;
    [self soakDays].delegate = self;
    [self canner].delegate = self;
    [self market].delegate = self;
    [self rockCrab].delegate = self;
    [self cunner].delegate = self;
    [self sculpin].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( textField == _hauledTraps || textField == _soakDays)
    {
        [GlobalView textFieldDidBeginEditing:textField UIview:self distance:0];
    }
    else if (textField == _canner || textField == _market)
    {
        [GlobalView textFieldDidBeginEditing:textField UIview:self distance:-70];
    }
    else
    {
        [GlobalView textFieldDidBeginEditing:textField UIview:self distance:-90];
    }
        
}

// The callback method for an alertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:index];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Save", nil)])
    {
        if ([_soakDays.text isEqualToString:@""] || [_market.text isEqualToString:@""] || [_sculpin.text isEqualToString:@""] || [_cunner.text isEqualToString:@""] || [_rockCrab.text isEqualToString:@""] || [_hauledTraps.text isEqualToString:@""] || [_canner.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) message:NSLocalizedString(@"All field must be filled", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            double longitude;
            double latitude;
            double totalLongitude;
            double totalLatitude;
            
            if ( longitudeGlobal.count > 0)
            {
                for( int i = 0; i< longitudeGlobal.count; i++)
                {
                    totalLongitude += [[longitudeGlobal objectAtIndex:i] doubleValue];
                    totalLatitude += [[latitudeGlobal objectAtIndex:i] doubleValue];
                }
                
                longitude = totalLongitude / longitudeGlobal.count;
                latitude = totalLatitude / latitudeGlobal.count;
            }
            else
            {
                longitude = 0;
                latitude = 0;
            }
            
            NSDateFormatter *dtFormat = [[NSDateFormatter alloc]init];
            [dtFormat setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *dt = [NSDate date];
            NSString *dateString = [dtFormat stringFromDate:dt];
            
            [[DBManager getSharedInstance ]saveDataDaily:idUserGlobal lineNo:-1 soakDays:[_soakDays.text intValue] market:[_market.text intValue] sculpin:[_sculpin.text intValue] cunner:[_cunner.text intValue] rockCrab:[_rockCrab.text intValue] hauledTraps:[_hauledTraps.text intValue] canner:[_canner.text intValue] Date:dateString longitude:longitude latitude:latitude];
            
            _market.text = @"";
            _soakDays.text = @"";
            _sculpin.text = @"";
            _cunner.text = @"";
            _rockCrab.text = @"";
            _hauledTraps.text = @"";
            _canner.text = @"";
            
            
            NSArray* result = [[DBManager getSharedInstance ]SelectDailyInfo:idUserGlobal];
            
            NSArray *keys = [NSArray arrayWithObjects:@"a", nil];
            NSArray *objects = [NSArray arrayWithObjects:result,  nil];
            NSDictionary *trackDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            
            GlobalView *a = [[GlobalView alloc] init ];
            
            NSMutableURLRequest * returnData = [a jsonHttp:trackDictionary address:@"https://nopilas.cuccfree.com/saveDaily.php"];
            (void) [NSURLConnection connectionWithRequest:returnData delegate:self];
        }
    }
}

- (IBAction)dailySave:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Question", nil) message:NSLocalizedString(@"Do you really want to save this info ?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Save", nil) otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void) dismissKeyboard
{
    [self.view endEditing:YES];
    [GlobalView closeKeyboard:self];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Retry again", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"NSURLConnection sendSynchronousRequest error: %@", error);
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Save", nil) message:NSLocalizedString(@"Save successfully", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    // on indique dans la bd que ce lignes où sent était à 0 qu'elles sont bien uploadées.
    [[DBManager getSharedInstance]updateSentDaily:idUserGlobal];
    
    if ( locationUIView != nil )
        [(LocationViewController *) locationUIView stopTimer];
}

-(void) connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


@end
