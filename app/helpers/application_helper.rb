module ApplicationHelper
  def flash_class(kind)
    {
      'alert' => 'warning',
      'error' => 'danger',
      'success' => 'success'
    }[kind] || 'info'
  end
end
