require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  # Pod name aligned with npm scope @vaecebyz/capacitor-getui
  # Convention: Scope + CamelCase of package remainder
  s.name = 'VaecebyzCapacitorGetui'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['repository']['url']
  s.authors = { 'vaecebyZ' => 'https://github.com/vaecebyZ' }
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target  = '12.0'
  s.dependency 'Capacitor'
  s.swift_version = '5.1'
end