production_seeds = []

production_seeds.each do |seed|
  seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
  if File.exists?(seed_file)
    require seed_file
  end
end
