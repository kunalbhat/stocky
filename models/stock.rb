class Stock
  include DataMapper::Resource

  belongs_to :portfolio

  property :id,                 Serial
  property :symbol,             String
  property :transaction_type,   Integer
  property :transaction_date,   Date
  property :shares,             Float
  property :price,              Float
  property :commission,         Float
  property :notes,              Text
  property :created_at,         DateTime
end

DataMapper.finalize.auto_upgrade!
