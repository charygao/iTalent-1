class Event < ActiveRecord::Base

	has_many :event_attendees, dependent: :destroy, foreign_key: "event_id"
	has_many :attendees, through: :event_attendee, source: :attendee

	before_validation :default_values
	
	has_and_belongs_to_many :tags
	belongs_to :creator, foreign_key: "creator_id", class_name: "User"

	validates :title,presence:true, length: { maximum:100 }
	validates :num_attendings,presence:true, numericality:{ only_integer:true, greater_than_or_equal_to:0 }
	validates :num_invitations,presence:true, numericality:{ only_integer:true, greater_than_or_equal_to:0 }
	validates :description,presence:true, length: { maximum:255 }
	validates :date_limit, presence:true, date:true
	validates :date_start, presence:true, date:{after_or_equal_to: :date_limit}
	validates :tags, presence: true
	validates :creator, presence: true



	has_many :event_invitations, dependent: :destroy, foreign_key: "event_id"
	has_many :invitees, through: :event_invitation, source: :invitee

	def invite(user)
		self.event_invitations.create(invitee: user)
	end

	def invited?(user)
		self.event_invitations.find_by(invitee: user)
	end

	private
		def default_values
			self.num_attendings = 0 if self.num_attendings.nil?
			self.num_invitations = 0 if self.num_invitations.nil?
		end
end