local cfg = require('kommentary.config')

cfg.configure_language('default', {
  prefer_single_line_comments = true,
})
cfg.configure_language('php', {
  single_line_comment_string = '//'
})
cfg.configure_language('python', {
  single_line_comment_string = '#'
})

