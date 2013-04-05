//
//  Config.h
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "GVJSONRemoteConfig.h"

@interface Config : GVJSONRemoteConfig

@property (strong, nonatomic) NSNumber *exampleIntegerValue;
@property (strong, nonatomic) NSString *exampleStringValue;
@property (strong, nonatomic) NSString *nonExistingStringValue;

+ (Config *)sharedInstance;

@end
