class Shop
	@@filepath = nil
	
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
	end
end
