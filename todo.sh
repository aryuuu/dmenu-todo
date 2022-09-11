#/bin/bash

todofile="/home/fatt/.todo"
doingfile="/home/fatt/.doing"
linkfile="/home/fatt/.todolink" # store relevant link to task with this format: [task]||[link]

# DMENU INTERFACE 
function add()
{
	echo "" | dmenu -i -fn "FontAwesome" -p  -l 5 -sb '#6272A4' -sf '#F8F8F2' -nb '#282A36' -nf '#F8F8F2' -shb '#6272A4' -shf '#FA485D' -nhb '#282A36' -nhf '#FA485D' | tr -d '\n' |  xargs -0 bash $0 add
    dmenu_main
}

function add_link() {
    echo "add link"

	echo "" |\
    dmenu -i -fn "FontAwesome" -p " add link" -l 5 -sb '#6272A4' -sf '#F8F8F2' -nb '#282A36' -nf '#F8F8F2' -shb '#6272A4' -shf '#FA485D' -nhb '#282A36' -nhf '#FA485D' |\
    tr -d '\n' |\
    xargs -0 bash $0 add-link "$1"

    dmenu_main
}

function display()
{
	 bash $0 |\
     dmenu -fn "FontAwesome" -p  -sb '#6272A4' -sf '#F8F8F2' -nb '#282A36' -nf '#F8F8F2' -shb '#6272A4' -shf '#FA485D' -nhb '#282A36' -nhf '#FA485D' -l $lines |\
     while read task; do \
         if grep "^$task" $todofile; \
         then \
             echo "match $task";\
              echo -en "delete\ndoing\nopen" |\
              dmenu -i -fn "FontAwesome" -l 5 -sb '#6272A4' -sf '#F8F8F2' -nb '#282A36' -nf '#F8F8F2' -shb '#6272A4' -shf '#FA485D' -nhb '#282A36' -nhf '#FA485D' -p "Action" |\
              while read action; do \
                  if [[ $action == "delete" ]]; then delete "$task"; elif [[ $action == "doing" ]]; then doing "$task"; elif [[ $action == "open" ]]; then open_link "$task"; else echo "huh"; fi; \
              done;\
         else \
             echo "none match"; \
             bash $0 add "$task"; \
             echo "task added"; \
             add_link "$task"; \
             dmenu_main; \
         fi; \
      done
}

function doing() 
{
    task=$1 
    notify-send "In Progress" "$task"
    echo "$task" > $doingfile
}


function delete()
{
    task=$1
    if [[ $(< $doingfile) == $task ]]; then
        > $doingfile
    fi

    echo "$1" | tr -d '.' | xargs bash $0 del; display
}

function open_link() {
    grep "^$1" $linkfile | choose -f '\|\|' 1 | xargs -0 xdg-open
    echo "openlink"
}

function dmenu_main()
{
	lines=$(wc -l <$todofile | tr -d '\n')
    display
}

# COMMAND LINE INTERFACE	
case $1 in
	add) shift 1; [ -z "$1" ] || for t in "$@"; do echo "$t" >> $todofile;done;;
	add-link) shift 1; [ -z "$1" ] || [-z "$2" ] || echo "$1||$2" >> $linkfile;;
	del) shift 1; echo $1; [ -z "$1" ] || sed "/$1/d" $todofile > /tmp/t; cat /tmp/t > $todofile; rm /tmp/t ;;
	dmenu) dmenu_main;;
	dmenu-add) add;;
	dmenu-display) display;;
	# *) awk '{print NR ". " $s}' $todofile;;
	*) cat $todofile;;
esac
