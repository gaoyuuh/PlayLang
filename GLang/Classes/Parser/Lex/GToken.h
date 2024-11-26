//
//  GToken.h
//  GLang
//
//  Created by gaoyu on 2024/7/22.
//

#import <Foundation/Foundation.h>
#import "GPosition.h"

typedef NS_ENUM(int, GTokenKind) {
    GTokenKindIdentifier = 1,
    GTokenKindKeyword,
    GTokenKindIntegerLiteral,
    GTokenKindFloatLiteral,
    GTokenKindBooleanLiteral,
    GTokenKindStringLiteral,
    /// .
    GTokenKindDot,
    /// ,
    GTokenKindComma,
    /// (
    GTokenKindLParen,
    /// )
    GTokenKindRParen,
    /// [
    GTokenKindLBracket,
    /// ]
    GTokenKindRBracket,
    /// {
    GTokenKindLBrace,
    /// }
    GTokenKindRBrace,
    /// :
    GTokenKindColon,
    /// ;
    GTokenKindSemiColon,
    /// ++
    GTokenKindIncrement,
    /// --
    GTokenKindDecrement,
    /// !
    GTokenKindNot,
    /// -
    GTokenKindSub,
    /// *
    GTokenKindMultiply,
    /// /
    GTokenKindDivide,
    /// %
    GTokenKindModulus,
    /// +
    GTokenKindAdd,
    /// <<
    GTokenKindLShift,
    /// >>
    GTokenKindRShift,
    /// <
    GTokenKindLT,
    /// <=
    GTokenKindLE,
    /// >
    GTokenKindGT,
    /// >=
    GTokenKindGE,
    /// ==
    GTokenKindEQ,
    /// !=
    GTokenKindNotEQ,
    /// &
    GTokenKindBitAnd,
    /// ^
    GTokenKindBitXor,
    /// |
    GTokenKindBitOr,
    /// &&
    GTokenKindAND,
    /// ||
    GTokenKindOR,
    /// =
    GTokenKindAssign,
    /// *=
    GTokenKindMultiplyAssign,
    /// /=
    GTokenKindDivideAssign,
    /// %=
    GTokenKindModulusAssign,
    /// +=
    GTokenKindAddAssign,
    /// -=
    GTokenKindSubAssign,
    /// <<=
    GTokenKindLShiftAssign,
    /// >>=
    GTokenKindRShiftAssign,
    /// &=
    GTokenKindBitAndAssign,
    /// ^=
    GTokenKindBitXorAssign,
    /// |=
    GTokenKindBitOrAssign,
    /// Int
    GTokenKindInt,
    /// Int64
    GTokenKindInt64,
    /// Float
    GTokenKindFloat,
    /// Bool
    GTokenKindBool,
    /// true
    GTokenKindTrue,
    /// false
    GTokenKindFalse,
    /// String
    GTokenKindString,
    /// Array
    GTokenKindArray,
    /// Dict
    GTokenKindDict,
    /// Any
    GTokenKindAny,
    /// var
    GTokenKindVar,
    /// let
    GTokenKindLet,
    /// if
    GTokenKindIf,
    /// else
    GTokenKindElse,
    /// while
    GTokenKindWhile,
    /// for
    GTokenKindFor,
    /// break
    GTokenKindBreak,
    /// continue
    GTokenKindContinue,
    /// switch
    GTokenKindSwitch,
    /// case
    GTokenKindCase,
    /// default
    GTokenKindDefault,
    /// class
    GTokenKindClass,
    /// func
    GTokenKindFunc,
    /// return
    GTokenKindReturn,
    /// self
    GTokenKindSelf,
    /// super
    GTokenKindSuper,
    /// new
    GTokenKindNew,
    /// null
    GTokenKindNull,
    /// printf
    GTokenKindPrintf,
    /// NSLog
    GTokenKindNSLog,
    /// 非法的
    GTokenKindILLEGAL,
    /// 结束符
    GTokenKindEOF,
};

@interface GToken : NSObject

/// token类型
@property (nonatomic, assign) GTokenKind kind;
/// token值
@property (nonatomic, strong) NSString * value;
/// token位置信息
@property (nonatomic, strong) GPosition * position;

+ (instancetype)tokenKind:(GTokenKind)kind value:(NSString *)value;
+ (instancetype)tokenKind:(GTokenKind)kind value:(NSString *)value pos:(GPosition *)pos;

- (BOOL)isTypeAnnotation;

- (BOOL)isOperation;

+ (BOOL)isAssignOp:(GTokenKind)op;

@end
