//
//  SNRBaseTableView.h
//  sonarr-ios
//
//  Created by Harry Singh on 20/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRBaseTableView;

@protocol SNRBaseTableViewProtocol <UITableViewDelegate>
-(void)didRequestRefresh:(SNRBaseTableView *)tableView;
@end

@interface SNRBaseTableView : UITableView

@end
