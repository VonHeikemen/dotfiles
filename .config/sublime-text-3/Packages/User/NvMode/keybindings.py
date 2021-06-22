leader = " "

def keybinding(bind, **kwargs):
  command = kwargs.get('command')

  nv_mode_enabled = context['command_mode'][0]
  normal_mode = context['command_mode']
  visual_mode = context['visual_mode']
  insert_mode = context['insert_mode']

  # Hacky stuff
  bind(["h"], "move_visual_mode_starting_point", visual_mode, context['selection_empty'], by="characters")
  bind(["k"], "move_visual_mode_starting_point", visual_mode, context['selection_empty'], by="lines")
  bind(["a"], "better_a", nv_mode_enabled, context['selection_empty'])
  bind(["ctrl+o"], "hacky_ctrl_o", insert_mode, context['selection_empty'])

  # App commands
  bind([leader, ","], "edit_settings", nv_mode_enabled, base_file="$packages/User/NvMode/keybindings.py")
  bind([leader, "Q"], "nv_disable_and_exit", nv_mode_enabled)
  bind([leader, "q", "q"], "safer_quit", nv_mode_enabled)
  bind([leader, "w"], "save", nv_mode_enabled, **{"async": True})

  bind(["[", "t"], "prev_view", nv_mode_enabled)
  bind(["]", "t"], "next_view", nv_mode_enabled)

  bind(["[", "q"], "prev_result", nv_mode_enabled)
  bind(["]", "q"], "next_result", nv_mode_enabled)

  # Manage multi-select Tabs
  bind(["[", "f"], "focus_to_left", nv_mode_enabled)
  bind(["]", "f"], "focus_to_right", nv_mode_enabled)
  bind(["[", "F"], "unselect_to_left", nv_mode_enabled)
  bind(["]", "F"], "unselect_to_right", nv_mode_enabled)

  bind([leader, "b", "b"], "otl_open_tab_list", nv_mode_enabled)
  bind([leader, "b", "l"], "next_view_in_stack", nv_mode_enabled)
  bind([leader, "b", "c"], "close", nv_mode_enabled)

  # Sidebar
  bind([leader, "d", "d"], "use_sidebar", nv_mode_enabled)
  bind([leader, "d", "d"], "use_sidebar", context['sidebar_focused'])
  bind(["h"], "move", context['sidebar_focused'], by="characters", forward=False)
  bind(["l"], "move", context['sidebar_focused'], by="characters", forward=True)
  bind(["k"], "move", context['sidebar_focused'], by="lines", forward=False)
  bind(["j"], "move", context['sidebar_focused'], by="lines", forward=True)

  # Search
  bind(["enter"], "show_overlay", nv_mode_enabled, overlay="command_palette")

  bind([leader, "F"], "show_panel", nv_mode_enabled, panel="find_in_files")
  bind([leader, "f", "f"], "show_overlay", nv_mode_enabled, overlay="goto", show_files=True)
  bind([leader, "f", "s"], "show_overlay", nv_mode_enabled, overlay="goto", text="@")
  bind([leader, "f", "S"], "goto_symbol_in_project", nv_mode_enabled)

  bind([leader, "r"], "show_panel", nv_mode_enabled, panel="replace", reverse=False)

  bind([leader, "y"], "slurp_find_string", nv_mode_enabled)

  bind(["n"], "find_under_expand", visual_mode)
  bind(["N"], "find_under_expand_skip", visual_mode)

  bind(["g", "d"], "goto_definition", normal_mode)
  bind(["g", "D"], "goto_reference", normal_mode)
  bind(["g", "l"], "goto_definition", normal_mode, side_by_side=True, clear_to_right=True)
  bind(["g", "L"], "goto_reference", normal_mode, side_by_side=True, clear_to_right=True)

  # Modes
  bind(["ctrl+l"], "nv_enter_normal_mode", insert_mode[0], context['no_widget'])
  bind(["ctrl+l"], "noop", normal_mode)
  bind(["ctrl+l"], "nv_enter_normal_mode", visual_mode)
  bind(["ctrl+l"], "then_go_back_to_normal_mode", context['multiple_selections'], exec="single_selection")

  bind(["ctrl+c"], "hide_overlay", context['in_overlay'])
  bind(["ctrl+m"], "select", context['overlay_focus'])
  bind(["ctrl+m"], "commit_completion", insert_mode, context['auto_complete'])
  bind(["ctrl+m"], "enter_key", context['panel_focus'])

  # Text commands
  bind(["ctrl+k"], "swap_line_up", nv_mode_enabled)
  bind(["ctrl+j"], "swap_line_down", nv_mode_enabled)

  bind(["c", "c"], "replace_selection", visual_mode)
  bind(["g", "c"], "then_go_back_to_normal_mode", visual_mode, exec="toggle_comment")

  bind(["ctrl+h"], "left_delete", insert_mode)
  bind(["ctrl+h"], "left_delete", context['overlay_focus'])
  bind(["ctrl+j"], "insert", insert_mode, context['auto_complete_hidden'], characters="\n")

  bind(["ctrl+shift+h"], [command("move_to", to="bol", extend=True), command("left_delete")], nv_mode_enabled)

  bind(["s", "w"], "select_inner_word", visual_mode)

  bind(["d", "w"], "delete_word", normal_mode)
  bind(["d", "i", "w"], "delete_word", normal_mode, scope="inner")

  bind(["c", "w"], "delete_word", normal_mode, replace=True, scope="word_end")
  bind(["c", "i", "w"], "delete_word", normal_mode, replace=True, scope="inner")

  bind(["y"], "then_go_back_to_normal_mode", visual_mode, exec="copy")
  bind(["d"], "then_go_back_to_normal_mode", visual_mode, exec="cut")
  bind(["x"], "then_go_back_to_normal_mode", visual_mode, exec="right_delete")

  # Moves
  bind([leader, "e"], "move_to", normal_mode, to="brackets", extend=False)
  bind([leader, "e"], "move_to", visual_mode, to="brackets", extend=True)

  bind([leader, "h"], "nv_move_to_first_char_in_line", normal_mode, extend=False)
  bind([leader, "h"], "nv_move_to_first_char_in_line", visual_mode, extend=True)

  bind([leader, "l"], "nv_move_to_last_char_in_line", normal_mode, extend=False)
  bind([leader, "l"], "nv_move_to_last_char_in_line", visual_mode, extend=True)

  # Move between overlay options
  bind(["ctrl+k"], "move", context['overlay_focus'], by="lines", forward=False)
  bind(["ctrl+j"], "move", context['overlay_focus'], by="lines", forward=True)

  # Move between autocomplete options
  bind(["ctrl+k"], "move", insert_mode, context['auto_complete'], by="lines", forward=False)
  bind(["ctrl+j"], "move", insert_mode, context['auto_complete'], by="lines", forward=True)

  # Plugin: AceJump
  bind(["f"], "ace_jump_within_line", nv_mode_enabled)
  bind(["F"], "ace_jump_line", nv_mode_enabled)
  bind(["s"], "ace_jump_word", normal_mode, context['single_selection'])
  bind(["S"], "ace_jump_char", nv_mode_enabled)
  bind(["V"], [command("nv_enter_visual_mode"), command("ace_jump_select")], nv_mode_enabled)
  bind(["D"], "ace_jump_add_cursor", normal_mode)

  # Plugin: File Manager
  bind(["c", "enter"], "show_overlay", nv_mode_enabled, overlay="command_palette", text="File Manager ")
  bind(["c", "p"], "show_overlay", nv_mode_enabled, overlay="command_palette", text="File Manager Copy ")
  bind(["c", "n"], "fm_create", nv_mode_enabled)
  bind(["c", "f"], "create_from_current_file", normal_mode)
  bind(["alt+i"], "create_from_current_file", insert_mode)
  bind(["alt+i"], "insert_input", {"key": "panel", "operand": "input"}, context['panel_focus'])

  # Plugin: Case Conversion
  bind(["c", "r", "s"], "convert_to_snake", nv_mode_enabled)
  bind(["c", "r", "S"], "convert_to_screaming_snake", nv_mode_enabled)
  bind(["c", "r", "c"], "convert_to_camel", nv_mode_enabled)
  bind(["c", "r", "d"], "convert_to_dash", nv_mode_enabled)

  # Plugin: Column Select
  bind(["alt+k"], "column_select", normal_mode, by="lines", forward=False)
  bind(["alt+j"], "column_select", normal_mode, by="lines", forward=True)

  # Plugin: BracketHighlighter
  bind(
    ["c", "s", "q"],
    "bh_key",
    normal_mode,
    lines=True,
    plugin={
      "type": ["single_quote", "double_quote"],
      "command": "bh_modules.swapquotes"
    }
  )
  bind(["c", "S"], "swap_brackets", normal_mode, **{"async": True})

  bind(["d", "i", "s"], "delete_surrounded", normal_mode)
  bind(["d", "a", "s"], "delete_surrounded", normal_mode, all=True)

  bind(["c", "i", "s"], "delete_surrounded", normal_mode, replace=True)
  bind(["c", "a", "s"], "delete_surrounded", normal_mode, replace=True, all=True)

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
