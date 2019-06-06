#/bin/bash

todofile=""

# DMENU INTERFACE 
function add()
{
	echo "" | dmenu -b -i -p "Add task: " | tr -d '\n' |  xargs -0 todo add
}

function display()
{
	 todo | dmenu -b -l $lines | while read task; do \
		echo -e "Yes\nNo" | dmenu -i -b -p "Delete?" | while read opt; do \
			[ "$opt" == "Yes" ] && delete "$task"; \
				done; done
}


function delete()
{
	 echo "$1" | awk '{print $1;}' | tr -d '.' | xargs todo del; display
}

function dmenu_main()
{
	lines=$(wc -l <$todofile | tr -d '\n')
	option=$(echo -e "Add\nDisplay\n" | dmenu -b -i -p "$lines tasks")

	case $option in 
		"Add") add;;
		"Display") display;;
	esac
}

# MAIN LOGIC	
case $1 in
	add) shift 1; [ -z "$1" ] || for t in "$@"; do echo "$t" >> $todofile;done;;
	del) shift 1; [ -z "$1" ] || sed "$1d" $todofile > /tmp/t; cat /tmp/t > $todofile; rm /tmp/t ;;
	dmenu) dmenu_main;;
	*) awk '{print NR ". " $s}' $todofile;;
esac


