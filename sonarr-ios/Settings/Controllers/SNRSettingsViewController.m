//
//  SNRSettingsViewController.m
//  Sonarr
//
//  Created by Harry Singh on 14/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSettingsViewController.h"
#import "SNRServer.h"
#import "SNRServerManager.h"
#import "SNRServerConfig.h"
#import "SNRAddServerCell.h"
#import "SNRServerCell.h"
#import "SNRServerManager.h"
#import "SNRSettingsCell.h"

typedef enum : NSUInteger {
    SNRSettingsSectionAddServer = 0,
    SNRSettingsSectionActiveServer,
    SNRSettingsSectionCount,
} SNRSettingsSection;

@interface SNRSettingsViewController () <UITableViewDataSource, UITableViewDelegate, SNRSettingsCellProtocol, SNRServerManagerProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) BOOL open;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIButton *chevronButton;
@property (assign, nonatomic) BOOL addingServer;
@property (assign, nonatomic) BOOL editingServer;
@end

@implementation SNRSettingsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.open = NO;
    self.addingServer = NO;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chevronTouchUpInide:)];
    self.view.gestureRecognizers = @[self.tap];
    
    [[SNRServerManager manager] addObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[SNRServerManager manager] removeObserver:self];
}

-(void)viewDidLoad{
    [super viewDidLoad];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![SNRServerManager manager].servers.count) {
            [self openSettings:YES];
        } else {
            [self updateTitle];
        }
    });
}

- (IBAction)chevronTouchUpInide:(id)sender {
    [self openSettings:!self.open];
}

-(void)openSettings:(BOOL)open{
    self.open = open;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self updateTitle];
        
        self.chevronButton.transform = open ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    }];
    
    [self.tap setEnabled:!self.open];
    [self.delegate openSettings:self.open];
}

-(void)updateTitle{
    if (self.open) {
        self.titleLabel.text = @"Servers";
    } else {
        SNRServer *active;
        if((active = [SNRServerManager manager].activeServer)) {
            self.titleLabel.text = active.config.hostname;
        } else {
            self.titleLabel.text = @"Tap To Add Servers";
        }
    }
}

#pragma mark - TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SNRSettingsSectionAddServer) {
        SNRAddServerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNRAddServerCellSBID" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    
    SNRServerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNRServerCellSBID" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureWithServer:[SNRServerManager manager].servers[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SNRSettingsSectionAddServer) {
        return 1;
    }
    return [SNRServerManager manager].servers.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SNRSettingsSectionCount;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SNRSettingsSectionAddServer) {
        return self.addingServer ? 190 : 50;
    }
    
    return self.editingServer ? 190 : 50;
}

#pragma mark - SettingsCell Protocol

-(void)expanded:(BOOL)expanded cell:(SNRSettingsCell *)cell {
    if ([cell isKindOfClass:[SNRServerCell class]]) {
        self.editingServer = expanded;
    } else if ([cell isKindOfClass:[SNRAddServerCell class]]) {
        self.addingServer = expanded;
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)addServerWithConfig:(SNRServerConfig *)config andCompletion:(void(^)(SNRStatus *status, NSError *error))completion{
    __block SNRServer *newServer = [[SNRServer alloc] initWithConfig:config];
    [newServer validateServerWithCompletion:^(SNRStatus * _Nullable status, NSError * _Nullable error) {
        if (status) {
            [[SNRServerManager manager] addServer:newServer];
        }
        completion(status, error);
    }];
}

#pragma mark - SNRServerManager protocol

-(void)didAddServer:(SNRServer *)server atIndex:(NSInteger)index{
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:SNRSettingsSectionActiveServer]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)didDeleteServer:(SNRServer *)server atIndex:(NSInteger)index{
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:SNRSettingsSectionActiveServer]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)didSetActiveServer:(SNRServer *)server atIndex:(NSInteger)index{
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:SNRSettingsSectionActiveServer]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)didUnsetActiveServer:(SNRServer *)server atIndex:(NSInteger)index{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:SNRSettingsSectionActiveServer]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
