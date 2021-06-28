import sublime
import sublime_plugin

def select_content(view, select_all):
  view.run_command(
    "bh_key",
    {
      "no_outside_adj": None,
      "lines" : True,
      "plugin": {
        "type": ["__all__"],
        "command": "bh_modules.bracketselect",
        "args": {"always_include_brackets": select_all}
      }
    }
  )


class ChangeSurroundings(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    surround = [kwargs.get('begin'), kwargs.get('end')]
    find_pair = kwargs.get('find', None)

    bracket_beginning = []
    starting_point = []

    for sel in self.view.sel():
      starting_point.append(sel)

    # Gather content data
    if find_pair is None:
      select_content(self.view, False)
    else:
      self.view.run_command(
        'select_surrounded_content',
        {"all": False, "find": find_pair}
      )

    for sel in self.view.sel():
      end = sel.end() + 1

      # Insert replacements
      self.view.insert(edit, sel.begin(), surround[0])
      self.view.insert(edit, end, surround[1])
      bracket_beginning.append(sublime.Region(sel.begin(), sel.begin()))

    # Delete old surroundings
    self.view.sel().clear()
    self.view.sel().add_all(bracket_beginning)
    self.delete_brackets()

    # restore starting point
    self.view.sel().clear()
    self.view.sel().add_all(starting_point)

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
    select_all = kwargs.get('all', False)
    replace = kwargs.get('replace', False)
    find_pair = kwargs.get('find', None)

    if find_pair is None:
      select_content(self.view, select_all)
    else:
      self.view.run_command(
        'select_surrounded_content',
        {"all": select_all, "find": find_pair}
      )

    self.view.run_command('cut')

    if replace:
      self.view.run_command('nv_enter_insert_mode')


class SelectSurroundedContent(sublime_plugin.TextCommand):
  def run(self, edit, **kwargs):
    query = kwargs.get('find')
    select_all = kwargs.get('all', False)

    found = False
    limit = 200
    attempts = 0

    lookup_fn = self.lookup(select_all)

    while not found:
      select_content(self.view, select_all)
      found = self.find(query, lookup_fn)
      attempts+=1

      if attempts == limit:
        break

  def find(self, query, lookup):
    for sel in self.view.sel():
      start = lookup[0](sel, len(query[0]))
      start_char = self.view.substr(start)
      match_start = query[0] == start_char

      end = lookup[1](sel, len(query[1]))
      end_char = self.view.substr(end)
      match_end = query[1] == end_char

      if match_start and match_end:
        return True

    return False

  def lookup(self, select_all):
    if select_all:
      return [
        lambda sel, offset: sublime.Region(sel.begin(), sel.begin() + offset),
        lambda sel, offset: sublime.Region(sel.end() - offset, sel.end())
      ]
    else:
      return [
        lambda sel, offset: sublime.Region(sel.begin() - offset, sel.begin()),
        lambda sel, offset: sublime.Region(sel.end(), sel.end() + offset)
      ]

