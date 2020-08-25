//
//  CustomKeyChain.m
//  EagleVision
//
//  Created by JAVIS on 2019/9/4.
//  Copyright © 2019 JAVIS. All rights reserved.
//

#import "CustomKeyChain.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation CustomKeyChain
static NSString * const serviceName = @"222.187.25.222";

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    // Must be persistent ref !!!!
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    
    return (__bridge_transfer NSData *)result;
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (Byte)ByteToNSString:(NSString *)str{
    NSData* bytes = [str dataUsingEncoding:NSUTF8StringEncoding];
    Byte *myByte = (Byte *)[bytes bytes];
    return *myByte;
}

+ (NSString *)encryptForPlainText:(NSString *)plainText WithSecondStr:(NSString *)str
{
    //保存加密后的字符
    NSMutableString *encryption=[NSMutableString string];
    //编码转换后的字符串 UTF_8->iso-8859-1
    NSString *encoding=[[NSString alloc]initWithData:[plainText dataUsingEncoding:NSUTF8StringEncoding] encoding:NSISOLatin1StringEncoding];
    
    for(int i=0,j=0;i<encoding.length;i++,j++){
        if(j==str.length){
            j=0;
        }
        //异或后的字符
        char cipher=(char)([encoding characterAtIndex:i]^[str characterAtIndex:i % str.length]);
        //NSLog(@"%c转成16进制的字符串：%@,%@",cipher,[NSString stringWithFormat:@"%hhx",cipher],[NSString stringWithFormat:@"%x",cipher&0xff]);
        //转成16进制形式的字符串 \x8b转成8b字符串
        NSString *strCipher= [NSString stringWithFormat:@"%hhx",cipher];
        if(strCipher.length == 1){
            [encryption appendFormat:@"0%@",strCipher];
        }else{
            [encryption appendString:strCipher];
        }
    }
    return encryption;
}

+ (NSString *)md5String:(NSString *)sourceString{
    if(!sourceString){
        return nil;//判断sourceString如果为空则直接返回nil。
    }
    //MD5加密都是通过C级别的函数来计算，所以需要将加密的字符串转换为C语言的字符串
    const char *cString = sourceString.UTF8String;
    //创建一个C语言的字符数组，用来接收加密结束之后的字符
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //MD5计算（也就是加密）
    //第一个参数：需要加密的字符串
    //第二个参数：需要加密的字符串的长度
    //第三个参数：加密完成之后的字符串存储的地方
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    //将加密完成的字符拼接起来使用（16进制的）。
    //声明一个可变字符串类型，用来拼接转换好的字符
    NSMutableString *resultString = [[NSMutableString alloc]init];
    //遍历所有的result数组，取出所有的字符来拼接
    for (int i = 0;i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString  appendFormat:@"%02x",result[i]];
        //%02x：x 表示以十六进制形式输出，02 表示不足两位，前面补0输出；超出两位，不影响。当x小写的时候，返回的密文中的字母就是小写的，当X大写的时候返回的密文中的字母是大写的。
    }
    //打印最终需要的字符
    return resultString;
}

+ (NSString *)md5Data:(NSData *)sourceData{
    if (!sourceData) {
        return nil;//判断sourceString如果为空则直接返回nil。
    }
    //需要MD5变量并且初始化
    CC_MD5_CTX  md5;
    CC_MD5_Init(&md5);
    //开始加密(第一个参数：对md5变量去地址，要为该变量指向的内存空间计算好数据，第二个参数：需要计算的源数据，第三个参数：源数据的长度)
    CC_MD5_Update(&md5, sourceData.bytes, (CC_LONG)sourceData.length);
    //声明一个无符号的字符数组，用来盛放转换好的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //将数据放入result数组
    CC_MD5_Final(result, &md5);
    //将result中的字符拼接为OC语言中的字符串，以便我们使用。
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X",result[i]];
    }
    return  resultString;
}

+(NSString *)base64EncodingWithData:(NSString *)str{
    NSData *sourceData = [str dataUsingEncoding:NSUTF8StringEncoding];
    if (!sourceData) {//如果sourceData则返回nil，不进行加密。
        return nil;
    }
    NSString *resultString = [sourceData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return resultString;
}

+(id)base64EncodingWithString:(NSString *)sourceString{
    if (!sourceString) {
        return nil;//如果sourceString则返回nil，不进行解密。
    }
    NSData *resultData = [[NSData alloc]initWithBase64EncodedString:sourceString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return resultData;
}

+ (NSString *)pinxCreator:(NSString *)pan withPinv:(NSString *)pinv
{
    if (pan.length != pinv.length)
    {
        return nil;
    }
    const char *panchar = [pan UTF8String];
    const char *pinvchar = [pinv UTF8String];
    NSString *temp = [[NSString alloc] init];
    for (int i = 0; i < pan.length; i++)
    {
        int panValue = [self charToint:panchar[i]];
        int pinvValue = [self charToint:pinvchar[i%pinv.length]];
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%X",panValue^pinvValue]];
    }
    return temp;
}
+ (int)charToint:(char)tempChar
{
    if (tempChar >= '0' && tempChar <='9')
    {
        return tempChar - '0';
    }
    else if (tempChar >= 'A' && tempChar <= 'F')
    {
        return tempChar - 'A' + 10;
    }
    return 0;
}


+ (NSData *)encodeData:(NSString *)sourceStr withKey:(NSString *)key {
    NSData *sourceData = [sourceStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte *keyBytes = (Byte *)[keyData bytes];   //取关键字的Byte数组, keyBytes一直指向头部
    
    Byte *sourceDataPoint = (Byte *)[sourceData bytes];  //取需要加密的数据的Byte数组
    
    for (long i = 0; i < [sourceData length]; i++) {
        sourceDataPoint[i] = sourceDataPoint[i] ^ keyBytes[(i % [keyData length])]; //然后按位进行异或运算
    }
    
    return keyData;
}

+ (NSString *)doEor: (NSString *)sourceStr withKey:(NSString *)key {
    NSData* sourceData = [sourceStr dataUsingEncoding:NSUTF8StringEncoding];
    Byte *sourceByte = (Byte *)[sourceData bytes];
    
    NSData* keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte* keyByte = (Byte *)[keyData bytes];
    
    for (long i = 0; i < [sourceData length]; i++) {
        sourceByte[i] = sourceByte[i] ^ keyByte[i % [keyData length]];
    }
    
    return [[NSString alloc] initWithData:sourceData encoding:NSUTF8StringEncoding];
}

+ (NSString *)getInsideString:(NSString *)pattern withString:(NSString *)string {
    NSRegularExpression *regex =[NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    NSMutableArray*  rangeArr=[[NSMutableArray alloc] init];
    for (NSTextCheckingResult* match in matches) {
        [rangeArr addObject:[NSValue valueWithRange:match.range]];//找到每个分号和冒号的Range，存到数组
    }
    NSString *finalString;
    for (int i=0; i<rangeArr.count; i=i+2) {//for循环获取到每个符合条件的字符串，i=i+2将相邻的冒号和分号配对
        NSRange   range=[[rangeArr objectAtIndex:i] rangeValue];
        NSInteger location=range.location;
        NSRange  nextRange=[[rangeArr objectAtIndex:i+1] rangeValue];
        NSInteger  nextLocation=nextRange.location;
        NSRange   finalRange=NSMakeRange(range.location+1, nextLocation-location-1);
        finalString=[string substringWithRange:finalRange];
    }
    return finalString;
}

//将十六进制的字符串转换成NSString则可使用如下方式:
+ (NSString *)convertHexStrToString:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    return string;
}

+ (NSString *)base64ToString:(NSString *)base64Str {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
