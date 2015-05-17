require 'shop'

class Guide
	
	@@actions = ['list' , 'add', 'find', 'quit']
	def initialize(path = nil)
		#Look for file
		Shop.filepath = path
		if Shop.file_exists?
			puts "Found Shops file  "
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
			puts "Actions : " + @@actions.join(", ")
			print "> "
			user_action = gets.chomp.downcase.strip
		end		
		return user_action
	end
	
	def introduction
		puts "\n\n\t\t\t<<< Welcome to the Gadget Finder. >>> \n"
		puts "This application allows you to select your desired gadget from a range of shops \n\n"
	end
	
	def conclusion
		puts "\n\n\t<<< Sure you found what you are looking for. Enjoy shopping! >>>\n\n"
	end
	
	def do_action(action)
		case action
		when 'list'
			puts "Listing all shops\n \n"
		when 'find'
			puts "Finding"
		when 'add'
			puts "Adding"
		when 'quit'
			return :quit
		else
			puts "Please enter correct choice"
		end
	end	
end