#Requires AutoHotkey v2.0
#SingleInstance Force

; Necessary Lib Loading
svvPath := FindSoundVolumeView()


; ----------- Key Bindings -----------
muteBindings := [
    { exe: "discords.exe", hotkey: "^!d" },  ; Ctrl + Alt + D
    { exe: "msedge.exe", hotkey: "^!e" }   ; Ctrl + Alt + E
]


; ----------- Globals --------------
global svvPath


; ---------- Startup Actions ---------
; ✅ Auto-unmute on startup (in case app was muted)
for binding in muteBindings {
    exe := binding.exe
    RunSvv("/Unmute", exe)

    key := binding.hotkey
    Hotkey key, ToggleAppMute.Bind(exe)
}


; ----------- Functions --------------
ToggleAppMute(app, thisHotkey := "", *) {
    global svvPath
    pid := ProcessExist(app)
    if !pid {
        PlayErrorTone()
        return
    }

    ; App is running — toggle mute and play feedback
    exitCode := RunSvv("/Switch", app)
    if exitCode
        PlayErrorTone()
    else
        PlaySuccessTone()
}


; ---------------- Helper ----------------
FindSoundVolumeView() {
    candidates := [
        A_ScriptDir "\bin\svv\SoundVolumeView.exe",
        A_ScriptDir "SoundVolumeView.exe",
        A_WinDir "\SoundVolumeView.exe",
        A_WinDir "\System32\SoundVolumeView.exe",
        A_WorkingDir "\SoundVolumeView.exe"
    ]

    ; Check specified locations
    for candidate in candidates
        if FileExist(candidate)
            return candidate

    ; Check in PATH env variable
    pathEnv := EnvGet("PATH")
    for entry in StrSplit(pathEnv, ";") {
        if (entry = "")
            continue

        candidate := RTrim(entry, "\") "\SoundVolumeView.exe"
        if FileExist(candidate)
            return candidate
    }

    ; If not found
    PlayErrorTone()
    ExitApp()
}

RunSvv(action, target) {
    global svvPath
    command := Format('"{:s}" {:s} "{:s}"', svvPath, action, target)
    exitCode := RunWait(command, , "Hide")

    return exitCode
}

PlaySuccessTone() {
    SoundBeep(500, 300)
}

PlayErrorTone() {
    SoundBeep(700, 120)
    SoundBeep(800, 140)
}
