import os
import sublime
import sublime_plugin

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


class UserExplorer(sublime_plugin.ApplicationCommand):
  def run(self):
    window = sublime.active_window()
    path = window.active_view().file_name()

    if path is None:
      window.run_command('fm_create', {
        'start_with_browser': True,
        'paths': ['$folder']
      })
    else:
      window.run_command('fm_create', {
        'start_with_browser': True,
        'paths': [os.path.dirname(path)]
      })


class SetTabIndex(sublime_plugin.WindowCommand):
    def run(self, new_index):
        view = self.window.active_view()
        group, index = self.window.get_view_index(view)

        if index < 0:
            return

        count = len(self.window.views_in_group(group))

        if new_index > count - 1:
            return

        self.window.set_view_index(view, group, new_index)
        self.window.focus_view(view)


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

