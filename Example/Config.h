//
//  Config.h
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import "MCJSONRemoteConfig.h"

@interface Config : MCJSONRemoteConfig

+ (Config *)config;
@property (strong, nonatomic) NSNumber *rateAppAfter;
@property (strong, nonatomic) NSString *rateAppUrl;

@end
