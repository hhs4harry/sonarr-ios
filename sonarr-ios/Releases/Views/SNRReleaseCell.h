//
//  SNRReleaseCell.h
//  Sonarr
//
//  Created by Harry Singh on 14/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRRelease;

@protocol SNRReleaseCellProtocol
-(void)downloadRelease:(SNRRelease * _Nonnull)release withCompletion:(void(^ _Nullable)(SNRRelease * _Nullable release, NSError * _Nullable error))completion;

@end

@interface SNRReleaseCell : UITableViewCell
@property (weak, nonatomic, nullable) id<SNRReleaseCellProtocol> delegate;

-(void)setRelease:(SNRRelease * _Nonnull)release;

@end
