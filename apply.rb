class Application
	def initialize (tenants, space)
		@tenants = tenants
		@space = space
	end

	def apply
		total_income = 0
		@tenants.each do |tenant|
			total_income += tenant.income
			if (@tenants.income * 0.3 / 12) > @space.rate
				p "congratulations!"
			else
				p "sorry, you don't qualify"
			end
		end
	end
end
