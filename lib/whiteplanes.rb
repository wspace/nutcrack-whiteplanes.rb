module Whiteplanes
  ROOT_PATH = File.expand_path(File.dirname(__FILE__)) + '/whiteplanes/'
  %w(command version runtime ).each do |file|
    require ROOT_PATH + '/' + file
  end
end