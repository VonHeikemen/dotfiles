return {
  cmd = {'intelephense', '--stdio'},
  filetypes = {'php'},
  root_markers = {'composer.json'},
  settings = {
    intelephense = {
      telemetry = {enabled = false},
    },
  },
}

