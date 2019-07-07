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
