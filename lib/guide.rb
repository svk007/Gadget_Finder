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
			user_action = get_action
			result  = do_action(user_action)	
		#loop until quit
		end
		conclusion
	end
	
	def get_action
		user_action = nil
		until @@actions.include?(user_action)
			puts "\nActions : " + @@actions.join(", ")
			print "> "
			user_action = gets.chomp.downcase.strip
		end		
		return user_action
	end
	
	def introduction
		puts_formatted("Welcome to the Gadget Finder.")
		puts "This application allows you to select your desired gadget from a range of shops"
	end
	
	def conclusion
		puts_formatted("Sure you found what you were looking for. Enjoy shopping!")
	end
	
	def do_action(action)
		case action
		when 'list'
			list
		when 'find'
			puts "Finding"
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
	
	def list
		puts_formatted("Listing shops")
		shop = Shop.saved_shops
		output_table(shop)
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