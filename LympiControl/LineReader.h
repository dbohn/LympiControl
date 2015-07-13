//
//  LineReader.h
//  LympiControl
//
//  Created by David Bohn on 13.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineReader : NSObject

@property (readonly, nonatomic) NSData *data;
@property (readonly, nonatomic) NSUInteger linesRead;
@property (strong, nonatomic) NSCharacterSet *lineTrimCharacters;
@property (readonly, nonatomic) NSStringEncoding stringEncoding;

- (instancetype)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding;
- (NSString *)readLine;
- (NSString *)readTrimmedLine;
- (void)setLineSearchPosition:(NSUInteger)position;

@end
