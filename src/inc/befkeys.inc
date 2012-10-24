SEGMENT .data

keytab  dw  Unimp         ; 0000
        dw  Unimp         ; 0100 Alt-ESC
        dw  Unimp         ; 0200
        dw  Unimp         ; 0300 Ctrl-2
        dw  Unimp         ; 0400
        dw  Unimp         ; 0500
        dw  Unimp         ; 0600
        dw  Unimp         ; 0700
        dw  Unimp         ; 0800
        dw  Unimp         ; 0900
        dw  Unimp         ; 0a00
        dw  Unimp         ; 0b00
        dw  Unimp         ; 0c00
        dw  Unimp         ; 0d00
        dw  Unimp         ; 0e00 Alt-BkSp
        dw  Unimp         ; 0f00

        dw  Unimp         ; 1000 Alt-Q
        dw  Unimp         ; 1100 Alt-W
        dw  EditMode      ; 1200 Alt-E
        dw  RunAsm        ; 1300 Alt-R
        dw  ColourPage    ; 1400 Alt-T
        dw  Unimp         ; 1500 Alt-Y
        dw  FillPage      ; 1600 Alt-U
        dw  Unimp         ; 1700 Alt-I
        dw  CopyByte      ; 1800 Alt-O
        dw  PasteByte     ; 1900 Alt-P
        dw  Unimp         ; 1a00 Alt-[ (sometimes)
        dw  Unimp         ; 1b00 Alt-] (sometimes)
        dw  Unimp         ; 1c00
        dw  Unimp         ; 1d00
        dw  PopUpTest     ; 1e00 Alt-A
        dw  SavePage      ; 1f00 Alt-S

        dw  Unimp         ; 2000 Alt-D
        dw  Unimp         ; 2100 Alt-F
        dw  AskGoPage     ; 2200 Alt-G
        dw  ToggleHighBit ; 2300 Alt-H
        dw  JumpPage      ; 2400 Alt-J
        dw  Unimp         ; 2500 Alt-K
        dw  LoadPage      ; 2600 Alt-L
        dw  Unimp         ; 2700
        dw  Unimp         ; 2800
        dw  Unimp         ; 2900
        dw  Unimp         ; 2a00
        dw  Unimp         ; 2b00
        dw  Unimp         ; 2c00 Alt-Z
        dw  CutPage       ; 2d00 Alt-X
        dw  CopyPage      ; 2e00 Alt-C
        dw  PastePage     ; 2f00 Alt-V

        dw  Unimp         ; 3000 Alt-B
        dw  LessScreen    ; 3100 Alt-N
        dw  MoreScreen    ; 3200 Alt-M
        dw  Unimp         ; 3300
        dw  Unimp         ; 3400
        dw  Unimp         ; 3500
        dw  Unimp         ; 3600
        dw  Unimp         ; 3700 Alt-*	(sometimes)
        dw  Unimp         ; 3800
        dw  Unimp         ; 3900
        dw  Unimp         ; 3a00
        dw  HelpPage      ; 3b00 F1
        dw  DiskInfo      ; 3c00 F2
        dw  Unimp         ; 3d00 F3
        dw  EditPageProps ; 3e00 F4
        dw  RefreshStatus ; 3f00 F5

        dw  Unimp         ; 4000 F6
        dw  ExecBeebInstr ; 4100 F7
        dw  PlugClock     ; 4200 F8
        dw  UnplugClock   ; 4300 F9
        dw  Unimp         ; 4400 F10
        dw  Unimp         ; 4500
        dw  Unimp         ; 4600
        dw  PrevPage      ; 4700 Home
        dw  BufUp         ; 4800 Up
        dw  PageUp        ; 4900 PgUp
        dw  Unimp         ; 4a00
        dw  BufLeft       ; 4b00 Left
        dw  Unimp         ; 4c00
        dw  BufRight      ; 4d00 Right
        dw  Unimp         ; 4e00
        dw  NextPage      ; 4f00 End

        dw  BufDown       ; 5000 Down
        dw  PageDown      ; 5100 PgDn
        dw  Unimp         ; 5200 Ins
        dw  Unimp         ; 5300 Del
        dw  Unimp         ; 5400
        dw  Unimp         ; 5500
        dw  Unimp         ; 5600
        dw  Unimp         ; 5700
        dw  Unimp         ; 5800
        dw  Unimp         ; 5900
        dw  Unimp         ; 5a00
        dw  Unimp         ; 5b00
        dw  Unimp         ; 5c00
        dw  Unimp         ; 5d00
        dw  Unimp         ; 5e00
        dw  Unimp         ; 5f00

        dw  Unimp         ; 6000
        dw  Unimp         ; 6100
        dw  Unimp         ; 6200
        dw  Unimp         ; 6300
        dw  Unimp         ; 6400
        dw  Unimp         ; 6500
        dw  Unimp         ; 6600
        dw  Unimp         ; 6700
        dw  Unimp         ; 6800
        dw  Unimp         ; 6900
        dw  Unimp         ; 6a00
        dw  Unimp         ; 6b00
        dw  Unimp         ; 6c00
        dw  Unimp         ; 6d00
        dw  Unimp         ; 6e00
        dw  Unimp         ; 6f00

        dw  Unimp         ; 7000
        dw  Unimp         ; 7100
        dw  Unimp         ; 7200
        dw  DecByte       ; 7300 Ctrl-Left
        dw  IncByte       ; 7400 Ctrl-Right
        dw  NextDisk      ; 7500 Ctrl-End
        dw  NextTextVidPage ; 7600 Ctrl-PgDn
        dw  PrevDisk      ; 7700 Ctrl-Home
        dw  Unimp         ; 7800 Alt-1
        dw  Unimp         ; 7900 Alt-2
        dw  Unimp         ; 7a00 Alt-3
        dw  Unimp         ; 7b00 Alt-4
        dw  Unimp         ; 7c00 Alt-5
        dw  Unimp         ; 7d00 Alt-6
        dw  Unimp         ; 7e00 Alt-7
        dw  Unimp         ; 7f00 Alt-8

        dw  Unimp         ; 8000 Alt-9
        dw  Unimp         ; 8100 Alt-0
        dw  DelPageProps  ; 8200 Alt--
        dw  InitPageProps ; 8300 Alt-=
        dw  PrevTextVidPage ; 8400 Ctrl-PgUp
        dw  Unimp         ; 8500
        dw  Unimp         ; 8600
        dw  Unimp         ; 8700
        dw  Unimp         ; 8800
        dw  Unimp         ; 8900
        dw  Unimp         ; 8a00
        dw  Unimp         ; 8b00
        dw  Unimp         ; 8c00
        dw  Unimp         ; 8d00
        dw  Unimp         ; 8e00
        dw  Unimp         ; 8f00
