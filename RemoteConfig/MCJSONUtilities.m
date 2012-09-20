//
//  MCJSONUtilities.m
//  RemoteConfig
//

#import "MCJSONUtilities.h"

id JSONDecode(NSData *data, NSError **error) {    
    id JSON = nil;
    
    SEL _JSONKitSelector = NSSelectorFromString(@"objectFromJSONDataWithParseOptions:error:"); 
    SEL _YAJLSelector = NSSelectorFromString(@"yajl_JSONWithOptions:error:");
    
    id _SBJSONParserClass = NSClassFromString(@"SBJsonParser");
    SEL _SBJSONParserSelector = NSSelectorFromString(@"JSONValue");

    id _NSJSONSerializationClass = NSClassFromString(@"NSJSONSerialization");
    SEL _NSJSONSerializationSelector = NSSelectorFromString(@"JSONObjectWithData:options:error:");
    
    id _NXJsonParserClass = NSClassFromString(@"NXJsonParser");
    SEL _NXJsonParserSelector = NSSelectorFromString(@"parseData:error:ignoreNulls:");

    if (_JSONKitSelector && [data respondsToSelector:_JSONKitSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[data methodSignatureForSelector:_JSONKitSelector]];
        invocation.target = data;
        invocation.selector = _JSONKitSelector;
        
        NSUInteger parseOptionFlags = 0;
        [invocation setArgument:&parseOptionFlags atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        if (error != NULL) {
            [invocation setArgument:&error atIndex:3];
        }
        
        [invocation invoke];
        [invocation getReturnValue:&JSON];
    } else if (_SBJSONParserClass && [_SBJSONParserClass instancesRespondToSelector:_SBJSONParserSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[data methodSignatureForSelector:_SBJSONParserSelector]];
        invocation.target = data;
        invocation.selector = _SBJSONParserSelector;

        [invocation invoke];
        [invocation getReturnValue:&JSON];
    } else if (_YAJLSelector && [data respondsToSelector:_YAJLSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[data methodSignatureForSelector:_YAJLSelector]];
        invocation.target = data;
        invocation.selector = _YAJLSelector;
        
        NSUInteger yajlParserOptions = 0;
        [invocation setArgument:&yajlParserOptions atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        if (error != NULL) {
            [invocation setArgument:&error atIndex:3];
        }
        
        [invocation invoke];
        [invocation getReturnValue:&JSON];
    } else if (_NXJsonParserClass && [_NXJsonParserClass respondsToSelector:_NXJsonParserSelector]) {
        NSNumber *nullOption = [NSNumber numberWithBool:YES];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_NXJsonParserClass methodSignatureForSelector:_NXJsonParserSelector]];
        invocation.target = _NXJsonParserClass;
        invocation.selector = _NXJsonParserSelector;
        
        [invocation setArgument:&data atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        if (error != NULL) {
            [invocation setArgument:&error atIndex:3];
        }
        [invocation setArgument:&nullOption atIndex:4];
        
        [invocation invoke];
        [invocation getReturnValue:&JSON];
    } else if (_NSJSONSerializationClass && [_NSJSONSerializationClass respondsToSelector:_NSJSONSerializationSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_NSJSONSerializationClass methodSignatureForSelector:_NSJSONSerializationSelector]];
        invocation.target = _NSJSONSerializationClass;
        invocation.selector = _NSJSONSerializationSelector;

        [invocation setArgument:&data atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        NSUInteger readOptions = kNilOptions;
        [invocation setArgument:&readOptions atIndex:3];
        if (error != NULL) {
            [invocation setArgument:&error atIndex:4];
        }

        [invocation invoke];
        [invocation getReturnValue:&JSON];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"Please either target a platform that supports NSJSONSerialization or add one of the following libraries to your project: JSONKit, SBJSON, or YAJL", nil) forKey:NSLocalizedRecoverySuggestionErrorKey];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:NSLocalizedString(@"No JSON parsing functionality available", nil) userInfo:userInfo] raise];
    }
        
    return JSON;
}
