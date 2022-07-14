#/bin/bash

todofile="/home/fatt/.todo"
doingfile="/home/fatt/.doing"

# DMENU INTERFACE 
function add()
{
	echo "" | dmenu -i -fn "FontAwesome" -p  -l 5 -sb '#6272A4' -sf '#F8F8F2' -nb '#282A36' -nf '#F8F8F2' -shb '#6272A4' -shf '#FA485D' -nhb '#282A36' -nhf '#FA485D' | tr -d '\n' |  xargs -0 bash $0 add
}

function display()
{
	 bash $0 | dmenu -fn "FontAwesome" -p  -sb '#6272A4' -sf '#F8F8F2' -nb '#282A36' -nf '#F8F8F2' -shb '#6272A4' -shf '#FA485D' -nhb '#282A36' -nhf '#FA485D' -l $lines | while read task; do \
         echo -en "Delete\nMark as doing" | dmenu -i -fn "FontAwesome" -l 5 -sb '#6272A4' -sf '#F8F8F2' -nb '#282A36' -nf '#F8F8F2' -shb '#6272A4' -shf '#FA485D' -nhb '#282A36' -nhf '#FA485D' -p "Action" | while read action; do \
             if [[ $action == "Delete" ]]; then delete "$task"; elif [[ $action == "Mark as doing" ]]; then doing "$task"; else echo "huh"; fi; \
             done; done
}

function doing() 
{
    task=$(echo -n "$1" | choose 1:) 
    notify-send "In Progress" "$task"
    echo "$task" > $doingfile
}


function delete()
{
    task=$(echo -n "$1" | choose 1:)
    if [[ $(< $doingfile) == $task ]]; then
        > $doingfile
    fi

	 echo "$1" | awk '{print $1;}' | tr -d '.' | xargs bash $0 del; display
}

function dmenu_main()
{
	lines=$(wc -l <$todofile | tr -d '\n')
	option=$(echo -e "Add\nDisplay\n" | dmenu -i -fn "FontAwesome" -l 5 -sb '#6272A4' -sf '#F8F8F2' -nb '#282A36' -nf '#F8F8F2' -shb '#6272A4' -shf '#FA485D' -nhb '#282A36' -nhf '#FA485D' -p "$lines tasks")

	case $option in 
		"Add") add;;
		"Display") display;;
	esac
}

# COMMAND LINE INTERFACE	
case $1 in
	add) shift 1; [ -z "$1" ] || for t in "$@"; do echo "$t" >> $todofile;done;;
	del) shift 1; [ -z "$1" ] || sed "$1d" $todofile > /tmp/t; cat /tmp/t > $todofile; rm /tmp/t ;;
	dmenu) dmenu_main;;
	dmenu-add) add;;
	dmenu-display) display;;
	*) awk '{print NR ". " $s}' $todofile;;
esac
