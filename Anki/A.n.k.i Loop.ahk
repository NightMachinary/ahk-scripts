;BlueRose Anki Script: Loopy section
;This section has been separated from the main script because it somehow interfered with the hotkeys.

#SingleInstance force
#NoEnv
SetTitleMatchMode, 2 ;2: A window's title can contain WinTitle anywhere inside it to be a match. 
I_Icon = A2.ico
if I_Icon <>
    IfExist, %I_Icon%
        Menu, Tray, Icon, %I_Icon%

JoystickNumber = 0

if JoystickNumber <= 0
{
    Loop 16  ; Query each joystick number to find out which ones exist.
    {
        GetKeyState, JoyName, %A_Index%JoyName
        if JoyName <>
        {
            JoystickNumber = %A_Index%
            break
        }
    }
    if JoystickNumber <= 0
    {
        ExitApp
    }
}

;Main Block

SetFormat, float, 03  ; Omit decimal point from axis position percentages.

Loop
{
if WinActive("ahk_class QWidget") ;|| WinActive("GoldenDict") No need, as GoldenDict also is class QWidget.
{
    GetKeyState, joyx, %JoystickNumber%JoyX
    GetKeyState, joyy, %JoystickNumber%JoyY
    ;The Second Joystick
    GetKeyState, joyr, %JoystickNumber%JoyR ;X axis (>50 = Right)
    GetKeyState, joyz, %JoystickNumber%JoyZ ;Y Axis (>50 = Down)
    ;Joy movepad
    GetKeyState, joyp, %JoystickNumber%JoyPOV
    ;Joy Buttons	
    ;=d -> down
    GetKeyState, joyb2, %JoystickNumber%joy2
    GetKeyState, joyb3, %JoystickNumber%joy3
    GetKeyState, joyb8, %JoystickNumber%joy8
    If joyr <= 25
	{
	if WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
	{
	Send {Left}
	sleep 250
	Continue
	}
	if WinActive("GoldenDict")
	{
	Send {Up}
	}
	else
	{
	Send {WheelUp}  
	}
	}
    If joyr >= 75
	{
	if WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
	{
	Send {Right}
	sleep 250
	Continue
	}
	if WinActive("GoldenDict")
	{
	Send {Down}
	}
	else
	{
	Send {WheelDown}
	}
	}
if (joyz <= 25) && WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
	{
	Send {.}
	sleep 500
	Continue
	}
if (joyz >= 75) && WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
	{
	Send {0}
	sleep 500
	Continue
	}
    ;Small wheel movements are not coded here, even though they are possible.
    ;Because there is no need for them.
    If joyy <= 25
	{
	Send {F3}
	Send {F4}
	Send r
	sleep 500
	}
    If joyy >= 75
	{
	Send {F11}
	sleep 500
	}
    If joyp = 0 ;POV Up
	{
	Send ^{NumpadAdd}
	sleep 200
	}
    If joyp = 18000 ;POV Down
	{
	Send ^{NumpadSub}
	sleep 200
	}
    If joyp = 9000 ;POV Right
	{
	Send {Tab}
	sleep 200
	}
    If joyp = 27000 ;POV Left
	{
	CLib_En() ;Otherwise CtrlZ won't work.
	sleep 100
	Send ^z
	sleep 1200
	}
}
Sleep, 50 
}
return	

;Warning: This section must stay below the Loopy Section.
;Global Hotkeys
~^s::
CLib_En()
Reload
return