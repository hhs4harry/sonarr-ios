//
//  SNRAuthViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAuthViewController.h"
#import "SNRAddServerPopUpViewController.h"
#import "SNRNavigationViewController.h"

@interface SNRAuthViewController () <UITextFieldDelegate, NSURLSessionDelegate, UITableViewDelegate, UITableViewDataSource, SNRNavigationBarButtonProtocol>

@end

@implementation SNRAuthViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

#pragma mark - TableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noServerCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - Navigation Protocol

-(void)addServerButtonTouchUpInside{
    [self presentViewController:[SNRAddServerPopUpViewController formViewController] animated:YES completion:nil];
}

-(UIBarButtonItem *)rightBarButton{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addServerButtonTouchUpInside)];
}

@end
