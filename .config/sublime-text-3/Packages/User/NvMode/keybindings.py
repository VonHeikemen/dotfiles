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
  bind(
    ["ctrl+l"],
    [
      command("nv_enter_normal_mode"),
      command("delete_till_beginning_of_line_if_empty")
    ],
    insert_mode[0],
    context['no_widget']
  )
  bind(["ctrl+l"], "noop", normal_mode)
  bind(["ctrl+l"], "nv_enter_normal_mode", visual_mode)
  bind(["ctrl+l"], "single_selection", normal_mode, context['multiple_selections'])

  bind(["i", "i"], "nv_enter_insert_mode", visual_mode)

  bind(["ctrl+c"], "hide_overlay", context['in_overlay'])
  bind(["ctrl+m"], "select", context['overlay_focus'])
  bind(["ctrl+m"], "commit_completion", insert_mode, context['auto_complete'])
  bind(["ctrl+m"], "enter_key", context['panel_focus'])

  # Text commands
  bind(["ctrl+k"], "swap_line_up", nv_mode_enabled)
  bind(["ctrl+j"], "swap_line_down", nv_mode_enabled)

  bind(["c", "c"], "replace_selection", visual_mode)
  bind(["g", "c"], "then_go_back_to_normal_mode", visual_mode, exec="toggle_comment")

  bind(["g", "u"], "convert_char_case", normal_mode, context['selection_empty'], to="lower")
  bind(["g", "U"], "convert_char_case", normal_mode, context['selection_empty'], to="upper")
  bind(["~"], "convert_char_case", normal_mode, context['selection_empty'], to="toggle")

  backspace(bind, ["ctrl+h"])
  bind(["ctrl+j"], "insert", insert_mode, context['auto_complete_hidden'], characters="\n")

  bind(["i", "w"], "select_inner_word", visual_mode)

  bind(["d", "w"], "custom_delete_word", normal_mode)
  bind(["d", "i", "w"], "custom_delete_word", normal_mode, scope="inner")

  bind(["d", "b"], "custom_delete_word", normal_mode, scope="word_start")
  bind(["c", "b"], "custom_delete_word", normal_mode, scope="word_start", replace=True)

  bind(["c", "w"], "custom_delete_word", normal_mode, replace=True, scope="word_end")
  bind(["c", "i", "w"], "custom_delete_word", normal_mode, replace=True, scope="inner")

  delete_move = create_delete_move(bind, command, delete_key=["d"], replace_key=["c"])

  delete_move(["0"], [command("move_to", to="bol", extend=True), command("move_to", to="bol", extend=True)])
  delete_move(["$"], [command("move_to", to="eol", extend=True)])

  delete_move([leader, "h"], [command("nv_move_to_first_char_in_line", extend=True)])
  delete_move([leader, "l"], [command("nv_move_to_last_char_in_line", extend=True)])

  bind(["y"], "then_go_back_to_normal_mode", visual_mode, exec="copy")
  bind(["d"], "then_go_back_to_normal_mode", visual_mode, exec="cut")
  bind(["x"], "then_go_back_to_normal_mode", visual_mode, exec="right_delete")

  bind(["g", "v"], [command("jump_to_previous_selection"), command("nv_enter_visual_mode")], normal_mode)
  bind(["g", "v"], "jump_to_previous_selection", visual_mode)

  bind(["c", "o"], "create_from_current_file", nv_mode_enabled)
  bind(["c", "f"], "insert_path_based_on_current_file", nv_mode_enabled)
  bind(["c", "f"], "complete_selected_path", visual_mode)
  bind(["alt+i"], "insert_path_based_on_current_file", insert_mode)

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

  bracket_select(bind, ["i", "s"])
  bracket_select(bind, ["a", "s"], all=True)

  all_pairs = [
    ["{", "}"],
    ["[", "]"],
    ["(", ")"],
    ["'", "'"],
    ["\"", "\""],
    ["`", "`"],
  ]

  for index, pair in enumerate(all_pairs):
    change_surroundings(bind, ["c", "s"], pair, index, all_pairs)
    change_closest_surroundings(bind, ["C"], pair[0], pair[1])

    select_surroundings(bind, ["i"], pair)
    select_surroundings(bind, ["a"], pair, all=True)

    delete_surroundings(bind, ["d", "i"], pair)
    delete_surroundings(bind, ["d", "a"], pair, all=True)

    delete_surroundings(bind, ["c", "i"], pair, replace=True)
    delete_surroundings(bind, ["c", "a"], pair, all=True, replace=True)


def change_surroundings(bind, prefix, replace, index, pairs):
  begin = replace[0]
  end = replace[1]

  for i, val in enumerate(pairs):
    if i == index:
      continue

    bind(
      prefix + [val[0], begin],
      "change_surroundings",
      context['command_mode'],
      begin=begin,
      end=end,
      find=val
    )

    if begin != end and val[0] != val[1]:
      bind(
        prefix + [val[1], end],
        "change_surroundings",
        context['command_mode'],
        begin=begin,
        end=end,
        find=val
      )

def change_closest_surroundings(bind, prefix, begin, ending):
  bind(
    prefix + [begin],
    "change_surroundings",
    context['command_mode'],
    begin=begin,
    end=ending
  )

  if begin != ending:
    bind(
      prefix + [ending],
      "change_surroundings",
      context['command_mode'],
      begin=begin,
      end=ending
    )


def select_surroundings(bind, prefix, pair, **kwargs):
  begin = pair[0]
  end = pair[1]
  select_all = kwargs.get('all', False)

  bind(
    prefix + [begin],
    "select_surrounded_content",
    context['visual_mode'],
    find=pair,
    all=select_all
  )

  if begin != end:
    bind(
      prefix + [end],
      "select_surrounded_content",
      context['visual_mode'],
      find=pair,
      all=select_all
    )


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

def delete_surroundings(bind, prefix, pair, **kwargs):
  begin = pair[0]
  end = pair[1]

  bind(
    prefix + [begin],
    "delete_surrounded",
    context['command_mode'],
    find=pair,
    all=kwargs.get('all', False),
    replace=kwargs.get('replace', False)
  )

  if begin != end:
    bind(
      prefix + [end],
      "delete_surrounded",
      context['command_mode'],
      find=pair,
      all=kwargs.get('all', False),
      replace=kwargs.get('replace', False)
    )

def create_delete_move(bind, command, delete_key=None, replace_key=None):
  def move(keys, cmds):
    delete_command = cmds + [command("cut")]
    replace_command = cmds + [command("cut"), command("nv_enter_insert_mode")]

    bind(delete_key + keys, delete_command, context['command_mode'])
    bind(replace_key + keys, replace_command, context['command_mode'])

  return move

def backspace(bind, key):
  bind(key, "left_delete", context['insert_mode'])
  bind(key, "left_delete", context['overlay_focus'])

  extra_context = [
    [
      { "key": "setting.auto_match_enabled", "operator": "equal", "operand": True },
      { "key": "selection_empty", "operator": "equal", "operand": True, "match_all": True },
      { "key": "preceding_text", "operator": "regex_contains", "operand": "\"$", "match_all": True },
      { "key": "following_text", "operator": "regex_contains", "operand": "^\"", "match_all": True },
      { "key": "selector", "operator": "not_equal", "operand": "punctuation.definition.string.begin", "match_all": True },
      { "key": "eol_selector", "operator": "not_equal", "operand": "string.quoted.double - punctuation.definition.string.end", "match_all": True },
    ],
    [
      { "key": "setting.auto_match_enabled", "operator": "equal", "operand": True },
      { "key": "selection_empty", "operator": "equal", "operand": True, "match_all": True },
      { "key": "preceding_text", "operator": "regex_contains", "operand": "'$", "match_all": True },
      { "key": "following_text", "operator": "regex_contains", "operand": "^'", "match_all": True },
      { "key": "selector", "operator": "not_equal", "operand": "punctuation.definition.string.begin", "match_all": True },
      { "key": "eol_selector", "operator": "not_equal", "operand": "string.quoted.single - punctuation.definition.string.end", "match_all": True },
    ],
    [
      { "key": "setting.auto_match_enabled", "operator": "equal", "operand": True },
      { "key": "selection_empty", "operator": "equal", "operand": True, "match_all": True },
      { "key": "preceding_text", "operator": "regex_contains", "operand": "\\($", "match_all": True },
      { "key": "following_text", "operator": "regex_contains", "operand": "^\\)", "match_all": True }
    ],
    [
      { "key": "setting.auto_match_enabled", "operator": "equal", "operand": True },
      { "key": "selection_empty", "operator": "equal", "operand": True, "match_all": True },
      { "key": "preceding_text", "operator": "regex_contains", "operand": "\\[$", "match_all": True },
      { "key": "following_text", "operator": "regex_contains", "operand": "^\\]", "match_all": True }
    ],
    [
      { "key": "setting.auto_match_enabled", "operator": "equal", "operand": True },
      { "key": "selection_empty", "operator": "equal", "operand": True, "match_all": True },
      { "key": "preceding_text", "operator": "regex_contains", "operand": "\\{$", "match_all": True },
      { "key": "following_text", "operator": "regex_contains", "operand": "^\\}", "match_all": True }
    ]
  ]

  for ctx in extra_context:
    bind(
      key,
      "run_macro_file",
      context['insert_mode'],
      ctx,
      file="res://Packages/Default/Delete Left Right.sublime-macro"
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
  "operand": False
}

context['sidebar_focused'] = {
  "key": "control",
  "operand": "sidebar_tree"
}
