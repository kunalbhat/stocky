DataMapper.setup(:default, ENV['DATABASE_URL'])

# set all String properties to have a default length of 255
DataMapper::Property::String.length(255)
