# je_tools

This consists of two tools for EvE Online:
 - je_wm: A window manager that aims to allow EvE to be fully playable in full screen mode
 - je_pass: A password manager

## je_wm

![Screenshot](https://github.com/user-attachments/assets/f5d83290-08c2-447b-ba2c-b5983d079ff1)

 -  "<" : Switch to Previous Window
 -  ">" : Switch to Next Window
 -  "⋮" : Menu (fits)
 -  "💤" : Sleep (Skip 4 times)
 -  "F" : Engage Drones?
 -  "U" : UniWiki
 -  "D" : Discord
 -  "☑ Ctrl" : Hold down Ctrl
 -  "🁤" : Tile Windows Vertically
 -  HH:MM:SS : Time Spend on this Window Title
 -  WinTitle : Currently Active Window/Character
 -  "#" : Windows Key (Raise TaskBar)
 -  "M" : Minimise All Windows
 -  "🚀" : DOTLAN Route Manager
 -  "🔔" : Yellow Alert
 -  "⟳" : Reload this Script

CCP doesn't whitelist scripts, but this does at most one in-game action per click.

## je_pass

- Script to log into multiple EVE accounts at once
- Windows only (haven't tested on Wine, probably won't work on native MacOS)
- Assumes that all the accounts you want to log into have the same password.; Assumes your EVE accounts are tied to a GMail, that you have logged into on MS Edge.
- Assumes you have disabled msedge's buggy "saving form data" feature.
- Most likely to work with Windows Desktop Scaling at 100%. Setting the Resolution to Full High Definition (FHD/1080p) may also help
- But you may have to run AutoHotKey.ahk to find the Text:= lines for your machine.

CCP doesn't whitelist scripts, but...
1) I have asked if a login script was OK. CCP by policy did't respond, but I haven't hidden that I am writing this.
2) This script performs no in-game actions
3) Reinstalling windows and running this script gives you no advantage over a user that didn't have to reinstall.
4) Enabling users to easily reinstall and clean off malware is probably a good thing.
