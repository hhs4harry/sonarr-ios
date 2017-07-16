//
//  SNRAddServerCell.h
//  Sonarr
//
//  Created by Harry Singh on 16/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRAddServerCell;

@protocol SNRAddServerCellProtocol
-(void)expand:(BOOL)expand cell:(SNRAddServerCell *)cell;
@end

@interface SNRAddServerCell : UITableViewCell
@property (weak, nonatomic) id<SNRAddServerCellProtocol> delegate;
@end
