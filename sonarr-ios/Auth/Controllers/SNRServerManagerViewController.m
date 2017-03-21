//
//  SNRServerManagerViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 20/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRServerManagerViewController.h"
#import "SNRAddServerPopUpViewController.h"
#import "SNRNavigationViewController.h"
#import "SNRServerManager.h"
#import "SNRServerTableViewCell.h"

@interface SNRServerManagerViewController () <UITextFieldDelegate, NSURLSessionDelegate, UITableViewDelegate, UITableViewDataSource, SNRNavigationBarButtonProtocol, SNRServerManagerProtocol>
@property (strong, nonatomic) SNRServerManager *serverManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SNRServerManagerViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.serverManager = [SNRServerManager manager];
}

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
    return self.serverManager.servers.count ? : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.serverManager.servers.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noServerCell" forIndexPath:indexPath];
        return cell;
    }
    
    SNRServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sonarrCell" forIndexPath:indexPath];
    [cell setServer:[self.serverManager.servers objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Navigation Protocol

-(void)addServerButtonTouchUpInside{
    [self presentViewController:[SNRAddServerPopUpViewController formViewController] animated:YES completion:nil];
}

-(UIBarButtonItem *)rightBarButton{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addServerButtonTouchUpInside)];
}

#pragma mark - Server Manager Protocol

-(void)didAddServer:(SNRServer *)server atIndex:(NSInteger)index{
    [self.tableView beginUpdates];
    
    if(self.serverManager.servers.count == 1){
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
    
    [self.tableView endUpdates];
}

-(void)didDeleteServer:(SNRServer *)server atIndex:(NSInteger)index{
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
