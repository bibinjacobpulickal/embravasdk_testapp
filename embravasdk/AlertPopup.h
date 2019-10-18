//
//  AlertPopup.h
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import <AppKit/NSAlert.h>

@interface AlertPopup : NSObject
{
    int nResult;
}

CWL_DECLARE_SINGLETON_FOR_CLASS (AlertPopup);

-(int)display:(NSString *)messageText :(NSString *)informativeText;

@end
