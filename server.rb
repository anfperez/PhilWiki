require 'pry'
require 'bcrypt'
require 'redcarpet'

module Wiki
  class Server < Sinatra::Base

    set :method_override, true
    enable :sessions

  def conn
      if ENV["RACK_ENV"] == 'production'
        @conn ||= PG.connect(
           dbname: ENV["POSTGRES_DB"],
           host: ENV["POSTGRES_HOST"],
           password: ENV["POSTGRES_PASS"],
           user: ENV["POSTGRES_USER"]
         )
       else
         @conn ||= PG.connect(dbname: "wiki_project")
       end
     end

# defines the method by which a user logs into their account
    def current_user
      # conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
      if session["user_id"]
        @user ||= conn.exec_params(<<-SQL, [session["user_id"]]).first
          SELECT * FROM users WHERE id = $1
        SQL
      else
        # THE USER IS NOT LOGGED IN
        {}
      end
    end

# defines method that displays the users login name on the top bar
  def logged_in
    # conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
    current_user
  end

  get '/login' do
    erb :login
  end

  # method to allow existing users to log in 
  post '/login' do 
    # conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
    @user = conn.exec_params("SELECT * FROM users where user_name = $1", [params[:user_name]]).first
    if @user
      if BCrypt::Password.new(@user["login_password"]) == params[:login_password]
        session["user_id"] = @user["id"]
        erb :user_dashboard
      else
        @error = "Invalid Password"
        erb :login
      end
    else
      @error = "Invalid username"
      erb :login
    end
  end

  # allows
  get '/logout' do 
    session.delete('user_id')
    redirect '/'
  end

  get '/signup' do
    erb :signup
  end

  # allows new user to sign up for an account

  post '/signup' do

    # conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
    encrypted_password = BCrypt::Password.create(params[:login_password])
    new_user = conn.exec_params(<<-SQL, [params[:user_name], encrypted_password, params[:image], params[:profile]])
    INSERT INTO users (user_name, login_password, image, profile) VALUES ($1, $2, $3, $4) RETURNING id;
    SQL

    session["user_id"] = new_user.first["id"].to_i
    erb :user_dashboard
  end

#this is the address for the general index (home page)
get '/' do 
  	 # conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
  		erb :index
  	end

#address for Categories
  get '/categories' do 
  		# conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
  		@categories = conn.exec_params("SELECT * FROM categories").to_a
  		erb :categories
  	end

  #this displays the articles that are all located in an individual category
  get '/categories/:id' do 
  		# conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
  		@id = params['id']
  		@category = conn.exec_params("SELECT * FROM categories WHERE id = $1", [params['id']]).first
      @articles = conn.exec_params("SELECT * FROM articles WHERE category = $1", [params['id']]).to_a
  		# @articles = conn.exec_params("SELECT articles.*, users.name AS user_name, category.id AS category_id FROM articles INNER JOIN users ON articles.user = users.id INNER JOIN categories ON articles.category = category.id WHERE category.id = #{@id}").to_a
  		erb :category
  	end

    #this displays all current users
  	get '/users' do 
  		# conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
  		@users = conn.exec_params("SELECT * FROM users").to_a
  		erb :users
  	end

  #this displays users individually along with the articles they wrote
  	get '/users/:id' do
  		# conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
  		@id = params['id']
  		@user = conn.exec_params("SELECT * FROM users WHERE id = $1", [params['id']]).first
  		@articles = conn.exec_params("SELECT * FROM articles WHERE author = $1", [params['id']]).to_a
  		erb :user
  	end

  #displays a list of all the articles in the database
  get '/articles' do
  		# conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
  		@articles = conn.exec_params("SELECT * FROM articles").to_a
  		@categories = conn.exec_params("SELECT * FROM categories").to_a
  		@users = conn.exec_params("SELECT * FROM users").to_a
  		erb :articles
  	end

  #displays individual article by ID
  	get '/articles/:id' do
      @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  		@id = params['id']
  		# conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
  		@article = conn.exec_params("SELECT articles.*, categories.title AS category_title FROM articles INNER JOIN categories ON articles.category = categories.id").first
  		@article = conn.exec_params("SELECT articles.*, users.user_name AS user_name FROM articles INNER JOIN users ON articles.author = users.user_name WHERE articles.id = $1", [@id]).first
      @comments = conn.exec_params("SELECT * FROM comments WHERE article_id = $1", [params['id']]).to_a
      # binding.pry
  		erb :article
  	end

  #allows comments to be inserted into the article
  	post '/articles/:id' do 
      @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  		# conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
      id = params[:id]
  		email = params[:email]
  		rating = params[:rating]
  		message = params[:message]
  		article_id = params[:article_id]
  		conn.exec_params("INSERT INTO comments (email, rating, message, article_id) VALUES ($1, $2, $3, $4)", [email, rating, message, article_id])
      redirect '/'
    end

    #goes to the form that allows new articles to be submitted
  	get '/article/new' do
  		erb :article_submit
  	end

    #allows new articles to be posted on the website
  	post '/article/new' do 
      @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  		# conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
  		title = params[:title]
      image = params[:image]
  		category = params[:category]
  		author = params[:author]
  		body = params[:body]
      conn.exec_params("INSERT INTO articles (title, image, category, author, body) VALUES ($1, $2, $3, $4, $5)", [title, image, category, author, body])
      redirect '/articles'
  	end

	 # get '/articles/:title' do
  # 		@title = params[:title]
  # 		conn = PG.connect(dbname: "wiki_project")
  # 		@article = conn.exec_params("SELECT * FROM articles WHERE title = #{@title}")
  # 		erb :article
  # 	end

  #displays the form which allows users to edit existing articles
  get '/articles/edit/:id' do
      @id = params[:id].to_i
      # conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
      @article = conn.exec_params("SELECT * FROM articles WHERE id = $1", [@id])
      erb :article_edit
    end

  # allows user to edit existing articles
    post '/articles/edit/:id' do 
      @id = params[:id]
      # conn = PG.connect(dbname: "wiki_project") || PG.connect(ENV['DATABASE_URL'])
      article = conn.exec_params("SELECT * FROM articles where id = #{@id}").first

      title = params["title"] || article["title"]
      image = params["image"] || article["image"]
      body = params["body"] || article["body"]
      category = params["category"] || article["category"]

      conn.exec_params("UPDATE articles SET title = $1,  image = $2, body = $3, category = $4, time_edited = CURRENT_TIMESTAMP WHERE id = $5",
        [title,image,body,category,params["id"].to_i])

      redirect "/articles/#{article["id"]}"
    end

    #allows
 

  end
end