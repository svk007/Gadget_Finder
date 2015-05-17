#Run this file to Launch the Application

APP_ROOT = File.dirname(__FILE__)

$:.unshift( File.join(APP_ROOT,  'lib'))

require 'guide'

guide = Guide.new('shops.txt')
guide.launch!