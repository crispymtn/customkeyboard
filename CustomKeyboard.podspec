Pod::Spec.new do |s|
  s.name             = "CustomKeyboard"
  s.version          = "1.1.1"
  s.summary          = "Custom inputView that looks like the default iPad keyboard"
  s.homepage         = "https://github.com/crispymtn/custom-keyboard"
  s.license          = '(c) 2016 Crispy Mountain GmbH, All rights reserved. This is a private pod.'
  s.author           = { "Josch" => "jg@crispymtn.com" }
  s.source           = { :git => "https://github.com/crispymtn/custom-keyboard.git", :tag => s.version }

  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = '**/*.{swift}'
  s.frameworks = 'UIKit'
  s.module_name = 'CustomKeyboard'
end
