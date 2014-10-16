class Plan < ActiveRecord::Base
	belongs_to :tape
	belongs_to :department
	has_one :nickelclad
	has_many :quclity_check
	has_one :merge
end
