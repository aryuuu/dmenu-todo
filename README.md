# Minimal script to help you manage todo list with comfy dmenu interface

---

## Installation

Place script somewhere. Point _todofile_ variable in script to an empty file in your
system. Now you can create a symbolic link to your script or add alias to _.bashrc_

## Dependecies

- awk, sed
- xargs
- dmenu
- bash
- choose/cut

## Command line interface

- `todo` - display numbered todofile
- `todo add "task1" "task2" ... "taskN"` - add tasks to todofile
- `todo del N` - delete N task
- `todo dmenu` - bring up dmenu interface
- `todo dmenu-add` - dmenu task addition interface
- `todo dmenu-display` - dmenu display interface

## Dmenu interface

Dmenu interface is useful with your favourite window manager. For example in i3 you could add `bindsym $mod+t exec todo dmenu`.

### Options

```
        ||N tasks|| |Add| |Display|
```

1. **N tasks** displays the number of current active tasks.
2. **Add** allows you to add new task. After choosing this option you will be promted to type your task. Click _Enter_ to finish.
3. **Display** shows your current task list and allows you to delete tasks. Select the task you want to delete and press _Enter_. You will be prompted "Delete?" with _Yes_ and _No_ option. Select _Yes_ if you wish to delete the task. Afterwards you will be shown updated todo list where you can delete any addional tasks or press _Esc_ if you wish to exit.

dmenu **Add** and **Display** can be accessed through `dmenu-add` and `dmenu-display` command-line options.
