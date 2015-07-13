//
//  LineReader.m
//  LympiControl
//
//  Created by David Bohn on 13.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

#import "LineReader.h"

static unsigned char const BRLineReaderDelimiter = '\n';

@implementation LineReader
{
    NSRange _lastRange;
}

- (instancetype)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
    self = [super init];
    if (self) {
        _data = data;
        _stringEncoding = encoding;
        _lineTrimCharacters = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    }
    
    return self;
}

- (NSString *)readLine
{
    NSUInteger dataLength = [_data length];
    NSUInteger beginPos = _lastRange.location + _lastRange.length;
    NSUInteger endPos = 0;
    if (beginPos == dataLength) {
        // End of file
        return nil;
    }
    
    unsigned char *buffer = (unsigned char *)[_data bytes];
    for (NSUInteger i = beginPos; i < dataLength; i++) {
        endPos = i;
        if (buffer[i] == BRLineReaderDelimiter) break;
    }
    
    // End of line found
    _lastRange = NSMakeRange(beginPos, endPos - beginPos + 1);
    NSData *lineData = [_data subdataWithRange:_lastRange];
    NSString *line = [[NSString alloc] initWithData:lineData encoding:_stringEncoding];
    _linesRead++;
    
    return line;
}

- (NSString *)readTrimmedLine
{
    return [[self readLine] stringByTrimmingCharactersInSet:_lineTrimCharacters];
}

- (void)setLineSearchPosition:(NSUInteger)position
{
    _lastRange = NSMakeRange(position, 0);
    _linesRead = 0;
}


@end
