class Group < ActiveRecord::Base
	has_many :subordinates, class_name: "Group", foreign_key: "parent_id"
	belongs_to :manager, class_name: "Group"
end
