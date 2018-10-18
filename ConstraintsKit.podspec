# MARK: converted automatically by spec.py. @hgy

Pod::Spec.new do |s|
	s.name = 'ConstraintsKit'
	s.version = '1.0.0'
	s.description = 'ConstraintsKit'
	s.license = { :type => 'MIT', :file => 'LICENSE.md' }
	s.summary = 'ConstraintsKit'
	s.homepage = 'http://www.qq.com'
	s.authors = { 'saucym' => '413132340@qq.com' }
	s.source = { :git => 'https://github.com/saucym/ConstraintsKit.git', :branch => 'master' }
	s.requires_arc = true
	s.ios.deployment_target = '9.0'

        s.swift_version = '4.2'
	s.source_files = 'ConstraintsKit/**/*.{h,m,swift}'
	s.resources = 'Resource/**/*.{xib,json,png,jpg,gif,js}','ConstraintsKit/**/*.{xib,json,png,jpg,gif,js}'
end
