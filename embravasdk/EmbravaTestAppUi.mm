//
//  EmbravaTestAppUi.m
//  embravasdk
//
//  Created by Senthilnathan T on 29/08/17.
//  Copyright © 2017 Embrava. All rights reserved.
//

#import "EmbravaTestAppUi.h"
#import "blynclightcontrol.h"
#import "AlertPopup.h"

@implementation EmbravaTestAppUi

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS (EmbravaTestAppUi);

-(void)Initialize
{
    NSLog(@"Initialize Start");
    
    nNumberOfDevices = 0;
    
    bySelectedFlashSpeed = 1;
    bySelectedMusic = 1;
    byVolumeLevel = 5;
    
    [self initBlyncDevices];
    
    Byte abyCommandBuffer[32] = {0};
    Byte achCommandBuffer[64] = {0};
    
    abyCommandBuffer[0] = 8;
    abyCommandBuffer[31] = 0x45;
    
    
    for (int i = 0; i < 32; i++)
    {
        NSString* str = [NSString stringWithFormat:@"%02x", abyCommandBuffer[i]];
        
        int j = i * 2;
        
        achCommandBuffer[j] = [str characterAtIndex:0];
        achCommandBuffer[j + 1] = [str characterAtIndex:1];
    }
    
    NSString *nameString = @"Test String 123456789";
    
    //nameString = [nameString substringWithRange:NSMakeRange(0, 10)];
    
    NSData *asciiData = [nameString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    

    unsigned char *bytePtr = (unsigned char *)[asciiData bytes];
    
    Byte nameStringAscii[62] = {0};
    
    memcpy(nameStringAscii, bytePtr, [asciiData length]);
    
     NSLog(@"Initialize End");
}

void OnUsbHidDeviceHotPlug()
{
    [[EmbravaTestAppUi sharedEmbravaTestAppUi] initBlyncDevices];
}

void OnUsbHidDeviceHotUnPlug()
{
    [[EmbravaTestAppUi sharedEmbravaTestAppUi] initBlyncDevices];
}

-(void)initBlyncDevices
{
    @try {
        
        BOOL bStatus = FindDevices (&nNumberOfDevices);
        
        RegisterForOnUsbHidDeviceHotPlugCallBack(&OnUsbHidDeviceHotPlug);
        
        RegisterForOnUsbHidDeviceHotUnPlugCallBack(&OnUsbHidDeviceHotUnPlug);
        
        // Add device list to SFB device list
        [[self comboboxDeviceList] removeAllItems];
        [[self comboboxDeviceList] setStringValue:@""];
        
        [[self cbFlashSpeed] selectItemAtIndex:0];
        [[self txtRedLevel] setStringValue:@"255"];
        [[self txtGreenLevel] setStringValue:@"255"];
        [[self txtBlueLevel] setStringValue:@"255"];
        
        if (nNumberOfDevices <= 0)
        {
            [self DisableUIComponentsForBlyncUsb1020Devices];
            [self DisableUIComponentsForBlyncUsb30Devices];
            
            return;
        }
        
        [self DisableUIComponentsForBlyncUsb1020Devices];
        [self DisableUIComponentsForBlyncUsb30Devices];

        for (int i = 0; i < nNumberOfDevices; i++)
        {
            [[self comboboxDeviceList] addItemWithObjectValue:[self GetDeviceNameFromDeviceType:asDeviceInfo[i].byDeviceType]];
        }
        
        [[self comboboxDeviceList] selectItemAtIndex:0];
        [self comboBoxDeviceList_SelectedIndexChanged:[self comboboxDeviceList]];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)EnableUIComponentsForBlyncUsb1020Devices
{
    [[self buttonBlue] setEnabled:true];
    [[self buttonRed] setEnabled:true];
    [[self buttonGreen] setEnabled:true];
    [[self buttonYellow] setEnabled:true];
    [[self buttonMagenta] setEnabled:true];
    [[self buttonCyan] setEnabled:true];
    [[self buttonWhite] setEnabled:true];
    [[self buttonReset] setEnabled:true];
}

-(void)DisableUIComponentsForBlyncUsb1020Devices
{
//    [[self buttonBlue] setEnabled:false];
//    [[self buttonRed] setEnabled:false];
//    [[self buttonGreen] setEnabled:false];
//    [[self buttonYellow] setEnabled:false];
//    [[self buttonMagenta] setEnabled:false];
//    [[self buttonCyan] setEnabled:false];
//    [[self buttonWhite] setEnabled:false];
//    [[self buttonReset] setEnabled:false];
}

-(void)EnableUIComponentsForBlyncUsb30Devices
{
    if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V40S)
    {
        [[self chkBoxDisplayLight] setEnabled:true];
        [[self txtRedLevel] setEnabled:true];
        [[self txtGreenLevel] setEnabled:true];
        [[self txtBlueLevel] setEnabled:true];
        [[self chkBoxDimLight] setEnabled:true];
        [[self chkBoxFlashLight] setEnabled:true];
        [[self cbFlashSpeed] setEnabled:true];
        [[self chkBoxPlayMusic] setEnabled:true];
        [[self cbMusicList] setEnabled:true];
        [[self sliderVolumeLevel] setEnabled:true];
        [[self chkBoxRepeatMusic] setEnabled:true];
        [[self buttonSetRgbLevels] setEnabled:true];
        
        [[self txtNamplateString] setEnabled:false];
        [[self buttonDisplayText] setEnabled:false];
        [[self buttonDisplayTextPixelControl] setEnabled:false];
        [[self buttonClearDisplay] setEnabled:false];
        
        
    }
    else if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30 ||
             asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40 ||
             asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_NAMEDISPLAY_DEVICE ||
             asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_EMBRAVA_EMBEDDED_V30 ||
             asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA110 ||
             asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA120 ||
             asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA ||
             asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA210 ||
             asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA220)
    {
        [[self chkBoxDisplayLight] setEnabled:true];
        [[self txtRedLevel] setEnabled:true];
        [[self txtGreenLevel] setEnabled:true];
        [[self txtBlueLevel] setEnabled:true];
        [[self chkBoxDimLight] setEnabled:true];
        [[self chkBoxFlashLight] setEnabled:true];
        [[self cbFlashSpeed] setEnabled:true];
        [[self buttonSetRgbLevels] setEnabled:true];
        
        [[self chkBoxPlayMusic] setEnabled:false];
        [[self cbMusicList] setEnabled:false];
        [[self sliderVolumeLevel] setEnabled:false];
        [[self chkBoxRepeatMusic] setEnabled:false];
        
        if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_NAMEDISPLAY_DEVICE)
        {
            [[self txtNamplateString] setEnabled:true];
            [[self buttonDisplayText] setEnabled:true];
            [[self buttonDisplayTextPixelControl] setEnabled:true];
            [[self buttonClearDisplay] setEnabled:true];
        }
    }
}

-(void)DisableUIComponentsForBlyncUsb30Devices
{
    [[self chkBoxDisplayLight] setEnabled:false];
    [[self txtRedLevel] setEnabled:false];
    [[self txtGreenLevel] setEnabled:false];
    [[self txtBlueLevel] setEnabled:false];
    [[self chkBoxDimLight] setEnabled:false];
    [[self chkBoxFlashLight] setEnabled:false];
    [[self cbFlashSpeed] setEnabled:false];
    [[self chkBoxPlayMusic] setEnabled:false];
    [[self cbMusicList] setEnabled:false];
    [[self sliderVolumeLevel] setEnabled:false];
    [[self chkBoxRepeatMusic] setEnabled:false];
    [[self buttonSetRgbLevels] setEnabled:false];
    
    [[self txtNamplateString] setEnabled:false];
    [[self buttonDisplayText] setEnabled:false];
    [[self buttonDisplayTextPixelControl] setEnabled:false];
    [[self buttonClearDisplay] setEnabled:false];
}

-(IBAction)comboBoxDeviceList_SelectedIndexChanged:(id)sender
{
    if (nNumberOfDevices == 0)
    {
        return;
    }
    
    nSelectedDeviceIndex = [[self comboboxDeviceList] indexOfSelectedItem];
    
    if (nSelectedDeviceIndex >=0)
    {
        if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_TENX_10 ||
            asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_TENX_20)
        {
            [self EnableUIComponentsForBlyncUsb1020Devices];
            [self DisableUIComponentsForBlyncUsb30Devices];
        }
        else if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30S ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40S ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30 ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_NAMEDISPLAY_DEVICE ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40 ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA110 ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA120 ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V30S ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V40S ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_EMBRAVA_EMBEDDED_V30 ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA210 ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA220)
        {
            [self EnableUIComponentsForBlyncUsb30Devices];
            [self DisableUIComponentsForBlyncUsb1020Devices];
        }
        
    
        NSString *arrMusicListForBlyncUSB30S[10] = {
            @"Music 1", @"Music 2", @"Music 3", @"Music 4", @"Music 5",
            @"Music 6", @"Music 7", @"Music 8", @"Music 9", @"Music 10"};
        
        NSString *arrMusicListForBlyncMiniWireless[14] = {
            @"Music 1", @"Music 2", @"Music 3", @"Music 4", @"Music 5",
            @"Music 6", @"Music 7", @"Music 8", @"Music 9", @"Music 10",
            @"Music 11", @"Music 12", @"Music 13", @"Music 14"};
        
        [[self cbMusicList] removeAllItems];
        [[self cbMusicList] setStringValue:@""];
        
        if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30S ||
            asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40S)
        {
            for (int i = 0; i < 10; i++)
            {
                [[self cbMusicList] addItemWithObjectValue:arrMusicListForBlyncUSB30S[i]];
            }
            
            [[self cbMusicList] selectItemAtIndex:0];
        }
        else if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V30S ||
                 asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V40S)
        {
            for (int i = 0; i < 14; i++)
            {
                [[self cbMusicList] addItemWithObjectValue:arrMusicListForBlyncMiniWireless[i]];
            }
            
            [[self cbMusicList] selectItemAtIndex:0];
        }
    }
    
}

-(IBAction)buttonUpdate_Clicked:(id)sender
{
    [self initBlyncDevices];
}

-(IBAction)buttonRed_Clicked:(id)sender
{
    if (nNumberOfDevices == 0)
    {
        return;
    }
    
    TurnOnRedLight(nSelectedDeviceIndex);
}

-(IBAction)buttonGreen_Clicked:(id)sender
{
    if (nNumberOfDevices == 0)
    {
        return;
    }
    
    TurnOnGreenLight(nSelectedDeviceIndex);
}

-(IBAction)buttonBlue_Clicked:(id)sender
{
    if (nNumberOfDevices == 0)
    {
        return;
    }
    
    TurnOnBlueLight(nSelectedDeviceIndex);
}

-(IBAction)buttonMagenta_Clicked:(id)sender
{
    if (nNumberOfDevices == 0)
    {
        return;
    }
    
    TurnOnMagentaLight(nSelectedDeviceIndex);
}

-(IBAction)buttonYellow_Clicked:(id)sender
{
    if (nNumberOfDevices == 0)
    {
        return;
    }
    
    TurnOnYellowLight(nSelectedDeviceIndex);
}

-(IBAction)buttonCyan_Clicked:(id)sender
{
    if (nNumberOfDevices == 0)
    {
        return;
    }
    
    TurnOnCyanLight(nSelectedDeviceIndex);
}

-(IBAction)buttonWhite_Clicked:(id)sender
{
    if (nNumberOfDevices == 0)
    {
        return;
    }

    TurnOnWhiteLight(nSelectedDeviceIndex);
}

-(IBAction)buttonReset_Clicked:(id)sender
{
    if (nNumberOfDevices == 0)
    {
        return;
    }
    
    TurnOffLight(nSelectedDeviceIndex);
}

-(IBAction)chkBoxDisplayLight_Clicked:(id)sender
{
    int nState = [[self chkBoxDisplayLight] state];
    
    if (nState == 1)
    {
        [self SetRGBValues];
    }
    else
    {
        nResult = TurnOffLight(nSelectedDeviceIndex);
        
        if (nResult != 0)
        {
            [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"TurnOffLight failed."];
        }
    }
}

-(IBAction)chkBoxDimLight_Clicked:(id)sender
{
    int nState = [[self chkBoxDimLight] state];
    
    if (nState == 1)
    {
        nResult = SetLightDim(nSelectedDeviceIndex);
        
        if (nResult != 0)
        {
            [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"SetLightDim failed."];
        }
    }
    else
    {
        nResult = ClearLightDim(nSelectedDeviceIndex);
        
        if (nResult != 0)
        {
            [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"ClearLightDim failed."];
        }
    }
}

-(IBAction)chkBoxFlashLight_Clicked:(id)sender
{
    bySelectedFlashSpeed = [[self cbFlashSpeed] indexOfSelectedItem] + 1;
    
    if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30 ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40 ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_NAMEDISPLAY_DEVICE ||
    asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_EMBRAVA_EMBEDDED_V30 ||
    asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA110 ||
    asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA120 ||
    asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA ||
    asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V40S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S ||
    asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA210 ||
    asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA220)
    {
        if ([[self chkBoxFlashLight] state] == 1)
        {
            nResult = StartLightFlash(nSelectedDeviceIndex);
        
            if (nResult != 0)
            {
                [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"StartLightFlash failed."];
            }
            
            nResult = SelectLightFlashSpeed(nSelectedDeviceIndex, bySelectedFlashSpeed);
            
            if (nResult != 0)
            {
                [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"SelectLightFlashSpeed failed."];
            }
        }
        else
        {
            nResult = StopLightFlash(nSelectedDeviceIndex);
            
            if (nResult != 0)
            {
                [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"StopLightFlash failed."];
            }

        }
        
    }
}

-(IBAction)chkBoxPlayMusic_Clicked:(id)sender
{
    byVolumeLevel = [[self sliderVolumeLevel] intValue];
    
    if ([[self chkBoxPlayMusic] state] == 1)
    {
        StopMusicPlay(nSelectedDeviceIndex);
        
        SelectMusicToPlay(nSelectedDeviceIndex, bySelectedMusic);
        
        SetMusicVolume(nSelectedDeviceIndex, byVolumeLevel);
        
        if ([[self chkBoxRepeatMusic] state] == 1)
        {
            SetMusicRepeat(nSelectedDeviceIndex);
        }
        else
        {
            ClearMusicRepeat(nSelectedDeviceIndex);
        }
        
        usleep(300000);
        
        nResult = StartMusicPlay(nSelectedDeviceIndex);
        
        if (nResult != 0)
        {
            [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"StartMusicPlay failed."];
        }
    }
    else
    {
        nResult = StopMusicPlay(nSelectedDeviceIndex);
        
        if (nResult != 0)
        {
            [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"StopMusicPlay failed."];
        }
    }
}

-(IBAction)chkBoxRepeatMusic_Clicked:(id)sender
{
    if ([[self chkBoxRepeatMusic] state] == 1)
    {
        if ([[self chkBoxPlayMusic] state] == 1)
        {
            
            StopMusicPlay(nSelectedDeviceIndex);
            SelectMusicToPlay(nSelectedDeviceIndex, bySelectedMusic);
            SetMusicVolume(nSelectedDeviceIndex, byVolumeLevel);
            SetMusicRepeat(nSelectedDeviceIndex);
            usleep(300000);
            StartMusicPlay(nSelectedDeviceIndex);
        }
    }
    else
    {
        StopMusicPlay(nSelectedDeviceIndex);
        ClearMusicRepeat(nSelectedDeviceIndex);
        usleep(300000);
        StartMusicPlay(nSelectedDeviceIndex);
        StopMusicPlay(nSelectedDeviceIndex);
    }
}

-(IBAction)buttonSetRgbLevels_Clicked:(id)sender
{
    int nState = [[self chkBoxDisplayLight] state];
    
    if (nState == 1)
    {
        [self SetRGBValues];
    }
}

-(IBAction)cbFlashSpeed_SelectedIndexChanged:(id)sender
{
    bySelectedFlashSpeed = [[self cbFlashSpeed] indexOfSelectedItem] + 1;
    
    if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30 ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40 ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_NAMEDISPLAY_DEVICE ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_EMBRAVA_EMBEDDED_V30 ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA110 ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA120 ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V40S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA210 ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA220)
    {
        nResult = SelectLightFlashSpeed(nSelectedDeviceIndex, bySelectedFlashSpeed);
        
        if (nResult != 0)
        {
            [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"SelectLightFlashSpeed failed."];
        }
    }
}

-(IBAction)cbMusicList_SelectedIndexChanged:(id)sender
{
    bySelectedMusic = [[self cbMusicList] indexOfSelectedItem] + 1;
    
    if (asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V40S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S ||
        asDeviceInfo[nSelectedDeviceIndex].byDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S)
    {
        if ([[self chkBoxPlayMusic] state] == 1)
        {
            StopMusicPlay(nSelectedDeviceIndex);
            
            SelectMusicToPlay(nSelectedDeviceIndex, bySelectedMusic);
            
            if ([[self chkBoxRepeatMusic] state] == 1)
            {
                SetMusicRepeat(nSelectedDeviceIndex);
            }
            else
            {
                ClearMusicRepeat(nSelectedDeviceIndex);
            }
            
            usleep(500000);
            
            nResult = StartMusicPlay(nSelectedDeviceIndex);
        }
    }
}

-(IBAction)sliderVolumeLevel_ValueChanged:(id)sender
{
    byVolumeLevel = [[self sliderVolumeLevel] intValue];
    
    if ([[self chkBoxPlayMusic] state] == 1)
    {
        StopMusicPlay(nSelectedDeviceIndex);
        
        SelectMusicToPlay(nSelectedDeviceIndex, bySelectedMusic);
        
        SetMusicVolume(nSelectedDeviceIndex, byVolumeLevel);
        
        if ([[self chkBoxRepeatMusic] state] == 1)
        {
            SetMusicRepeat(nSelectedDeviceIndex);
        }
        else
        {
            ClearMusicRepeat(nSelectedDeviceIndex);
        }
        
        usleep(300000);
        
        nResult = StartMusicPlay(nSelectedDeviceIndex);
    }
}

-(IBAction)buttonGetUid_Clicked:(id)sender
{
    uint unDeviceId = 0;
    
    int nResult = GetDeviceUniqueId(nSelectedDeviceIndex, &unDeviceId);
    
    if (unDeviceId > 0)
    {
        NSString *resultString = [NSString stringWithFormat: @"Device UID: %u", unDeviceId];
        
        [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :resultString];
    }
    else
    {
        [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"Device doesn't support UID feature"];
    }
    
}

-(void)SetRGBValues
{
    Byte byRedLevel = 255;
    Byte byGreenLevel = 255;
    Byte byBlueLevel = 255;
    
    int value = [[[self txtRedLevel] stringValue] intValue];
    if (value > 255)
    {
        [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"Please enter the RGB values from 0 to 255."];
        
        return;
    }
    byRedLevel = (Byte)value;
    
    value = [[[self txtGreenLevel] stringValue] intValue];
    if (value > 255)
    {
        [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"Please enter the RGB values from 0 to 255."];
        
        return;
    }
    byGreenLevel = (Byte)value;
    
    value = [[[self txtBlueLevel] stringValue] intValue];
    if (value > 255)
    {
        [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"Please enter the RGB values from 0 to 255."];
        
        return;
    }
    byBlueLevel = (Byte)value;
    
    int nResult = TurnOnRGBLights(nSelectedDeviceIndex, byRedLevel, byGreenLevel, byBlueLevel);
    
    if (nResult != 0)
    {
        [[AlertPopup sharedAlertPopup] display:@"Embrava Test App" :@"TurnOnRGBLights failed."];
    }
    
}

-(NSString *)GetDeviceNameFromDeviceType:(Byte)byDeviceType
{
    NSString *deviceName = @"";
    
    switch (byDeviceType)
    {
        case DEVICETYPE_BLYNC_CHIPSET_TENX_10:
            deviceName = @"Blynclight Standard";
            break;
            
        case DEVICETYPE_BLYNC_CHIPSET_TENX_20:
            deviceName = @"Blynclight Standard";
            break;
            
        case DEVICETYPE_BLYNC_CHIPSET_V30:
            deviceName = @"Blynclight Standard";
            break;
            
        case DEVICETYPE_BLYNC_CHIPSET_V40:
            deviceName = @"Blynclight Standard";
            break;
            
        case DEVICETYPE_BLYNC_CHIPSET_V30S:
        case DEVICETYPE_BLYNC_CHIPSET_V40S:
            deviceName = @"Blynclight Plus";
            break;
            
        case DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA110:
            deviceName = @"Lumena 110";
            break;
            
        case DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S:
        case DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S:
            deviceName = @"Blynclight Wireless";
            break;
            
        case DEVICETYPE_BLYNC_MINI_CHIPSET_V30S:
        case DEVICETYPE_BLYNC_MINI_CHIPSET_V40S:
            deviceName = @"Blynclight Mini";
            break;
            
        case DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA120:
            deviceName = @"Lumena 120";
            break;
            
        case DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA:
            deviceName = @"Lumena";
            break;
            
        case DEVICETYPE_BLYNC_EMBRAVA_EMBEDDED_V30:
            deviceName = @"Embrava Embedded";
            break;
            
        case DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA210:
            deviceName = @"Lumena 210";
            break;
            
        case DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA220:
            deviceName = @"Lumena 220";
            break;
            
        case DEVICETYPE_BLYNC_NAMEDISPLAY_DEVICE:
            deviceName = @"Embrava Nameplate";
            break;
            
        default:
            break;
    }
    
    return deviceName;
}

-(void)ResetBlyncUSB1020Device:(int)nIndex
{
    TurnOffLight(nIndex);
}

-(void)ResetBlyncUSB30Device:(int)nIndex
{
    Byte byDetectedDeviceType = asDeviceInfo[nIndex].byDeviceType;
    
    // Clear Music
    if (byDetectedDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V30S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V40S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S)
    {
        StopMusicPlay(nIndex);
        ClearMusicRepeat(nIndex);
    }
    
    // Clear Light
    if (byDetectedDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30 ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40 ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_NAMEDISPLAY_DEVICE ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_CHIPSET_V30S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_CHIPSET_V40S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V30S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_MINI_CHIPSET_V40S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA110 ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA120 ||
        byDetectedDeviceType == DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA)
    {
        StopLightFlash(nIndex);
        ClearLightDim(nIndex);
        TurnOffLight(nIndex);
    }
}


-(IBAction)buttonDisplayText_Clicked:(id)sender
{
    NSString *value = [[self txtNamplateString] stringValue];
    
    DisplayTextOnNameDisplay(nSelectedDeviceIndex, value);
}

-(IBAction)buttonDisplayTextPixelControl_Clicked:(id)sender
{
    NSString *value = [[self txtNamplateString] stringValue];

    Byte byFontType = GetFontTypeFromFontDetails(FONT_CALIBRI, FONT_SIZE_18PT);
    DisplayTextOnNameDisplayUsingPixelControlNameAdjust(nSelectedDeviceIndex, value, byFontType);
}

-(IBAction)buttonClearDisplay_Clicked:(id)sender
{
    ClearTextOnNameDisplay(nSelectedDeviceIndex);
}

- (BOOL)windowShouldClose:(id)sender
{
    for (int i = 0; i < nNumberOfDevices; i++)
    {
        Byte byDetectedDeviceType = asDeviceInfo[i].byDeviceType;
        
        if (byDetectedDeviceType == DEVICETYPE_BLYNC_CHIPSET_TENX_10 ||
            byDetectedDeviceType == DEVICETYPE_BLYNC_CHIPSET_TENX_20)
        {
            [self ResetBlyncUSB1020Device:i];
        }
        else
        {
            [self ResetBlyncUSB30Device:i];
        }
    }
    
    ReleaseDevices();
    
    return YES;
}

@end
