"""Hyprland-like master layout for sway.

Every workspace is kept as `[master | stack]`: the master on the left, the
others stacked vertically on the right. New windows go to the bottom of the
stack (Hyprland's `new_status = slave`), and when the master closes, the top
of the stack takes its place.

`sway-master` runs the daemon, `sway-master swap` swaps the focused window
with the master (or the master with the top of the stack).
"""

import sys

from i3ipc import Connection, Event

MARK = "_sway_master"


def cmd(ipc, con, command):
    ipc.command(f"[con_id={con.id}] {command}")


def is_tiled(con):
    return con.type == "con" and not con.nodes


def workspace_of(ipc, con_id):
    con = ipc.get_tree().find_by_id(con_id)
    return con.workspace() if con else None


def move_after(ipc, con, target):
    """Moves `con` right after the `target` window, in its container."""
    cmd(ipc, target, f"mark --add {MARK}")
    cmd(ipc, con, f"move container to mark {MARK}")
    cmd(ipc, target, f"unmark {MARK}")


def fix(ipc, ws):
    """Applies one fix towards `[master | stack]`, returns False when done.

    Structures the layout doesn't produce (made by hand) are left alone.
    """
    leaves = ws.leaves()
    if len(leaves) < 2:
        # A lone window left inside a split container: unwrap it
        if leaves and leaves[0].parent.id != ws.id:
            cmd(ipc, leaves[0], "split none")
            return True
        return False

    nodes = ws.nodes
    if len(nodes) == 1:
        # The master is gone: promote the top of the stack
        cmd(ipc, nodes[0].leaves()[0], "move left")
        return True

    master = nodes[0]
    if master.nodes:
        return False
    if ws.layout != "splith":
        cmd(ipc, master, "layout splith")
        return True

    stack = next((n for n in nodes[1:] if n.nodes), None)
    strays = [n for n in nodes[1:] if not n.nodes]
    if stack is None:
        # Second window: wrap it, it becomes the stack
        cmd(ipc, strays[0], "split vertical")
        return True
    if strays:
        move_after(ipc, strays[0], stack.leaves()[-1])
        return True
    return False


def tidy(ipc, ws_name):
    for _ in range(16):
        ws = next((w for w in ipc.get_tree().workspaces() if w.name == ws_name), None)
        if ws is None or not fix(ipc, ws):
            return


def tidy_all(ipc):
    for ws in ipc.get_tree().workspaces():
        tidy(ipc, ws.name)


def to_stack_bottom(ipc, con_id):
    """Puts a new window at the bottom of the stack."""
    ws = workspace_of(ipc, con_id)
    if ws is None:
        return
    tidy(ipc, ws.name)
    ws = workspace_of(ipc, con_id)
    if ws is None or len(ws.nodes) < 2:
        return
    con = ws.find_by_id(con_id)
    stack = ws.nodes[-1]
    if not is_tiled(con) or not stack.nodes:
        return
    last = stack.leaves()[-1]
    if con.id != last.id and con.parent.id == stack.id:
        move_after(ipc, con, last)


def on_new(ipc, e):
    if is_tiled(e.container):
        to_stack_bottom(ipc, e.container.id)


def on_floating(ipc, e):
    if is_tiled(e.container):
        to_stack_bottom(ipc, e.container.id)
    else:
        tidy_all(ipc)


def on_change(ipc, e):
    tidy_all(ipc)


def swap():
    ipc = Connection()
    focused = ipc.get_tree().find_focused()
    if focused is None or not is_tiled(focused):
        return
    leaves = focused.workspace().leaves()
    if len(leaves) < 2:
        return
    target = leaves[1] if focused.id == leaves[0].id else leaves[0]
    cmd(ipc, focused, f"swap container with con_id {target.id}")


def daemon():
    ipc = Connection(auto_reconnect=False)
    tidy_all(ipc)
    ipc.on(Event.WINDOW_NEW, on_new)
    ipc.on(Event.WINDOW_FLOATING, on_floating)
    ipc.on(Event.WINDOW_CLOSE, on_change)
    ipc.on(Event.WINDOW_MOVE, on_change)
    ipc.main()


if __name__ == "__main__":
    if sys.argv[1:] == ["swap"]:
        swap()
    else:
        daemon()
