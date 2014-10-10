//
//  NSDataEncryption.h
//  eLog
//
//  Created by nopilas on 2014-10-09.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (AES256)

- (NSData *)AES256EncryptWithKey;
- (NSData *)AES256DecryptWithKey;
- (NSData*) encryptString:(NSString*)plaintext;
- (NSString*) decryptData:(NSData*)ciphertext;

@end
