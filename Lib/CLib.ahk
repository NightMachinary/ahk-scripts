;BlueRose Common AHK Library
;Contains shared functions.
;v1.0
;Language Switcher
; This should be replaced by whatever your native language is. See 
; http://msdn.microsoft.com/en-us/library/dd318693%28v=vs.85%29.aspx
; for the language identifiers list.

;Global variables don't exist. Use search and replace.
;CLibDir = I:\Dropbox\Me\Important Documents\Scripts\AHK Scripts\AutoHotkey\Lib

CLib_CopyTxt(WaitS = 2)
{
clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived.
Send ^c
ClipWait, %WaitS%
}

CLib_Fa()
{
;fa := DllCall("LoadKeyboardLayout", "Str", "00000429", "Int", 1)
PostMessage 0x50, 0, 0x0429,, A
sleep 50
}
CLib_En()
{
;en := DllCall("LoadKeyboardLayout", "Str", "00000409", "Int", 1)
PostMessage 0x50, 0, 0x0409,, A
sleep 50
}
CLib_SwitchLang()
{
PostMessage 0x50, 0,,, A
sleep 50
}
CLib_Shutdown(Seconds = 30)
{
WinClose ahk_class Winamp v1.x  ;KMP saves bookmarks when it is closed (seemingly).
Run, shutdown.exe -s -t %Seconds% -f
;t>0 implies -f. Use calc for -t. -t is in seconds.
}
CLib_ToggleReadingMode(Toggle = -1)
{
CLibDir = I:\Dropbox\Me\Important Documents\Scripts\AHK Scripts\AutoHotkey\Lib
;This code finds the position of workrave icon if it is active 
; part of system tray.
;Strangely, workrave's context menu does not receive any keys (even manually).
;Thus we need to use another image search to click on the "Reading Mode."
;It is possible to use two images to explicitly enable OR disable the reading mode.
;But that does not seem needed.
WinActivate ahk_class Shell_TrayWnd ;This is the easiest way.
ControlGetPos, Ux, Uy, ,, Button4, A ;These coordinates are always relative to the target window's upper-left corner.
ImageSearch, VX, VY, %Ux%, %Uy%, (Ux+300),(Ux+50),*128 %CLibDir%\WorkraveIco.jpg
;*128 is a good tolerance. It does not work with 100, if you change the coloring of the taskbar.
if ErrorLevel != 0
{
return
}
Blockinput on ;Necessary, but does NOT work. Thus this function may be disrupted by user.
Click right %VX%,%VY%
if Toggle = -1 ;Switches
ImageSearch, VX, VY, %VX%, (VY-150), (VX+100),%VY%,*100 %CLibDir%\WRRead.jpg
if Toggle = 0 ;Disables
ImageSearch, VX, VY, %VX%, (VY-150), (VX+100),%VY%,*100 %CLibDir%\WRReadEn.jpg
if Toggle = 1 ;Enables
ImageSearch, VX, VY, %VX%, (VY-150), (VX+100),%VY%,*100 %CLibDir%\WRReadDis.jpg
if ErrorLevel = 0
{
Click %VX%,%VY%
return
}
Click
Blockinput off
}