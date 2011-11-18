module AssetsHelper

  def asset_file(file, o = {})
    options = { :type => 'js' }.merge(o)

    case options[:type]
      when 'js'   then concat(javascript_include_tag("/javascripts/#{file}"))
      when 'less' then concat(stylesheet_link_tag("/stylesheets/#{file}", :rel => "stylesheet/less"))
      when 'css'  then concat(stylesheet_link_tag("/stylesheets/#{file}"))
    end
  end

  def asset_dir(dirname, o = {})
    options = { :recursive => false, :type => 'js' }.merge(o)

    type = options[:type] == 'js' ? 'javascripts' : 'stylesheets'
    path = "#{Rails.root}/public/#{type}/#{dirname}"
    return if !File.exists?(path)

    dir = Dir.new(path)
    dir.each do |name|
      if name =~ /.*\.#{options[:type]}$/
        asset_file(dirname+"/"+name, options)
      elsif options[:recursive] and FileTest.directory?(path) and name !~ /^\./
        asset_dir(dirname+"/"+name, options)
      end
    end
  end
end