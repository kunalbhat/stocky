class Stock
  include DataMapper::Resource

  property :id, Serial
  property :symbol, String

  DataMapper.finalize
  DataMapper.auto_upgrade!
end
