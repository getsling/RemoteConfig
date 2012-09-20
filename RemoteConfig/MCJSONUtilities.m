//
//  MCJSONUtilities.m
//  RemoteConfig
//

#import "MCJSONUtilities.h"

@implementation MCJSONUtilities

+ (id)parseJSONResultString:(NSString *)jsonString error:(NSError **)error {
    __unsafe_unretained id feedResult = nil;

    if (!jsonString)
        return nil;

    id nsjsonClass = NSClassFromString(@"NSJSONSerialization");
    SEL nsjsonSelect = NSSelectorFromString(@"JSONObjectWithData:options:error:");
    SEL sbJSONSelector = NSSelectorFromString(@"JSONValue");
    SEL jsonKitSelector = NSSelectorFromString(@"objectFromJSONStringWithParseOptions:error:");
    SEL yajlSelector = NSSelectorFromString(@"yajl_JSONWithOptions:error:");

    if (nsjsonClass && [nsjsonClass respondsToSelector:nsjsonSelect]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[nsjsonClass methodSignatureForSelector:nsjsonSelect]];
        invocation.target = nsjsonClass;
        invocation.selector = nsjsonSelect;
        __unsafe_unretained NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

        if (!jsonData)
            return nil;

        [invocation setArgument:&jsonData atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        NSUInteger readOptions = kNilOptions;
        [invocation setArgument:&readOptions atIndex:3];
        [invocation setArgument:&error atIndex:4];
        [invocation invoke];
        [invocation getReturnValue:&feedResult];
    } else if (jsonKitSelector && [jsonString respondsToSelector:jsonKitSelector]) {
        // first try JSONkit
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[jsonString methodSignatureForSelector:jsonKitSelector]];
        invocation.target = jsonString;
        invocation.selector = jsonKitSelector;
        int parseOptions = 0;
        [invocation setArgument:&parseOptions atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [invocation setArgument:&error atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&feedResult];
    } else if (sbJSONSelector && [jsonString respondsToSelector:sbJSONSelector]) {
        // now try SBJson
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[jsonString methodSignatureForSelector:sbJSONSelector]];
        invocation.target = jsonString;
        invocation.selector = sbJSONSelector;
        [invocation invoke];
        [invocation getReturnValue:&feedResult];
    } else if (yajlSelector && [jsonString respondsToSelector:yajlSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[jsonString methodSignatureForSelector:yajlSelector]];
        invocation.target = jsonString;
        invocation.selector = yajlSelector;

        NSUInteger yajlParserOptions = 0;
        [invocation setArgument:&yajlParserOptions atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [invocation setArgument:&error atIndex:3];

        [invocation invoke];
        [invocation getReturnValue:&feedResult];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"Please either target a platform that supports NSJSONSerialization or add one of the following libraries to your project: JSONKit, SBJSON, or YAJL", nil) forKey:NSLocalizedRecoverySuggestionErrorKey];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:NSLocalizedString(@"No JSON parsing functionality available", nil) userInfo:userInfo] raise];
    }
    
    if (error) {
        return nil;
    }
    
    return feedResult;
}

@end