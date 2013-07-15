# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#`mongoimport -d #{Mongoid.master.name} -h #{Mongoid.master.connection.host_to_try[0]} --drop -c records test/fixtures/records.json`

#puts "#{Mongoid.default_session.inspect}"
`mongoimport -d #{Mongoid.default_session.options[:database]} --drop --collection records --file test/fixtures/records.json`