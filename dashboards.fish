#!/usr/bin/fish

function list_dashboards
    echo -e "bi server\nlocal\nNOOP"
end

function l_bi_server

    set -f i3class "bi_server_db"
    alacritty --class $i3class,docker -T docker --hold -e ssh theo@172.25.249.104 -i /home/theo/.ssh/BI-server -t lazydocker &
    alacritty --class $i3class,ra -T ra --hold -e ssh theo@172.25.249.104 -i /home/theo/.ssh/BI-server -t fish -c ranger &
    alacritty --class $i3class,btm -T btm --hold -e ssh theo@172.25.249.104 -i /home/theo/.ssh/BI-server -t btm &
    
    sleep 0.5
    i3-msg "[class=$i3class]" move scratchpad
    i3-msg "[class=$i3class]" scratchpad show

    set windows (xdotool search --class $i3class)

    for w in $windows
        set -l name (xdotool getwindowname $w)
        switch $name 
            case "docker"
                i3-msg [class=$i3class title=$name] move position 0 0
                i3-msg [class=$i3class title=$name] resize set 1500 900
            case "ra"
                i3-msg [class=$i3class title=$name] resize set 1300 950
                i3-msg [class=$i3class title=$name] move down 900
            case "btm"
                i3-msg [class=$i3class title=$name] resize set 1000 700
                i3-msg [class=$i3class title=$name] move position 2700 0
                
        end 
    end
end


function l_local
    set -f i3class "local_db"
    alacritty --class $i3class,btm -T btm --hold -e btm &
    alacritty --class $i3class,lsblk -T lsblk --hold -e watch lsblk &
    alacritty --class $i3class,lsusb -T lsusb --hold -e watch lsusb &

    sleep 0.5
    i3-msg "[class=$i3class]" move scratchpad
    i3-msg "[class=$i3class]" scratchpad show

    set windows (xdotool search --class $i3class)

    for w in $windows
        set -l name (xdotool getwindowname $w)
        switch $name 
            case "lsusb"
                i3-msg [class=$i3class title=$name] resize set 1000 700
                i3-msg [class=$i3class title=$name] move position 2800 0
            case "btm"
                i3-msg [class=$i3class title=$name] move position 2800 720
                i3-msg [class=$i3class title=$name] resize set 1000 700
            case "lsblk"
                i3-msg [class=$i3class title=$name] resize set 1000 700
                i3-msg [class=$i3class title=$name] move position 2800 1450
                
        end 
    end

end

set -l dtype (list_dashboards | rofi -dmenu)

switch $dtype
    case "bi server"
        l_bi_server
    case "local"
        l_local
    case '*'
        echo -e "\"$dtype is not known\"" | xargs rofi -e
        exit 1
end

exit 0
