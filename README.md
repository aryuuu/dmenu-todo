# Minimal script to help you manage todo list with comfy dmenu interface

---

## Installation

Place script somewhere. Point *todofile* variable in script to an empty file in your
system. Now you can create a symbolic link to your script or add alias to *.bashrc*

## Dependecies

+ awk, sed
+ xargs
+ dmenu

## Command line interface

`todo` - display numbered todofile  
`todo add task1 task2 ... taskN` - add tasks to todofile  
`todo del N` - delete N task  

## Dmenu interface

Dmenu interface is useful with your favourite window manager. For example in i3 you could add `bindsym $mod+t exec todo dmenu`.

```
        ||N tasks|| |Add| |Display|
```

1. **N tasks** displays the number of current active tasks.  
2. **Add** allows you to add new task. After choosing this option you will be promted to type your task. Click *Enter* to finish.  
3. **Display** shows your current task list and allows you to delete tasks. Select the task you want to delete and press *Enter*. You will be prompted "Delete?" with *Yes* and *No* option. Select *Yes* if you wish to delete the task. Afterwards you will be shown updated todo list where you can delete any addional tasks or press *Esc* if you wish to exit.
