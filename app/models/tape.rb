class Tape < ActiveRecord::Base
	has_many :plan
	has_many :tape_log
end
