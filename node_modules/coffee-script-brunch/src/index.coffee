coffeescript = require 'coffee-script'

# Example
# 
#   capitalize 'test'
#   # => 'Test'
#
capitalize = (string) ->
  (string[0] or '').toUpperCase() + string[1..]

# Example
# 
#   formatClassName 'twitter_users'
#   # => 'TwitterUsers'
#
formatClassName = (filename) ->
  filename.split('_').map(capitalize).join('')

module.exports = class CoffeeScriptCompiler
  brunchPlugin: yes
  type: 'javascript'
  extension: 'coffee'
  generators:
    backbone:
      model: (name, pluralName) ->
        """module.exports = class #{formatClassName name} extends Backbone.Model

"""

      view: (name, pluralName) ->
        """template = require 'views/templates/#{name}'

module.exports = class #{formatClassName name}View extends Backbone.View
  template: template

"""

    chaplin:
      controller: (name, pluralName) ->
        """Controller = require 'controllers/base/controller'

module.exports = class #{formatClassName pluralName}Controller extends Controller

"""

      collection: (name, pluralName) ->
        """Collection = require 'models/base/collection'
#{formatClassName name} = require 'models/#{name}'

module.exports = class #{formatClassName pluralName} extends Collection
  model: #{formatClassName name}

"""

      model: (name, pluralName) ->
        """Model = require 'models/base/model'

module.exports = class #{formatClassName name} extends Model

"""

      view: (name, pluralName) ->
        """View = require 'views/base/view'
template = require 'views/templates/#{name}'

module.exports = class #{formatClassName name}View extends View
  template: template

"""

      'page-view': (name, pluralName) ->
        """PageView = require 'views/base/page_view'
template = require 'views/templates/#{name}_page'

module.exports = class #{formatClassName name}PageView extends View
  template: template

"""

      'collection-view': (name, pluralName) ->
        """CollectionView = require 'views/base/collection_view'
#{formatClassName name} = require 'views/#{name}_view'

module.exports = class #{formatClassName pluralName}View extends CollectionView
  getView: (item) ->
    new #{formatClassName name} model: item

"""

  constructor: (@config) ->
    null

  compile: (data, path, callback) ->
    try
      result = coffeescript.compile data, bare: yes
    catch err
      error = err
    finally
      callback error, result
