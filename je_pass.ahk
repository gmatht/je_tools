; Script to log into multiple EVE accounts at once
; Windows only (haven't tested on Wine, probably won't work on native MacOS)
; Assumes that all the accounts you want to log into have the same password.; Assumes your EVE accounts are tied to a GMail, that you have logged into on MS Edge.
; Assumes you have disabled msedge's buggy "saving form data" feature.
; Most likely to work with Windows Desktop Scaling at 100%. Setting the Resolution to Full High Definition (FHD/1080p) may also help
; But you may have to run AutoHotKey.ahk to find the Text:= lines for your machine.

; CCP doesn't whitelist scripts, but...
; 1) I have asked if a login script was OK, and they *didn't* scream "no".
; 2) This script performs no in-game actions
; 3) Reinstalling windows and running this script gives you no advantage over a user that didn't have to reinstall.
; 4) Enabling users to easily reinstall and clean off malware is probably a good thing.

#SingleInstance Force
#Include <FindText>
SetTitleMatchMode, 2

;Configure these vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
Edge:="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
Account_Names :=  []
Default_Password := "CCP_MasterKey_Fx7Jk1" 

Reset_Names := []
;Uncomment to put Accounts you need to reset the password of here.
;You don't need to do this if auto_reset is true, but it will be a bit faster
;Reset_Names :=  StrSplit("Sandman Dream Del", A_Space)

Account_Names := []
;Uncomment to set account names to log into on this machine (With Default Password)
;Account_Names := StrSplit("DrJekyll MrHyde Father Son HolyGhost", A_Space)

auto_reset := 0
;Uncomment to automatically change the password if EVE complains the password is wrong
auto_reset := 1

;Uncomment to reset an account to a non-default password
;ResetOneAccount("MySuperSecretAccnt", "Password123")

;Uncomment to add an account that does not use the default password
;AddOneAccount("MySuperSecretAccount", "Password123")

;END CONFIGURATION ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



CoordMode, mouse, Screen
MouseGetPos, xPos, yPos	

Gui, Add, Edit, Readonly x0 y10 w400 h300 vDebug
Gui, Show, w420 h320 x%xPos% y%yPos%, Debug Window

DebugAppend("This is a test")

DebugAppend(Data)
{
GuiControlGet, Debug
GuiControl,, Debug, %Debug%%Data%`r`n
}

sleep 3000

;;; MAIN FOR LOOPS ;;;

For k1, account_name in Reset_Names
{
    ResetOneAccount(account_name, Default_Password)
}

For k1, account_name in Account_Names
{
    AddOneAccount(account_name, Default_Password)
}


FFindText(ByRef X, ByRef Y, a, b, c, d, e, f, Text)
{
    Loop
    {
        if(ok:=FindText(X, Y, a, b, c, d, e, f, Text)) {
            Sleep 100
            FindText().Click(X, Y, "L")
			if (ok <> "NULL") {
				break
			}
        }
        Sleep 200
    }
  return ok
}


FClick(ByRef X, ByRef Y, a, b, c, d, e, f, Text)
{
	if FFindText(X, Y, a, b, c, d, e, f, Text) {
	    FindText().Click(X, Y, "L")
	}
}

ResetOneAccount(Uname, Password)
{
	;goto lDEBUG

    global Edge
	Run,taskkill /im "msedge.exe"
	Sleep 1000
	Run,taskkill /im "msedge.exe" /F5
	Sleep 1000
	
	

	DebugAppend("Run Edge")
		
	Run, %Edge% "https://secure.eveonline.com/RecoverAccount"
	
	Sleep 2000
	
	DebugAppend("Insert Username")
	
	;UserName or Email
	Text:="|<>*218$71.0000zy0000020001zs000004000300000008000600000000000A0000000TVj0M05yTUzVzXw0k0DzzXzW3701U0QC36346A03zkkM6A68AM07zVUkA0AEMk0A031UM3sUlU0M0630lzl1X00k0A61X1W3601U0MA36346A0300kM6A68AM0601UkAMQTsk0DzX1UMzszVU0Tz630kylU"
	Text:="|<100%>*245$7.07rzXVUkMA631UkMA631UkMA631UkMA631UkMA631UkMC7lyT0E"

	if (ok:=FFindText(X, Y, 2676-150000, 1471-150000, 2676+150000, 1471+150000, 0, 0, Text))
	{
       FindText().Click(X, Y, "L")
       Sleep 500
    }
	
	; PiC6CMsgBox, "U1: " %Uname%
	
	Send, %Uname%
	Sleep 500
	DebugAppend("Submit")
	;Sumbit
	Text:="|<>*178$68.k0y7sS01wDy807Vy7U0D1z001sTVs03kTk3wC7sS7kw3s0z3Vy7Vw70y0DksTVsT1k703zy7sS7kQ1k07zVy7VwD08007sTVs03k08U0S7sS01w82D03Vy7U0D21Xz0sTVsTVkkMzwC7sS7sQCC0z3Vy7Vy73zUDksTVsTVkzs3wC7sS7sQDy003U07U073zU01s03s03kzsU0zU1y01wDy8"
	Text.="|<100%>*173$56.UAQM3XtW001760MwMU0QFlba76D774QNtVVXlkz76QM8MwS0llU606D7k4QM1U9Xlzl76SMWMwQQFlbaBaD774QNtXtXlk1060MyMwS0s3U6DaD7U"


	if (ok:=FFindText(X, Y, 2676-150000, 1471-150000, 2676+150000, 1471+150000, 0, 0, Text))
	{
       FindText().Click(X, Y, "L")
       Sleep 500
    }

	Sleep 999

	
	

     ;IfWinExist GMail
     ;{
     ;  WinActivate
     ;} else {
		Run, %Edge% "www.gmail.com"
	;}
	
	 ;Inbox
	; Text:="|<>*123$71.s0000D000001k0000S000003U0000w00000700001s00000C00003k00000Q00007U00000s01w0D3s00TVkDjy0STw07znUTzy0xzw0Tzr0zzy1zzw1zzy1zzw3zzw7zzw3y3s7s7sDkDs7s7kDU7kT0DkDU7UT07lw0TUT0D0w0DXs0z0y0S1s0T7k0y1w0w3k0yDU1w3s1s7U1wT03s7k3kD03sy0DkDU7UT0Dlw0TUT0D0y0T1w1z0y0S1z1y3w7y1w0w3zzs3zzw3s1s7zzk7zzs7k3kDTz07zx"
    ; FClick(X, Y, 394-150000, 548-150000, 394+150000, 548+150000, 0, 0, Text)

	; lDEBUG:
	;EVE
	DebugAppend("Selecting EVE email")
	Loop {
		Text:="|<>*147$178.zzyDk0DVzzy000zz000003sDk00003zzsT00y7zzs007zz00000DUz00000DzzVw07sTzzU00zzy00000y1s00000zzy7s0T1zzy007zzw00003s0000003s00DU1w7k0000zUDs0000DU000000DU00y0DkT00007s0TU0000y0000000y003w0y1w0000T00z00DU3s0007k03s007k3s7k0003w01w3nzUDUS1tzk0zU00T0TUT0000DU07sDTz0y1s7jzU7y000y1w1w0000y00DUzzw3s7UTzy0zzzk3s7k7zzU03s00y3zzsDUS1zzw3zzz0DUy0Tzy00DU03sDkTUy1s7sDkTzzw0T3s1zzs00y00DUy0y3s7UT0T1zzzk1wDU7zzU03s00y3s3sDUS1w1wDjzz07lw0Tzy00DU03sDUDUy1s7k7kzy000Dbk1w0000y00DUy0y3s7UT0T3zs000yT07k0003s00y3s3sDUS1w1wDzU003vs0T0000DU07kDUDUy1s7k7kyy0007zU1w0000T00T0y0y3s7UT0T3vs000Ty07k0001y03w3s3sDUS1w1wDjU001zk0T00007w0TUDUDUy1s7k7kTzzy03z01zzw00Dw7y0y0y3s7UT0T1zzzs0Dw07zzs00Tzzk3s3sDUS1w1w3zzzU0zU0TzzU00zzy0DUDUy1s7k7kDzzy01y01zzy001zzk0y0y3s7UT0T0Tzzs07s07zzs001zw03s3sDUS1w1w0M"
		Text.="|<100%>*158$26.zA6Tjv1bz0stUk6AMA1X63wRVyk3MMA0y630D1UzVkTzsQ7y"
		Text.="|<100%>*159$26.zA6Tjv1bz0stUk6AMA1X63wRVyk3MMA0y630D1UzVkTzsQ7y"


		;REFRESH
			Text2:="|<refresh>*177$33.00Tk1k0TzUT0Dzz3s3zzyT0zszvsDs0zz3w01zsz007zDk00Ttw01zzD00Tzvs03zzS00Tzvk01zyS00007k0000y00003k000SS0003nk000ST0007ls000wDU00DVy003w7s00z0TU0Dk1z07w07z7z00Tzzk01zzw003zy0003y00U"
			Text2.="|<refresh>*177$33.00Tk1k0TzUT0Dzz3s3zzyT0zszvsDs0zz3w01zsz007zDk00Ttw01zzD00Tzvs03zzS00Tzvk01zyS00007k0000y00003k000SS0003nk000ST0007ls000wDU00DVy003w7s00z0TU0Dk1z07w07z7z00Tzzk01zzw003zy0003y00U"
			
			Text2.="|<100%>*194$13.3tbzrXv1zVzUTk0M0y0v0NswTw3sE"

			if FFindText(X, Y, 1181-150, 621-150, 1181+150, 621+150, 0, 0, Text) {
				break
			}
			FClick(X, Y, 394-150000, 548-150000, 394+150000, 548+150000, 0, 0, Text2)
			Sleep 2000
}


    ;Text:="|<>*147$84.zzyDk0DVzzy000zzy7k0DVzzy001zzy7k0TVzzy003zzy7s0T1zzy007y003s0T1w0000Dy003s0z1w0000Ty003w0y1w0000Ty001w0y1w0000zy001w1y1w0000yy000y1w1w0000yzzw0y1w1zzs00yzzw0y3s1zzs00yzzw0T3s1zzs00yzzw0T3s1zzs00yzzw0T7k1zzs00yy000Dbk1w0000yy000Dbk1w0000yy000DjU1w0000yy0007zU1w0000Ty0007zU1w0000Ty0007z01w0000Tzzy03z01zzw00Dzzy03z01zzy007zzy03y01zzy003zzy01y01zzy001zzy01y01zzy000U"
	FClick(X, Y, 1181-150, 621-150, 1181+150, 621+150, 0, 0, Text)
	
	sleep 3000
	
	Send {PgDn 99}
	
	sleep 1000
	
	DebugAppend("Click Reset Password Link")
	;Reset Password
	Text:="|<>*183$91.0000zw0000zk007U000Dy0000Tk001k0003z0000Ds000M0001zU0007s00040000Tk0003w0T020zy0Ds1zzzw0zs10TzU3w0zzzy0zy00Dzs1y0Tzzz0Tz007zw0z0DzzzU7zzs3zy0TU7zzzk0zzw1zz0Dk3zzzs03zy0zz0Ds1zzzy00Dz0Ty07w0003z000zU0003y0001zk007k0003z0000zw000s0003zU000Tz000A0003zk000Dzk0020007zs0007zz001000Dzw0zzzzzw000D03zy0Tzzzzzk007s0zz0Dzzzzzz003y0DzU7zzzzzzk01zU3zk3zzzw7zw00zk0zs1zzzs3zy00Tw0Tw0zzzw0zz00Dz07y0Tzzy0TzU07zU3z0DzzzU7zU03zs0zU0007k0z001zy0Dk0003s00020zz07s0001y00010Tzk1w0000zU001UDzw0S0000Ts001k7zy0D0000Dz003zzzzzzzzzzzzs07y"
	Text.="|<100%>*182$62.07U0w3s0M000M0C0S0600060303U1U07lXzlsszzXlwMzwSCDzswT6071zU1yD01U1s3s0TXk0s0T0C07sw0yDzz1XzyD67XzlwMzzXlkszwS6DzswS60301U1yD7lU0s0s0TXly80D0y07sy"

	FClick(X, Y, 1903-150000, 996-150000, 1903+150000, 996+150000, 0, 0, Text)
	
	lDebug:
	
	DebugAppend("Select Password Input Box")
	Unselected:="|<unselected>*232$62.3zzzzzzzzzlU000000000U000000000E000000000A00000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000U000000000800000000020000000000k00000000040000000000U00000000060000000000zzzzzzzzzy"
	Selected:="|<>*186$20.0TzkzzwS00C007001U00M00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A003000k00A001U00M007000w007zzkzzw1zzU"
	
	Selected.="|<100%>*244$7.Djz731UkMA631UkMA631UkMA631UkMA631UkMA631UkMC7lyTU"



	Sleep 1000

	Loop {
		if (ok:=FindText(X, Y, 685-150000, 889-150000, 685+150000, 889+150000, 0, 0, Selected))
		{
			break
		}
		if (ok:=FindText(X, Y, 685-150000, 889-150000, 685+150000, 889+150000, 0, 0, Unselected))
		{
			FindText().Click(X+3,Y+3, "L")
		}
		Sleep 500
	}


	DebugAppend("Sending Password")
   Send, %Password%

  	sleep 800
	
	DebugAppend("Submitting Password, or ^V")
	clipboard := Password
;	;Text:="|<>*176$91.U0wDkzkzkz3s0D000C7sTkDsDVs03U0073wDs7w7kw01k0T3Vy7w1y1sQ7ksQDVkz3w0z0wC3sQC7ksTVy0TUC71;wC73zwDky67k73Uzz3Vzy7sT33s1VkTzVkzz00DVVw0EsDzk0TzU07VsS48Q60s0Dzk03kwD20C30Q07zsTVsS3VU71UC73sQDks01kk3U;y73VwC7sQ00sQ1kT3Vky73wC00QD0sDVksT3Vy73wC7UQ7ksQ01kz3Vy73sD00Q000sTVkz3Vw7U0C0U0wDksTVkz3s0D0E"
	;FClick(X, Y, 743-150000, 1146-150000, 743+150000, 1146+150000, 0, 0, Text)
	Send {Enter}
	DebugAppend("Sleeping For 5 Seconds")
	Sleep 5000


   } ;;; end RESET_ONE_ACCOUNT ---------------------------------------------------


AddOneAccount(Uname, Password)
{
	; MsgBox, %Uname%

	global Edge
	global auto_reset

	ft_Verification:="|<>*77$69.0w07ls03Xs0M7U0SD00QS01zwTXlszzXly7zXyCD7zwSDszwTllszzXlz7zXyCD7zwSDszwTllszzXlzzzXyCD7zwSDz0wTXlszzXlzs7U0SD00wSDzzw07ls07XlzzzXlyD7zwSDzzwSDlszzXlzzzXsyD7zwSDszwT7lszzXlz7zXsyD7zwSDszwTXlszzXky03XwSD7zwS010QTXlszzXs0Q"
	ft_Verification.="|<>*77$71.wTy0Dk3s0D01szs0D03k0C03lzlwQTXXwQTzXzbwsz77wszz7zDtlyCDtlzyDyTzXwQTnXzQTwzz7sszb7ysztzyDllzCDwlznzwTXXyQ00Xzbzsz77ws017zDzlyCDtlzkDyTzXwQTnXzUTwzb7sszb7zUztzCDllzCDzVznyQTXXyQTz3zXssz77sszz7z01s0S01k0SDz07s1w07U0U"
	ft_Verification.="|<>*77$70.03lk0Az0DwT007700ns0Tlw3wQQTzD7sy3zDtllzwwTXsDwzb77znlyDYTnyQQTzD7zwFzDtllzwwTznbwzb77znlzyCDnwQQ07D7zssz01lk0QwTzbnw0D77znlzwT7nlwQTzD7zlwTDbllzwwTX00wyD77znly803nswQTzD7sXyDDnllzwwTWDswz777zns0MzXnwQQTzDk3XyDU"
	ft_Verification.="|<>*123$65.zzzzzzzXy1lzzzzzzz7s3XzzzzzzyDlz7zzzzzzzzXzzzzzzzzzz7zXsT0Dl3ls0s7kw0DU7Xk1kDVkwT1z7szUT3Vsy7yDlz0SD3lwTwTXy8wS03szsz7wEkw07lzlyDslXsTzXzXwTlW7kzz7z7szXUTVsyDyDlz70z3lwTwTXyC3z03szsz7wS7z0DlzlyDsU"

	ft_Verification.="|<>*71$71.Q1A3bjkC1UA0SSNnDT79nCNwwwraCySHqSnxttjARwzbgxbtnnSOPtzDNvDnbawqrnySnq1rDBtgjbwxbgy6SPnQTD9vDNzAwrasySHqSnw"


	DebugAppend("Uname")
	DebugAppend(Uname)

	DebugAppend("Raise EVE Launcher")
	 ; WinActivate, "EVE Online Launcher" <- doesn't work?
	 IfWinExist EVE Online Launcher
	 {
	   WinActivate
	 }

	 Sleep 200
	
	 ;goto lInvalid

	DebugAppend("(+)")
	 ;Already Have an Account
	 Text:="|<>*125$67.y7z3zs07k07y1zVzw01s03z0zkzy00w01zUDsTz3sS3zzU7wDzVw71zzk3y7zky3Uzzkkz3zsT1kTzsMTVzwDUsDzwADkzy7kw03wD3sTz00S01y7VwDzU0D00z3ky7zk0DUzz00D3zsQDkTz007VzwC3sDzU03kzy7Vw7zkTVsTz3ky3zsDkw03VsD00Q7sS01ky7U0C3wD00sT3k07E"
	 
	 

	Text:="|<(+)>*123$26.y1s7z3zkzVzy7kzzkwTVyCDsTlXy7wMzVz4S01s7U0S1s07US01sXy7wMzVz6DsTlly7swDzwDVzy7wDz3zUS1zw00zzk0zzzVzy"
	Text.="|<100%>*118$15.y3z07lwQztD79swA1VUAA1VswD7AztnyT07w1w"

	 ;if (ok:=FindText(X, Y, 2676-150000, 1471-150000, 2676+150000, 1471+150000, 0, 0, Text))
	 ;{
	 ;  FindText().Click(X, Y, "L")
	 ;  Sleep 2000
	 ;}

	FFindText(X, Y, 2676-150000, 1471-150000, 2676+150000, 1471+150000, 0, 0, Text)

	DebugAppend("USERNAME")
	 ft_USERNAME:="|<>*70$56.1UM6QwwwkCNyRbCDDAzqTjMnVlXDzbvqAsQMnls6xdArEg26TUP3AqPDxbtCkrBanzNyti83TgzaTiPmSrvD1UPqwbhyk8"
	 ft_USERNAME.="|<>*76$71.07U0yDwTsTsy0D00wDszkzkzzyDlsTlz1zVzzwTlkTXyFz1zzszXUT7wny3zzlz70yDlXw3zzXyC8wTb7s7zz7wQFsyDDl40yDlsllwSDX81w03lXXtwT6Dzs0DXX7XwSCTzlsz7WD7swQzzXlyD4S01sxzz7lwT0s01lzzyDXsy1lz3XzzwT7ly3Xz77zzsz7Xw77yCDU3lyD7wCDwQT07XwSDwQTssz"
	 ft_USERNAME.="|<>*73$69.0yDlz7wTwQ003lyDsTVz3U0yC7ly3wDsQTzlkyDkTUy3XzyC3lyFw7kQTzlkSDWDUQ3XzyCFlwtw3YQTzlmCD77W8XXzyCMlsswNAQ083naDDbX1XU10yQFlwQQQQTz7nkCDXXXXXzsyS1k0ATwQTz7nsA01XzXXzwST1XyATwQTzXnwATlXzXXzwSTVXyATwQ07lnyATlXzXU0U"
	 ft_USERNAME.="|<>*74$71.0D01k0yTlz7w0C03U0wTXyDtwQTz7ssT7sDrwszyDlkyDkTjtlzwTXUwTYTTzXzsz71sy8yTz7zlyCFlwtw7yDzXwQnXlls1w077stX7XXo0s0C03naDDbjVlzw0Db4QT7TlXzswTD8syCzX7zlsyS1k0Bz6DzXlwy300PyATz7ltw6DsnwszyDXnwATlU1k0QT7bwMzX07U0sz7Dslz6U"
	 
	;100% scaling ft_USERNAME.="|<>*70$63.M60kAxwwyM3CHywXj7bXTPmTrYRsQQPvTnywVjHX3TMyTrYBnR+PvUk61YiNgH0TWTqQZrBaPvyHytaA1jnTPmTrAlbZyPvCHytbAwjnTs60rYxbZyM4"
	ft_USERNAME.="|<>*64$47.A3DDDDY1vmCQSS9zrYQsQQHzD8NoskbySEnBkVDY1YaNYG0tb9Bn9YznaME6T9zbAkbYyHzCNlD9wbmSHWSHt0E"

	


	 if (FFindText(X, Y, 679-150000, 299-150000, 679+150000, 299+150000, 0, 0, ft_USERNAME))
	 {
		goto lUSERNAME
	 ;   MsgBox, "lUsername"
	 }
	  else {
		MsgBox, "NOT!!!! lUsername"
	 }

	DebugAppend("Find Verification")
	if (ok:=FindText(X, Y, 1437-150000, 1102-150000, 1437+150000, 1102+150000, 0, 0, ft_Verification))
	{
		goto lVERIFICATION
	}

	 ; 1 Add Account (+)
	 t1:=A_TickCount, Text:=X:=Y:=""

	DebugAppend("(+) 2")
	 Text:="|<>*127$28.sDzkT1zzUwDzz3Vz3y6DwDwEzkzk7z3zUTs7y1s01s7U07US00S1s01s7y1zUTwDy0zkzkXz3z67wDsQDzz3kTzsDUzz1z0zkDy001zy00Tzy07zU"
	 Text.="|<>*113$14.w3w4CDlbyHnkwwA330kwwDD9zbDlk0z0y"
	 Text.="|<100%>*118$15.y3z07lwQztD79swA1VUAA1VswD7AztnyT07w1w"
	 ;Text:="|<>*118$15.y3z07lwQztD79swA1VUAA1VswD7AztnyT07w1w"


	 ok:=FFindText(X, Y, 465-150000, 816-150000, 465+150000, 816+150000, 0, 0, Text)

	 lUSERNAME:
	 ; #2 UserName
	 Text:="|<>*70$56.1UM6QwwwkCNyRbCDDAzqTjMnVlXDzbvqAsQMnls6xdArEg26TUP3AqPDxbtCkrBanzNyti83TgzaTiPmSrvD1UPqwbhyk8"

	DebugAppend("USERNAME 2")
	 ok:=FFindText(X, Y, 679-150000, 299-150000, 679+150000, 299+150000, 0, 0, ft_USERNAME)
	 Send %Uname%

	 Sleep 200


	Loop {
	 DebugAppend("Password")	
	 ; 3 Password
	 Text:="|<>*69$61.ww30rQkQ30gStbPiHaRb67Srhr9nSnX3jtytgtjNlBkQ78aQrgtaS7VYHCM6QrDvyufbAbCE4xjQFnatb9vQri8tnQnYxUM7CS3jM6"
	 Text.="|<>*70$60.ts61itUs61lvaRitCNqQkvqxitCPqQkvyTiPCPqQasC3YHCPqQaS7VYHCM6QiTrxpLCNCQ0Hqxl7CPaQDPaxl7CPaQDM61nbUvq1U"
	 Text.="|<>*77$71.0Tk0wTbsy07s0D00szDls07nwSDllyTXVyDbswzlXwz77yDDltzX7tyCDwSTXnzCDlwQTswzzXzyD3tszlszz1zwS7XlzXk7y0DswD7Xz7U1z07tkCD7yDA1zs7lUQyDwSTXzy7X4lwTswz7zyD6MXszltyDzwT8lDlzXnwQTsy1kTXz7bsszlw7Uz7yDDlsz3wD1y7sy03k0DsS7y01w0Dk0zlyDy07t"

	Text.="|<>*76$71.lzk3w0QTDXk1Vz03k0MyT7023wTXbslwyATY7sz6DlXtwMzd7lyATX7nslz2DXzszyD7nXy6T7zlzyS7b7wQT1zkTwwCCDswy0DU3ssQQTnszUDs1lUtszblzwDz3n0nlzDnzwTzbaN7Xy03zszzD4mD7w06DlXyT1UyDvyATX7wy71wTrwMz6DlwD3szDss0C03sSDs0Tls0y0DswTs0U"
	 Text.="|<100%>*71$59.S1kBng3UQ2wtCPbNnCPkvmSrCraQrVrwziNjAtj/XsTAnSNnSHUs6Fawk6wbszCVRtaRsDtzQEvnAvn/mSslraNraHYtlXbAtjAUQ3nD0tn0k"
	Text.="|<100%>*71$57.s70rCkC1kDCHatqQnawvmSrCraQrbTnytawnawsy7nAraQrXUs6Fawk6wTXwu5raNrXyTr4CwnCw/mSslraNrVCHb6CQnaw870wnkCQkA"


	 ok:=FFindText(X, Y, 677-150000, 378-150000, 677+150000, 378+150000, 0, 0, Text)
	 Send %Password%
	DebugAppend("Sign In")

	 Send {Enter}
	 ; 4 Sign In
;	 Text:="|<>*165$58.UCC0wwzlXWAMsllnz669lXbb3DwMMbyCSQAzlUW7stzkHz62A3Xbz9DwM0y6CMQUzlW3wMtln3z681lXbbADwMk26CAQszlXW0ss3nXz6C8"
	 ;Text.="|<>*176$70.k0TsTw07z3z000zVzU0DwDw001y7w00TkTk3y7sTkzVz1z0TsTVz3y7w3w1zVy7wDsTk7k7zDsTkzlz0T0DzzVz3zzw0w0Dzy7wDzzl3k07zsTkzzz67201zVz3zzwMQD03y7wD0TlkkzU7sTkw1z713zsTVz3k7wS4DzVy7wDsTlw07y7sTkzVz7k0TsTVz3y7wTU1zVy7wDsTly07y7sTkzVz7w000TVz007wTk003y7y00zlzUU0TsTw07z7z2"
	;	 Text.="|<>*175$61.U0zXz03y7w00Dlz00z3y0y7sz3sDUz0zXwTVy7kDUTlyDkz3s7kDsz7sTnw1s7zzXwDzy0w0Tzly7zz0C80zsz3zzV7607wTVk7kVXs1yDks3sMFzkT7sTVwC8zwDXwDky703y7ly7sT3k1z3sz3wDVs0zVwTVy7ky0DVyDky3sT000z7w03wDkU0zXz03y7wE"


	 ;ok:=FFindText(X, Y, 839-150000, 463-150000, 839+150000, 463+150000, 0, 0, Text)
	
	 Sleep 2000
	 Loop {
	   If A_TimeIdle > 2000
		 break 1
	 }
		lInvalid:
		ft_Invalid:="|<>*121$67.3zzzzzzzzlw1zzzzzzzzsy0zzzzzzzzwT0TzzzzzzzyDwDzzzzzzzz7y7k0z7lw0TXs3s0DXsw07lw1w33lwS73sy0y7VsyD7lwT0T7kwT7XsyDUDXsSD3zsT7k7lwD3Xw0DXs3sy7llw07lw1wT3sEyDXsy0yDVy8z7lwT0T7kz0TXkyDUDXsTkTkkT7k7lwDsDs0DXs3sy7wDy17lwE"
		;ft_Invalid.="|<100%>*113$69.DzzzztnyDzztzzzzzDzlzzzDzzzztzyDzztkCQs7CQ1zCQC0na8tn4Dtn1naAnbCMlzCMCQlb0tn6DtnVnb8k7CMlzCSCQsCQtn6Dtn1nbVl7CMVz0MCQwT0tnUDs3Y"
		ft_Invalid.="|<>*111$50.Dzzzztny3zzzzyTzUzzzzzbzsC1nb0tnU3UAtWCQk0tn6MnbAMCQlb0tn63bCFUCQlUtnUtnbAMCQwC8tn03bD7kCQs2"

		DebugAppend("Enter Loop")
		Loop {
			 if FindText(X, Y, 1437-150000, 1102-150000, 1437+150000, 1102+150000, 0, 0, ft_Verification)
			 {
			   FindText().Click(X, Y, "L")
				   break 2
			   ;Sleep 2000
			 }
			 ;if FindText(X, Y, 1437-150000, 1102-150000, 1437+150000, 1102+150000, 0, 0, ft_Invalid)
			 if FindText(X, Y, 1437-150000, 1102-150000, 1437+150000, 1102+150000, 0, 0, ft_Invalid)
			 {
				if (auto_reset) {
					ResetOneAccount(Uname, Password)
					IfWinExist EVE Online Launcher
					{
						WinActivate
					}
					continue 2
				} else {
					DebugAppend("auto_reset not enabled")
					Sleep 2000
				}
			}
			
		 }
	}

	;MsgBox, "Found"

	 lVERIFICATION:
	 ; Firefox doesn't support select all on raw XML
	 ; Run, %A_ProgramFiles%\Mozilla Firefox\firefox.exe "https://mail.google.com/mail/u/0/feed/atom"
 	DebugAppend("Edge -> Atom")
	 Run, %Edge% "https://mail.google.com/mail/u/0/feed/atom"

	 IfWinExist Edge
	 {
	   WinActivate
	 }

	 Sleep 999
	 Url:=""
	 DebugAppend("Copy GMail URL")
	 Loop {
	   ;WinWaitActive mail.google.com/mail/u/0/feed/atom <- doesn't work
	   Send ^a^c
	
	   Array := StrSplit(Clipboard, "<entry>")
	   for k, s in Array
	   {
		 If InStr(s, Uname)
		 {
		   Url := StrSplit(Array[2], "href=""")
		   Url := StrSplit(Url[2], """")
		   Url := Url[1]

		   break 2
		 }
	   }

	   Sleep 2999
	   if (A_Index>20)
		 MsgBox, "Looked " %A_Index% "Times, Continue? (Press Esc to quit)"
	   WinGetActiveTitle, Title
	   if (InStr(Title,"atom"))
		 Send {F5}
	 }

	DebugAppend("Copy Verification Code")
	 Run, %Edge% %Url%
	 s := ""
	 Clipboard:=""
	 Loop {
	   Sleep 999
	   WinGetActiveTitle, Title
	   if (InStr(Title,"Verification Code - ")=0)
		 continue
	   ;WinWaitActive, Verification
	   Send ^a^c
	   s:=Clipboard
	   if (InStr(clipboard,"Verification Code")=0)
		 continue
	   If InStr(s, Uname)
	   {
		 break 1
	   }
	   WinGetActiveTitle, Title
	 }
	 s := StrSplit(s, "login:")
	 s := StrSplit(s[s.MaxIndex()], "If you did not")
	 s := s[1]

	 s := RegExReplace(s, "\D")
	
	 DebugAppend("Switch back to EVE")
	 IfWinExist, Verification
	 {
	   WinMinimize
	 }

	 IfWinExist EVE Online Launcher
	 {
	   WinActivate
	 }

	DebugAppend("Send Verification")
	 Send %s%

	DebugAppend("Continue")
	 ; Continue
	 Text:="|<>*171$66.0S0wwk3bDCS6AQwwyTb7CSDAwwQyTb7CSDwwwAyTb3CSDwwwAyTb1CSDwwx4yTb9CSDwwxUyTb8CSDAwxkyTbACSDAwxkyTbCCS0AQxsyTbCC00S0xsyTbDD0U"
	 Text.="|<>*175$71.00Ds01zUzVw000Dk01z1z3s0TsT3z3y1y7zkzky7y7w3wDzVzVwDwDs3sTz3z3sTsTk7kzy7zzkzkzU7VzwDzzVzVz073zsTzz3z3y4C7zkzzy7y7wAADzVzzwDwDsMMTz3zzsTsTksEzy7zzkzkzVkVzwDwDVzVz3k3zsTsT3z3y7k7zkzky7y7wDUDzVzVwDwDsTUTz3z3sTsTkz0zy007s00zVz1zw00Tk03z3y3zu01zk0Dy7y7zo"
	 Text.="|<>*173$68.03y01z3wD003sT3wDkT3zVxz7lz3w7kzsTTlwTkz0wDy7rwT7wDkD3zVxzzlz3w1kzsTTzwTkz4QDy7rzz7wDl33zVxzzlz3wMEzsTTzwTkz64Dy7rzz7wDlk3zVxz7lz3wS0zsTTlwTkz7UDy7rwT7wDlw3zVxz7lz3wT0zsT01wDkz7sDy7k0zU0Tlz3zVw0Ts0DwTkzsTU"
	 Text.="|<100%>*172$68.UD0SDA0ttttk3U3Xn0CSCSQwtssQyTbXbbDCSC7DbtsNtnzbXUntyS6SQztstAyTbUbbDySCFDbtt9tnzbXa3tySESQwtstkyTba7bDCSCQDbttltk3U3bXtySQS20w1tsyTbbbUU"

	 ok:=FFindText(X, Y, 931-150000, 490-150000, 931+150000, 490+150000, 0, 0, Text)
	
	 sleep 1000

	DebugAppend("END ADD_ONE_ACCOUNT")
   } ;;; end ADD_ONE_ACCOUNT

DebugAppend("FINISHED")

^p::Send, %Default_Password%
return

Escape::ExitApp
