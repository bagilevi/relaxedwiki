class RelaxedwikiGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      dir = "app/views/wiki"
      m.directory dir
      m.file 'views/show.haml', "#{dir}/show.haml"
      m.file 'views/edit.haml', "#{dir}/edit.haml"
      m.file 'views/changelog.haml', "#{dir}/changelog.haml"
      m.file 'views/version.haml', "#{dir}/version.haml"
      m.file 'wiki_controller.rb', "app/controllers/wiki_controller.rb"
      m.file 'wiki_helper.rb', "app/helpers/wiki_helper.rb"
    end
  end
end
