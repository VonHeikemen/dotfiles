import os
from pathlib import Path

import sublime
import sublime_plugin

class CompletePath():
  def run(self, window, **kwargs):
    filename = kwargs.get('path', None)
    self.done = kwargs.get('done', self.default_done)
    self.options = []

    if filename is None:
      return

    if not os.path.isabs(filename):
      filename = self.to_absolute_path(window, filename)

    if os.path.isdir(filename):
      folder = filename
      name = ''
    else:
      folder, name = os.path.split(filename)

    def next_step(index):
      # User cancelled
      if index == -1:
        return

      level = self.level
      options = self.options

      # Insert previous selection
      if index == 0:
        path = level["rel"]
        self.done(window, path)
        return

      selected = options[index].trigger

      # Go up one level
      if index == 1:
        level["path"] = self.resolve(level["path"], '..')
        parts = Path(level["rel"]).parts
        rel_empty = len(parts) == 0

        if rel_empty and selected == self.up():
          level["rel"] = '..'

        elif rel_empty:
          level["rel"] = os.path.join('.', selected)

        elif parts[-1] == '..':
          level["rel"] = os.path.join(level["rel"], '..')

        else:
          level["rel"] = os.path.dirname(level["rel"])

      # Add user selection to path
      else:
        level["path"] = os.path.join(level["path"], selected)
        level["rel"] = os.path.join(level["rel"], selected)

      # Can we continue?
      if os.path.isfile(level["path"]):
        self.done(window, level["rel"])
        return

      # Yes, we can
      next_folder = os.path.basename(level["path"])
      above_folder = os.path.basename(self.resolve(level["path"], '..'))

      self.options = [
        sublime.QuickPanelItem(self.current(), next_folder),
        sublime.QuickPanelItem(self.up(), above_folder),
      ]

      self.options.extend([sublime.QuickPanelItem(i, level["rel"]) for i in os.listdir(level["path"])])

      window.show_quick_panel(self.options, next_step)

    current_folder = self.above_folder(filename) if name != '' else os.path.basename(folder)

    self.options = [
      sublime.QuickPanelItem(self.current(), current_folder),
      sublime.QuickPanelItem(self.up(), self.above_folder(folder)),
    ]

    self.options.extend([sublime.QuickPanelItem(i, self.current()) for i in os.listdir(folder)])
    self.level = {"path": Path(folder), "rel": self.current()}

    window.show_quick_panel(self.options, next_step)

  def default_done(self, window, path):
    window.run_command('insert', {"characters": path})

  def up(self):
    return '..' + os.sep

  def current(self):
    return '.' + os.sep

  def resolve(self, *args):
    return Path(os.path.join(*args)).resolve()

  def above_folder(self, path):
    return os.path.basename(os.path.dirname(path))

  def to_absolute_path(self, window, filename):
    cwd = window.active_view().file_name()
    filename = os.path.expanduser(filename)

    if cwd is not None:
      cwd = os.path.dirname(cwd)

    if filename[0:2] in [self.current(), '.']:
      filename = os.path.join(cwd, filename[2:])
    elif filename[0:3] == self.up():
      filename = os.path.join(os.path.dirname(cwd), filename[3:])

    return filename


class InsertPathBasedOnCurrentFile(sublime_plugin.TextCommand):
  def run(self, edit):
    cmd = CompletePath()
    cmd.run(self.view.window(), path=self.view.file_name())


class CompleteSelectedPath(sublime_plugin.TextCommand):
  def run(self, edit):
    selection = self.view.sel()[0]
    self.path = self.view.substr(selection)
    window = self.view.window()

    self.cmd = CompletePath()
    self.cmd.run(window, path=self.path, done=self.done)

  def done(self, window, result):
    if result[0:2] == self.cmd.current():
      complete_path = os.path.join(self.path, result[2:])
    else:
      complete_path = os.path.normpath(os.path.join(self.path, result))

      if self.path[0:2] == self.cmd.current() and result[3:] != self.cmd.up():
        complete_path = self.cmd.current() + complete_path

    window.run_command('insert', {"characters": complete_path})
