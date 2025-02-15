require "csv"

puts "\nCreating Tags..."
CSV.foreach('db/csv/20250215_new_tags.csv', headers: true) do |row|
  tag = Tag.find_or_create_by!(id: row['tag_id']) do |t|
    t.name = row['name']
    t.color = row['color']
  end
  print "."
end