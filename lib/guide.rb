require 'shop'
require 'support/string_extend'
class Guide

	@@actions = ['list' , 'add', 'find', 'quit']
	def initialize(path = nil)
	#Look for file
		Shop.filepath = path
		if Shop.file_exists?
			puts "Found Shops file"
		#Create file if not present
		elsif Shop.create_file
			puts "Created file"
		#Exit if create fails
		else
			puts "Exiting."
			exit!
	end
end

def launch!
	introduction
		#action loop
		result = nil
		until result == :quit
			user_action, args = get_action
			result  = do_action(user_action, args)	
		#loop until quit
	end
	conclusion
end

def get_action
	user_action = nil
	until @@actions.include?(user_action)
		puts "\nActions : " + @@actions.join(", ")
		print "> "
		args = gets.chomp.downcase.strip.split(' ')
		user_action = args.shift
	end		
	return user_action, args
end

def introduction
	puts_formatted("Welcome to the Gadget Finder.")
	puts "This application allows you to select your desired gadget from a range of shops"
end

def conclusion
	puts_formatted("Sure you found what you were looking for. Enjoy shopping!")
end

def do_action(action, args)
	case action
	when 'list'
		list(args)
	when 'find'
		keyword = args.shift
		find(keyword)
	when 'add'
		add
	when 'quit'
		return :quit
	else
		puts_formatted("Please enter correct choice")
	end
end	

def add
	puts_formatted("Add a Shop")
	shop = Shop.build_from_input
	if shop.save
		puts_formatted("Shop Successfully Added")
	else
		puts_formatted("Shop could not be saved")
	end
end

def find(keyword="")
	puts_formatted("Find a restaurant")
	if keyword
		shops = Shop.saved_shops
		found = shops.select do |shop|
			shop.name.downcase.include?(keyword.downcase) || 
			shop.type.downcase.include?(keyword.downcase) || 
			shop.price.to_i <= keyword.to_i
		end
		output_table(found)
	else
		list
		puts "Examples: 'find bose', 'find headphone', 'find 10000', 'find east'\n\n"
	end
end

def list(args=[])
	sort_order = args.shift
	sort_order = args.shift if sort_order ='by'
	sort_order = "name" unless ['name', 'type', 'price', 'rate'].include?(sort_order)
	
	puts_formatted("Listing shops")
	shop = Shop.saved_shops
	
	shop.sort! do |s1,s2|
		case sort_order
		when 'name'
			s1.name.downcase <=> s2.name.downcase
		when 'type'
			s1.type.downcase <=> s2.type.downcase
		when 'price'
			s1.price.to_i <=> s2.price.to_i
		when 'rate'
			s2.rate.to_i <=> s1.rate.to_i
		end
	end
	
	output_table(shop)
	puts "Table can be listed by 'list type' or 'list by type'"
end

private

def puts_formatted(text)
	puts "\n<<< #{text.upcase.center(70)} >>>\n\n"
end

def output_table(shops=[])
	puts "-" * 70
	print " " + "Name".ljust(30)
	print " " + "Type".ljust(15)
	print " " + "Price".ljust(12)
	print " " + "Rating".rjust(6) + "\n"
	puts "-" * 70
	shops.each do |shop|
		line =  " " << shop.name.titleize.ljust(30)
		line << " " + shop.type.titleize.ljust(15)
		line << " " + shop.formatted_price.ljust(12)
		line << " " + shop.formatted_rate.titleize.rjust(6)
		puts line
	end
	puts "No listings found" if shops.empty?
	puts "-" * 70
end
end