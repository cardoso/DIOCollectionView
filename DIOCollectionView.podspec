#
# Be sure to run `pod lib lint DIOCollectionView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DIOCollectionView'
  s.version          = '0.1.0'
  s.summary          = 'Drag Items in and out of CollectionViews.'

  s.description      = 'Drag from CollectionView to any View, flexible delegated behaviors, snapshot view and animations specifiable via DataSource'

  s.homepage         = 'https://github.com/matheusmcardoso/DIOCollectionView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Matheus Martins' => 'matheusmcrds@gmail.com' }
  s.source           = { :git => 'https://github.com/matheusmcardoso/DIOCollectionView.git', :tag => "0.1.0"}
  # s.social_media_url = 'https://twitter.com/matheusmcardoso’

  s.ios.deployment_target = '8.0'

  s.source_files = 'Classes/**/*'
  
  # s.resource_bundles = {
  #   'DIOCollectionView' => ['Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
