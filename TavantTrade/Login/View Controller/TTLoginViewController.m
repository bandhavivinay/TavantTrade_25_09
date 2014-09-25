//
//  TTLoginViewController.m
//  TavantTrade
//
//  Created by TAVANT on 2/19/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTLoginViewController.h"
#import "TTDashboardViewController.h"
#import "TTAlertView.h"
#import "SBITradingNetworkManager.h"
#import "TTUrl.h"
#import "TTAppDelegate.h"

@interface TTLoginViewController ()
@property(nonatomic,strong) TTAlertView *alertView;
@end

@implementation TTLoginViewController

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
//    _userNameTextField.text = @"Gautham";
//    _passwordTextField.text = @"Novell@123";
    // Do any additional setup after loading the view from its nib.
    _alertView = [TTAlertView sharedAlert];
    _loginButton.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClickAction:(id)sender {
    // validating the credentials and allowing user  to proceed
    if([self validateTextFields]){
        [self validateUser];
    }
     else{

        [_alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Missing_Credentials", @"Localizable",@"Please Enter the credentials")];

     }

}

-(void)validateUser{
    
    TTDashboardViewController *viewController = [[TTDashboardViewController alloc] initWithNibName:@"TTDashboardViewController" bundle:nil];
    [(TTAppDelegate *)[[UIApplication sharedApplication] delegate] setDashboardViewController:viewController];
    //[self presentViewController:viewController animated:NO completion:NULL];
    [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"clientId"];
    
    // commenting basic authentication since no authentication being done from server
    
//    NSString *relativePath = [TTUrl accountLoginURL];
//    
//    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
//   
//    [networkManager makeBasicAuthenticationRequestWithRelativePath:(NSString *)relativePath withUserName:_userNameTextField.text withPassword: _passwordTextField.text responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
//        
//        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if(recievedResponse.statusCode != 200){
//                [_alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Login_Failed", @"Localizable",@"Login failed")];
//                
//                NSLog(@"error %d",recievedResponse.statusCode);
//            }
//            else{
//                
//                TTDashboardViewController *viewController = [[TTDashboardViewController alloc] initWithNibName:@"TTDashboardViewController" bundle:nil];
//
//                [(TTAppDelegate *)[[UIApplication sharedApplication] delegate] setDashboardViewController:viewController];
//                //[self presentViewController:viewController animated:NO completion:NULL];
//                [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"clientId"];
//            }
//        });
//        
//        
//    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginButtonClickAction:nil];
    return YES;
}

-(BOOL)validateTextFields{
    // hardcoding it for time being
    bool isValidField=YES;
    
    if([_userNameTextField.text isEqualToString:@""]||[_passwordTextField.text isEqualToString:@""]){
        isValidField=NO;
    }
    
    return isValidField;
}
@end
