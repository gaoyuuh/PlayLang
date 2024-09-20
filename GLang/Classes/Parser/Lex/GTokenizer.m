//
//  GTokenizer.m
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import "GTokenizer.h"
#import "GToken.h"
#import "GCharStream.h"
#import "GMacroDefines.h"

@interface GTokenizer ()

@property (nonatomic, strong) GCharStream * charStream;
@property (nonatomic, strong) NSMutableArray<GToken *> * aryPeekToken;
@property (nonatomic, strong) GPosition * lastPos;
@property (nonatomic, strong) NSDictionary * dicKeyword;

@end

@implementation GTokenizer

+ (NSArray<GToken *> *)lexWithCode:(NSString *)code {
    NSMutableArray *tokens = [NSMutableArray array];
    GTokenizer *tokenizer = [GTokenizer tokenizerWithCode:code];
    while ([tokenizer peek].kind != GTokenKindEOF) {
        GToken *token = [tokenizer next];
        if (token) {
            [tokens addObject:token];
        }
    }
    return tokens.copy;
}

+ (instancetype)tokenizerWithCode:(NSString *)code {
    GTokenizer *tokenizer = [[GTokenizer alloc] init];
    tokenizer.charStream = [GCharStream streamWithCode:code];
    return tokenizer;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (GToken *)peek {
    GToken *token = self.aryPeekToken.firstObject;
    if (!token) {
        token = [self getAToken];
        if (token) {
            [self.aryPeekToken addObject:token];
        }
    }
    return token;
}

- (GToken *)peek2 {
    GToken *token = nil;
    if (self.aryPeekToken.count > 1) {
        token = self.aryPeekToken[1];
    }
    while (token == nil) {
        GToken *token1 = [self getAToken];
        if (token1) {
            [self.aryPeekToken addObject:token1];
        }
        if (self.aryPeekToken.count > 1) {
            token = self.aryPeekToken[1];
        }
    }
    return token;
}

- (GToken *)next {
    GToken *token = self.aryPeekToken.firstObject;
    if (self.aryPeekToken.count) {
        [self.aryPeekToken removeObjectAtIndex:0];
    }
    if (!token) {
        token = [self getAToken];
    }
    self.lastPos = token.position;
    return token;
}

- (GPosition *)getNextPos {
    return [self peek].position;
}

- (GPosition *)getLastPos {
    return self.lastPos;
}

- (GToken *)getAToken {
    [self skipWhiteSpaces];
    GPosition *pos = [self.charStream position];
    if ([self.charStream eof]) {
        return [GToken tokenKind:GTokenKindEOF value:@"EOF" pos:pos];
    }
    
    unichar ch = [self.charStream peek];
    // 标识符
    if ([self isAlpha:ch] || ch == '_') {
        return [self parseIdentifier];
    }
    // 字符串
    if (ch == '"') {
        return [self parseStringLiteral];
    }
    // 数字
    if ([self isDecimalDigit:ch]) {
        return [self parseNumberLiteral];
    }
    // 小数点开头的浮点数
    if (ch == '.') {
        unichar ch1 = [self.charStream peek2];
        if ([self isDecimalDigit:ch1]) {
            [self.charStream next];
            return [self parseFloatLiteral];
        }
    }
    // 注释
    if (ch == '/') {
        unichar ch1 = [self.charStream peek2];
        if (ch1 == '/') {
            [self.charStream next];
            [self skipSingleLineComment];
            return [self getAToken];
        } else if (ch1 == '*') {
            [self.charStream next];
            [self skipMultipleLineComment];
            return [self getAToken];
        }
    }
    // 操作符、分隔符
    return [self parseOperatorAndSeparator];
}

/// 解析标识符
- (GToken *)parseIdentifier {
    GToken *token = [GToken tokenKind:GTokenKindIdentifier 
                                value:@""
                                  pos:[self.charStream position]];
    unichar ch0 = [self.charStream next];
    NSMutableString *content = [[NSMutableString alloc] initWithFormat:@"%C", ch0];
    while (![self.charStream eof] &&
           [self isRemainIdentifier]) {
        [content appendString:_S(@"%C", self.charStream.next)];
    }
    token.value = content;
    token.position.end = self.charStream.pos + 1;
    
    // 识别关键词
    if (self.dicKeyword[token.value]) {
        token.kind = [self.dicKeyword[token.value] intValue];
    }
    
    return token;
}

/// 解析字符串
- (GToken *)parseStringLiteral {
    GToken *token = [GToken tokenKind:GTokenKindStringLiteral
                                value:@""
                                  pos:[self.charStream position]];
    [self.charStream next];
    NSMutableString *content = [[NSMutableString alloc] initWithString:@""];
    while (![self.charStream eof] &&
           [self.charStream peek] != '"' &&
           [self.charStream peek] != '\n') {
        unichar ch = [self.charStream peek];
        if (ch == '\\') {
            [self.charStream next];
            if (![self.charStream eof]) {
                unichar ch1 = [self.charStream peek];
                unichar transChar = ch1;
                switch (ch1) {
                    case 'r':   transChar='\r';     break;
                    case 'n':   transChar='\n';     break;
                    case 't':   transChar='\t';     break;
                    case '"':   transChar='"';      break;
                    case '\'':   transChar='\'';    break;
                    case '0':   transChar='\0';     break;
                    case 'a':   transChar='\a';     break;
                    case 'b':   transChar='\b';     break;
                    case 'f':   transChar='\f';     break;
                    case 'v':   transChar='\v';     break;
                    case 'u': {
                        [self.charStream next];
                        NSString *str = [self.charStream peekToCount:4];
                        BOOL interrupt = NO;
                        for (int i = 0; i < str.length; i++) {
                            unichar ch = [str characterAtIndex:i];
                            if (![self isDecimalDigit:ch] && ![self isAlpha:ch]) {
                                interrupt = YES;
                                break;
                            }
                        }
                        if (!interrupt) interrupt = str.length < 4;
                        NSAssert2(interrupt == NO, @"\\u used with no following hex digits line:%ld, col:%ld", self.charStream.line, self.charStream.column);
                        if (!interrupt) {
                            for (int i = 0; i < str.length; i++) {
                                [self.charStream next];
                            }
                            NSString *unicodeStr = [self strFromUnicodeStr:str];
                            NSAssert2(unicodeStr.length, @"\\u Invalid universal character line:%ld col:%ld", self.charStream.line, self.charStream.column);
                            if (unicodeStr) {
                                [content appendString:unicodeStr];
                            }
                        }
                        continue;
                    } break;
                    case 'U': {
                        [self.charStream next];
                        NSString *str = [self.charStream peekToCount:8];
                        BOOL interrupt = NO;
                        for (int i = 0; i < str.length; i++) {
                            unichar ch = [str characterAtIndex:i];
                            if (![self isDecimalDigit:ch] && ![self isAlpha:ch]) {
                                interrupt = YES;
                                break;
                            }
                        }
                        if (!interrupt) interrupt = str.length < 8;
                        NSAssert2(interrupt == NO, @"\\U used with no following hex digits line:%ld, col:%ld", self.charStream.line, self.charStream.column);
                        if (!interrupt) {
                            for (int i = 0; i < str.length; i++) {
                                [self.charStream next];
                            }
                            NSString *unicodeStr = [self strFromUnicodeStr:str];
                            NSAssert2(unicodeStr.length, @"\\U Invalid universal character line:%ld col:%ld", self.charStream.line, self.charStream.column);
                            if (unicodeStr) {
                                [content appendString:unicodeStr];
                            }
                        }
                        continue;
                    } break;
                    case 'x': {
                        [self.charStream next];
                        NSString *str = [self.charStream peekToCount:2];
                        BOOL interrupt = NO;
                        for (int i = 0; i < str.length; i++) {
                            unichar ch = [str characterAtIndex:i];
                            if (![self isDecimalDigit:ch] && ![self isAlpha:ch]) {
                                interrupt = YES;
                                break;
                            }
                        }
                        if (!interrupt) interrupt = str.length < 2;
                        NSAssert2(interrupt == NO, @"\\x used with no following hex digits line:%ld, col:%ld", self.charStream.line, self.charStream.column);
                        if (!interrupt) {
                            for (int i = 0; i < str.length; i++) {
                                [self.charStream next];
                            }
                            NSString *unicodeStr = [self strFromHexStr:str];
                            NSAssert2(unicodeStr.length, @"\\x Invalid universal character line:%ld col:%ld", self.charStream.line, self.charStream.column);
                            if (unicodeStr) {
                                [content appendString:unicodeStr];
                            }
                        }
                        continue;
                    } break;
                    default:
                        [content appendString:@"\\"];
                        break;
                }
                [self.charStream next];
                [content appendString:_S(@"%C", transChar)];
            } else {
                [content appendString:@"\\"];
            }
        } else {
            [self.charStream next];
            [content appendString:_S(@"%C", ch)];
        }
    }
    token.value = content;
    NSAssert2([self.charStream peek] == '"', @"Expecting an \" at line: %ld  col: %ld", self.charStream.line, self.charStream.column);
    // 跳过末尾的'"'
    [self.charStream next];
    token.position.end += 1;
    return token;
}

/// 解析数字
- (GToken *)parseNumberLiteral {
    GPosition *position = self.charStream.position;
    unichar ch = [self.charStream peek];
    [self.charStream next];
    unichar ch1 = [self.charStream peek];
    if (ch == '0') {
        NSAssert2(ch1 == 'x' || ch1 == 'X' || ch1 == '.', @"parseNumberLiteral error line:%ld, col:%ld", self.charStream.line, self.charStream.column);
        NSMutableString *content = [[NSMutableString alloc] initWithString:_S(@"0%C", ch1)];
        [self.charStream next];
        while ([self isDecimalDigit:[self.charStream peek]]) {
            [content appendString:_S(@"%C", [self.charStream next])];
        }
        position.end = self.charStream.pos + 1;
        GTokenKind kind = GTokenKindIntegerLiteral;
        if (ch1 == '.') {
            kind = GTokenKindFloatLiteral;
        }
        GToken *token = [GToken tokenKind:kind value:content pos:position];
        return token;
    } else {
        NSMutableString *content = [[NSMutableString alloc] initWithString:_S(@"%C", ch)];
        while ([self isDecimalDigit:[self.charStream peek]]) {
            [content appendString:_S(@"%C", [self.charStream next])];
        }
        if ([self.charStream peek] == '.') {
            [content appendString:_S(@"%C", [self.charStream next])];
            while ([self isDecimalDigit:[self.charStream peek]]) {
                [content appendString:_S(@"%C", [self.charStream next])];
            }
            position.end = self.charStream.pos + 1;
            return [GToken tokenKind:GTokenKindFloatLiteral value:content pos:position];
        } else {
            position.end = self.charStream.pos + 1;
            return [GToken tokenKind:GTokenKindIntegerLiteral value:content pos:position];
        }
    }
    
    return [GToken tokenKind:GTokenKindILLEGAL value:@"" pos:position];
}

/// 解析浮点数，以.开头的 ".100"
- (GToken *)parseFloatLiteral {
    GPosition *position = [self.charStream position];
    NSMutableString *content = [[NSMutableString alloc] initWithString:@"."];
    while ([self isDecimalDigit:[self.charStream peek]]) {
        [content appendString:_S(@"%C", [self.charStream next])];
    }
    position.end = self.charStream.pos + 1;
    GToken *token = [GToken tokenKind:GTokenKindFloatLiteral value:content pos:position];
    return token;
}

/// 解析操作符及分隔符
- (GToken *)parseOperatorAndSeparator {
    unichar ch = [self.charStream peek];
    GPosition *position = [self.charStream position];
    GTokenKind kind = GTokenKindILLEGAL;
    switch (ch) {
        case '.':
            [self.charStream next];
            kind = GTokenKindDot;
            break;
        case ',':
            [self.charStream next];
            kind = GTokenKindComma;
            break;
        case '(':
            [self.charStream next];
            kind = GTokenKindLParen;
            break;
        case ')':
            [self.charStream next];
            kind = GTokenKindRParen;
            break;
        case '[':
            [self.charStream next];
            kind = GTokenKindLBracket;
            break;
        case ']':
            [self.charStream next];
            kind = GTokenKindRBracket;
            break;
        case '{':
            [self.charStream next];
            kind = GTokenKindLBrace;
            break;
        case '}':
            [self.charStream next];
            kind = GTokenKindRBrace;
            break;
        case ':':
            [self.charStream next];
            kind = GTokenKindColon;
            break;
        case ';':
            [self.charStream next];
            kind = GTokenKindSemiColon;
            break;
        case '+': {
            [self.charStream next];
            unichar ch1 = [self.charStream peek];
            if (ch1 == '+') {
                [self.charStream next];
                kind = GTokenKindIncrement;
            } else if (ch1 == '=') {
                [self.charStream next];
                kind = GTokenKindAddAssign;
            } else {
                kind = GTokenKindAdd;
            }
        } break;
        case '-': {
            [self.charStream next];
            unichar ch1 = [self.charStream peek];
            if (ch1 == '-') {
                [self.charStream next];
                kind = GTokenKindDecrement;
            } else if (ch1 == '=') {
                [self.charStream next];
                kind = GTokenKindSubAssign;
            } else {
                kind = GTokenKindSub;
            }
        } break;
        case '!': {
            [self.charStream next];
            if ([self.charStream peek] == '=') {
                [self.charStream next];
                kind = GTokenKindNotEQ;
            } else {
                kind = GTokenKindNot;
            }
        } break;
        case '*': {
            [self.charStream next];
            if ([self.charStream peek] == '=') {
                [self.charStream next];
                kind = GTokenKindMultiplyAssign;
            } else {
                kind = GTokenKindMultiply;
            }
        } break;
        case '/': {
            [self.charStream next];
            if ([self.charStream peek] == '=') {
                [self.charStream next];
                kind = GTokenKindDivideAssign;
            } else {
                kind = GTokenKindDivide;
            }
        } break;
        case '%': {
            [self.charStream next];
            if ([self.charStream peek] == '=') {
                [self.charStream next];
                kind = GTokenKindModulusAssign;
            } else {
                kind = GTokenKindModulus;
            }
        } break;
        case '<': {
            [self.charStream next];
            unichar ch1 = [self.charStream peek];
            if (ch1 == '<') {
                [self.charStream next];
                unichar ch2 = [self.charStream peek];
                if (ch2 == '=') {
                    [self.charStream next];
                    kind = GTokenKindLShiftAssign;
                } else {
                    kind = GTokenKindLShift;
                }
            } else if (ch1 == '=') {
                [self.charStream next];
                kind = GTokenKindLE;
            } else {
                kind = GTokenKindLT;
            }
        } break;
        case '>': {
            [self.charStream next];
            unichar ch1 = [self.charStream peek];
            if (ch1 == '>') {
                [self.charStream next];
                unichar ch2 = [self.charStream peek];
                if (ch2 == '=') {
                    [self.charStream next];
                    kind = GTokenKindRShiftAssign;
                } else {
                    kind = GTokenKindRShift;
                }
            } else if (ch1 == '=') {
                [self.charStream next];
                kind = GTokenKindGE;
            } else {
                kind = GTokenKindGT;
            }
        } break;
        case '=': {
            [self.charStream next];
            if ([self.charStream peek] == '=') {
                [self.charStream next];
                kind = GTokenKindEQ;
            } else {
                kind = GTokenKindAssign;
            }
        } break;
        case '&': {
            [self.charStream next];
            unichar ch1 = [self.charStream peek];
            if (ch1 == '&') {
                [self.charStream next];
                kind = GTokenKindAND;
            } else if (ch1 == '=') {
                [self.charStream next];
                kind = GTokenKindBitAndAssign;
            } else {
                kind = GTokenKindBitAnd;
            }
        } break;
        case '^': {
            [self.charStream next];
            unichar ch1 = [self.charStream peek];
            if (ch1 == '=') {
                [self.charStream next];
                kind = GTokenKindBitXorAssign;
            } else {
                kind = GTokenKindBitXor;
            }
        } break;
        case '|': {
            [self.charStream next];
            unichar ch1 = [self.charStream peek];
            if (ch1 == '|') {
                [self.charStream next];
                kind = GTokenKindOR;
            } else if (ch1 == '=') {
                [self.charStream next];
                kind = GTokenKindBitOrAssign;
            } else {
                kind = GTokenKindBitOr;
            }
        } break;
            
        default:
            break;
    }
    NSString *value = [self tokenValueWithKind:kind];
    position.end += value.length;
    return [GToken tokenKind:kind value:value pos:position];
}

- (void)skipWhiteSpaces {
    while (![self.charStream eof] &&
           isspace([self.charStream peek])) {
        [self.charStream next];
    }
}

/// 跳过单行注释
- (void)skipSingleLineComment {
    [self.charStream next];
    while (![self.charStream eof] && [self.charStream peek] != '\n') {
        [self.charStream next];
    }
}

/// 跳过多行注释
- (void)skipMultipleLineComment {
    [self.charStream next];
    NSAssert2(![self.charStream eof], @"Failed to find matching */ for multiple line comments at line: %ld  col: %ld", self.charStream.line, self.charStream.column);
    unichar ch1 = [self.charStream next];
    while (![self.charStream eof]) {
        unichar ch2 = [self.charStream next];
        if (ch1 == '*' && ch2 == '/') {
            return;
        }
        ch1 = ch2;
    }
}

- (NSString *)strFromUnicodeStr:(NSString *)unicodeStr {
    NSScanner* scanner = [NSScanner scannerWithString:unicodeStr];
    UInt64 hex ;
    [scanner scanHexLongLong:&hex];
    unsigned int unicodeValue = (unsigned int) hex;
    NSString *s = [[NSString alloc] initWithBytes:&unicodeValue length:sizeof(unicodeValue) encoding:NSUTF32LittleEndianStringEncoding];
    return s;
}

- (NSString *)strFromHexStr:(NSString *)hexStr {
    NSScanner* scanner = [NSScanner scannerWithString:hexStr];
    UInt64 hex ;
    [scanner scanHexLongLong:&hex];
    return _S(@"%C", (unichar)hex);
}

- (BOOL)isRemainIdentifier {
    unichar ch = self.charStream.peek;
    return ([self isAlpha:ch] || [self isDecimalDigit:ch] || ch == '_');
}

- (BOOL)isAlpha:(unichar)ch {
    return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z');
}

- (BOOL)isDecimalDigit:(unichar)ch {
    return (ch >= '0' && ch <= '9');
}

- (NSMutableArray<GToken *> *)aryPeekToken {
    if (!_aryPeekToken) {
        _aryPeekToken = [NSMutableArray array];
    }
    return _aryPeekToken;
}

- (NSDictionary *)dicKeyword {
    if (!_dicKeyword) {
        _dicKeyword = @{
            @"Int": @(GTokenKindInt),
            @"Int64": @(GTokenKindInt64),
            @"Float": @(GTokenKindFloat),
            @"Bool": @(GTokenKindBool),
            @"String": @(GTokenKindString),
            @"Array": @(GTokenKindArray),
            @"Dict": @(GTokenKindDict),
            @"Id": @(GTokenKindId),
            @"var": @(GTokenKindVar),
            @"let": @(GTokenKindLet),
            @"if": @(GTokenKindIf),
            @"else": @(GTokenKindElse),
            @"while": @(GTokenKindWhile),
            @"for": @(GTokenKindFor),
            @"break": @(GTokenKindBreak),
            @"continue": @(GTokenKindContinue),
            @"switch": @(GTokenKindSwitch),
            @"case": @(GTokenKindCase),
            @"default": @(GTokenKindDefault),
            @"class": @(GTokenKindClass),
            @"func": @(GTokenKindFunc),
            @"return": @(GTokenKindReturn),
            @"self": @(GTokenKindSelf),
            @"super": @(GTokenKindSuper),
            @"new": @(GTokenKindNew),
            @"null": @(GTokenKindNull),
            @"printf": @(GTokenKindPrintf),
            @"NSLog": @(GTokenKindNSLog),
            @"true": @(GTokenKindTrue),
            @"false": @(GTokenKindFalse),
        };
    }
    return _dicKeyword;
}

- (NSString *)tokenValueWithKind:(GTokenKind)kind {
    NSString *value = @"";
    switch (kind) {
        case GTokenKindDot: return @".";
        case GTokenKindComma: return @",";
        case GTokenKindLParen: return @"(";
        case GTokenKindRParen: return @")";
        case GTokenKindLBracket: return @"[";
        case GTokenKindRBracket: return @"]";
        case GTokenKindLBrace: return @"{";
        case GTokenKindRBrace: return @"}";
        case GTokenKindColon: return @":";
        case GTokenKindSemiColon: return @";";
        case GTokenKindIncrement: return @"++";
        case GTokenKindDecrement: return @"--";
        case GTokenKindNot: return @"!";
        case GTokenKindSub: return @"-";
        case GTokenKindMultiply: return @"*";
        case GTokenKindDivide: return @"/";
        case GTokenKindModulus: return @"%";
        case GTokenKindAdd: return @"+";
        case GTokenKindLShift: return @"<<";
        case GTokenKindRShift: return @">>";
        case GTokenKindLT: return @"<";
        case GTokenKindLE: return @"<=";
        case GTokenKindGT: return @">";
        case GTokenKindGE: return @">=";
        case GTokenKindEQ: return @"==";
        case GTokenKindNotEQ: return @"!=";
        case GTokenKindBitAnd: return @"&";
        case GTokenKindBitXor: return @"^";
        case GTokenKindBitOr: return @"|";
        case GTokenKindAND: return @"&&";
        case GTokenKindOR: return @"||";
        case GTokenKindAssign: return @"=";
        case GTokenKindMultiplyAssign: return @"*=";
        case GTokenKindDivideAssign: return @"/=";
        case GTokenKindModulusAssign: return @"%=";
        case GTokenKindAddAssign: return @"+=";
        case GTokenKindSubAssign: return @"-=";
        case GTokenKindLShiftAssign: return @"<<=";
        case GTokenKindRShiftAssign: return @">>=";
        case GTokenKindBitAndAssign: return @"&=";
        case GTokenKindBitXorAssign: return @"^=";
        case GTokenKindBitOrAssign: return @"|=";
        default:
            break;
    }
    return value;
}

@end
