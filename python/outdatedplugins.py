import vim
import subprocess
import os


def plug_can_proceed():
    # plug.vim has these two guards in place. occassionally, if trigger mode is
    # enabled, we can get in a situation where we're calling PlugUpdate when it
    # will throw, causing a nasty error message. instead, we can just duplicate
    # the guards here
    if not os.getcwd():
        return False

    for evar in ["GIT_DIR", "GIT_WORK_TREE"]:
        if os.environ.get(evar) != None:
            return False

    return True


def check_for_updates():
    if not plug_can_proceed():
        return

    g_plugs = vim.eval("g:plugs")

    update_commands = []
    calculate_updates_commands = []

    for plug in g_plugs.values():
        update_commands.append("git -C %s remote update > /dev/null" % plug["dir"])
        calculate_updates_commands.append(
            "git -C %s rev-list HEAD..origin/%s --count" % (plug["dir"], plug["branch"])
        )

    update_commands.append("wait")
    update_command = " & ".join(update_commands)
    calculate_updates_command = " && ".join(calculate_updates_commands)

    subprocess.run(["bash", "-c", update_command])

    out = subprocess.run(
        ["bash", "-c", calculate_updates_command], stdout=subprocess.PIPE
    )

    plugs_to_update = sum(1 for i in out.stdout.decode().split() if int(i) > 0)
    g_outdated_plugins_silent_mode = int(vim.eval("g:outdated_plugins_silent_mode"))
    g_outdated_plugins_trigger_mode = int(vim.eval("g:outdated_plugins_trigger_mode"))
    if plugs_to_update > 0:
        print("Plugins to update: %d" % plugs_to_update)
        if g_outdated_plugins_trigger_mode:
            vim.command("PlugUpdate")
    elif not g_outdated_plugins_silent_mode:
        print("All plugins up-to-date")


vim.async_call(check_for_updates)
