class Department < ActiveRecord::Base
	has_many :plan
	has_many :employee
end
