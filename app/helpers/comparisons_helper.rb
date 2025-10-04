module ComparisonsHelper
  def in_comparison?(property)
    comparison_properties = session[:comparison_properties] || []
    comparison_properties.include?(property.id)
  end

  def comparison_count
    (session[:comparison_properties] || []).length
  end
end

