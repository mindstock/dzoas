class Power < ActiveRecord::Base
	has_and_belongs_to_many :roles

	has_many :subordinates, class_name: "Power", foreign_key: "parent_id"
	belongs_to :parent, class_name: "Power"
end
