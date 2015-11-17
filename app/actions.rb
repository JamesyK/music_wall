# Homepage (Root path)
helpers do
  def current_user
    if session
      current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    else
      false
    end
  end 
end

before do
  redirect '/login' if !current_user && request.path != '/login' && request.path != '/signup' && request.path != '/posts' && request.path != '/' 
end

get '/' do
  redirect '/posts'
end

get '/signup' do
  @user = User.new
  erb :'users/signup'
end

get '/login' do
  @user = User.new
  if params[:message]
    @message = params[:message]
  end
  erb :'users/login'
end

get '/logout' do
  session.clear
  redirect '/posts'
end

get '/posts' do
  @posts = Post.joins("LEFT JOIN votes ON votes.post_id = posts.id").select("posts.*, COUNT(votes.id) AS vote_count").group("posts.id").order("vote_count DESC")
  erb :'posts/index'
end

get '/posts/new' do
  @post = current_user.posts.new
  erb :'posts/new'
end

get '/posts/:id' do
  @post = Post.find params[:id]
  erb :'posts/show'
end

post '/posts' do
  @post = current_user.posts.new(
    title: params[:title],
    author: params[:author],
    url: params[:url]
  )
  if @post.save
    redirect '/posts'
  else
    erb :'posts/new'
  end
end

post '/signup' do
  @user = User.new(
    username: params[:username],
    email: params[:email],
    password: params[:password]
  )
  if @user.save
    session[:user_id] = @user.id
    redirect '/posts'
  else
    erb :'users/signup'
  end
end

post '/login' do
  email = params[:email]
  password = params[:password]

  user = User.find_by(email: email)
  if user && user.password == password
    session[:user_id] = user.id
    redirect '/posts'
  else
    redirect '/login?message=Invalid username or password'
  end    
end

post '/vote' do
  vote = Vote.create(post_id: params[:post_id], user_id: params[:user_id])
  if vote.persisted?
    redirect '/posts'
  else
    redirect '/posts?message=Cannot vote for a song twice'
  end
end
