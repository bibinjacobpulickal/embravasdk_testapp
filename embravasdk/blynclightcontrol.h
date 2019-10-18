//
//  blynclightcontrol.h
//  blynclightcontrol
//
//  Created by Senthilnathan T on 29/08/17.
//  Copyright © 2017 Embrava. All rights reserved.
//
//

#ifndef Blync_Light_Control_h
#define Blync_Light_Control_h

#include <CoreFoundation/CFBase.h>
#include <IOKit/hid/IOHIDManager.h>
#include <unistd.h>
#include <pthread.h>

#define MAXIMUM_DEVICES                                         5

#define DEVICE_TYPE_INVALID                                     0
#define DEVICETYPE_BLYNC_CHIPSET_TENX_10                        1
#define DEVICETYPE_BLYNC_CHIPSET_TENX_20                        2
#define DEVICETYPE_BLYNC_CHIPSET_V30                            3
#define DEVICETYPE_BLYNC_CHIPSET_V30S                           4
#define DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA110          5
#define DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V30S                  6
#define DEVICETYPE_BLYNC_MINI_CHIPSET_V30S                      7
#define DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA120          8
#define DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA             9
#define DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA210          10
#define DEVICETYPE_BLYNC_HEADSET_CHIPSET_V30_LUMENA220          11
#define DEVICETYPE_BLYNC_EMBRAVA_EMBEDDED_V30                   12
#define DEVICETYPE_BLYNC_MINI_CHIPSET_V40S                      13
#define DEVICETYPE_BLYNC_WIRELESS_CHIPSET_V40S                  14
#define DEVICETYPE_BLYNC_CHIPSET_V40                            15
#define DEVICETYPE_BLYNC_CHIPSET_V40S                           16
#define DEVICETYPE_BLYNC_NAMEDISPLAY_DEVICE                     17


enum BlyncColors
{
    Red = 0,
    Green,
    Yellow,
    Purple,
    Cyan,
    Blue,
    White,
    Orange,
    Off
};

enum FontType
{
    FONT_TYPE_CALIBRI_8PT = 1,
    FONT_TYPE_CALIBRI_9PT,
    FONT_TYPE_CALIBRI_10PT,
    FONT_TYPE_CALIBRI_12PT,
    FONT_TYPE_CALIBRI_16PT,
    FONT_TYPE_CALIBRI_18PT,
    FONT_TYPE_CALIBRI_20PT,
    FONT_TYPE_CALIBRI_BOLD_12PT,
    FONT_TYPE_LUCIDA_CONSOLE_18PT,
    FONT_TYPE_CONSOLAS_20PT,
    FONT_TYPE_ARIALNARROW_20PT,
    FONT_TYPE_TIMES_NEW_ROMAN_6PT,
    FONT_TYPE_TIMES_NEW_ROMAN_8PT,
    FONT_TYPE_TIMES_NEW_ROMAN_16PT,
    FONT_TYPE_TIMES_NEW_ROMAN_18PT,
    FONT_TYPE_TIMES_NEW_ROMAN_20PT,
    FONT_TYPE_CENTURY_GOTHIC_8PT,
    FONT_TYPE_CENTURY_GOTHIC_18PT,
    FONT_TYPE_CENTURY_GOTHIC_20PT
};

struct DeviceInfo
{
    Byte byDeviceType;
};

extern struct DeviceInfo asDeviceInfo[MAXIMUM_DEVICES];

typedef void (*POnUsbHidDeviceHotPlug)();
typedef void (*POnUsbHidDeviceHotUnPlug)();

extern NSString *FONT_CALIBRI;
extern NSString *FONT_TIMES_NEW_ROMAN;
extern NSString *FONT_CENTURY_GOTHIC;

extern NSString *FONT_SIZE_18PT;
extern NSString *FONT_SIZE_20PT;

// Function prototypes
int TurnOnGreenLight (unsigned char byDeviceIndex);
int TurnOnRedLight (unsigned char  byDeviceIndex);
int TurnOnMagentaLight (unsigned char  byDeviceIndex);
int TurnOnYellowLight (unsigned char  byDeviceIndex);
int TurnOnBlueLight (unsigned char  byDeviceIndex);
int TurnOnCyanLight (unsigned char  byDeviceIndex);
int TurnOnWhiteLight (unsigned char  byDeviceIndex);
int TurnOnOrangeLight (unsigned char  byDeviceIndex);
int TurnOffLight (unsigned char  byDeviceIndex);
unsigned char FindDevices (int *pnNumberOfBlyncDevices);
void ReleaseDevices (void);
int TurnOnRGBLights(Byte byDeviceIndex, Byte byRedLevel, Byte byGreenLevel, Byte byBlueLevel);
int TurnOnV30Light (Byte byDeviceIndex);
int TurnOffV30Light (Byte byDeviceIndex);

int SetRedColorBrightnessLevel(Byte byDeviceIndex, Byte byBrightnessLevel);
int SetGreenColorBrightnessLevel (Byte byDeviceIndex, Byte byBrightnessLevel);
int SetBlueColorBrightnessLevel (Byte byDeviceIndex, Byte byBrightnessLevel);
int StartLightFlash (Byte byDeviceIndex);
int StopLightFlash (Byte byDeviceIndex);
int SelectLightFlashSpeed (Byte byDeviceIndex, Byte bySelectedFlashSpeed);
int SelectMusicToPlay(Byte byDeviceIndex, Byte bySelectedMusic);
int StartMusicPlay(Byte byDeviceIndex);
int StopMusicPlay(Byte byDeviceIndex);
int SetMusicRepeat(Byte byDeviceIndex);
int ClearMusicRepeat(Byte byDeviceIndex);
int SetVolumeMute(Byte byDeviceIndex);
int ClearVolumeMute(Byte byDeviceIndex);
int SetMusicVolume(Byte byDeviceIndex, Byte byVolumeLevel);
int SetLightDim(Byte byDeviceIndex);
int ClearLightDim(Byte byDeviceIndex);

int ClearTextOnNameDisplay(Byte byDeviceIndex);
int DisplayTextOnNameDisplay(Byte byDeviceIndex, NSString *nameString);
int DisplayTextOnNameDisplayUsingPixelControlNameAdjust(Byte byDeviceIndex, NSString *nameString, int nFontType);
Byte GetFontTypeFromFontDetails(NSString *fontType, NSString *fontSize);

int GetDeviceUniqueId (Byte byDeviceIndex, uint *punDeviceId);

void RegisterForOnUsbHidDeviceHotPlugCallBack(POnUsbHidDeviceHotPlug OnUsbHidDeviceHotPlugCallBack);
void RegisterForOnUsbHidDeviceHotUnPlugCallBack(POnUsbHidDeviceHotUnPlug OnUsbHidDeviceHotUnPlugCallBack);

#endif


