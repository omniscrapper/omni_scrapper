spec = Gem::Specification.find_by_name 'omni_scrapper'
Dir["#{spec.gem_dir}/lib/tasks/*.rake"].each do |path|
  load path
end


