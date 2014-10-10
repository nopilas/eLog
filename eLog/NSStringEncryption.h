//
//  NSString+AESCrypt.h
//
//  Created by Michael Sedlaczek, Gone Coding on 2011-02-22
//

#import <Foundation/Foundation.h>
#import "NSDataEncryption.h"

@interface NSString (AESCrypt)

- (NSString *)AES256EncryptWithKey;
- (NSString *)AES256DecryptWithKey;

@end