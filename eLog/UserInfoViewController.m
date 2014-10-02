//
//  UserInfoViewController.m
//  eLog
//
//  Created by nopilas on 2014-10-01.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import "UserInfoViewController.h"
#import "DBManager.h"
#import "GlobalView.h"

@implementation UserInfoViewController

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

// The callback method for an alertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:index];
    if ([buttonTitle isEqualToString:@"OK"])
    {
        [self performSegueWithIdentifier:@"userInfo.Push" sender:self];
    }
}

/*
- (void) retrieveData
{
    NSString *strURL = [NSString stringWithFormat:@"http://nopilas.cuccfree.com/getBoat.php?userId=%@",userId];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    jsonArray = [NSJSONSerialization JSONObjectWithData:dataURL options:kNilOptions error:nil];
    
    boatArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSString * cNo = [[jsonArray objectAtIndex:i] objectForKey:@"No"];
        NSString * cName = [[jsonArray objectAtIndex:i] objectForKey:@"Name"];
        NSString * cColor = [[jsonArray objectAtIndex:i] objectForKey:@"Color"];
        
        [boatArray addObject:[[Boat alloc] initWithBoatNo:cNo andBoatName:cName andBoatColor:cColor]];
    }
    if ([boatArray count] > 0)
    {
        Boat *boatObject;
        boatObject = [boatArray objectAtIndex:0];
        _boatNo.text = boatObject.boatNo;
        _boatName.text = boatObject.boatName;
        _boatColor.text = boatObject.boatColor;
    }
}*/
- (IBAction)saveUserInfo:(id)sender
{
    [[DBManager getSharedInstance ]saveDataUserInfo:idUserGlobal licenceHolder:_licenceHolder.text lobsterlicence:_lobsterLicence.text vesselName:_vesselName.text vesselNumber:_vesselNumber.text zone:_zone.text];
    
    NSArray *keys = [NSArray arrayWithObjects:@"idUser", @"licenceHolder", @"lobsterLicence",@"vesselName", @"vesselNumber", @"zone", nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", idUserGlobal], _licenceHolder.text, _lobsterLicence.text, _vesselName.text, _vesselNumber.text, _zone.text,  nil];
    NSDictionary *trackDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    GlobalView *a = [[GlobalView alloc] init ];
    
    NSError *requestError = nil;
    NSData * returnData = [a jsonHttp:trackDictionary address:@"http://nopilas.cuccfree.com/saveUserInfo.php" error:requestError];
    
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
@end
