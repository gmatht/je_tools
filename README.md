# je_tools

This consists of two tools for EvE Online:
 - je_wm: A window manager that aims to allow EvE to be fully playable in full screen mode
 - je_pass: A password manager

## je_wm

![image](https://github.com/user-attachments/assets/69d32f47-5692-4c67-8931-6d2f8e02aeaa)

 - "<": Switch to previous window
 - ":": Menu (Fits)
 - ">": Switch to next window
 - "Zzz": Hide this EvE window and skip over it 4 times"
 - "F": "Drones Engage"
 - [] Ctrl: Hold down Ctrl
 - "U": EVE University Wiki
 - "D": Launch Discord
 - F1-4: Press F1-4
 - "M": Minimize All
 - "R": Launch DotLan Route Planner
 - HH:MM:SS: Amount of time waster on current Window/Character
 - CHARACTER/WINDOW NAME: Click to paste an active character name

CCP doesn't whitelist scripts, but this does at most one in-game action per click.

## je_pass

- Script to log into multiple EVE accounts at once
- Windows only (haven't tested on Wine, probably won't work on native MacOS)
- Assumes that all the accounts you want to log into have the same password.; Assumes your EVE accounts are tied to a GMail, that you have logged into on MS Edge.
- Assumes you have disabled msedge's buggy "saving form data" feature.
- Most likely to work with Windows Desktop Scaling at 100%. Setting the Resolution to Full High Definition (FHD/1080p) may also help
- But you may have to run AutoHotKey.ahk to find the Text:= lines for your machine.

CCP doesn't whitelist scripts, but...
1) I have asked if a login script was OK, and they *didn't* scream "no" (or respond in any other way to be honest).
2) This script performs no in-game actions
3) Reinstalling windows and running this script gives you no advantage over a user that didn't have to reinstall.
4) Enabling users to easily reinstall and clean off malware is probably a good thing.
