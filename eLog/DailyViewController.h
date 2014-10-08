//
//  DailyViewController.h
//  eLog
//
//  Created by nopilas on 2014-09-29.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *soakDays;
@property (weak, nonatomic) IBOutlet UITextField *market;
@property (weak, nonatomic) IBOutlet UITextField *sculpin;
@property (weak, nonatomic) IBOutlet UITextField *cunner;
@property (weak, nonatomic) IBOutlet UITextField *rockCrab;
@property (weak, nonatomic) IBOutlet UITextField *hauledTraps;
@property (weak, nonatomic) IBOutlet UIButton *dailySave;
@property (weak, nonatomic) IBOutlet UITextField *canner;
- (IBAction)dailySave:(id)sender;
@end
