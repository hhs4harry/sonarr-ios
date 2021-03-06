//
//  SNRAddSeriesDetailsTableViewCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 3/04/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesDetailsTableViewCell.h"
#import "SNRSeries.h"
#import "SNRServer.h"
#import "SNRServerManager.h"
#import "SNRProfile.h"
#import "SNRRootFolder.h"
#import "SNRSeason.h"

typedef enum : NSUInteger {
    MonitorTypeAll = 0,
    MonitorTypeFuture,
    MonitorTypeMissing,
    MonitorTypeExisting,
    MonitorTypeFirstSeason,
    MonitorTypeLastSeason,
    MonitorTypeNone
} MonitorType;

@interface SNRAddSeriesDetailsTableViewCell() <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) SNRServer *server;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (assign, nonatomic) SeriesDetail type;
@end

@implementation SNRAddSeriesDetailsTableViewCell

-(void)becomeFirstResponder{    
    if(!self.valueTextField.isFirstResponder && self.dataSource){
        [self.valueTextField becomeFirstResponder];
    }
}

-(void)setSeries:(SNRSeries *)series seriesDetailType:(SeriesDetail)type{
    self.server = [SNRServerManager manager].activeServer;
    self.series = series;
    self.type = type;

    switch (type) {
        case SeriesDetailPath:
            self.nameLabel.text = @"Path";
            self.dataSource = self.server.rootFolders;
            
            if(!self.dataSource){
                self.valueTextField.text = @"Loading...";
                
                __weak typeof(self) wself = self;
                [self.server rootFolderswithCompletion:^(NSArray<SNRRootFolder *> * _Nullable rootFolders, NSError * _Nullable error) {
                    if(rootFolders){
                        wself.dataSource = rootFolders;
                        wself.series.path = [rootFolders.firstObject.path stringByAppendingString:self.series.title];
                        wself.valueTextField.text = rootFolders.firstObject.path;
                    }else{
                        [wself setSeries:wself.series seriesDetailType:wself.type];
                    }
                }];
            }else{
                self.valueTextField.text = ((SNRRootFolder *)self.dataSource.firstObject).path;
                self.series.path = [((SNRRootFolder *)self.dataSource.firstObject).path stringByAppendingString:self.series.title];
            }
            break;
        case SeriesDetailMonitor:
            self.nameLabel.text = @"Monitor";
            self.dataSource = @[@"All",
                                @"Future",
                                @"Missing",
                                @"Existing",
                                @"First Season",
                                @"Last Season",
                                @"None"];
            self.valueTextField.text = self.dataSource.lastObject;
            self.series.addOptions = @{
                                       IGNOREEPISODESWITHFILES : @"false",
                                       IGNOREEPISODESWITHOUTFILES : @"false"
                                       };
            
            [self setSeasonPass:-1];
            break;
        case SeriesDetailProfile:
            self.nameLabel.text = @"Quality Profile";
            self.dataSource = self.server.profiles;
            
            if(!self.dataSource){
                self.valueTextField.text = @"Loading...";
                
                __weak typeof(self) wself = self;
                [self.server profilesWithCompletion:^(NSArray<SNRProfile *> * _Nullable profiles, NSError * _Nullable error) {
                    if(profiles){
                        wself.dataSource = profiles;
                        wself.valueTextField.text = ((SNRProfile *)self.dataSource.firstObject).name;
                        wself.series.profileId = ((SNRProfile *)self.dataSource.firstObject).id;
                    }else{
                        [wself setSeries:wself.series seriesDetailType:wself.type];
                    }
                }];
            }else{
                self.valueTextField.text = ((SNRProfile *)self.dataSource.firstObject).name;
                self.series.profileId = ((SNRProfile *)self.dataSource.firstObject).id;
            }
            break;
        case SeriesDetailSeriesType:
            self.nameLabel.text = @"Type";
            self.dataSource = @[@"Standard",
                                @"Daily",
                                @"Anime"];
            self.valueTextField.text = self.dataSource.firstObject;
            self.series.seriesType = self.valueTextField.text;
            break;
        default:
            return;
            break;
    }
    
    [self setupPickerView];
}

#pragma mark - PickerView

-(void)setupPickerView{
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                     130)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *objStr = obj;
        
        switch (self.type) {
            case SeriesDetailPath:
                objStr = ((SNRRootFolder *)obj).path;
                break;
            case SeriesDetailProfile:
                objStr = ((SNRProfile *)obj).name;
                break;
            default:
                break;
        }
        
        if([objStr isEqualToString:self.valueTextField.text]){
            [self.pickerView selectRow:idx inComponent:0 animated:NO];
        }
    }];
    
    self.valueTextField.inputView = self.pickerView;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    id obj = [self.dataSource objectAtIndex:row];
    
    switch (self.type) {
        case SeriesDetailPath:
            return ((SNRRootFolder *)obj).path;
        case SeriesDetailMonitor:
            return (NSString *)obj;
        case SeriesDetailProfile:
            return ((SNRProfile *)obj).name;
        case SeriesDetailSeriesType:
            return (NSString *)obj;
        default:
            break;
    }
    
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    id obj = [self.dataSource objectAtIndex:row];
    
    switch (self.type) {
        case SeriesDetailPath:
            self.series.path = [((SNRRootFolder *)obj).path stringByAppendingString:self.series.title];
            self.valueTextField.text = ((SNRRootFolder *)obj).path;
            break;
        case SeriesDetailMonitor:{
            NSMutableDictionary *options = @{
                                             IGNOREEPISODESWITHFILES : @"false",
                                             IGNOREEPISODESWITHOUTFILES : @"false"
                                             }.mutableCopy;
            
            [self setSeasonPass:-1];
            
            switch (row) {
                case MonitorTypeAll:
                    [self setSeasonPass:((SNRSeason *)self.series.seasons.lastObject).seasonNumber.integerValue];
                    break;
                case MonitorTypeFuture:
                    [self setSeasonMonitored:((SNRSeason *)self.series.seasons.lastObject).seasonNumber.integerValue];
                    options[IGNOREEPISODESWITHFILES] = @"true";
                    options[IGNOREEPISODESWITHOUTFILES] = @"true";
                    break;
                case MonitorTypeMissing:
                    [self setSeasonPass:((SNRSeason *)self.series.seasons.lastObject).seasonNumber.integerValue];
                    options[IGNOREEPISODESWITHFILES] = @"true";
                    break;
                case MonitorTypeExisting:
                    [self setSeasonMonitored:((SNRSeason *)self.series.seasons.lastObject).seasonNumber.integerValue];
                    options[IGNOREEPISODESWITHOUTFILES] = @"true";
                    break;
                case MonitorTypeFirstSeason:
                    [self setSeasonMonitored:1];
                    break;
                case MonitorTypeLastSeason:
                    [self setSeasonPass:-1];
                    [self setSeasonMonitored:((SNRSeason *)self.series.seasons.lastObject).seasonNumber.integerValue];
                    break;
                case MonitorTypeNone:
                    [self setSeasonPass:-1];
                    break;
                default:
                    break;
            }
            self.series.addOptions = options;
            self.valueTextField.text = obj;
            break;
        }
        case SeriesDetailProfile:
            self.series.profileId = ((SNRProfile *)obj).id;
            self.valueTextField.text = ((SNRProfile *)obj).name;
            break;
        case SeriesDetailSeriesType:
            self.series.seriesType = obj;
            self.valueTextField.text = self.series.seriesType;
            break;
            
        default:
            break;
    }
}

#pragma mark - Helper methods

-(void)setSeasonMonitored:(NSInteger)season{
    [self.series.seasons enumerateObjectsUsingBlock:^(SNRSeason * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.seasonNumber.integerValue == season){
            obj.monitored = !obj.monitored;
        }
    }];
}

-(void)setSeasonPass:(NSInteger)season{
    [self.series.seasons enumerateObjectsUsingBlock:^(SNRSeason * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!idx){
            return;
        }
        
        if(obj.seasonNumber.integerValue <= season){
            obj.monitored = YES;
        }else{
            obj.monitored = NO;
        }
    }];
}

@end
