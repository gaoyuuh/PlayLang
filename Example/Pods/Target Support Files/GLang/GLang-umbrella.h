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
#import "GAssignExpr.h"
#import "GAstHeader.h"
#import "GBinaryExpr.h"
#import "GBlock.h"
#import "GExprStatement.h"
#import "GForInStmt.h"
#import "GForStmt.h"
#import "GFuncCallExpr.h"
#import "GFuncDecl.h"
#import "GFuncSignature.h"
#import "GIfStatement.h"
#import "GIncOrDecExpr.h"
#import "GLiteral.h"
#import "GProgram.h"
#import "GReturnStmt.h"
#import "GScope.h"
#import "GType.h"
#import "GUnaryExpr.h"
#import "GVarDecl.h"
#import "GVarExpr.h"
#import "GCharStream.h"
#import "GLexHeader.h"
#import "GPosition.h"
#import "GToken.h"
#import "GTokenizer.h"
#import "GAstDumpVisitor.h"
#import "GAstVisitor.h"
#import "GEnterVisitor.h"
#import "GIntepretor.h"
#import "GLeftValueAttrVisitor.h"
#import "GParseError.h"
#import "GParser.h"
#import "GRefResolverVisitor.h"
#import "GSemanticAnalyer.h"
#import "GSemanticVisitor.h"
#import "GStackFrame.h"
#import "GFunctionSymbol.h"
#import "GSymbol.h"
#import "GVarSymbol.h"
#import "GMacroDefines.h"
#import "GVM.h"

FOUNDATION_EXPORT double GLangVersionNumber;
FOUNDATION_EXPORT const unsigned char GLangVersionString[];

