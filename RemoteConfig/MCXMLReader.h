//
//  MCXMLReader.h
//
//

#import <Foundation/Foundation.h>

@interface MCXMLReader : NSObject <NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *__autoreleasing *errorPointer;
}

+ (NSMutableDictionary *)dictionaryForPath:(NSString *)path error:(NSError *__autoreleasing *)errorPointer;
+ (NSMutableDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *__autoreleasing *)errorPointer;
+ (NSMutableDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *__autoreleasing *)errorPointer;

@end

@interface NSDictionary (XMLReaderNavigation)

- (id)retrieveForPath:(NSString *)navPath;

@end