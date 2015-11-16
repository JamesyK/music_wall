# Homepage (Root path)
helpers do

end

get '/' do
  erb :index
end

get '/posts' do
  @posts = Post.all
  erb :'posts/index'
end

get '/posts/new' do
  @post = Post.new
  erb :'posts/new'
end

get '/posts/:id' do
  @post = Post.find params[:id]
  @all_posts = Post.all
  erb :'posts/show'
end

post '/posts' do
  @post = Post.new(
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