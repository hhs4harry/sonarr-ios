//
//  SNRHistory.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol SNRRecord;

@interface SNRHistory : JSONModel
@property (strong, nonatomic) NSNumber *page;
@property (strong, nonatomic) NSNumber *pageSize;
@property (copy, nonatomic) NSString *sortKey;
@property (copy, nonatomic) NSString *sortDirection;
@property (strong, nonatomic) NSNumber *totalRecords;
@property (copy, nonatomic) NSArray<SNRRecord> *records;
@end
