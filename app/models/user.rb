class User < ActiveRecord::Base

    has_secure_password # bcrypt hashes password
    
    has_many :finstagram_posts
    has_many :comments
    has_many :likes

    validates :email, :username, uniqueness: true
    validates :email, :avatar_url, :username, presence: true
end