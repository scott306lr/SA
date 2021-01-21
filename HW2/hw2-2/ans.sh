#!/bin/bash
display_menu() {
    local cmd=(dialog --keep-tite --clear --menu "$1" $2 $3 $4)
    local opt=($menuopt)
    while true
    do
        select=$("${cmd[@]}" "${opt[@]}" 3>&1 1>&2 2>&3 3>&-)
        local return_v=$?

        case $return_v in
            1)
            break
            ;;
            255)
            echo "Esc Pressed." 1>&2
            exit "Esc Pressed."
            ;;
        esac
        
        local showmsg=$("${subcmd[@]}" "${select[@]}")
        display_msgbox "$subbox $select" 0 0
    done
}

display_msgbox() {
    dialog \
    --title "$1"\
	--keep-tite \
    --clear \
    --no-collapse \
    --msgbox "$showmsg" $2 $3
}

save_inputbox() {
   local cmd=(dialog --title "$1" --clear --no-collapse \
    --inputbox "Enter the path:" $2 $3)
    while true
    do
        select=$("${cmd[@]}" 3>&1 1>&2 2>&3 3>&-)
        local return_v=$?
        case $return_v in
            1) 
            break
            ;;
            255)
            echo "Esc Pressed." 1>&2
            exit 
            ;;
        esac
			
		if [ "$select" = "" ]; then
			showmsg="\n     Should not be left blank!"
			display_msgbox "Input Error!" 7 40
			continue
		elif [ -d "$select" ]; then 
			showmsg="\n    You have entered a directory."
			display_msgbox "Input Error!" 7 40
			continue
		fi
		local filename=$(basename "$select")
        local dir=$(dirname "$select") ; [ $dir = "." ] && dir=$(readlink -f ~)

		local fullpath="$dir/$filename"
		if [ ! -d $dir ]; then
			local showmsg="$dir\nnot found!"
			display_msgbox "Directory not found" 0 0
			continue
		elif [ ! -w $dir ] || [ ! -w $fullpath -a -f $fullpath ]; then
			local showmsg="\nNo write permission to\n$fullpath !"
			display_msgbox "Permission Denied" 0 0
			continue
		fi

		bash sys_inf.sh $MARK $fullpath > $fullpath

        local showmsg=$(cat $fullpath | tail -n +2)
        display_msgbox "System Info" 0 0

        break
    done
}

load_inputbox(){
    local cmd=(dialog --title "$1" --clear --no-collapse \
    --inputbox "Enter the path:" $2 $3)
    while true
    do
        select=$("${cmd[@]}" 3>&1 1>&2 2>&3 3>&-)
        local return_v=$?
        case $return_v in
            1) 
            break
            ;;
            255)
            echo "Esc Pressed." 1>&2
            exit 1 
            ;;
        esac
		
		if [ "$select" = "" ]; then
			showmsg="\n     Should not be left blank!"
			display_msgbox "Input Error!" 7 40
			continue
		elif [ -d "$select" ]; then 
			showmsg="\n    You have entered a directory."
			display_msgbox "Input Error!" 7 40
			continue
		fi
		local filename=$(basename "$select")
		local dir=$(dirname "$select");	[ $dir = "." ] && dir=$(readlink -f ~)
		
		local fullpath="$dir/$filename"
		if [ ! -f $fullpath ]; then
			local showmsg="\n$fullpath\nnot found!"
			display_msgbox "File not found" 0 0
			continue
		elif [ ! -r $fullpath ]; then
			local showmsg="\nNo read permission to\n$fullpath !"
			display_msgbox "Permission Denied" 0 0 
			continue
		fi
		
		local firstl=$(cat $fullpath | head -n 1 )
		if ! [ "$firstl" = $MARK ]; then
			local showmsg="\nThe file is not generated by this program."
			display_msgbox "File not valid" 7 40
			continue
		fi

		local showmsg=$(cat $fullpath | tail -n +2)
		display_msgbox "$filename" 0 0
		break

    done
}

MARK="This-file-is-made-by-Scott."


base=(dialog \
    --keep-tite \
    --clear \
    --cancel-label "Exit"\
    --menu "System Info Panel" 22 76 16)

options=(1 "LOGIN RANK"
         2 "PORT INFO"
         3 "MOUNPOINT INFO"
         4 "SAVE SYSTEM INFO"
         5 "LOAD SYSTEM INFO") 

trap "echo 'Ctrl + C pressed.'; exit 2" 2
while true 
do
    choices=$("${base[@]}" "${options[@]}" 3>&1 1>&2 2>&3 3>&- )
    exit_status=$?

    case $exit_status in
        1) #Cancel
        echo "Exit." 
        exit 0
        ;;
        255) #Esc
        echo "Esc Pressed." 1>&2
        exit 1
        ;;
    esac

    case $choices in 
        1)
            showmsg="$(bash login_rank.sh)"
            display_msgbox "LOGIN RANK" 0 0
            ;;
        2)
            menuopt=$(bash port_info.sh)
            subbox="Proccess Status:" 
            subcmd=(bash p_status.sh)
            display_menu "PORT INFO(PID and PORT)" 22 76 16
            ;;
        3)
            menuopt=$(bash mp_info.sh)
            subbox=""
            subcmd=(bash mp_status.sh)
            display_menu "MOUNTPOINT INFO" 22 76 16
            ;;
        4)
            save_inputbox "Save to file" 8 60
            ;;
        5)
            load_inputbox "Load from file" 8 60 
            ;;
    esac

done