//
//  DailyViewController.h
//  eLog
//
//  Created by nopilas on 2014-09-29.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *line;
@property (weak, nonatomic) IBOutlet UITextField *nbTraps;
@property (weak, nonatomic) IBOutlet UITextField *nbLobster;
- (IBAction)nextLine:(id)sender;
- (IBAction)dailySave:(id)sender;



@end
