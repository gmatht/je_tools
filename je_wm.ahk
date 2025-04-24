; https://www.reddit.com/r/Eve/comments/a0i0mm/need_an_ahk_script_to_switch_between_chosen_eve/
#Warn 
#SingleInstance Force
#NoEnv
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.


mtoggle:=0
groupid := []
;groupname := []
;groupw := []
;grouph := []
yellow_alert_ids := []
groupcount = 0
groupselect = 0
gtile := FALSE
dict := {"0x0000":0}
timewasted := {"NULL":0}
LastActiveBeforeYellowAlert := 0

; Yellow Alert Configuration
yellow_alerts_enabled := true
yellow_alert_min_idle := 5  ; Default minimum idle time in seconds
yellow_alert_delay := 60    ; Default delay in seconds
yellow_alert_gui_created := false  ; Track if the Yellow Alert GUI has been created

;					CoordMode Mouse, Screen

fits:={"NULL":0}

InitFits() {
	global fits
	FileRead, V, %A_ScriptFullPath%
	V := RegExReplace(V, "ms).*^__FITS__$" , "")
	V := RegExReplace(V, "ms)^__END FITS__$.*" , "") 

	q:=0
	r:=1
	While(r) {
		p := InStr(V,"[",,q+1)
		q := InStr(V,"]",,p)
		name := Substr(V,p,q-p+1)
		r := InStr(V,"[",,q+1)
		if (r) {
			fit := Substr(V,p,r-3-p)
		} else {
			fit := Substr(V,p)
		}
		;MsgBox, fits[%name%] := %fit%)
		fits[name]:=fit
	}
	fits.remove("NULL")
}

InitFits()


ActiveWindowID:=0
WindowShown:=0
Gui, Close:new
Gui, Close: -Caption +Border +ToolWindow +AlwaysOnTop
Gui, Close:Font, s24
Gui, Close:Add, Button, Default gButtonAltF4, Alt-F4

Gui Switch:new
Gui Switch:Font, s40
Gui Switch: +Caption +Border +ToolWindow +AlwaysOnTop
;Gui Switch: +ToolWindow +AlwaysOnTop
Gui Switch:Add, Button, gswitchback x0 y0 w68 h64, < ; Switch to Previous Window
Gui Switch:Add, Button, gswitch x104 y0 w68 h64, > ; Switch to Next Window
;Gui Switch:Font
Gui Switch:Font, s18
Gui Switch:Add, Button, gmenu  x68 y0  w36 h64, ⋮ ; Menu (fits)
Gui Switch:Add, Button, gCtrlS x0  y64 w64 h32, 💤 ; Sleep (Skip 4 times)
Gui Switch:Add, Button, gOSK   x64 y64 w32 h32, F ; Engage Drones?
Gui Switch:Add, Button, gEveUni   x96 y64  w32 h32, U ; UniWiki
Gui Switch:Add, Button, gDiscord   x128 y64  w32 h32, D ; Discord
Gui Switch:Add, Button, gOSK   x0 y96 w44 h32, F1
Gui Switch:Add, Button, gOSK   x44 y96 w44 h32, F2
Gui Switch:Add, Button, gOSK   x88 y96 w44 h32, F3
Gui Switch:Add, Button, gOSK   x132 y96  w44 h32, F4
;Gui, Color, Red
;Gui Switch:Add, Button, gCtrlUp  x0  y128 w128 h32 c87BBFF, CtrlU
;Gui Switch:Add, Button, gCtrlDown  x0  y128 w128 h32  c87BBFF, CtrlD
Gui, Switch:Add, CheckBox, vCtrlDown gCtrl x0 y128 w64 h32, Ctrl ; Hold down Ctrl
Gui Switch:Add, Button, gTile   x64 y128  w32 h32, 🁤 ; Tile Windows Vertically
Gui Switch:Font, s14
Gui, Add, Text, cRed x96 y128 w128 vTextTimeWasted gTimeWasted, HH:MM:SS ; Time Spend on this Window Title
;^ Click for Summary of Time Wasted e.g.:
;^ ^EVE: Time spend on EVE that could have been spent in the sunshine admiring the flowers.
;^ AFK: Time spent in the sunshine admiring the flowers that could have been spent earning ISK.
;^ (Remember you have children to PLEX!!!)
Gui Switch:Font, s8
Gui, Add, Text, x96 y146 w128 vWinTitle gCopyWinTitle, WinTitle ; Currently Active Window/Character
Gui Switch:Font, s18
Gui Switch:Add, Button, gWinKey   x0 y160 w32 h32, # ; Windows Key (Raise TaskBar)
Gui Switch:Add, Button, gMinimizeAll   x32 y160 w32 h32, M ; Minimise All Windows
Gui Switch:Add, Button, gRoutePlanner  x64 y160 w32 h32, 🚀 ; DOTLAN Route Manager
Gui Switch:Add, Button, gYellowAlert  x96 y160 w32 h32, 🔔 ; Yellow Alert Config
Gui Switch:Add, Button, gMyReload  x140 y160 w32 h32, ⟳ ; Reload this Script
Gui Characters:new
Gui Characters: +Caption +Border +ToolWindow +AlwaysOnTop +E0x08000000 ; Never Focus, even when clicked on.


MyReload() {
	Send ^s
	Sleep 100
	Reload
}

;https://www.autohotkey.com/boards/viewtopic.php?t=74127
LineStr(ByRef S, P, C:="", D:="") {   ;  LineStr v0.9d,   by SKAN on D341/D449 @ tiny.cc/linestr
	Local L := StrLen(S),   DL := StrLen(D:=(D ? D : Instr(S,"`r`n") ? "`r`n" : "`n") ),   F, P1, P2 
	Return SubStr(S,(P1:=L?(P!=1&&InStr(S,D,,0))?(F:=InStr(S,D,,P>0,Abs(P-1)))?F+DL:P-1<1?1:0:(F:=1)
	:0),(P2:=(P1&&C!=0)?C!=""?(F:=InStr(S,D,,(C>0?F+DL:0),Abs(C)))?F-1:C>0?L:1:L:0)>=P1?P2-P1+1:0)
	}
	
TimeWasted() {
	global timewasted 
	tw := {NULL: 0}
	Regexs := ["^EVE|^..:..$","Mozilla Firefox$"]

	for i,r in Regexs {
		
		tw[r]:=0
	}

	for k, v in timewasted {
		__k := "    "
		__k .= k
		;tw[k] := v
		tw[__k] := v
		for i,r in Regexs {
			if (RegExMatch(k,r)) {
				tw[r] += v
			}
		}
	}

	s := ""
	for k, v in tw {
		t := Round(v/1000)
		if (t=0)
			continue
		L := FormatSeconds(t)
		L .= "	"
		L .= k
		L .= "`n"
		s .= L
	}

	Sort, s,l, R
	s20 := LineStr(s,1,20)
	if (s <> s20) {
		s20 .= "`n..."
	}
	s20 .= "`n`nCopy All?"

	IfWinExist, Time Wasted
		WinClose

	MsgBox, 4, Time Wasted, %s20%
	IfMsgBox YES
		clipboard := s
	
}

ShowCharacters() {
	Gui Characters:Destroy
Gui Characters:new
Gui Characters: +Caption +Border +ToolWindow +AlwaysOnTop +E0x08000000 ; Never Focus, even when clicked on.
	
	static exists={"NULL":0}
	SetTitleMatchMode, 1  
	;WinGet,Windows,List,"EVE - "
	WinGet,Windows,List
	Loop,%Windows%
	{
		this_id := Windows%A_Index%
		WinGetTitle,this_title,ahk_id %this_id%
		short_title := RegExReplace(this_title, "^EVE - " , "")
		if (short_title <> this_title and !exists[short_title]) {
			Gui Characters:Add, Button, gCharacter, %short_title%
			;exists[short_title] := 1
		}
	}
	
	Gui Characters:Submit
	;Gui Characters:Show, h1000 NA, Paste
	Gui Characters:Show, NA, Paste
}

Character() {
		clipboard := A_GuiControl
		;SendPlay {Ctrl down}{100}v{100}{Ctrl up}
		Send {Ctrl down}
		Sleep 100
		Send v
		Sleep 100
		Send {Ctrl up}
}

WinKey() {
	WinActivate, Program Manager
	Send {Ctrl up}{LWin}
	;ControlSend, , {LWin}, Program Manager 
}

MinimizeAllAll() {
	WinMinimizeAll
}

CopyWinTitle() {
	GuiControlGet, clipboard,Switch:,WinTitle
	ShowCharacters()
}
	

;Gui Switch:Font, s12
;Gui Switch:Add, Button, gOSK   x0 y128 w172 h16, Ctrl Down
;Gui Switch:Add, Button, gOSK   x0 y144 w172 h16, Ctrl Up
;Gui Switch:Add, Button, gOSK   x96 y64 w64 h32, +RFFFFFF

Gui Menu:new
Gui Menu: +ToolWindow +AlwaysOnTop
;Gui Menu:Add, Button, , Venture
;Gui Menu:Add, Button, , Travel
;local _i
for _i in fits {
	Gui Menu:Add, Button, gfit, %_i%
}
Gui Menu:Add, Button, , Exit


Gui, Switch: +AlwaysOnTop +Owner +E0x08000000
Gui, Switch:Show, NoActivate x200 y200 w176 h200, SwitchBar

Sleep 1200

OnMessage( 0x200, "Drag", 1 )

EveUni() {
	SetTitleMatchMode, 2
    ToolTip ; Hide ToolTip so WinExist doesn't find it.
	if (WinExist("EVE University Wiki")) {
		WinActivate
		WinMove,,,200,100,A_ScreenWidth-400, A_ScreenHeight-400
		Splash("Uni Wiki Exists -- activating")
	} else {
		Splash("Launching Uni Wiki")
		Run, firefox.exe -new-window https://wiki.eveuniversity.org/Main_Page
	}
}

RoutePlanner() {
	SetTitleMatchMode, 2
    ToolTip ; Hide ToolTip so WinExist doesn't find it.
	if (WinExist("DOTLAN")) {
		WinActivate
		WinMove,,,200,100,A_ScreenWidth-400, A_ScreenHeight-400
		Splash("Route Planner Exists -- activating")
	} else {
		Splash("Launching RoutePlanner")
		Run, firefox.exe -new-window https://evemaps.dotlan.net/route
	}
}

	; Create and show Yellow Alert configuration GUI
	Gui, YellowAlert:New
	Gui, YellowAlert:+AlwaysOnTop +ToolWindow
	Gui, YellowAlert:Font, s12
	Gui, YellowAlert:Add, Text, , Yellow Alert Configuration
	Gui, YellowAlert:Add, CheckBox, vYellowAlertCurrentWindow gYellowAlertToggleCurrent, Add current window
	Gui, YellowAlert:Add, Text, vYellowAlertWindowName, Current window
	Gui, YellowAlert:Add, CheckBox, vYellowAlertsEnabled gYellowAlertToggleEnabled Checked%yellow_alerts_enabled%, Alerts Enabled
	Gui, YellowAlert:Add, Text, , Minimum Idle (seconds):
	Gui, YellowAlert:Add, Edit, vYellowAlertMinIdle gYellowAlertUpdateSettings w60, %yellow_alert_min_idle%
	Gui, YellowAlert:Add, Text, , Delay (seconds):
	Gui, YellowAlert:Add, Edit, vYellowAlertDelay gYellowAlertUpdateSettings w60, %yellow_alert_delay%
	Gui, YellowAlert:Add, Button, gYellowAlertYield, Yield
	Gui, YellowAlert:Add, Button, gYellowAlertClose, Close
	yellow_alert_gui_created := true  ; Mark that the GUI has been created

Gui, YellowAlert:Hide

	;Gui, YellowAlert:Show, , Yellow Alert

	; No longer need this timer as EventLoop handles it
	; SetTimer, YellowAlertUpdateCurrentWindow, 200


;Toggle if ship is under yellow alert, i.e. if groupid is in yellow_alert_ids

YellowAlert() {
	
	
	static showing:=0
	
	; Check if Yellow Alert GUI is currently showing
	;f (WinExist("Yellow Alert")) {
	if (showing) {
		; Hide the GUI instead of destroying it
		Gui, YellowAlert:Hide
		showing := 0
	} else {
		; Show the GUI
		Gui, YellowAlert:Show, , Yellow Alert
		showing := 1
	}
	
	return
}

YellowAlertClose() {
	; Hide the GUI instead of destroying it
	;Gui, YellowAlert:Hide
	YellowAlert()
	return
}

YellowAlertToggleCurrent() {
	global YellowAlertCurrentWindow
	global yellow_alert_ids
	global LastActiveBeforeYellowAlert
	
	; Get the current foreground window and its title
	WinGet, foreground_id, ID, A
	WinGetTitle, foreground_title, A
	
	; Determine which window to toggle - if Yellow Alert is foreground, use LastActiveBeforeYellowAlert
	toggle_id := foreground_id
	
	if (InStr(foreground_title, "Yellow Alert") == 1) {
		if (LastActiveBeforeYellowAlert && LastActiveBeforeYellowAlert != foreground_id) {
			toggle_id := LastActiveBeforeYellowAlert
		}
	} else {
		LastActiveBeforeYellowAlert := foreground_id
	}
	
	; Get window title for messages
	WinGetTitle, toggle_title, ahk_id %toggle_id%
	
	; Get the checkbox state
	Gui, YellowAlert:Submit, NoHide
	
	; Check if the window is already in yellow alert
	isYellowAlert := False
	for i, id in yellow_alert_ids {
		if (id = toggle_id) {
			isYellowAlert := True
			break
		}
	}
	
	; If checkbox state doesn't match current state, toggle it
	if (YellowAlertCurrentWindow && !isYellowAlert) {
		; Add to yellow alert
		yellow_alert_ids.Push(toggle_id)
		Splash("Yellow Alert Added: " . toggle_title)
	} else if (!YellowAlertCurrentWindow && isYellowAlert) {
		; Remove from yellow alert
		newYellowAlerts := []
		for i, id in yellow_alert_ids {
			if (id != toggle_id) {
				newYellowAlerts.Push(id)
			}
		}
		yellow_alert_ids := newYellowAlerts
		Splash("Yellow Alert Removed: " . toggle_title)
	}
}

YellowAlertToggleEnabled() {
	global yellow_alerts_enabled
	global YellowAlertsEnabled
	
	; Update enabled state immediately
	Gui, YellowAlert:Submit, NoHide
	yellow_alerts_enabled := YellowAlertsEnabled
	
	if (yellow_alerts_enabled) {
		Splash("Yellow Alerts Enabled")
	} else {
		Splash("Yellow Alerts Disabled")
	}
}

YellowAlertUpdateSettings() {
	global yellow_alert_min_idle
	global YellowAlertMinIdle
	global YellowAlertDelay
	global yellow_alert_delay
	
	; Update settings immediately
	Gui, YellowAlert:Submit, NoHide
	
	; Apply changes if values are valid numbers
	if YellowAlertMinIdle is integer
	{
		yellow_alert_min_idle := YellowAlertMinIdle
	}
	
	if YellowAlertDelay is integer
	{
		yellow_alert_delay := YellowAlertDelay
	}
}


UpdateYellowAlertButton() {
	global yellow_alert_ids
	global ActiveWindowID
	global yellow_alerts_enabled
	
	isYellowAlert := False
	WinGet, this_id, ID, A
	
	; Check if the current window is in yellow alert
	if (this_id) {
		for i, id in yellow_alert_ids {
			if (id = this_id) {
				isYellowAlert := True
				break
			}
		}
	}
	
	; Update button appearance based on state
	if (yellow_alerts_enabled && yellow_alert_ids.Length() > 0) {
		if (isYellowAlert) {
			; Current window is in alert - show bright yellow
			GuiControl, Switch:+Background#FFFF00, 🔔
		} else {
			; Some windows in alert but not current - show pale yellow
			GuiControl, Switch:+Background#FFFFCC, 🔔
		}
	} else {
		; No alerts or alerts disabled - show normal button
		GuiControl, Switch:+Background#EEEEEE, 🔔
	}
}



Tile1() {
	global gTile
	global groupcount
	global groupid
	
	gTile := TRUE
	DeleteAll()
	AddAll()
	for i,v in groupid {
		h:= Round(A_ScreenHeight*(0.5+((groupcount-i)*0.5)/groupcount))
		WinActivate, ahk_id %v%
		;MsgBox, %h%
		WinMove, ahk_id %v%,,1,1,%A_ScreenWidth%,%h%
		
		Gui, FullScreen%i%: -Caption -Border +ToolWindow +AlwaysOnTop
		Gui, FullScreen%i%:Add,Button, x0 y0 w256 h32 gFullScreenX, FullScreen %i%
		h32:=h-60
		Gui, FullScreen%i%:Show,x0 y%h32%
		
		
	}
}

Tile() {
	global gTile
	global groupcount
	global groupid
	
	gTile := TRUE
	DeleteAll()
	AddAll()
	h:= Round(A_ScreenHeight*0.5)
	w:= Round(A_ScreenWidth*0.5)
	v:=groupid[1]
	WinMove, ahk_id %v%,,1  ,1  ,%w%,%h%
	v:=groupid[2]
	WinMove, ahk_id %v%,,%w%,1  ,%w%,%h%
	v:=groupid[3]
	WinMove, ahk_id %v%,,1  ,%h%,%w%,%h%
	v:=groupid[0]
	WinMove, ahk_id %v%,,%w%,%h%,%w%,%h%
}


FullScreenX() {
	global groupselect
	global groupid
	
	Array := StrSplit(A_GuiControl," ")
	n:=Array[2]
	;MsgBox, %n%
	
	groupselect:=n
	id:=groupid[n]
	UnTile()
	WinActivate, ahk_id %id%
}

UnTile() {
	global gTile
	global groupcount
	global groupid

	if (gTile) {
		gTile := FALSE
		for i,v in groupid {
			;WinActivate, ahk_id %v%
			WinMove, ahk_id %v%,,1,1,%A_ScreenWidth% ,%A_ScreenHeight%
			Gui, FullScreen%i%: hide
		}
		Gui, FullScreen%i%: hide
	}
}

Discord() {
	SetTitleMatchMode, 2
    ToolTip ; Hide ToolTip so WinExist doesn't find it.

	if (WinExist("Discord")) {
		WinActivate
	} else {
		;Run, discord.exe
		Run, %A_AppData%\..\Local\Discord\Update.exe --processStart Discord.exe
	}
}

HideToolTip() {
	ToolTip
}
	
;menu:
;(){
;}


Mod() {
	static down:={0:0}
	if (down[A_GuiControl]) {
		;Send, {%A_GuiControl% Up}
		down[A_GuiControl]:=FALSE
		
	} else {
	
		Gui, Switch:Font, s18 cRed Bold, Verdana  ; If desired, use a line like this to set a new default font for the window.
		GuiControl, Switch:Font, MyEdit  ; Put the above font into effect for a control.
		down[A_GuiControl]:=TRUE
	}
		
		
} 


NULLF(){
sleep 2000
return
}


;Gui, -Caption +Border +ToolWindow +AlwaysOnTop
;Gui, Show, w200 h13
;return

WM_MOUSEMOVE( wparam, lparam, msg, hwnd )
{
	if wparam = 1 ; LButton
		PostMessage, 0xA1, 2,,, A ; WM_NCLBUTTONDOWN
}


;-------------------------------------------------
; EDITED FROM Window dragging via alt+lbutton                -
; Author: Lasmori (email AT lasmori D0T com)     -
;-------------------------------------------------
Drag(){
;return
; Fixed to move background windows properly
CoordMode, Mouse, Screen

MouseGetPos, , , id ; get ID of window under cursor
WinGetTitle, ltitle, ahk_id %id% ; get title of window under cursor
SetTitleMatchMode 3 ; match window that has the exact name as %title%
WinGetPos, win_x, win_y, , , %ltitle% ; get upper left corner of window
MouseGetPos, current_x, current_y, window_id ; get cursor position on the screen (not relative to window)
cur_win_x := current_x - win_x ; calculate relative cursor position
cur_win_y := current_y - win_y
WinGet, window_minmax, MinMax, ahk_id %window_id%

tips:={"D":"Discord","<":"Switch to previous window",":":"Menu",">":"Switch to next window","💤":"Hide window and skip over it 4 times","F":"Drones Engage","CtrlDown":"Hold down Ctrl","U":"EVE University Wiki","🔔":"Yellow Alert Configuration"}
MouseGetPos,,,, VarControl
tip:=tips[A_GuiControl]
if (tip) {
ToolTip % tip
SetTimer, HideToolTip, -5000
;} else {
;	ToolTip % A_GuiControl
}

dragging:=FALSE

Sleep 20

SetWinDelay, 0

loop
{
  ; exit the loop if the left mouse button was released
  GetKeyState, lbutton_state, LButton, P
  if lbutton_state = U
  {
    break
  }
  

  MouseGetPos, cur_x, cur_y
  window_x := cur_x - cur_win_x
  window_y := cur_y - cur_win_y
  if (abs(window_x-win_x)+abs(window_y-win_y)<64)
	dragging:=TRUE
  if (dragging)	
      WinMove, ahk_id %window_id%,, %window_x%, %window_y%
  Sleep 10
}

return
}

;https://www.autohotkey.com/docs/v1/lib/FormatTime.htm
FormatSeconds(NumberOfSeconds)  ; Convert the specified number of seconds to hh:mm:ss format.
{
    time := 19990101  ; *Midnight* of an arbitrary date.
    time += NumberOfSeconds, seconds
    FormatTime, mmss, %time%, mm:ss
    return Format("{:02}",NumberOfSeconds//3600) ":" mmss
    /*
    ; Unlike the method used above, this would not support more than 24 hours worth of seconds:
    FormatTime, hmmss, %time%, h:mm:ss
    return hmmss
    */
}

EventLoop() 
{
global timewasted
static awaytime:=0
static last_Min:=-1

global ActiveWindowID
global WindowShown
global yellow_alert_ids
global yellow_alerts_enabled
global yellow_alert_min_idle
global yellow_alert_delay
global YellowAlertCurrentWindow
global LastActiveBeforeYellowAlert
static last_alert_time := 0

; Get the current foreground window
WinGet, foreground_id, ID, A
WinGetTitle, foreground_title, A

; Determine which window ID to use as "current" for Yellow Alert purposes
WinGetTitle, current_title, ahk_id %foreground_id%
current_id := foreground_id

; If Yellow Alert is the foreground window, use the LastActiveBeforeYellowAlert instead
if (InStr(foreground_title, "Yellow Alert") == 1) {
    ;if (LastActiveBeforeYellowAlert && LastActiveBeforeYellowAlert != foreground_id) {
        current_id := LastActiveBeforeYellowAlert
        WinGetTitle, current_title, ahk_id %current_id%
    ;}
} else {
	LastActiveBeforeYellowAlert := foreground_id
}

idle:=round(A_TimeIdle/1000)

static lasttime=""

; Check if Yellow Alert window exists (not necessarily visible)
if WinExist("Yellow Alert") {
    ; Check if current window is in yellow alert list
    x:=False
    for i, id in yellow_alert_ids {
        if (id = current_id) {
            x := True
            break
        }
    }
    
    isYellowAlert:=x

    ; Update the checkbox without triggering its g-label
    GuiControl, YellowAlert:, YellowAlertCurrentWindow, %isYellowAlert%
    
    ; Update window title display
    GuiControl, YellowAlert:, YellowAlertWindowName, Current: %current_title% (ID: %current_id%)
}

; Check if we need to raise Yellow Alert windows
if (yellow_alerts_enabled && A_TimeIdlePhysical > yellow_alert_min_idle * 1000) {
    ; Get current time for delay check
    current_time := A_TickCount // 1000
    
    ; If there are any windows in yellow alert and either:
    ; 1. It's a different minute and minimum idle time exceeded, or
    ; 2. Delay seconds have passed since last alert and user is still idle
    if (yellow_alert_ids.Length() > 0 &&         (         (current_time - last_alert_time > yellow_alert_delay))) {
        
        last_alert_time := current_time
        
        ; Loop through all yellow alert windows and bring them to the front
        for i, id in yellow_alert_ids {
            WinGetTitle, alert_title, ahk_id %id%
            if (WinExist("ahk_id " . id)) {
                WinActivate, ahk_id %id%
                Splash("Yellow Alert: " . alert_title)
            }
        }
    }
}

; Update Yellow Alert button appearance
UpdateYellowAlertButton()

time:=A_Hour ":" A_Min

if (time <> lasttime) {
	Gui Switch:show, NA , %time%
	lasttime:=time
}

if (InStr(current_title,"EVE")) {
	awaytime:=0
} else {
	awaytime += 0.5
	if (awaytime > 200) {
		WinActivate, ahk_id %current_id% 
	} 
}


if (idle>5) {
	WinSet, Top,, MEmu
	If(idle>60) {
		return
	}
}


if (!timewasted[current_title]) 
	timewasted[current_title] := 0
timewasted[current_title] += 500 

tw := Round(timewasted[current_title]/1000)


HHMMSS := FormatSeconds(tw)

short_title := RegExReplace(current_title, "^EVE - " , "")

GuiControl, Switch:Text, TextTimeWasted, %HHMMSS%
GuiControl, Switch:Text, WinTitle, %short_title%


; ControlSetText, Switch:Text1 , XXX

;%tw%%tw%

; if (this_title = "QuickSwitch4.ahk") {
if (current_title = "SwitchBar") {
	return
}
if (current_title = "AltF4") {
	return
}


	
	
if (current_title = "EVE") {
	ActiveWindowID := current_id
	if (WindowShown=0) {
		WinGetPos, OutX, OutY, OutWidth, OutHeight, A
		X:=OutX+OutWidth*3/4
		Y:=OutY+OutHeight*3/4
		;Splash(X ":" Y)
		;Sleep 1000
		gui, Close:show, x%X% y%Y%, AltF4
		;Winset, Alwaysontop, , A
		OnMessage( 0x200, "WM_MOUSEMOVE" ) 

		;sleep 100
		WinActivate, ActiveWindowID
		;Splash(ActiveWindowID)
		WindowShown:=1
	}
} else {
	ActiveWindowID:=0
	if (WindowShown=1) {
		gui, Close:hide
		WindowShown:=0
	}
}

return
}

SetTimer, EventLoop, 500

Goto AddAll

AddWindow() {
    global groupid
	;global groupname
	global groupcount
	global groupselect
	
	; WinGet, active_id, PID, A
	
	this_id := "ahk_id " . Windows%A_Index%
	groupid[groupcount] := this_id
	WinGetTitle, active_name, A
	;groupname[groupcount] := active_name
	test := groupid[groupcount]
	groupcount += 1
	;Splash("The active window's ID is " %test% ", " %groupcount% " registered windows8")
	MsgBox, %s%
			
}

__SubMaximizeWindow()
{
	
	w=3840
	h=2160
	adj=80		
	leavebottom=256
	this_id := "ahk_id " . Windows%A_Index%
	WinGetTitle,this_title,%this_id%
	if (InStr(this_title,"EVE - Suu Gaku") 
	    or InStr(this_title,"EVE - Sun S")
		or InStr(this_title,"EVE - Lef A"))
	{	
		leavebottom=0
	}	
	;WinMove, A,, w/3-adj, 0, w*2/3+adj, h-64-leavebottom,
}


Splash(t,w=400,h=20) 
{
	SplashTextOn,w,h,%t%
	SetTimer,MySplashTextOff,-3000
}

MySplashTextOff()
{
	SplashTextOff
}


;Ctrl() {
;  global CtrlDown
Ctrl:
  Gui, Submit, NoHide
  if (CtrlDown) {
	Splash("Ctrl Down")
	Send, {Ctrl Down}
  } else {
  	Splash("Ctrl Up")
	Send, {Ctrl Up}
  }
;}
;	

#3::
AddWindow()
return

buttonAltF4:
Splash("Kill _" . ActiveWindowID . "_")
WinKill, ahk_id %ActiveWindowID%
goto switch
;return

MinimizeAll(){
	WinGet,Windows,List
	Loop,%Windows%
	{
		this_id := Windows%A_Index%
	
		WinGetTitle,this_title,ahk_id %this_id%
		if (this_title = "EVE" or InStr(this_title,"EVE - " ) = 1)   
		{
			WinMinimize, ahk_id %this_id%
		}
	}
	return
}


AddAll(){
global groupid
;global groupname
global groupcount
global groupselect

WinGet,Windows,List
;Sort, Windows
last_id := ""
Loop,%Windows%
{
	;this_id := "ahk_id " . Windows%A_Index%
	this_id := Windows%A_Index%

	WinGetTitle,this_title,ahk_id %this_id%
	if (this_title = "EVE" or InStr(this_title,"EVE - " ) = 1)   
	{
	groupid[groupcount] := this_id
	;groupname[groupcount] := this_title
	groupcount += 1
	}
}
;WinActivate %last_id%

	Splash("Add"+groupcount)
	;Sleep, 1000
	;Sort, groupid -- built in sort does nothing!
	;So implement simple bubble sort.
	for i,v in groupid {
		for j,w in groupid {
			if (j>0 and w < groupid[j-1]) {
				groupid[j]:=groupid[j-1]
				groupid[j-1]:=w
			}
		}
	}
	;	groupid=sortArray(groupid)
	s:=""
	for i,v in groupid
    s .= "`n" . v
	;MsgBox, %s%
return
}

OSK:
	;ControlSend, , {F}, ahk_id groupid[groupselect]
	Send, {%A_GuiControl%}
	return

	
~^S::
	AutoPilot()
	return
	
CtrlS:
	AutoPilot()
	SwitchForward()
	return
	
	


AutoPilot() {
	global dict
	WinGet, this_id, ID, A
	WinGetTitle, lTitle, ahk_id %this_id%
	if (InStr(lTitle, "EVE")=1) {
		dict[this_id]:=4
	}
	;d := dict[this_id]
	;Splash("AP" this_id "is" d "::" lTitle)
}

#8::
	AutoPilot()
return
	

#9::
AddAll:
	;Splash("Add All")
AddAll()
return

DeleteAll(){
	global
	groupid.Delete(0, groupcount)	
	groupcount = 0
	groupselect = 0
}

#0::
	DeleteAll()
	Splash(Group Cleared)
return

SwitchForward(direction=1) {
	global groupcount
	global groupselect
	global dict
	global groupid
	
	UnTile()
	;global groupname
	;sleep 500
	;WinMinimize, A
	If (groupcount >= 1)
	{
        AutoPilot:
		WinGetTitle, Title, A
		;MouseGetPos _lastX, _lastY
		;				if (Title="SwitchBar" or Title = "AltF4" or InStr(Title, "EVE")=1 or InStr(Title, "BlueStacks")=1) {
			;select := groupid[groupselect]
			;selectname := groupname[groupselect]
			;WinMinimize %select%
			;SplashTextOn,400,20,Switch Window, Selected %select% %selectname%.
			;Sleep 1000
			;SplashTextOff
			groupselect+=direction
			If (groupselect >= groupcount) {
				DeleteAll()
				AddAll()
				groupselect = 0
			} else {
			    If (groupselect < 0) {
					DeleteAll()
					AddAll()
					groupselect := groupcount-1
				}
			}
;		Splash("i="+groupselect+" "+)
				
			if (groupcount=0) {
				Splash("All windows disappeared")
				AddAll()
				return
			}
			
			select := groupid[groupselect]
			s := ""
  for i,v in groupid
    s .= "`n" . v
			;MsgBox, "i=" %groupselect% " -> " %select% %s%
			;selectname := groupname[groupselect]
			;WinActivate ahk_id %select%
			;WinGet, this_id, ID, A
			this_id := select
			autopiloting:=dict[this_id]
			if (autopiloting > 0) {
				Splash("Auto" autopiloting this_id)
				dict[this_id]--
				goto AutoPilot
			}
			;Splash("Manual " autopiloting selectname this_id)
			WinActivate ahk_id %select%
		;}				
	}
	else
	{
	Splash("No registered windows")
	AddAll()
	}
}




~$tab::	
;Send, {Tab}
WinGetTitle, gTitle, A
if (gTitle="SwitchBar" or gTitle = "AltF4" or InStr(gTitle, "EVE")=1 or InStr(gTitle, "BlueStacks")=1) {
	SwitchForward(1)
}
return

switch:
OnMessage( 0x200, "Drag", 1 ) 


;#1::
;Splash("Switch Forwards")
SwitchForward(1)
return

switchback:

OnMessage( 0x200, "Drag", 1 ) 
;Splash("Switch Back")
SwitchForward(-1)
return

menu:
OnMessage( 0x200, "Drag", 1 ) 
;Splash("Menu!")
mtoggle := !mtoggle
if (mtoggle) {
	gui Menu:show
} else { 
	gui Menu:hide
}

return



;https://www.autohotkey.com/board/topic/93570-sortarray/
sortArray(arr,options="") {	; specify only "Flip" in the options to reverse otherwise unordered array items

	if	!IsObject(arr)
		return	0
	new :=	[]
	if	(options="Flip") {
		While	(i :=	arr.MaxIndex()-A_Index+1)
			new.Insert(arr[i])
		return	new
	}
	list:=""
	For each, item in arr
		list .=	item "`n"
	list :=	Trim(list,"`n")
	Sort, list, %options%
	Loop, parse, list, `n, `r
		new.Insert(A_LoopField)
	return	new

}

Test:
WinMove, A, , 100, 100, 1000, 1000
return
fit:
A_Clipboard := fits[A_GuiControl]
return

;Doesn't work...
GuiClose:
exitapp

/*

SE	Sisters of Eve

AE	Amarr Empire
CS	Caldari State
GF	Gallente Federation
MR	Minmatar Republic

GP	Guristas Pirates
AC	Angel Cartel

A*	Amarr Choice Point
S*	Sisters of Eve Choice Point
G*	Gallente Federation Choice Point
?	Unknown
0	Unavailable
1	Available
2	In Progess


Amarr VIII - Emperor Family Academy
Amarr VIII (Oris) - Emperor Family Academy 

__FITS__

[Executioner, LEXI Warp]
Nanofiber Internal Structure II
Nanofiber Internal Structure II
'Halcyon' Core Equalizer I

1MN Monopropellant Enduring Afterburner
Small Clarity Ward Enduring Shield Booster
Enduring Multispectrum Shield Hardener

Salvager I
Responsive Auto-Targeting System I
Small I-ax Enduring Remote Armor Repairer
Small Asymmetric Enduring Remote Shield Booster

Small Capacitor Control Circuit I
Small Low Friction Nozzle Joints I
Small Capacitor Control Circuit I





[Executioner, Loot]
Nanofiber Internal Structure II
Nanofiber Internal Structure II
'Halcyon' Core Equalizer I

1MN Monopropellant Enduring Afterburner
Small Azeotropic Restrained Shield Extender
Small Azeotropic Restrained Shield Extender

Salvager I
Salvager I
Salvager I
Salvager I

Small Cargohold Optimization I
Small Low Friction Nozzle Joints I
Small Cargohold Optimization I


[Venture, EP-S 9000]
Mining Laser Upgrade II

1MN Monopropellant Enduring Afterburner
Medium Shield Extender II
Enduring Multispectrum Shield Hardener

EP-S Gaussian Scoped Mining Laser
EP-S Gaussian Scoped Mining Laser
Festival Launcher

Small EM Shield Reinforcer I
Small Core Defense Field Extender I
Small Core Defense Field Extender I



Hornet I x2

Barium Firework x50
Medium Azeotropic Restrained Shield Extender x1
Mining Laser Upgrade I x1

[Executioner, Null Burn Bubble]
Nanofiber Internal Structure II
Nanofiber Internal Structure II
'Halcyon' Core Equalizer I

Small Azeotropic Restrained Shield Extender
5MN Quad LiF Restrained Microwarpdrive
Small Azeotropic Restrained Shield Extender

Salvager I
Salvager I
Small Tractor Beam II
Small Tractor Beam I

Small Polycarbon Engine Housing I
Small Auxiliary Thrusters I
Small Auxiliary Thrusters I




Microwave S x14
Scourge Auto-Targeting Light Missile I x5466
Multifrequency S x7
Radio S x7
Eifyr and Co. 'Rogue' Warp Drive Speed WS-605 x1
Limited Memory Augmentation x1
Inherent Implants 'Squire' Capacitor Management EM-801 x1
Eifyr and Co. 'Rogue' Evasive Maneuvering EM-701 x1
Limited Cybernetic Subprocessor x1



[Algos, SoE]
Damage Control II
Type-D Restrained Shield Flux Coil
AE-K Compact Drone Damage Amplifier

1MN Monopropellant Enduring Afterburner
Medium Shield Extender II
Enduring Multispectrum Shield Hardener

Festival Launcher
75mm Compressed Coil Gun I
75mm Compressed Coil Gun I
75mm Compressed Coil Gun I
75mm Compressed Coil Gun I
75mm Compressed Coil Gun I

Small Core Defense Field Extender I
Small Core Defense Field Extender I
Small Core Defense Field Extender I



Hornet I x12

Thorium Charge S x200
Antimatter Charge S x200
Blood Dagger Firework x198
Iron Charge S x2600
Salvager I x6
Auto Targeting System I x1



[Executioner, Zippy]
Nanofiber Internal Structure II
Nanofiber Internal Structure II
Type-D Restrained Inertial Stabilizers

5MN Quad LiF Restrained Microwarpdrive
Small Azeotropic Restrained Shield Extender
Small Azeotropic Restrained Shield Extender

Festival Launcher
Small Focused Anode Particle Stream I
Small Focused Anode Particle Stream I
Small Focused Anode Particle Stream I

Small Auxiliary Thrusters I
Small Hyperspatial Velocity Optimizer I
Small Hyperspatial Velocity Optimizer I


[Caracal, SoE Multibox]
Ballistic Control System II
Ballistic Control System II
Ballistic Control System II
Damage Control II

Multispectrum Shield Hardener II
Multispectrum Shield Hardener II
Large Shield Extender II
Large Shield Extender II
50MN Quad LiF Restrained Microwarpdrive

Rapid Light Missile Launcher II
Rapid Light Missile Launcher II
Rapid Light Missile Launcher II
Rapid Light Missile Launcher II
Rapid Light Missile Launcher II

Medium EM Shield Reinforcer I
Medium Core Defense Field Purger I
Medium Core Defense Field Purger I



Hobgoblin I x2

Nova Fury Light Missile x1211
Scourge Auto-Targeting Light Missile I x1565
Scourge Light Missile x2014
Civilian Relic Analyzer x1
Festival Launcher x1

[Drake, *PvE]
Ballistic Control System II
Ballistic Control System II
Type-D Restrained Shield Power Relay
Type-D Restrained Shield Power Relay

Large Shield Extender II
Large Shield Extender II
10MN Afterburner II
Enduring Multispectrum Shield Hardener
Enduring EM Shield Hardener
Pithum C-Type Thermal Shield Amplifier

'Arbalest' Heavy Missile Launcher
'Arbalest' Heavy Missile Launcher
'Arbalest' Heavy Missile Launcher
'Arbalest' Heavy Missile Launcher
'Arbalest' Heavy Missile Launcher
'Arbalest' Heavy Missile Launcher
Small Knave Scoped Energy Nosferatu

Medium Core Defense Field Purger I
Medium Core Defense Field Purger I
Medium Core Defense Field Purger I



Salvage Drone I x5

Scourge Heavy Missile x4076
Scourge Auto-Targeting Heavy Missile I x854
Mobile Tractor Unit x1


[Arbitrator, *Arbitrator]
Damage Control II
Shield Power Relay II
Shield Power Relay II
Drone Damage Amplifier II
Drone Damage Amplifier II

Large Shield Extender II
Large Shield Extender II
Compact EM Shield Amplifier
10MN Monopropellant Enduring Afterburner

Focused Modulated Medium Energy Beam I
Prototype 'Arbalest' Rapid Light Missile Launcher
Prototype 'Arbalest' Rapid Light Missile Launcher
Prototype 'Arbalest' Rapid Light Missile Launcher

Medium Core Defense Field Purger I
Medium Core Defense Field Purger I
Medium Core Defense Field Purger I



Mining Drone I x10
Hobgoblin I x9
Valkyrie I x5

Barium Firework x70
Mjolnir Rocket x100
Inferno Light Missile x100
Proton S x100
Inferno Auto-Targeting Light Missile I x3338
Standard M x1
Festival Launcher x1
Data Analyzer I x1

[Bellicose, *PVE Light Missiles ]
Damage Control II
Ballistic Control System II
Ballistic Control System II
Ballistic Control System II

Large Shield Extender II
Large Shield Extender II
Large Shield Extender II
Enduring Multispectrum Shield Hardener
50MN Quad LiF Restrained Microwarpdrive

Prototype 'Arbalest' Rapid Light Missile Launcher
Prototype 'Arbalest' Rapid Light Missile Launcher
Prototype 'Arbalest' Rapid Light Missile Launcher
Prototype 'Arbalest' Rapid Light Missile Launcher

Medium EM Shield Reinforcer II
Medium Core Defense Field Extender I
Medium Core Defense Field Extender I



Hornet I x5
Mining Drone I x5

Caldari Navy Scourge Light Missile x1496
Scourge Auto-Targeting Light Missile I x277
Caldari Navy Nova Light Missile x210

[Jackdaw, *Simulated Jackdaw Fitting]
Crosslink Compact Ballistic Control System
Ballistic Control System II
Ballistic Control System II

Medium Clarity Ward Enduring Shield Booster
Multispectrum Shield Hardener II
Small Compact Pb-Acid Cap Battery
Eutectic Compact Cap Recharger
1MN Afterburner II

Light Missile Launcher II
Light Missile Launcher II
Light Missile Launcher II
Light Missile Launcher II
Light Missile Launcher II
Auto Targeting System I

Small Thermal Shield Reinforcer I
Small Warhead Calefaction Catalyst I
Small Polycarbon Engine Housing II




Nova Fury Light Missile x820
Nova Light Missile x3000
Caldari Navy Nova Light Missile x835
250mm Light Carbine Howitzer I x1
100mm Rolled Tungsten Compact Plates x1


[Executioner, Lexi]
Nanofiber Internal Structure II
Nanofiber Internal Structure II
Nanofiber Internal Structure II

1MN Monopropellant Enduring Afterburner
Linked Enduring Remote Sensor Booster
Medium Azeotropic Restrained Shield Extender

Small I-ax Enduring Remote Armor Repairer
Small Asymmetric Enduring Remote Shield Booster
Festival Launcher
Auto Targeting System I

Small Capacitor Control Circuit I
Small Capacitor Control Circuit I
Small Capacitor Control Circuit I




Targeting Range Script x1
Scan Resolution Script x1
Crown Imperial Firework x17



[Magnate, Nimble Cargo]
Nanofiber Internal Structure II
Nanofiber Internal Structure II
Nanofiber Internal Structure II
Nanofiber Internal Structure II

Compact EM Shield Amplifier
1MN Monopropellant Enduring Afterburner
Small Azeotropic Restrained Shield Extender

Salvager I
Salvager I
Salvager I

Small Cargohold Optimization I
Small Cargohold Optimization I
Small Hyperspatial Velocity Optimizer I



Salvage Drone I x3
Hobgoblin I x5

Expanded Cargohold II x4

[Punisher, 50MN Rocket]
Micro Auxiliary Power Core II
Micro Auxiliary Power Core II
Capacitor Power Relay II
Capacitor Power Relay II
Overdrive Injector System II

50MN Y-T8 Compact Microwarpdrive
Cap Recharger II


Small Ancillary Current Router II
Small Ancillary Current Router I
Small Auxiliary Thrusters II



[Punisher, 50MN Rocket T1 ]
Micro Auxiliary Power Core I
Mark I Compact Power Diagnostic System
Type-D Restrained Capacitor Power Relay
Mark I Compact Power Diagnostic System
Mark I Compact Power Diagnostic System

50MN Y-T8 Compact Microwarpdrive
Eutectic Compact Cap Recharger


Small Ancillary Current Router I
Small Ancillary Current Router I
Small Auxiliary Thrusters I









__END FITS__

*/

YellowAlertYield() {
    global yellow_alert_ids
    
    ; Loop through all yellow alert windows and minimize them
    for i, id in yellow_alert_ids {
        if (WinExist("ahk_id " . id)) {
            WinMinimize, ahk_id %id%
        }
    }
    
    Splash("Minimized all Yellow Alert windows")
    return
}
