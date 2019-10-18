//
//  AppDelegate.h
//  embravasdk
//
//  Created by Senthilnathan T on 28/08/17.
//  Copyright © 2017 Embrava. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CWLSynthesizeSingleton.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

CWL_DECLARE_SINGLETON_FOR_CLASS (AppDelegate);

@property (strong) id activity;


@end

