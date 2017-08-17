module ApplicationHelper
  def flash_class(kind)
    {
      'alert' => 'warning',
      'error' => 'danger',
      'success' => 'success'
    }[kind] || 'info'
  end

  def r_image_tag(name_at_1x, options={})

    path_at_2x = if options[:path_at_2x]
      options[:path_at_2x]
    else
      name_at_2x = name_at_1x.gsub(%r{\.\w+$}, '@2x\0')
      asset_path(name_at_2x)
    end

    image_tag(name_at_1x, options.merge(srcset: "#{path_at_2x} 2x"))
  end
  
end
