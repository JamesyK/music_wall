# Homepage (Root path)
helpers do
  def current_user
    current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end 
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
  erb :'users/login'
end

get '/logout' do
  session.clear
  redirect '/posts'
end

get '/posts' do
  @posts = Post.all
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
    erb :'users/login'
  end    
end

post '/vote' do
  vote = Vote.create(post_id: params[:post_id], user_id: params[:user_id])
  if vote.persisted?
    redirect '/posts'
  else
    redirect '/animals?message=Cannot vote for animal twice'
  end
end
