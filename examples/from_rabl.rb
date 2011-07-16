# from RABL
collection @versions

attributes :id => :version_id
attributes :number

code :date do |x|
  x.created_at.strftime("%Y-%m-%d %H:%M")
end

code :current do |x|
  x.current? ? 'current' : content_tag(:a, 'make current', :class => 'make-current')
end

code :view do |x|
  x.current? ? 'view' : content_tag(:a, 'view', :class => 'view-version')
end

code :pages_amount do |x|
  x.pages.count
end

# to Jam
collection @versions, :only => [:number] { |v|
  {
    :date    => v.created_at.strftime("%Y-%m-%d %H:%M"),
    :current => v.current? ? 'current' : content_tag(:a, 'make current', :class => 'make-current'),
    :view    => v.current? ? 'view' : content_tag(:a, 'view', :class => 'view-version'),
    :pages_amount => v.pages.count
  }
}
