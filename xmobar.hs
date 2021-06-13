Config {
    font = "xft:DejaVu Sans:size=9:condenced:antialias=true",
    additionalFonts = [ "-*-*-*-*-*-*-12-*-*-*-*-*-*-*"
                      , "xft:DejaVu Sans Mono:size=9:book:antialias=true"
                      , "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-koi8-*"
                      ],
    textOffset = 15,
    textOffsets = [15, 15, 15],
    alpha = 255,
    fgColor = "#10101c",
    bgColor = "#cacaca"
    position = Static { xpos = 0, ypos = 0, width = 1920, height = 20 },
    border = FullBM -2,
    borderColor = "#cacaca",
    borderWidth = 3,
    lowerOnStart = True,
    commands =
        [Run Date "%a %b %d" "date" 3600
        ,Run Date "<fn=2>%H:%M</fn>" "time" 30
        ,Run Cpu ["--template" , "<fn=2><total></fn>%", "-w", "2"] 10 -- fix %
        ,Run Com "bash" ["-c", ".xmonad/battery.sh"] "battery" 10
        ,Run Com "bash" ["-c", "pactl list sinks | grep -oh \"[0-9]*%\" | head -n 1 | tr -d %"] "vol" 10
        ,Run Com "bash" ["-c", ".xmonad/network.sh"] "network" 60
        ,Run Kbd [("ru", "ru"), ("us", "en")]
        ,Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "¯\_(ツ)_/¯"
}
