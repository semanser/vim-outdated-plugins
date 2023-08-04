from typing import Any, List
import pynvim
import subprocess
import os
from pynvim.api.nvim import Nvim


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


@pynvim.plugin
class OutdatedPlugins:
    def __init__(self, vim: Nvim) -> None:
        self.vim = vim

    @pynvim.function("CheckOutdatedPlugins")
    def check_for_updates(self, args: List):
        if not plug_can_proceed():
            return

        g_plugs = self.vim.eval("g:plugs")

        update_commands = []
        calculate_updates_commands = []

        for plug in g_plugs.values():
            update_commands.append("git -C %s remote update > /dev/null" % plug["dir"])
            calculate_updates_commands.append(
                "git -C %s rev-list HEAD..origin%s%s --count"
                % (plug["dir"], "/" if plug["branch"] else "", plug["branch"])
            )

        update_commands.append("wait")
        update_command = " & ".join(update_commands)
        calculate_updates_command = " && ".join(calculate_updates_commands)

        subprocess.run(["bash", "-c", update_command])

        out = subprocess.run(
            ["bash", "-c", calculate_updates_command], stdout=subprocess.PIPE
        )

        plugs_to_update = sum(1 for i in out.stdout.decode().split() if int(i) > 0)
        g_outdated_plugins_silent_mode = self.get_default(
            "g:outdated_plugins_silent_mode", 0
        )
        g_outdated_plugins_trigger_mode = self.get_default(
            "g:outdated_plugins_trigger_mode", 0
        )

        if plugs_to_update > 0:
            self.vim.command(f"echom 'Plugins to update: {plugs_to_update}'")
            if g_outdated_plugins_trigger_mode:
                self.vim.command("PlugUpdate")
        elif not g_outdated_plugins_silent_mode:
            self.vim.command("echom 'All plugins up-to-date'")

    def get_default(self, var: str, default: Any) -> Any:
        """
        Return the value of the vim variable `var` or `default` if it doesn't exist
        """

        try:
            return self.vim.eval(var)
        except:
            return default
