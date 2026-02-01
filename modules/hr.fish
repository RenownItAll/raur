function hr --argument-names color
    # Match the safety margin of the panel
    set -l width (math (tput cols) - 1)

    set -l c (set_color normal)
    if test -n "$color"
        set c (set_color $color)
    end

    echo -e "$c"(string repeat -n $width "─")(set_color normal)
end
