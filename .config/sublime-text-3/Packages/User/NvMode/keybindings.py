leader = " "

def keybinding(bind, **kwargs):
  command = kwargs.get('command')
  command_mode = context['command_mode']
  visual_mode = context['visual_mode']
  insert_mode = context['insert_mode']

  # Hacky stuff
  bind(["h"], "move_visual_mode_starting_point", visual_mode, context['selection_empty'], by="characters")
  bind(["k"], "move_visual_mode_starting_point", visual_mode, context['selection_empty'], by="lines")
  bind(["a"], "better_a", command_mode, context['selection_empty'])
  bind(["ctrl+o"], "hacky_ctrl_o", insert_mode, context['selection_empty'])

  # App commands
  bind([leader, ","], "edit_settings", command_mode[0], base_file="$packages/User/NvMode/keybindings.py")
  bind([leader, "Q"], "nv_disable_and_exit", command_mode[0])
  bind([leader, "q", "q"], "safer_quit", command_mode[0])
  bind([leader, "w"], "save", command_mode[0], **{"async": True})

  bind(["[", "t"], "prev_view", command_mode[0])
  bind(["]", "t"], "next_view", command_mode[0])

  bind(["[", "q"], "prev_result", command_mode[0])
  bind(["]", "q"], "next_result", command_mode[0])

  bind([leader, "b", "b"], "otl_open_tab_list", command_mode[0])
  bind([leader, "b", "l"], "next_view_in_stack", command_mode[0])
  bind([leader, "b", "c"], "close", command_mode[0])

  # Sidebar
  bind([leader, "d", "d"], "use_sidebar", command_mode[0])
  bind([leader, "d", "d"], "use_sidebar", context['sidebar_focused'])
  bind(["h"], "move", context['sidebar_focused'], by="characters", forward=False)
  bind(["l"], "move", context['sidebar_focused'], by="characters", forward=True)
  bind(["k"], "move", context['sidebar_focused'], by="lines", forward=False)
  bind(["j"], "move", context['sidebar_focused'], by="lines", forward=True)

  # Search
  bind(["enter"], "show_overlay", command_mode[0], overlay="command_palette")

  bind([leader, "F"], "show_panel", command_mode[0], panel="find_in_files")
  bind([leader, "f", "f"], "show_overlay", command_mode[0], overlay="goto", show_files=True)
  bind([leader, "f", "s"], "show_overlay", command_mode[0], overlay="goto", text="@")
  bind([leader, "f", "S"], "goto_symbol_in_project", command_mode[0])

  bind([leader, "r"], "show_panel", command_mode[0], panel="replace", reverse=False)

  bind([leader, "y"], "slurp_find_string", command_mode[0])

  bind(["n"], "find_under_expand", visual_mode)
  bind(["N"], "find_under_expand_skip", visual_mode)

  bind(["g", "d"], "goto_definition", command_mode)
  bind(["g", "D"], "goto_reference", command_mode)

  # Modes
  bind(["ctrl+l"], "nv_enter_normal_mode", insert_mode[0], context['no_widget'])
  bind(["ctrl+l"], "noop", command_mode)
  bind(["ctrl+l"], "nv_enter_normal_mode", visual_mode)
  bind(["ctrl+l"], "then_go_back_to_normal_mode", context['multiple_selections'], exec="single_selection")

  bind(["ctrl+c"], "hide_overlay", context['in_overlay'])
  bind(["ctrl+m"], "select", context['overlay_focus'])
  bind(["ctrl+m"], "commit_completion", insert_mode, context['auto_complete'])
  bind(["ctrl+m"], "enter_key", context['panel_focus'])

  # Text commands
  bind(["ctrl+k"], "swap_line_up", command_mode[0])
  bind(["ctrl+j"], "swap_line_down", command_mode[0])

  bind(["c", "c"], "replace_selection", visual_mode)
  bind(["g", "c"], "then_go_back_to_normal_mode", visual_mode, exec="toggle_comment")

  bind(["ctrl+h"], "left_delete", insert_mode)
  bind(["ctrl+h"], "left_delete", context['overlay_focus'])
  bind(["ctrl+j"], "insert", insert_mode, context['auto_complete_hidden'], characters="\n")

  bind(["ctrl+shift+h"], [command("move_to", to="bol", extend=True), command("left_delete")], command_mode)

  bind(["d", "w"], "delete_word", command_mode)
  bind(["d", "i", "w"], "delete_word", command_mode, scope="inner")

  bind(["c", "w"], "delete_word", command_mode, replace=True, scope="word_end")
  bind(["c", "i", "w"], "delete_word", command_mode, replace=True, scope="inner")

  bind(["y"], "then_go_back_to_normal_mode", visual_mode, exec="copy")
  bind(["d"], "then_go_back_to_normal_mode", visual_mode, exec="cut")
  bind(["x"], "then_go_back_to_normal_mode", visual_mode, exec="right_delete")

  # Moves
  bind([leader, "e"], "move_to", command_mode, to="brackets", extend=False)
  bind([leader, "e"], "move_to", visual_mode, to="brackets", extend=True)

  bind([leader, "h"], "nv_move_to_first_char_in_line", command_mode, extend=False)
  bind([leader, "h"], "nv_move_to_first_char_in_line", visual_mode, extend=True)

  bind([leader, "l"], "nv_move_to_last_char_in_line", command_mode, extend=False)
  bind([leader, "l"], "nv_move_to_last_char_in_line", visual_mode, extend=True)

  # Move between overlay options
  bind(["ctrl+k"], "move", context['overlay_focus'], by="lines", forward=False)
  bind(["ctrl+j"], "move", context['overlay_focus'], by="lines", forward=True)

  # Move between autocomplete options
  bind(["ctrl+k"], "move", insert_mode, context['auto_complete'], by="lines", forward=False)
  bind(["ctrl+j"], "move", insert_mode, context['auto_complete'], by="lines", forward=True)

  # Plugin: AceJump
  bind(["f"], "ace_jump_within_line", command_mode[0])
  bind(["F"], "ace_jump_line", command_mode[0])
  bind(["s"], "ace_jump_word", command_mode, context['single_selection'])
  bind(["S"], "ace_jump_char", command_mode[0])
  bind(["V"], [command("nv_enter_visual_mode"), command("ace_jump_select")], command_mode[0])
  bind(["D"], "ace_jump_add_cursor", command_mode)

  # Plugin: File Manager
  bind(["c", "enter"], "show_overlay", command_mode[0], overlay="command_palette", text="File Manager ")
  bind(["c", "p"], "show_overlay", command_mode[0], overlay="command_palette", text="File Manager Copy ")
  bind(["c", "n"], "fm_create", command_mode[0])
  bind(["c", "f"], "create_from_current_file", command_mode)
  bind(["alt+i"], "create_from_current_file", insert_mode)
  bind(["alt+i"], "insert_input", {"key": "panel", "operand": "input"}, context['panel_focus'])

  # Plugin: BracketHighlighter
  bind(
    ["c", "s", "q"],
    "bh_key",
    command_mode,
    lines=True,
    plugin={
      "type": ["single_quote", "double_quote"],
      "command": "bh_modules.swapquotes"
    }
  )
  bind(["c", "S"], "swap_brackets", command_mode, **{"async": True})

  bind(["d", "i", "s"], "delete_surrounded", command_mode)
  bind(["d", "a", "s"], "delete_surrounded", command_mode, all=True)

  bind(["c", "i", "s"], "delete_surrounded", command_mode, replace=True)
  bind(["c", "a", "s"], "delete_surrounded", command_mode, replace=True, all=True)

  cs_prefix = ["c", "s"]
  change_surroundings(bind, cs_prefix, "{", "}")
  change_surroundings(bind, cs_prefix, "[", "]")
  change_surroundings(bind, cs_prefix, "(", ")")
  change_surroundings(bind, cs_prefix, "'", "'")
  change_surroundings(bind, cs_prefix, "\"", "\"")
  change_surroundings(bind, cs_prefix, "`", "`")

  bracket_select(bind, ["s", "i"])
  bracket_select(bind, ["s", "a"], all=True)


def change_surroundings(bind, prefix, begin, ending):
  bind(prefix + [begin], "change_surroundings", context['command_mode'], begin=begin, end=ending)

  if begin != ending:
    bind(prefix + [ending], "change_surroundings", context['command_mode'], begin=begin, end=ending)

def bracket_select(bind, keys, **kwargs):
  plugin = {
    "type": ["__all__"],
    "command": "bh_modules.bracketselect"
  }

  if kwargs.get('all', False):
    plugin['args'] = {}
    plugin['args']['always_include_brackets'] = True

  bind(
    keys,
    "bh_key",
    context['visual_mode'],
    lines=True,
    no_outside_adj=None,
    plugin=plugin
  )

context = {}

context['command_mode'] = [
  {"key": "setting.command_mode", "operand": True},
  {"key": "setting.visual_mode", "operand": False}
]

context['visual_mode'] = [
  {"key": "setting.command_mode", "operand": True},
  {"key": "setting.visual_mode", "operand": True}
]

context['insert_mode'] = [
  {"key": "setting.command_mode", "operand": False},
  {"key": "setting.visual_mode", "operand": False},
]

context['selection_empty'] = {
  "key": "selection_empty",
  "operator": "equal",
  "operand": True,
  "match_all": True
}

context['no_widget'] = {
  "key": "setting.is_widget",
  "operand": False
}

context['single_selection'] = {
  "key": "num_selections",
  "operator": "equal",
  "operand": 1
}

context['multiple_selections'] = {
  "key": "num_selections",
  "operator": "not_equal",
  "operand": 1
}

context['in_overlay'] = [
  {"key": "overlay_visible", "operator": "equal", "operand": True},
  {"key": "panel_has_focus", "operator": "equal", "operand": False}
]

context['overlay_focus'] = {
  "key": "overlay_has_focus",
  "operator": "equal",
  "operand": True
}

context['overlay_hidden'] = {
  "key": "overlay_visible",
  "operator": "equal",
  "operand": False
}

context['panel_focus'] = {
  "key": "panel_has_focus",
  "operand": True
}

context['auto_complete'] = {
  "key": "auto_complete_visible"
}


context['auto_complete_hidden'] = {
  "key": "auto_complete_visible",
  "operator": "equal",
  "operand": True
}

context['sidebar_focused'] = {
  "key": "control",
  "operand": "sidebar_tree"
}
