require 'sinatra/base'
require 'json'
require 'sequel'
require 'yajl'
require 'awesome_print'
require 'pony'
require 'sinatra/param' 
require 'rack/contrib'

class LoveMachine < Sinatra::Base
  use Rack::PostBodyContentTypeParser
  helpers Sinatra::Param

  DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/lovemachine')

  require_relative "lovemachine/models/love"
  require_relative "lovemachine/models/user"
  require_relative "lovemachine/models/apikey"

  include LoveMachine::Model

  def development?
    ENV['RACK_ENV'] == 'test'
  end

  def valid_key?
    if development?
      true
    else
      @key = APIKey.where(:key => params[:key]).first
    end
  end

  before do
    content_type :json
    halt(401, "Invalid Key") unless valid_key?
  end

  def uuid
    @uuid ||= User.where(:email => params[:email]).first || halt(404, "Could not find uuid")
    @uuid[:id]
  end

  def uuid_to_user(uuid)
    @user = User.where(:id => uuid).first || halt(404, "Could not find user from uuid")
    @user[:email]
  end                                            
  
  def user
    @user || User.where(:email => params[:email]).first || halt(404, "Could not find user")
  end

  def get_uuid(email)
    @x = User.where(:email => email).first || halt(404, "Could not find uuid for #{email}")
    @x[:id] if @x
  end

  get '/' do
    "Welcome to the Love Machine!"
  end

  post '/user' do
    param :email, String, required: true

    if User.where(:email => params[:email]).first
      halt(400, "User already exists") 
    end

    @u = User.create(:email => params[:email])
    @u = @u.to_hash
    @u[:message] = "User successfully created"

    [201, @u.to_json.to_s]
  end 

  get '/user/:email' do
    [201, user.to_hash.to_json.to_s]
  end

  get '/users' do
    @users = User.all || halt(404, "No users found") 
    @users.map! { |x| x.to_hash.to_json }
    [200, @users.to_s]
  end

  post '/love' do
    param :to, String, required: true
    param :from, String, required: true
    param :message, String, required: true
    
    @to = get_uuid(params['to'])
    @from = get_uuid(params['from'])
    @love = Love.create(:message => params['message'], :to_id => @to, :from_id => @from)

    if @love
      Pony.mail({
                  :to => params['to'], 
                  :from => params['from'], 
                  :subject => "Love from #{params['from']}", 
                  :body => params['message'],
                  :via => :smtp,
                  :via_options => {
                    :address              => 'smtp.gmail.com',
                    :port                 => '587',
                    :enable_starttls_auto => true,
                    :user_name            => ENV['LOVEMACHINE_EMAIL_USERNAME'],
                    :password             => ENV['LOVEMACHINE_EMAIL_PASSWORD'],
                    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                    :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
                  }
                }) unless development?
    end
    [201, @love.to_hash.to_json.to_s]
  end

  get '/love' do
    @love = Love.all || halt(404, "No love found!") 
    @love.map! { |x| x.to_hash.to_json } 

    [200, @love.to_s]
  end

  get '/love/:email' do
    @love = Love.where(Sequel.or(:to_id => uuid, :from_id => uuid)).all || halt(404, "No love found")
    @love.map!{ |x| x.to_hash.to_json }

    [201, @love.to_s]
  end
end






