#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GDecl.h"
#import "GExpr.h"
#import "GNode.h"
#import "GStatement.h"
#import "GArrayLiteral.h"
#import "GAssignExpr.h"
#import "GAstHeader.h"
#import "GBinaryExpr.h"
#import "GBlock.h"
#import "GCallExpr.h"
#import "GClassDecl.h"
#import "GDoWhileExpr.h"
#import "GEnumDecl.h"
#import "GExprStatement.h"
#import "GForInStmt.h"
#import "GForStmt.h"
#import "GFuncDecl.h"
#import "GFuncParamDecl.h"
#import "GFuncType.h"
#import "GIfStatement.h"
#import "GIncOrDecExpr.h"
#import "GMemberAccess.h"
#import "GParenType.h"
#import "GPrimitiveType.h"
#import "GProgram.h"
#import "GPropDecl.h"
#import "GRefExpr.h"
#import "GRefType.h"
#import "GReturnStmt.h"
#import "GScope.h"
#import "GStructDecl.h"
#import "GThisType.h"
#import "GTypeNode.h"
#import "GUnaryExpr.h"
#import "GVarDecl.h"
#import "GVarStmt.h"
#import "GWhileExpr.h"
#import "GCharStream.h"
#import "GLexHeader.h"
#import "GPosition.h"
#import "GToken.h"
#import "GTokenizer.h"
#import "GParseError.h"
#import "GParser.h"
#import "GFunctionSymbol.h"
#import "GSymbol.h"
#import "GVarSymbol.h"
#import "GMacroDefines.h"
#import "GVM.h"

FOUNDATION_EXPORT double GLangVersionNumber;
FOUNDATION_EXPORT const unsigned char GLangVersionString[];

