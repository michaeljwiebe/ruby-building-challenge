# A real estate developer has hired you to create an app for a new mixed-use development downtown. The app will allow prospective tenants to sign up for an apartment, condo, or commercial space, and then pay rent and HOA fees from the app. The breakdown of the development is as follows: 
# The development is ten stories high.
# The top two floors are made up of ten two-bedroom condos. 
# Floors 2-8 are made up of 1, 2, and 3 bedroom apartments. 
# The apartments have a base rate, and then are charged more per bedroom per month. A premium is charged on the apartments for every floor higher you go. An apartment on the 5th floor will be more expensive than an apartment on the 3rd floor.
# On the first floor are 6 commercial spaces. Two can be combined to form a restaurant, which would then cost more than the two separate commercial spaces.
# Between all of the rents and HOA fees, the developer wants to make 100,000/month. However, because of regulations, there can only be a maximum of two restaurants and 50 units between the condos and apartments. Because of the market, The apartments should not be more than $2000 and the commercial spaces no more than $5000.
# -There will be multiple types of customers interested in leasing the spaces or owning the condos. Some will be commercial customers and some residential, some are looking to buy and some to rent. Some commercial customers are restauranteurs, some want to create a gym or an escape room or a co-working space.
# Commercial customers need at least a two-year lease. Restaurants need a three-year lease.
# -Apartments with three bedrooms need at least two people on a lease. 
# -Condo purchasers need to make at least $40,000/year
# -Students can rent apartments with a cosigner.
# -The first ten renters get the first month free.
# -The first 5 purchasers get a 10-year tax abatement.
# -Rent should not exceed 30% of a renter’s monthly income. 
# The app should deny any customers that do not meet the criteria. and allow any customers who do meet the criteria to lease or purchase the space.
# After all of this is complete, tenants should be able to pay their rent through the app. 
# All of this should happen through a terminal interface.

require './apply.rb'

class Development
	attr_reader :single_incomes, :double_incomes, :triple_incomes, :floor_availability, :floors, :units

	def initialize floors
		@floors = floors
		@single_incomes = [36000, 42000, 48000, 54000, 60000, 66000, 72000]
		@double_incomes = [44000, 50000, 56000, 62000, 68000, 74000, 80000]
		@triple_incomes = [56000, 62000, 68000, 74000, 80000]
		@floor_availability = ["2", "2 and 3", "2-4", "2-5", "2-6", "2-7", "2-8"]
		@units = []
	end

	def add_space bedrooms, floor
		apt = Apartment.new(bedrooms, floor)
		@units.push(apt)
	end

end

class Floor #5-6 units possible per floor
	attr_reader :units

	def initialize units
		@units = units
		
	end
end

class Space
	attr_reader :unit_count
	def initialize
		@unit_count = 1
	end
end

class Apartment < Space
	attr_reader :bedrooms, :rate
	def initialize (bedrooms, floor)
		@bedrooms = bedrooms
		@floor = floor
		@rate = calc_rate
	end

	def calc_rate
		base_rate = 700
		room_premium = 300 * @bedrooms
		floor_premium = 30 * @floor
		base_rate + room_premium + floor_premium
	end
end

class Condo < Space
	def initialize
		@bedrooms = 2
		
	end
end

class Commercial < Space
	def initialize
		@unit_count = 1

	end
end

class Restaurant < Commercial
	def initialize
		@unit_count = 2
	end
end


class Tenant
	attr_reader :name, :interest, :income, :type, :rooms_req, :development

	def initialize
		# puts "Hello, what is your name?"
		# name = gets.chomp
		# puts name + ", is your desire to rent or buy? Enter rent or buy"
		# interest = gets.chomp
		# if interest == "buy"
		# 	puts "All condos for sale are 2 bedroom, is that acceptable? Enter yes or no"
		# 	condo = gets.chomp
		# 	if condo == "yes"
		# 		@rooms_req = 2
		# 	end
		# end
		# puts "Are you a student, a residential tenant, or a commercial customer? Enter student, residential or commercial"
		# type = gets
		# puts "How many rooms do you want to have in your apartment?"
		# rooms_req = gets
		# puts "And " + name + ", what is your total annual household income?"
		# income = gets

		name = "michael"
		interest = "rent"
		type = "residential"
		income = 70000
		rooms_req = 2

		@name = name
		@interest = interest #buy or rent
		@type = type
		@income = income
		@rooms_req = rooms_req
		@credit = 0
	end

	def apply development
		if @type == "residential"
			if @interest == "rent"
				if @rooms_req == 1 
					single_incomes_rev = development.single_incomes.reverse
					single_incomes_rev.each_with_index do |single_income, i|
						if @income >= single_income
							puts "floors " + development.floor_availability.reverse[i] + " have apartments available for you to rent"
							sign_apt()
							break
						end
					end
				elsif @rooms_req == 2 
					double_incomes_rev = development.double_incomes.reverse
					double_incomes_rev.each_with_index do |double_income, i|
						if @income >= double_income
							puts "floors " + development.floor_availability.reverse[i] + " have apartments available for you to rent"
							sign_apt()
							break
						end
					end
				elsif @rooms_req == 3 
					triple_incomes_rev = development.triple_incomes.reverse
					triple_incomes_rev.each_with_index do |triple_income, i|
						if @income >= triple_income
							puts "floors " + development.floor_availability.reverse[i] + " have apartments available for you to rent"
							sign_apt()
							break
						end
					end
				end
			elsif @interest == "buy"
				if @income >= 70000
					sign_condo()
				else
					puts "I'm sorry, there are no condos available for sale at your level of income."
				end
			end
		elsif @type == "commercial"
		  puts "Are you interested in renting space for a restaurant? Enter yes or no"
		  restaurant = gets.chomp
			if restaurant == "yes"
		    	puts "there are 2 restaurant spaces available for 5000 per month each. Do you want to sign for one of them? Enter yes or no"
		    	rent_rest = gets.chomp
				if rent_rest == "yes"
		    		development.commercial -= 2
				else
		    		goodbye()
		    	end
			end
		end
	end
	
	def sign_apt
		puts "Would you like to sign to rent an apartment? Enter yes or no"
		rent = gets.chomp
		if rent == "yes"
			puts "which floor do you want to live on? Enter the floor number only"
			floor = gets.chomp
			remove_habitation(floor)
		elsif rent == "no"
			goodbye()
		end
	end

	def sign_condo
		puts "Your montly mortgage payment will be $1900 on the 9th floor or $2000 on the 10th floor plus HOA fees of $100. Do you want to sign? Enter yes or no"
		buy = gets.chomp
		if buy == "yes"
			puts "Which floor do you want to live on? Enter 9 or 10"
			floor = gets.chomp
			remove_habitation(floor)
		end
	end

	def remove_habitation floor
		
	end

	def pay
		puts "Please enter the amount you are paying"
		payment = gets
		@credit += payment.to_i
	end
	
	def goodbye
	  puts "Thank you for inquiring!"
	end
end

development = Development.new(10)

development.add_space(2,3)

# new_space = Apartment.new(2,3)

new_renter = Tenant.new

# new_renter.apply(development)





