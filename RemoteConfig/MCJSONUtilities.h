//
//  MCJSONUtilities.h
//  RemoteConfig
//

#import <Foundation/Foundation.h>

@interface MCJSONUtilities : NSObject

+ (id)parseJSONResultString:(NSString *)jsonString error:(NSError **)error;

@end
