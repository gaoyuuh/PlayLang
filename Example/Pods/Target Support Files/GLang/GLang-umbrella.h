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

#import "GParser.h"
#import "GPosition.h"
#import "GToken.h"
#import "GTokenizer.h"
#import "GVM.h"

FOUNDATION_EXPORT double GLangVersionNumber;
FOUNDATION_EXPORT const unsigned char GLangVersionString[];
