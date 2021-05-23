import os

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
    self.select_content(all)
    self.view.run_command('cut')

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

    word = self.view.word(self.view.sel()[0].begin())

    self.view.sel().clear()
    self.view.sel().add(word)
    self.view.run_command('cut')

    if goto_insert_mode:
      self.view.run_command('nv_enter_insert_mode')

