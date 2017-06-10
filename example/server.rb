require 'sinatra/reloader'
require './config/environment'
current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

class Sinatra::Application
  configure :development do
    register Sinatra::Reloader
  end


  get "/" do
    @trouts = Trout.all
    erb :index
  end

  get "/:id" do
    @trout = Trout.find(params[:id])
    erb :show
  end

end
