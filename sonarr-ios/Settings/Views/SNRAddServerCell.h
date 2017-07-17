//
//  SNRAddServerCell.h
//  Sonarr
//
//  Created by Harry Singh on 16/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRAddServerCell;
@class SNRServerConfig;
@class SNRStatus;

@protocol SNRAddServerCellProtocol
-(void)expand:(BOOL)expand cell:(SNRAddServerCell *)cell;
-(void)addServerWithConfig:(SNRServerConfig *)config andCompletion:(void(^)(SNRStatus *status, NSError *error))completion;
@end

@interface SNRAddServerCell : UITableViewCell
@property (weak, nonatomic) id<SNRAddServerCellProtocol> delegate;
@end
