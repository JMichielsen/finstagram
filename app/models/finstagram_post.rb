class FinstagramPost < ActiveRecord::Base

    belongs_to :user
    has_many :comments
    has_many :likes

    # validates_presence_of :user
    validates :photo_url, :user, presence: true

    # Calculates the age of the post in minutes / hours / days
    def humanized_time_ago
        time_ago_in_seconds = Time.now - self.created_at
        time_ago_in_minutes = time_ago_in_seconds / 60
        time_ago_in_hours = time_ago_in_minutes / 60

        if time_ago_in_hours >= 24
            "#{(time_ago_in_hours / 24).to_i} days ago."
        elsif time_ago_in_minutes >= 60
            "#{(time_ago_in_minutes / 60).to_i} hours ago."
        else
            "#{time_ago_in_minutes.to_i} minutes ago."
        end
    end

    # Calculates likes
    def like_count
        self.likes.size
    end

    # Calculates comment count
    def comment_count
        self.comments.size
    end

end