#SingleInstance force
#NoEnv
#InstallMouseHook
;Startup Commands
SetTitleMatchMode, 2 ;2: A window's title can contain WinTitle anywhere inside it to be a match. 
I_Icon = Y1.ico
if I_Icon <>
    IfExist, %I_Icon%
        Menu, Tray, Icon, %I_Icon%
;FormatTime, Today, %A_Now% L99 ;LCID is needed to format the time automatically in English.
Menu, Tray, Add ;Adds a separator
Menu, Tray, Add, KMPSleep
Menu, Tray, Add ;Adds a separator
Menu, Tray, Add, %A_MM%/%A_DD%/%A_YYYY%, DateLabel

SetTimer, AutoShut, 300000
SetTimer Closer, 250

SetNumLockState AlwaysOn

SoundSet, 19  ;On Windows Vista or later, SoundSet and SoundGet affect only the script itself (this may be resolved in a future version). 

;Constants
Ads_TTN = I:\OneDrive\Office Live Documents\The Textish Note.rtf ;The Textish Note
Ads_DejaMort = I:\Win Starter\(Alarm) 07 - Deja mort - Bruno Coulais.mp333
Ads_KMP = C:\KMPlayer/KMPlayer.exe ;%A_ProgramFiles%\The KMPlayer\KMPlayer.exe

MusicFileList1 =  ; Initialize to be blank.
Loop, I:\Music\Without Speech\Instrumental\Bethoven\01 - Symphonies\*.mp3
    MusicFileList1 = %MusicFileList1%%A_LoopFileLongPath%`n

;Labels
return ;Stops the execution.
Closer:
IfWinExist, Workrave ahk_class gdkWindowToplevel
WinClose
IfWinExist, ahk_class TRegMessageForm
ControlSend, TButton2 ,{Down}{Enter}
IfWinExist, ahk_class TVerCheckForm
WinClose
IfWinExist, ahk_class TDownloadProgressForm
WinClose
IfWinExist, This page can’t be displayed ahk_class #32770    ;This is an annoying window of Vuze
WinClose
IfWinActive, Kaspersky Internet Security ;Kaspersky's windows lack a static ahk_class.
WinActivate ahk_class KMPlayer Ext ;It is impossible to close Kaspersky windows 
;(unless we can simulate physical keystrokes). So I just activate the KMP.
;Kaspersky CAN be minimized, though.
return
DateLabel:
return
AutoShut: 
if (A_Hour = 07) && (A_Min <= 10)
{
IfGreater, A_TimeIdlePhysical, 600000, 
CLib_Shutdown(0)
}
return

;Alarms
;If hotkeys are pressed while they are already running, NOTHING will happen.
;(it's as if you pressed the hotkey only once)
return
#`:: ;Custom Alarm
SoundBeep,5000,1000
sleep (40*60*1000)
SoundBeep,400,10000
return
#+z:: ;Shutdown instead of alerting.
#z::
GetKeyState, shKey, Shift ;Shutdown
SoundBeep,5000,3000
sleep (7*60*1000 - 1000)
Winactivate ahk_class KMPlayer Ext
WinWaitActive , ahk_class KMPlayer Ext, ,5
Send {Space}
Send p
if shKey = D
{
SoundBeep,400,1000
CLib_Shutdown(10)
Gui, Show ;To show the user that a shutdown is looming.
return
}
Run, %Ads_DejaMort%
SoundBeep,400,1000
return
#!z::
SoundBeep ,,1500
sleep (15*60*1000 - 1000)
Winactivate ahk_class KMPlayer Ext
WinWaitActive , ahk_class KMPlayer Ext, ,5
Send {Space}
Send p
Run, %Ads_DejaMort%
SoundBeep,400,1000
return
#x::
^#x::
+^#x::
KMPSleep: ;Warning: Any of the three labels can have their own thread, thus being active together.
GetKeyState, shKey, Shift ;Asks for the interval.
GetKeyState, ctKey, Control ;Long shutdown delay.
if shKey = U
{
SoundBeep,400,2000
sleep (20*60*1000)
}
else
{
InputBox si, ,Enter interval in minutes., , , , , , ,60,20
sleep (si*60*1000) ;Don't use %si%, as that does not work.
}
Winactivate ahk_class KMPlayer Ext
WinWaitActive , ahk_class KMPlayer Ext, ,5
Send {Space}
Send p
SoundBeep,400,1000
if ctKey = D
{
	CLib_Shutdown(300)
}
else
{
	CLib_Shutdown(30)
}
Gui, Show ;To show the user that a shutdown is looming.
return
;Global Hotkeys
~^s::
CLib_En()
IfWinActive The Textish Note
{
WinClose
}
;sleep 100 ;Sometimes this acts funny and doesn't switch to EN.
Reload
return

Browser_Stop::
Run, I:\PDF\Story Books\English\Nonfiction\- By Author\Douglas R. Hofstadter\Douglas Hofstadter-Metamagical Themas_ Questing for the Essence of Mind and Pattern-Bantam (1986).djvu
return

Browser_Favorites::
Run, %Ads_TTN%
WinWaitActive The Textish Note, , 10
if !ErrorLevel
{
Send {PgDn 5} ;{Enter}  ;Two subsequent Enters will erase the bulleted style.
}
return

^+d::
;SID := DllCall("FindWindow",UInt,0,UInt,0, UInt)
;SendMessage, 274, 61808, 2, , ahk_id %SID% 
;The above method somehow does not work.
;DllCall("SendMessage",uint, %SID%, int, 274, int, 61808, int, 2)
;The above method somehow does not work.
loop
{
GetKeyState, Hm, home
if hm = D
{
	SoundBeep ,,500
	loop, 1000
	{
	SoundBeep ,,1	;This seems quite effective at turning the screen on. :D
	}
	return
}
DllCall("SendMessage", int, DllCall("FindWindow",UInt,0,UInt,0, UInt), int, 274, int, 61808, int, 2)
sleep 300 ;You see, this script might be hazardous on another PC, as this one seems to
;generate anti-monitor_off responses continuously.
}
return
;This loop is adopted because my PC somehow kept turning on the monitor even when it shouldn't.
;It also has the advantage that it really turns off the monitor, unlike other software.
;Perfect for laptops!
;This, finally, works. Now, the whole Fix soft Turn Off Display is here, part of the Bluerose Y Script 1.
return
#^+d::
;This is designed for computers which function normally.
;This can be extended, so that whenever a predefined key is pressed (when IsMonitorOff = 1),
;this function is called, and thus that key will not trigger the monitor.
loop, 10
{
DllCall("SendMessage", int, DllCall("FindWindow",UInt,0,UInt,0, UInt), int, 274, int, 61808, int, 2)
sleep 100
}
return
ScrollLock & Break::AltTab
/*
; This didn't work, so i gave up on it.
#x:: ;Overrides the OS. The original shows the context menu of the Start Button.
;Copies the text and send it to GoldenDict (compact).
CLib_CopyTxt()
Send #!x 
Return
*/
#v:: ;Copies the text and send it to GoldenDict (main window).
CLib_CopyTxt()
;These Windows manipulations are quite instable and buggy.
Send {LWin Down}{Left}{LWin Up} ;Don't use Send for this. It won't work.
Send #!v
WinWaitActive GoldenDict, ,5
Send ^v{Enter}
Send {LWin Down}{Right}{LWin Up}
Return

;Shutdown Hotkeys
#s::CLib_Shutdown()
!#s::CLib_Shutdown(300) ;5min
#a::Run, shutdown.exe -a ;Cancels all events.

NumpadEnter & Numpad3::
CLib_ToggleReadingMode(0)
return

NumpadEnter & NumpadMult::
;Centers and activates KMP.
;If KMP goes off-screen, I really don't know ANY other way to get it back.
WinMove ahk_class KMPlayer Ext, ,(A_ScreenWidth/2-475),(A_ScreenHeight/2-125)
WinActivate ahk_class KMPlayer Ext
return
;Launch KMP
!#^+k::
Run, %Ads_KMP%
KMP_B()
return
NumpadEnter & NumpadSub:: ;Launches KM and starts playing.
Run, %Ads_KMP%
KMP_B()
Send {Enter}
return
;The $ is, most strangely, not needed at all, seemingly.
;But circumspection demands.
$NumpadEnter::Send {NumpadEnter} ;Sends NumpadEnter when released, if the other key was not also pressed.
;KMP Bookmark Script
KMP_RightClick()
{
	;WinGetPos Kx,Ky,,, ahk_class KMPlayer Ext
	Click right 0,0 ;Relative to the active window
}
KMP_B()
{
	CLib_En()
	Loop ;This will activate KMP. At any cost.
	{
		WinActivate ahk_class KMPlayer Ext
		WinWaitActive, ahk_class KMPlayer Ext, , 1
		If ErrorLevel = 0
			break
	}
	BlockInput, On ;Blocks all mouse and keyboard. It is just an adjunct.
	CLib_En()
	KMP_RightClick() ;Click right 400,350
	Send b+{Right}+{Up 2}+{Right}+{Up}
	BlockInput, Off
	return
}

;KMP Hotkeys
#IfWinActive ahk_class KMPlayer Ext
Numpad7::
Sort, MusicFileList1, Random
Loop, parse, MusicFileList1, `n
{
    Soundplay %A_LoopField%
    return
}
return
Numpad8::
Soundplay Nonexistent.hell
return
Numpad0::
KMP_B()
return
Numpad2::
CLib_En()
Click right 0,0
Send b+{Right}
return
$NumLock:: ;Changes the playback speed hotkeys.
Send {Shift Down}{NumLock Down}
sleep 15000 ;So that these keys don't ever get stuck down.
Send {Shift Up}{NumLock Up}
return
$*NumLock Up::Send {Shift Up}{NumLock Up}
~p::
Soundbeep , ,500
return
$c::
WinActivate ahk_class ahk_class Shell_TrayWnd ;Activates the Taskbar, to avoid giving KMP keys.
if (Clipboard =" ") or not Clipboard ;If Clipboard is empty or contains a space.
{
Clipboard = Sage ;This is done because if clipboard is empty, GoldenDict would not open.
}
Send ^c^c
return
;MPC Hotkeys
#IfWinActive ahk_class MediaPlayerClassicW
;This creates an "Add to favorites" hotkey. Cool!
p:: Send !a+a+{Enter}
~Esc::Send !{F4}


#IfWinActive ahk_class TMainForm
Numpad0::send {Escape}
