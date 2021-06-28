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


class DeleteWord(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    goto_insert_mode = kwargs.get('replace', False)
    scope = kwargs.get('scope', 'word_end')

    if scope == 'inner':
      for sel in self.view.sel():
        word = self.view.word(sel.begin())
        self.view.sel().subtract(sel)
        self.view.sel().add(word)

    elif scope == 'word_end':
      self.view.run_command('move', {"by": "word_ends", "forward": True, "extend": True})

    self.view.run_command('cut')

    if goto_insert_mode:
      self.view.run_command('nv_enter_insert_mode')


class SelectInnerWord(sublime_plugin.TextCommand):
  def run(self, edit):
    for sel in self.view.sel():
      word = self.view.word(sel.begin())
      self.view.sel().subtract(sel)
      self.view.sel().add(word)


class ThenGoBackToNormalMode(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    command = kwargs.get('exec', 'noop')
    self.view.run_command(command)
    self.view.run_command('nv_enter_normal_mode')


class MoveVisualModeStartingPoint(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    move = kwargs.get('by', 'characters')
    self.view.run_command('nv_enter_normal_mode')
    self.view.run_command('move', {"by": "characters", "forward": True})
    self.view.run_command('nv_enter_visual_mode')
    self.view.run_command('move', {"by": "characters", "forward": False, "extend": True})
    self.view.run_command('move', {"by": move, "forward": False, "extend": True})


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


class BetterA(sublime_plugin.TextCommand):
  def run(self, edit):
    for sel in self.view.sel():
      cursor_pos = sel.b
      character = self.view.substr(cursor_pos)
      after = character != '\n'
      self.view.run_command('nv_enter_insert_mode', {"after": after})


class HackyCtrlO(sublime_plugin.TextCommand):
  def run(self, edit):
    self.view.run_command('nv_enter_normal_mode')
    sublime.set_timeout_async(self.go_back, 1000)

  def go_back(self):
    self.view.run_command('nv_enter_insert_mode', {"after": False})


class UseSidebar(sublime_plugin.ApplicationCommand):
  def run(self):
    window = sublime.active_window()
    sidebar_visible = window.is_sidebar_visible()

    if sidebar_visible:
      window.run_command('focus_group', {"group": window.active_group()})
      window.run_command('toggle_side_bar')
    else:
      window.run_command('toggle_side_bar')
      window.run_command('focus_side_bar')


class CreateFromCurrentFile(sublime_plugin.TextCommand):
  def run(self, edit):
    path = self.view.file_name()

    if path is None:
      return

    self.view.window().run_command('fm_create', {'paths': [path]})


class InsertInput(sublime_plugin.TextCommand):
  def run(self, edit):
    self.view.run_command('select_all')
    input = self.view.substr(self.view.sel()[0])
    self.view.window().run_command('hide_panel', {'cancel': True})
    sublime.active_window().run_command('insert', {'characters': input})


class JumpToPreviousSelection(sublime_plugin.TextCommand):
  def run(self, edit):
    iteration_limit = 120
    initial_state = []

    for sel in self.view.sel():
      initial_state.append([sel.a, sel.b])

    found = self.find_non_empty_selection(iteration_limit)

    if found:
      # Add starting point to history
      # So we can go back to it with the 'jump_back' command
      self.view.run_command('add_jump_record', {"selection": initial_state})
    else:
      self.restore(iteration_limit)
      sublime.status_message('No selections found')

  def find_non_empty_selection(self, steps):
    for i in range(steps):
      self.view.run_command("jump_back")

      for sel in self.view.sel():
        if not sel.empty():
          return True

    return False

  def restore(self, steps):
    for i in range(steps):
      self.view.run_command("jump_forward")

