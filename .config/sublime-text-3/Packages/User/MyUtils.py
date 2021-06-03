import subprocess

import sublime
import sublime_plugin

class TogglePackage(sublime_plugin.ApplicationCommand):
  def run(self, name):
    settings = sublime.load_settings('Preferences.sublime-settings')
    ignored_packages = settings.get('ignored_packages', [])

    if name in ignored_packages:
      ignored_packages.remove(name)
      status = 'enabled'
    else:
      ignored_packages.append(name)
      status = 'disabled'

    ignored_packages.sort()
    settings.set('ignored_packages', ignored_packages)
    sublime.save_settings('Preferences.sublime-settings')

    sublime.status_message('{} Package {}'.format(name, status))


class UiHideAll(sublime_plugin.ApplicationCommand):
  def run(self):
    for w in sublime.windows():
      w.set_menu_visible(False)
      w.set_tabs_visible(False)
      w.set_status_bar_visible(False)
      w.set_sidebar_visible(False)


class ChangeSurroundings(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    surround = [kwargs.get('begin'), kwargs.get('end')]
    start = self.view.sel()[0]

    # Gather content data
    self.select_content()
    sel = self.view.sel()[0]
    end = sel.end() + 1

    # Insert replacements
    self.view.insert(edit, sel.begin(), surround[0])
    self.view.insert(edit, end, surround[1])

    # Delete old surroundings
    self.view.sel().clear()
    self.view.sel().add(sublime.Region(sel.begin(), sel.begin()))
    self.delete_brackets()

    # restore starting point
    self.view.sel().clear()
    self.view.sel().add(start)

  def select_content(self):
    self.view.run_command(
      "bh_key",
      {
        "no_outside_adj": None,
        "lines" : True,
        "plugin": {
          "type": ["__all__"],
          "command": "bh_modules.bracketselect"
        }
      }
    )

  def delete_brackets(self):
    self.view.run_command(
      "bh_key",
      {
        "plugin": {
          "args": {
            "remove_block": False,
            "remove_content": False,
            "remove_indent": False
          },
          "command": "bh_modules.bracketremove",
          "type": ["__all__"]
        }
      }
    )


class DeleteSurrounded(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    all = kwargs.get('all', False)
    replace = kwargs.get('replace', False)
    self.select_content(all)
    self.view.run_command('cut')

    if replace:
      self.view.run_command('nv_enter_insert_mode')

  def select_content(self, all):
    self.view.run_command(
      "bh_key",
      {
        "no_outside_adj": None,
        "lines" : True,
        "plugin": {
          "type": ["__all__"],
          "command": "bh_modules.bracketselect",
          "args": {"always_include_brackets": all}
        }
      }
    )


class DeleteWord(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    goto_insert_mode = kwargs.get('replace', False)
    scope = kwargs.get('scope', 'word_end')

    if scope == 'inner':
      word = self.view.word(self.view.sel()[0].begin())

      self.view.sel().clear()
      self.view.sel().add(word)
    elif scope == 'word_end':
      self.view.run_command('move', {"by": "word_ends", "forward": True, "extend": True})

    self.view.run_command('cut')

    if goto_insert_mode:
      self.view.run_command('nv_enter_insert_mode')


class ThenGoBackToNormalMode(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    command = kwargs.get('exec', 'noop')
    self.view.run_command(command)
    self.view.run_command('nv_enter_normal_mode')


class MoveVisualModeStartingPoint(sublime_plugin.TextCommand):
  def run(self, edit):
    self.view.run_command('nv_enter_normal_mode')
    self.view.run_command('move', {"by": "characters", "forward": True})
    self.view.run_command('nv_enter_visual_mode')
    self.view.run_command('move', {"by": "characters", "forward": False, "extend": True})
    self.view.run_command('move', {"by": "characters", "forward": False, "extend": True})


class ReplaceSelection(sublime_plugin.TextCommand):
  def run(self, edit):
    self.view.run_command('cut')
    self.view.run_command('nv_enter_insert_mode')


class EnterKey(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    subprocess.run(['xdotool', 'key', '--clearmodifiers', 'Return'])


class FileStatus(sublime_plugin.EventListener):
  def __init__(self):
    # format reference: 
    # https://github.com/maliayas/SublimeText_PluginStandards#status-bar-items
    self.index = ').0.file_status'

  def on_modified(self, view):
    self.show_status(view)

  def on_activated(self, view):
    self.show_status(view)

  def on_post_save(self, view):
    view.erase_status(self.index)

  def show_status(self, view):
    if view.is_dirty():
      status = "✗"
    else:
      status = ""

    view.set_status(self.index, status)


class SaferQuit(sublime_plugin.TextCommand):
  def run(self, edit):
    self.view.window().run_command('close_workspace')
    sublime.run_command('exit')

