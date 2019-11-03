Gem::Specification.new do |s|
  s.name          = "omni_scrapper"
  s.version       = "2.0.0.beta1"
  s.licenses      = ['MIT']
  s.summary       = "This is an example!"
  s.description   = "Much longer explanation of the example!"
  s.author        = "Stanislav Mekhonoshin"
  s.email         = "ejabberd@gmail.com"
  s.require_paths = ["lib"]
  s.files         = `git ls-files`.split($/)

  s.add_runtime_dependency 'mechanize'
  s.add_runtime_dependency 'ferrum'
  s.add_runtime_dependency 'json-schema'
end
