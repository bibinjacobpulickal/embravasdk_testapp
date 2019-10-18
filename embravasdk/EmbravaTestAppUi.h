//
//  EmbravaTestAppUi.h
//  embravasdk
//
//  Created by Senthilnathan T on 29/08/17.
//  Copyright © 2017 Embrava. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@interface EmbravaTestAppUi : NSObject <NSWindowDelegate>
{
    int nNumberOfDevices;
    int nSelectedDeviceIndex;
    
    int nResult;
    
    Byte bySelectedMusic;
    Byte bySelectedFlashSpeed;
    Byte byVolumeLevel;
}

CWL_DECLARE_SINGLETON_FOR_CLASS (EmbravaTestAppUi);

@property (strong, nonatomic) IBOutlet NSComboBox *comboboxDeviceList;
@property (strong, nonatomic) IBOutlet NSButton *buttonUpdateDeviceList;
@property (strong, nonatomic) IBOutlet NSButton *buttonRed;
@property (strong, nonatomic) IBOutlet NSButton *buttonGreen;
@property (strong, nonatomic) IBOutlet NSButton *buttonBlue;
@property (strong, nonatomic) IBOutlet NSButton *buttonMagenta;
@property (strong, nonatomic) IBOutlet NSButton *buttonYellow;
@property (strong, nonatomic) IBOutlet NSButton *buttonWhite;
@property (strong, nonatomic) IBOutlet NSButton *buttonReset;
@property (strong, nonatomic) IBOutlet NSButton *buttonCyan;

@property (strong, nonatomic) IBOutlet NSBox *boxUiBlynclight1020;

@property (strong, nonatomic) IBOutlet NSButton *chkBoxDisplayLight;
@property (strong, nonatomic) IBOutlet NSButton *chkBoxDimLight;
@property (strong, nonatomic) IBOutlet NSButton *chkBoxFlashLight;
@property (strong, nonatomic) IBOutlet NSButton *chkBoxPlayMusic;
@property (strong, nonatomic) IBOutlet NSButton *chkBoxRepeatMusic;

@property (strong, nonatomic) IBOutlet NSTextField *txtRedLevel;
@property (strong, nonatomic) IBOutlet NSTextField *txtBlueLevel;
@property (strong, nonatomic) IBOutlet NSTextField *txtGreenLevel;

@property (strong, nonatomic) IBOutlet NSButton *buttonSetRgbLevels;
@property (strong, nonatomic) IBOutlet NSButton *buttonGetUid;

@property (strong, nonatomic) IBOutlet NSComboBox *cbFlashSpeed;

@property (strong, nonatomic) IBOutlet NSComboBox *cbMusicList;

@property (strong, nonatomic) IBOutlet NSSlider *sliderVolumeLevel;

@property (strong, nonatomic) IBOutlet NSBox *boxNamplateDisplayControl;
@property (strong, nonatomic) IBOutlet NSTextField *txtNamplateString;
@property (strong, nonatomic) IBOutlet NSButton *buttonDisplayText;
@property (strong, nonatomic) IBOutlet NSButton *buttonDisplayTextPixelControl;
@property (strong, nonatomic) IBOutlet NSButton *buttonClearDisplay;

-(void)Initialize;

-(IBAction)comboBoxDeviceList_SelectedIndexChanged:(id)sender;

-(IBAction)buttonUpdate_Clicked:(id)sender;

-(IBAction)buttonRed_Clicked:(id)sender;
-(IBAction)buttonGreen_Clicked:(id)sender;
-(IBAction)buttonBlue_Clicked:(id)sender;
-(IBAction)buttonMagenta_Clicked:(id)sender;
-(IBAction)buttonYellow_Clicked:(id)sender;
-(IBAction)buttonCyan_Clicked:(id)sender;
-(IBAction)buttonWhite_Clicked:(id)sender;
-(IBAction)buttonReset_Clicked:(id)sender;

-(IBAction)chkBoxDisplayLight_Clicked:(id)sender;
-(IBAction)chkBoxDimLight_Clicked:(id)sender;
-(IBAction)chkBoxFlashLight_Clicked:(id)sender;
-(IBAction)chkBoxPlayMusic_Clicked:(id)sender;
-(IBAction)chkBoxRepeatMusic_Clicked:(id)sender;
-(IBAction)buttonSetRgbLevels_Clicked:(id)sender;
-(IBAction)cbFlashSpeed_SelectedIndexChanged:(id)sender;
-(IBAction)cbMusicList_SelectedIndexChanged:(id)sender;
-(IBAction)sliderVolumeLevel_ValueChanged:(id)sender;
-(IBAction)buttonGetUid_Clicked:(id)sender;
-(IBAction)buttonDisplayText_Clicked:(id)sender;
-(IBAction)buttonDisplayTextPixelControl_Clicked:(id)sender;
-(IBAction)buttonClearDisplay_Clicked:(id)sender;


@end
