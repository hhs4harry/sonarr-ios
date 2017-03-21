//
//  SNRServerTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 20/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRServerTableViewCell.h"
#import "SNRServer.h"
#import "SNRServerConfig.h"

@interface SNRServerTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *serverImageView;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;

@end

@implementation SNRServerTableViewCell

-(void)setServer:(SNRServer *)server{
    self.serverImageView.image = [UIImage imageNamed:@"sonarr_icon"];
    self.ipLabel.text = [[server.config.hostname stringByAppendingString:@":"] stringByAppendingString:server.config.port.stringValue];
}

@end
