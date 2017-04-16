require "faker"

20.times do
  Trout.create(
    name: Faker::Name.name,
    weight: Faker::Commerce.price.to_i,
    taste: Faker::Food.spice
  )
end

