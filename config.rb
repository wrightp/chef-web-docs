require 'lib/sitemap'
require 'lib/compass'
require 'lib/markdown'
require 'lib/helpers/deploy_helpers'
require 'lib/helpers/tab_helpers'
require 'lib/helpers/url_helpers'

# In development you can use `binding.pry` anywhere to pause execution and bring
# up a Ruby REPL
begin
  require 'pry'
rescue LoadError
  logger.debug 'Pry is missing and will not be loaded.'
end

###
# Config
###
set :site_url, 'learnchef.opscode.com'

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
compass_config do |config|
  # config.output_style = :compact
  config.line_comments = false
end

# Slim Configuration
Slim::Engine.set_default_options pretty: true, disable_escape: true

###
# Page options, layouts, aliases and proxies
###

activate :directory_indexes
set :trailing_slash, false

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end
page '/robots.txt', layout: false
page '/sitemap.xml', layout: false
page '/website_configuration.xml', layout: false

# S3 hosting needs a page at the root
page '/error.html', directory_index: false

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
helpers do
  include DeployHelpers
  include TabHelpers
  include URLHelpers
end

# Enable Livereload
activate :livereload

# Enable syntax highlighting - turn off the default wrapping
activate :syntax, wrap: false
# Override the middleman-syntax to provide backwards compat with pygments wrap
require 'lib/middleman_syntax'

# Parse code blocks
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: false

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir, 'assets/fonts'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable asset hash
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Compress PNGs after build
  activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

# Write out a REVISION file that shows which revision we're running
after_build do
  open("#{root_path.join('build', 'REVISION')}", 'w').write(
    ENV['TRAVIS_COMMIT'] || `git rev-parse HEAD`.chomp
  )
end
