import vim
import subprocess


def check_for_updates():
    g_plugs = vim.eval("g:plugs")

    update_commands = []
    calculate_updates_commands = []

    for plug in g_plugs.values():
        update_commands.append(
            "git -C %s remote update > /dev/null" % plug["dir"])
        calculate_updates_commands.append(
            "git -C %s rev-list HEAD..origin/%s --count" % (plug["dir"], plug["branch"]))

    update_commands.append("wait")
    update_command = " & ".join(update_commands)
    calculate_updates_command = " && ".join(calculate_updates_commands)

    updates_process = subprocess.Popen(["bash", "-c", update_command])
    updates_process.communicate()

    calculate_updates_process = subprocess.Popen(
        ["bash", "-c", calculate_updates_command],
        stdout=subprocess.PIPE,
        text=True)
    stdout, stderr = calculate_updates_process.communicate()

    plugs_to_update = sum(1 for i in stdout.split() if int(i) > 0)
    g_outdated_plugins_silent_mode = int(
        vim.eval("g:outdated_plugins_silent_mode"))
    g_outdated_plugins_trigger_mode = int(vim.eval(
        "g:outdated_plugins_trigger_mode"))
    if plugs_to_update > 0:
        print("Plugins to update: %d" % plugs_to_update)
        if g_outdated_plugins_trigger_mode:
            vim.command("PlugUpdate")
    elif not g_outdated_plugins_silent_mode:
        print("All plugins up-to-date")


vim.async_call(check_for_updates)
