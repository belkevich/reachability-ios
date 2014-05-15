//
//  MainViewController.m
//  ReachabilityApp
//
//  Created by Alexey Belkevich on 4/11/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "MainViewController.h"
#import "SCNetworkReachability.h"

NSString * const kDefaultHost = @"google.com";

@interface MainViewController () <UITextFieldDelegate>
{
    SCNetworkReachability *_reachability;
}

@property (weak, nonatomic) IBOutlet UITextField *hostField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation MainViewController

#pragma mark - appearance

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hostField.text = kDefaultHost;
    [self checkReachabilityForHost:kDefaultHost];
}

#pragma mark - actions

- (IBAction)viewTapped:(id)sender
{
    [self.hostField resignFirstResponder];
}

#pragma mark - text field delegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length < 5)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Host Name"
                                                        message:nil delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    [textField resignFirstResponder];
    [self checkReachabilityForHost:textField.text];
    return YES;
}

#pragma mark - private

- (void)checkReachabilityForHost:(NSString *)hostName
{
    self.statusLabel.text = @"Checking reachability status...";
    __weak __typeof(self) weakSelf = self;
    _reachability = [[SCNetworkReachability alloc] initWithHost:hostName];
    [_reachability observeReachability:^(SCNetworkStatus status)
    {
        switch (status)
        {
            case SCNetworkStatusReachableViaWiFi:
                weakSelf.statusLabel.text = @"Reachable via WiFi";
                break;
            case SCNetworkStatusReachableViaCellular:
                weakSelf.statusLabel.text = @"Reachable via Cellular";
                break;
            case SCNetworkStatusNotReachable:
                weakSelf.statusLabel.text = @"Not Reachable";
                break;
        }
    }];
}

@end
