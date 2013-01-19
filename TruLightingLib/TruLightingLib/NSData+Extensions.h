//
//  NSData+Extensions.h
//  ContractorGallery
//
//  Created by bmahloch on 9/1/09.
//  Copyright 2009 Brian Mahloch. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Extensions)

+ (id)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64Encoding;

@end
