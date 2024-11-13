import os, sys
from pprint import pprint
import gdb

# https://interrupt.memfault.com/blog/automate-debugging-with-gdb-python-api


def get_call_stack():
    stack = list()
    frame = gdb.newest_frame()
    level = 0
    while frame:
        func = frame.name() or "Unknown"
        sal = frame.find_sal()
        if sal.symtab:
            file_name = sal.symtab.filename
            line = sal.line
        else:
            file_name = "Unknown"
            line = "1"

        # Print frame information
        stack.append({"level": level, "file_name": file_name, "line": line, "func": func})

        # Move to the older frame
        frame = frame.older()
        level += 1
    return stack

class Nvql(gdb.Command):
    def __init__(self):
        super(Nvql, self).__init__("nvql", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        try:
            stack = get_call_stack()
            nvim_file = os.environ["NVIM_FILE_LIST"]
            f = open(nvim_file, 'w')
            for frame in stack:
                print(f'{frame["file_name"]}:{frame["line"]}:{frame["level"]} {frame["func"]}', file=f)
            f.close()
        except Exception as e:
            print(f"Error: {e}")

Nvql()
