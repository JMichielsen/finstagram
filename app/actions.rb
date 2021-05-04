helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end
end

get '/' do              # Main Page
    @finstagram_posts = FinstagramPost.order(created_at: :desc)
    erb(:index)
end

get '/signup' do        # Sign-up Page (blank)
    # setup an empty @user object to prevent signup.erb from erroring out trying to find error messages.
    @user = User.new

    # render "app/views/signup.erb"
    erb(:signup)                
end


post '/signup' do       # Sign-up Page (submit)
    # grab the user input values from params
    email       = params[:email]
    avatar_url  = params[:avatar_url]
    username    = params[:username]
    password    = params[:password]

    # instantiate and save the new User
    @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
    
    # if user validation succeeded in user.rb, the user can be saved.
    if @user.save # = true
        redirect to ('/login')
    else
        # display error cause & let them try again
        erb(:signup)
    end
end

get '/login' do         # Log in page (Blank)
    erb(:login)
end

post '/login' do        # Log in page (submit)
    username = params[:username]
    password = params[:password]

    # 1 find user by username
    @user = User.find_by(username: username)

    # 2 if that user exists
    if @user
        # and their password matches (using bCrypt method)
        if @user.authenticate(password)
            session[:user_id] = @user.id
            redirect to ('/')
        else
            @error_message = "Login Failed, please check if your password is correct."
            erb(:login)
        end
    else
        "User does not exist"
    end
end

get '/logout' do
    session[:user_id] = nil
    redirect to ('/')
end