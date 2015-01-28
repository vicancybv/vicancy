require 'attachinary/orm/active_record'

# To support uploading from browser
#
# Next, add following line in your routes.rb file:
# mount Attachinary::Engine => "/attachinary"
#
# It will generate '/attachinary/cors' which will be used for iframe file transfers (for unsupported browsers).
#
# Finally, make sure that you have following line in head section of your application layout file:
#
# <%= cloudinary_js_config %>
#
# from https://github.com/assembler/attachinary