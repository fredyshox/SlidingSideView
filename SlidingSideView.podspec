Pod::Spec.new do |s|

    s.name         = 'SlidingSideView'
    s.version      = '0.3.0'
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.author       = { 'Kacper Raczy' => 'gfw.kra@gmail.com' }
    s.homepage     = 'https://github.com/fredyshox/SlidingSideView'
    s.summary      = 'Framework for displaying side views by sliding them out of the edge of the screen/container.'
    s.description  = <<-DESC
        Tool for displaying any kind of side views by sliding them out of the edge of the screen, written in Swift
        It supports every screen egde(left, right, top and bottom)and handles the presentation programmaticaly.

        To use it, you have to provide your own view or view controller's view that you want to display and
        embed it in SlidingSideView.

        It can be treated as a regular UIView subclass, and be embedded in regular UIView to achieve
        similar effects in different contexts.
    DESC

    s.platform     = :ios
    s.ios.deployment_target = '8.0'
    s.requires_arc = true

    s.source       = { :git => 'https://github.com/fredyshox/SlidingSideView.git', :tag => s.version.to_s }
    s.source_files  = 'SlidingSideView/*.{swift}'

    s.framework  = 'UIKit'
    s.pod_target_xcconfig = {'SWIFT_VERSION' => '3'}

end
