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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextLine:(id)sender
{
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc]init];
    [dtFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dt = [NSDate date];
    NSString *dateString = [dtFormat stringFromDate:dt];
    
    [[DBManager getSharedInstance ]saveDataDaily:idUserGlobal LineNo:[_line.text intValue] NbTrap:[_nbTraps.text intValue] NbLobster:[_nbLobster.text intValue] Date:dateString];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Save successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    _line.text = @"";
    _nbTraps.text = @"";
    _nbLobster.text = @"";

}

- (IBAction)dailySave:(id)sender
{
    NSArray* result = [[DBManager getSharedInstance ]SelectDailyInfo:idUserGlobal];
     
    NSArray *keys = [NSArray arrayWithObjects:@"a", nil];
    NSArray *objects = [NSArray arrayWithObjects:result,  nil];
    NSDictionary *trackDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    GlobalView *a = [[GlobalView alloc] init ];
    
    NSError *requestError = nil;
    NSData * returnData = [a jsonHttp:trackDictionary address:@"http://nopilas.cuccfree.com/saveDaily.php" error:requestError];
    
    NSString *returnString;
    
    if (requestError == nil)
    {
        returnString = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
        NSLog(@"returnString: %@", returnString);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Save successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
    }

}

- (void) dismissKeyboard
{
    [self.view endEditing:YES];
}


@end
