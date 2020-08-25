//
//  CustomKeyChain.h
//  EagleVision
//
//  Created by JAVIS on 2019/9/4.
//  Copyright © 2019 JAVIS. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface CustomKeyChain : NSObject
- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier;
- (NSData *)searchKeychainCopyMatching:(NSString *)identifier;
- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier;
+ (Byte)ByteToNSString:(NSString *)str;
+ (NSString *)encryptForPlainText:(NSString *)plainText WithSecondStr:(NSString *)str;

+ (NSString *)base64EncodingWithData:(NSString *)str;
+ (NSString *)md5String:(NSString *)sourceString;
+ (NSString *)pinxCreator:(NSString *)pan withPinv:(NSString *)pinv;
+ (NSData *)encodeData:(NSString *)sourceStr withKey:(NSString *)key;
+ (NSString *)doEor: (NSString *)sourceStr withKey:(NSString *)key;

+ (NSString *)getInsideString:(NSString *)pattern withString:(NSString *)string;

+ (NSString *)convertHexStrToString:(NSString *)str;

+ (NSString *)base64ToString:(NSString *)base64Str;
@end
