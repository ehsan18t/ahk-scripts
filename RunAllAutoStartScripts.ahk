#Requires AutoHotkey v2.0

; --- SETTINGS ---
; Examples: 
; folderPath := "D:\Others\AHK Scripts" ; Relative
; folderPath := A_ScriptDir "\scripts"  ; Absolute
folderPath := "D:\Others\AHK Scripts\AutoStart"

; --- MAIN LOGIC ---
Loop Files, folderPath "\*.ahk", "R"  ; "R" = recursive
{
    filePath := A_LoopFileFullPath
    if (filePath = A_ScriptFullPath)  ; skip this script itself
        continue
    Run(A_AhkPath ' "' filePath '"', , "Hide")
}

; Just copy this script to shell:startup folder to run all scripts
; in the specified "AutoStart" folder on Windows startup

ExitApp
