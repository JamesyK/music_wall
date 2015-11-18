# Homepage (Root path)
helpers do

  def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end

end

before do
  redirect '/posts?message=You must be logged in' if !current_user && request.path != '/login' && request.path != '/signup' && request.path != '/posts' && request.path != '/' 
end

get '/' do
  redirect '/posts'
end

get '/signup' do
  erb :'users/signup'
end

get '/login' do
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
  @posts = Post.all.order('votes_count DESC, id')
  # @posts = Post.joins("LEFT JOIN votes ON votes.post_id = posts.id").select("posts.*, COUNT(votes.id) AS vote_count").group("posts.id").order("vote_count DESC")
  if params[:message]
    @message = params[:message]
  end
  erb :'posts/index'
end

get '/posts/new' do
  @post = Post.new
  erb :'posts/new'
end

get '/posts/:id' do
  @post = Post.find params[:id]
  @review = Review.new
  erb :'posts/show'
end

post '/posts' do
  post = current_user.posts.create(
    title: params[:title],
    author: params[:author],
    url: params[:url]
  )
  if post.persisted?
    redirect '/posts'
  else
    erb :'posts/new'
  end
end

post '/signup' do
  session['username_given'] = params['username']
  session['email_given'] = params['email']
  user = User.new(
    username: params[:username],
    email: params[:email],
    password: params[:password]
  )
  if user.save
    session[:user_id] = user.id
    redirect '/posts'
  else
    session['signup_errors'] = user
    redirect '/signup'
  end
end

post '/login' do
  user = User.find_by(email: params[:email])
  if user.email && user.password == params[:password]
    session[:user_id] = user.id
    redirect '/posts'
  else
    redirect '/login?message=Invalid username or password'
  end    
end

post '/vote' do
  @vote = Vote.create(post_id: params[:post_id],
    user_id: params[:user_id]
  )
  if vote.persisted?
    redirect '/posts'
  else
    redirect '/posts'
  end
end

post '/review' do
  review = Review.create(post_id: params[:post_id],
    user_id: params[:user_id],
    comment: params[:comment]
  )
  if review.persisted?
    redirect "/posts/#{params[:post_id]}"
  else
    redirect "/posts/#{params[:post_id]}"
  end
end

post '/review/delete' do
  review = Review.find_by(id: params[:review])
  review.destroy
  redirect "/posts/#{review.post_id}"
end
