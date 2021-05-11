## This is the controller

helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end

    def logged_in?
        !!current_user
    end

end

get '/' do              # Main Page
    @finstagram_posts = FinstagramPost.order(created_at: :desc)
    erb(:index)
end


### Sign-up Page (blank)
get '/signup' do
    # setup an empty @user object to prevent signup.erb from erroring out trying to find error messages.
    @user = User.new

    # render "app/views/signup.erb"
    erb(:signup)                
end

### Sign-up Page (submit)
post '/signup' do
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

### Log in Page (blank)
get '/login' do
    erb(:login)
end

### Log in Page (submit)
post '/login' do        # Log in page (submit)
    username = params[:username]
    password = params[:password]

    # 1 find user by username
    @user = User.find_by(username: username)

    # 2 if that user exists
    if @user
        # 3 and their password matches (using bCrypt method)
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

### log out button
get '/logout' do
    session[:user_id] = nil
    redirect to ('/')
end

### New post page
before '/finstagram_posts/new' do
    # verify that the user is logged in.
    redirect to ('/login') unless logged_in?
end

get '/finstagram_posts/new' do
    @finstagram_post = FinstagramPost.new
    erb(:"finstagram_posts/new")
end

### New post (submit)
post '/finstagram_posts' do
    photo_url = params[:photo_url]

    # instantiate new FinstagramPost
    @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })

    # if @post validates, save
    if @finstagram_post.save
        redirect(to('/'))
    else
        erb(:"finstagram_posts/new")
    end
end

### Individual post pages
get '/finstagram_posts/:id' do
    @finstagram_post = FinstagramPost.find(params[:id])
    erb(:"finstagram_posts/show")
end

### Submit Comment button
post '/comments' do
    # points values from form to variables
    text = params[:text]
    finstagram_post_id = params[:finstagram_post_id]

    # instantiate a comment with those values and assign the comment to the 'current_user'
    comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })
    # save the comment
    comment.save
    # 'redirect' back to wherever we came from
    redirect(back)
end

### Add Like button
post '/likes' do
    finstagram_post_id = params[:finstagram_post_id]
    
    # instantiate the like; and assign it to the 'current_user'
    like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })
    like.save

    redirect(back)
end

### Delete Like button
delete '/likes/:id' do
    like = Like.find(params[:id])
    like.destroy
    redirect(back)
end