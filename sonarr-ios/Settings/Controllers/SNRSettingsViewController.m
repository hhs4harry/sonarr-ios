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

@interface SNRSettingsViewController () <UITableViewDataSource, UITableViewDelegate, SNRAddServerCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) BOOL open;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) NSMutableArray<SNRServer *>* servers;
@property (weak, nonatomic) IBOutlet UIButton *chevronButton;
@property (assign, nonatomic) BOOL addingServer;
@end

@implementation SNRSettingsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.open = NO;
    self.addingServer = NO;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chevronTouchUpInide:)];
    self.view.gestureRecognizers = @[self.tap];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.servers = [SNRServerManager manager].servers;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.servers) {
            [self openSettings:YES];
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
        [self.addButton setHidden:!self.open];
        
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

- (IBAction)addButtonTouchUpInside:(id)sender {
    
}

#pragma mark - TableView DataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (!indexPath.row) {
        SNRAddServerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNRAddServerCellSBID" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.servers.count + 1;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.row) {
        return self.addingServer ? 200 : 50;
    }
    
    return 50;
}

#pragma mark - AddServerCell Protocol

-(void)expand:(BOOL)expand cell:(SNRAddServerCell *)cell{
    self.addingServer = expand;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
@end
