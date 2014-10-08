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

NSArray *pickerArray;
UIPickerView * myPickerView;


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
    [self addPickerView];
    
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

-(void)addPickerView
{
    pickerArray = [[NSArray alloc]initWithObjects:@"23-A", @"23-B",@"23-C",@"23-D",@"24-1", @"24-2", @"25-1",@"25-2",@"25-3",@"26A-1",
                   @"26A-2", @"26A-3",@"26A-4",@"26B-1",@"26B-2",nil];

    _zone.delegate = self;
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:NSLocalizedString(@"Done",nil) style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     myPickerView.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects: doneButton, nil];
    [toolBar setItems:toolbarItems];
    _zone.inputView = myPickerView;
    _zone.inputAccessoryView = toolBar;
    
}

-(void) done
{
    [_zone resignFirstResponder];
}

#pragma mark - Text field delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _zone && [textField.text isEqualToString:@""])
    {
        [_zone setText:[pickerArray objectAtIndex:0]];
    }
}
#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    [_zone setText:[pickerArray objectAtIndex:row]];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
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
    if ([_licenceHolder.text isEqualToString:@""] || [_lobsterLicence.text isEqualToString:@""] || [_vesselNumber.text isEqualToString:@""] || [_vesselName.text isEqualToString:@""] || [_zone.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please fill all the field", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Save", nil) message:NSLocalizedString(@"Save successfully", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[requestError localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}
@end