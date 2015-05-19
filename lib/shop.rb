require 'support/number_helper'

class Shop
	include NumberHelper
	
	@@filepath = nil
	attr_accessor :name , :type , :price , :rate
	
	def initialize(args={})
		@name = args[:name] || ""
		@type = args[:type] || ""
		@price = args[:price] || ""
		@rate = args[:rate] || ""
	end	

	def self.filepath=(path=nil)
		@@filepath = File.join(APP_ROOT, path)
	end
	
	def self.file_exists?
		#does file exists
		if File.exists?(@@filepath)
			return true
		end
	end

	def self.create_file
		#create if it does not exist
		File.open(@@filepath, 'w') unless file_exists?
		return file_exists?
	end

	def self.saved_shops
		#return shops and other details by reading the file
		shops = []
		file = File.new(@@filepath , 'r')
		file.each_line do |line|
			shops << Shop.new.import_line(line)
		end
		file.close
		return shops
	end
	
	def self.build_from_input
		args = {}
		puts "\nName of Shop :"
		print "> "
		args[:name] = gets.chomp.strip
		
		puts "\nType of Gadget Found :"
		print "> "
		args[:type] = gets.chomp.strip
		
		puts "\nAverage Price :"
		print "> "
		args[:price] = gets.chomp.strip
		
		puts "\nRate on 5 stars :"
		print "> "
		args[:rate] = gets.chomp.strip
		
		return self.new(args)
	end
	
	def import_line(line)
		array = line.split("\t")
		@name , @type, @price, @rate = array
		return self
	end
	
	def save
		File.open(@@filepath , 'a') do |file|
			file.puts "#{[@name, @type, @price, @rate].join("\t")}\n"
		end
		return true
	end

	def formatted_price
		number_to_currency(@price)
	end

	def formatted_rate
		number_to_stars(@rate)
	end
end
