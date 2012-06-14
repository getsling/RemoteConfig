//
//  Config.h
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import "MCJSONRemoteConfig.h"

@interface Config : MCJSONRemoteConfig

@property (strong, nonatomic) NSNumber *exampleIntegerValue;
@property (strong, nonatomic) NSString *exampleStringValue;
@property (strong, nonatomic) NSString *nonExistingStringValue;

+ (Config *)config;

@end
