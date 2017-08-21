Dir[Rails.root + 'lib/errors/*.rb'].each do |file|
  require file
end
