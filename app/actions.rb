get '/' do              # Main Page
    @finstagram_posts = FinstagramPost.order(created_at: :desc)
    erb(:index)
end

get '/signup' do
    # setup an empty @user object
    @user = User.new

    # render "app/views/signup.erb"
    erb(:signup)                
end


post '/signup' do       # Sign-up Page
    # grab the user input values from params
    email       = params[:email]
    avatar_url  = params[:avatar_url]
    username    = params[:username]
    password    = params[:password]

    # instantiate and save the new User
    @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
    
    # if user validation succeeded in user.rb, the user can be saved.
    if @user.save # = true
        "User #{username} saved!"
    else
        # display error cause & let them try again
        erb(:signup)
    end
end