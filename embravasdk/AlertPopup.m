//
//  AlertPopup.m
//

#import "AlertPopup.h"

@implementation AlertPopup

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS (AlertPopup);

-(int)display:(NSString *)messageText :(NSString *)informativeText
{
    [self performSelectorOnMainThread:@selector(displayAlert:) withObject:@[messageText, informativeText] waitUntilDone:YES];    
    
    return nResult;
}

-(void)displayAlert:(NSArray*)array
{
    NSString *messageText = (NSString *)[array objectAtIndex:0];
    NSString *informativeText = (NSString *)[array objectAtIndex:1];

	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle: @"OK"];
	[alert setMessageText: messageText];
	[alert setInformativeText: informativeText];
	[alert setAlertStyle: NSInformationalAlertStyle];	
	nResult = (int)[alert runModal];
}

@end
