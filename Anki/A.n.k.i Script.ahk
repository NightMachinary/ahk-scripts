;BlueRose Anki Script v1.2
;I dare say this script is slowly becoming mad...
;Just the way I love things!
;Who painted this heart ebony? It wasn't us, was it?

#SingleInstance force
#WinActivateForce
#NoEnv

;Startup Code (The Loopy Section)
;Creates ahk_group GrpJA.
GroupAdd, GrpJA, jetAudio
GroupAdd, GrpJA, ahk_class COWON Jet-Audio MainWnd Class
GroupAdd, GrpAnki,  – Anki ahk_class QWidget ;GrpAnki is not meant to include QWidget.
GroupAdd, GrpAnki, V2AEnabled 

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
AHKScriptsPath = I:\Dropbox\Me\Important Documents\Scripts\AHK Scripts
I_Icon = Anki.ico
if I_Icon <>
    IfExist, %I_Icon%
        Menu, Tray, Icon, %I_Icon%

;Note that by using "Anki" as a criterion, these hotkeys won't work in Add, Edit etc windows. :D
SetTitleMatchMode, 2 ;2: A window's title can contain WinTitle anywhere inside it to be a match. 
SetFormat, float, 03  ; Omit decimal point from axis position percentages.

;Warning: This section must stay below the Loopy Section.
;Global Hotkeys
~^s::
CLib_En()
Reload
return
1Joy5:: ;Left Shoulder
If WinActive("ahk_class QWidget") ;|| WinActive("Notepad") || WinActive("AutoHotkey Help")
{
GetKeyState, joyb8, %JoystickNumber%joy8
if joyb8 = D 
{
If WinActive("ahk_group GrpAnki") 
{
;Refreshes the current card to its Question side.
Send e
sleep 25
Send {Esc}
return
}
Send ^{Enter} ;Add note in Anki.
WinClose GoldenDict
Sleep 400 ;Does NOT return here. Thus it will close the Add Window.
}
If WinActive("ahk_group GrpAnki") 
{
InputBox OVar,V2AEnabled,1 = Close Anki | 2 = Shutdown
if (OVar = 1) || (OVar = 2)
{
Send !{F4}
sleep 100
CLib_ToggleReadingMode(0)
}
if Ovar = 2
{
WinWaitClose ahk_group GrpAnki
CLib_Shutdown()
}
return
}
}
Send !{F4}
return
;Chrome-Anki Switcher
#c:: ;Overrides Cortana hotkey in Anki.
If WinActive("ahk_class QWidget")
{
;CLib_CopyTxt() ;Calls the function from BlueRose Common Library.
WinActivate ahk_class Chrome_WidgetWin_1
WinWaitActive, ahk_class Chrome_WidgetWin_1
WinActivate Chrome
CLib_En()
Send {Alt Down}d{Alt Up} ;Focuses the address bar.
Send !d
Send gi{Space} ;This needs you to add Google Images as a search engine
;(right-click on the search box and...)
; and setting its keyword to "gi".
;"bim" = Bing Images

return
}
If WinActive("Chrome")
{
WinActivate ahk_class QWidget
WinWaitActive, ahk_class QWidget, , 2
Send {Left}^v
CLib_Fa()
return
}
return
Joy7:: ;Right Shoulder
GetKeyState, joyb8, %JoystickNumber%joy8
if joyb8 = D
{
if WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
{
Send 9
return
}
Goto ~^s
return
}
If WinActive("ahk_class QWidget") || WinActive("ahk_group GrpAnki")
{
Send {Enter}
MouseMove 3700,100 ;Different position, to make Workrave timers tick.
;This position must always fall somewhere on the card. If not, scrolling won't work.
}
return
1Joy6:: ;Left Trigger
If WinActive("ahk_class QWidget")
{
GetKeyState, joyb8, %JoystickNumber%joy8
if joyb8 = D
{
WinClose, ahk_group GrpJA
Send {Esc} ;Closes JoystickTest.
return
}
Run, %AHKScriptsPath%\Downloaded Scripts\JoystickTest.ahk
}
return
1Joy4:: ;Y
GetKeyState, joyb8, %JoystickNumber%joy8
if joyb8 = D
{
If WinActive("ahk_class QWidget")
{
if WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
{
Send 8
return
}
Send {Alt Down}{Shift}{Alt Up} ;Alt+Shift      
return
}
Gosub #w ;Launches Anki.
return ;Essential, since GoSub will return here.
}
If WinActive("ahk_group GrpAnki") || WinActive("ahk_class QWidget")
{
MouseMove 3700,400
Send {Numpad3} 
}
return

#!w::
;Adding Alt will also launch JetAudio.
Run, C:\Program Files\JetAudio\JetAudio.exe
if A_ThisHotkey = #!w
{
WinActivate ahk_group GrpJA
WinWaitActive ahk_group GrpJA
Send {Space}
}
return
;OBSOLETE Note that there's no 'return' here! I'm a genius!
;Launch Anki
#w::
Run, D:\Program Files\Anki\anki.exe -p"User 1" -b D:\Users\Fery\Documents\Anki
sleep 1000 ;Waits for Anki to load.
WinWaitActive  ahk_group GrpAnki
KeyWait LWin ;LWin will interfere with our next Send.
Send, /All{Enter 2} ;SendPlay doesn't work with Anki.
Goto ~^s ;Reloads the script, since some times it doesn't work before doing so.
return

#IfWinActive ahk_group GrpAnki  
;Viera2Anki
Insert UP::Send +2 ;Suspends the card.
;Seemingly UP doesn't work with Joysticks, though it was working fine.
1Joy9:: ;Back
GetKeyState, joyb8, %JoystickNumber%joy8
if joyb8 = D
{
Send - ;Buries the card.
return
}
CLib_En()
Send e^a
CLib_CopyTxt(3) ;Waits x seconds.
Send ^c^c
return
1Joy1:: ;A
GetKeyState, joyb8, %JoystickNumber%joy8
if joyb8 = D
{
if WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
{
Send 5
return
}
Send e
sleep 500
if WinActive("Persian")
{
Send {Tab 2}SplTest ;This fills the auto-spelling field of Persian cards.
}
if WinActive("English") || WinActive("YCards")
{
Send {Tab 4}PrnTest
}
return
}
MouseMove 3700,400
Send {Numpad1} 
return
1Joy2:: ;B
GetKeyState, joyb8, %JoystickNumber%joy8
if joyb8 = D
{
if WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
{
Send 6
return
}
Loop 
{
GetKeyState, joyb2, %JoystickNumber%joy2
GetKeyState, joybn8, %JoystickNumber%joy8
if (joyb2 = "U" or joybn8 = "U")
{
Return
}
Send {Right}
sleep 50
}
}
MouseMove 3700,400
Send {Numpad2} 
return
1Joy3:: ;X
GetKeyState, joyb8, %JoystickNumber%joy8
if joyb8 = D
{
if WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
{
Send 7
return
}
Loop 
{
GetKeyState, joyb3, %JoystickNumber%joy3
GetKeyState, joybn8, %JoystickNumber%joy8
if (joyb3 = "U" or joybn8 = "U")
{
Return
}
Send {Left}
sleep 50
}
}
MouseMove 3700,400
Send {Numpad4} ;X
return
Joy10:: ;Start
GetKeyState, joyb8, %JoystickNumber%joy8
if joyb8 = D
{
Send +2      
return
}
Send {Numpad5}
return
Joy12:: ;RightThumb
GetKeyState, joyb8, %JoystickNumber%joy8
if (joyb8 = D) || 1 ;This is inactive, but you can reactivate it.
{
if WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
{
Send {BS}
return
}
}
return ;Previously it buried cards, but it is now empty.

;V2A Ends Here.
$Numpad0::
if !WinActive("Math") ;Note that Anki must display the current deck in its title for this to work.
{
Send {Enter}
return
}
Send {Numpad0}
return
AnkiAdd(shKey,Deck)
{
	CLib_En()
	if shKey = U
	{
		Send ^c
	}
	Send a^n%Deck%{Enter}
	if shKey = U
	{
		Send ^v
	}
}
OpenGD(shKey,slp = 100)
{
	sleep %slp%
	Send ^c^c
	WinActivate GoldenDict
	if shKey = D 
	{
		sleep 300
		WinWaitActive GoldenDict, , 10
		Send {BS}
	}
}
$+q::
$q::
GetKeyState, shKey, Shift
AnkiAdd(shKey,"EnglishAdvancedPronunciation")
OpenGD(shKey)
return
$+w::
$w::
GetKeyState, shKey, Shift
AnkiAdd(shKey,"EnglishAMulti")
OpenGD(shKey)
return
$+]::
$]::
GetKeyState, shKey, Shift
AnkiAdd(shKey,"- Cloze")
return
$~c:: ;~ is essential. Don't ask me why, dearest.
Send ^c^c
return
#IfWinActive ahk_class QWidget ;These hotkeys work in any Anki window. They also work in some other
;windows, like GoldenDict. I guess it has something to do with the programming framework.

^y:: ú
::-->::<img src="PSk.jpg" />
::--rtl:: <div dir="rtl"> </div>
::ÝÝÝ::T
::˜˜˜::UnK
::**::(* =){Left}  ;Note:You need to use space to activate this hotstring for it to work.

;These are buggy. They twist AltShift.
$~LAlt::Send {Tab 4} ;Switch to M1 for Arabic notes.
;Right-ALT has become a prefix, which automatically allows it to modify all other keys as it normally would.
~LAlt & ~Shift::return 
$~LCtrl::Send {Tab 3}
~LCtrl & ~Shift::return 
AppsKey::Send {Tab 17} ;Kills the original fucntion :D 
F2:: Send {Shift down}{RAlt}{Shift up} ;F1 is the black hotkey.
F3::
Send ^+x
sleep 50 ; Waits for the dialog to load.
Send {PgUp}
Send {Home}<div dir=rtl>{Enter} ;<Span> doesn NOT work.
Send {PgDn}
Send {End}
Send {Enter}</div>{Esc}  ;Makes an Anki field RTL.
return