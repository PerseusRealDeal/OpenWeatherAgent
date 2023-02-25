Pod::Spec.new do |p|

p.name           = "OpenWeatherFreeClient"
p.version        = "0.0.1"
p.summary        = "OpenWeather Free API Client."
p.description    = "OpenWeatherMap Dara Provider Free API Client."
p.homepage       = "https://github.com/perseusrealdeal/OpenWeatherFreeClient"

p.license        = { :type => "MIT", :file => "LICENSE" }
p.author         = { "perseusrealdeal" => "mzhigulin@gmail.com" }

p.source         = { :git => "https://github.com/perseusrealdeal/OpenWeatherFreeClient.git", :tag => p.version.to_s }

p.ios.deployment_target  = '9.3'
p.osx.deployment_target  = '10.9'

p.swift_version  = "4.2"
p.requires_arc   = true

p.source_files   = 'Sources/**/*.swift'

end