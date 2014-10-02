//
//  CreateUseController.h
//  eLog
//
//  Created by nopilas on 2014-08-25.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface CreateUserViewController : UIViewController


- (IBAction)CreateUser:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *Login;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *RepeatPassword;

@property (nonatomic, strong) NSMutableArray * jsonArray;
@property (nonatomic, strong) NSMutableArray * boatArray;

@end
