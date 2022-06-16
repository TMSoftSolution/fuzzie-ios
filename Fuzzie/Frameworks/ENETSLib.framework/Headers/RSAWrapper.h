//
//  RSAWrapper.h
//  eNETS
//
//  Created by Innovation on 4/24/17.
//  Copyright © 2017 NETS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAWrapper : NSObject

-(NSString*)performRSAEncryptionForData:(NSString *)plaintext withModulus:(NSString*)mod andExponent:(NSString*)exp;

@end
