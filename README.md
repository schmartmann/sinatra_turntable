### Sinatra Turntable
![](https://media.giphy.com/media/hrxXnzVoLr74k/giphy.gif)

Sinatra Turntable is a bash script that, with two simple commands, allows developers to quickly spin up a full MVC web app with Sinatra and ActiveRecord wrapping a postgresql database.

It's ideal for situations where Ruby on Rails is too cumbersome, but Sinatra alone doesn't cut it. An example would be an app that relies on one or two tables that you need to set up in a hurry.

### Installation
![](https://media.giphy.com/media/kHXW69kaIZIGc/giphy.gif)

Add the code snippet below to your bash profile. 
```function sinatra_turntable(){
  if [ "$#" -ne 1 ]
  then
    echo "You must provide a project name. Usage: 'sinatra_turntable [name]'"
    return
  fi
    mkdir $1
    cd $1
    mkdir views
      echo -e '"Hello World."' > views/index.erb
      echo -e '<!doctype html>\n<html>\n<head>\n  <link href="/css/style.css" rel="stylesheet" type="text/css">\n</head>\n<body>\n  <div class="container">\n    <%= yield %>\n  </div>\n</body>\n</html>\n<script src="/js/jquery.js" type="text/javascript"></script>\n<script src="/js/script.js" type="text/javascript"></script>' > views/layout.erb
    mkdir public
      mkdir public/img
      mkdir public/css
        touch public/css/style.css
      mkdir public/js

    #gets jQuery, checks for successful download.
    curl -f http://code.jquery.com/jquery-2.2.1.min.js > public/js/jquery.js
    if [ -s public/js/jquery.js ]
      then
        echo 'jQuery Download Successful.'
    else
        rm public/js/jquery.js
        echo 'ERROR: jQuery download failed, file removed.'
    fi

    echo -e '"use strict";\n(function(){\n\n})();' > public/js/script.js
    mkdir lib
    printf 'module Sinatra\n  class Server < Sinatra::Base\n    get "/" do\n      erb :index\n    end\n  end\nend' > server.rb
    printf 'require "sinatra/base"\n# require "sinatra/reloader"\nrequire_relative "server"\nrun Sinatra::Server' > config.ru

    read -p "Would you like to set up ActiveRecord for this project? (y/n)" input_cmd
    if [[ -n "$input_cmd" && "$input_cmd"=y ]]
      then
        bundle init
          echo -e "source 'https://rubygems.org'\ngem 'sinatra' \ngem 'activerecord', '4.2.5' \ngem 'sinatra-activerecord' \ngem 'rake'\ngem'thin' \ngem'require_all' \ngem 'pg' \ngroup :development do\n  gem 'shotgun'\n  gem 'pry'\n  gem 'tux'\n  gem 'sqlite3'\nend" > Gemfile
        bundle install
        mkdir models
        mkdir db/migrate
        mkdir config
        touch config/environment.rb
        echo -e "require 'zlib' \n\n\ndb = URI.parse(ENV['DATABASE_URL'] || 'postgres://$(whoami)@localhost:5432/$1_db')\n\nActiveRecord::Base.establish_connection(\n  :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme, \n  :host => db.host, \n  :username => db.user, \n  :password => db.password, \n  :database => db.path[1..-1], \n  :encoding => 'utf8' \n)\n" > config/environment.rb
        touch config/boot.rb
        echo -e "ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)\n\nrequire 'bundler/setup'" > config/boot.rb
        touch config/database.yml
        echo -e "development: \n  adapter: postgresql \n  database: $1_db \n  username: postgres \n  password: postgres \n  host: localhost \n\nproduction: \n  adapter: postgresql \n  database: $1_db \n  username: ENV['USER_NAME'] \n  password: ENV['USER_PASS'] \n  host: localhost" > config/database.yml
        touch Rakefile
        echo -e "require 'sinatra/activerecord' \nrequire './config/environment' \nrequire 'sinatra/activerecord/rake' \nrequire './server'" > Rakefile
        echo -e "require 'sinatra/activerecord'\n$(cat config.ru)" > config.ru
        echo -e "require 'sinatra/activerecord'\nrequire './config/environment'\ncurrent_dir = Dir.pwd\nDir[\"#{current_dir}/models/*.rb\"].each { |file| require file }\n\n$(cat server.rb)" > server.rb
        echo "for resources on Sinatra + Active Record, visit https://learn.co/lessons/sinatra-activerecord-setup and/or http://recipes.sinatrarb.com/p/databases/postgresql-activerecord"
    elif [[ -n "$input_cmd" && "$input_cmd"=n ]]; then
      return
    else
      echo "Please respond with y/n"
      return
    fi
    vim 
}
```

Then, in your CLI, call the script like so: `sinatra_turntable <your_project_name>`. 

If you'd like ActiveRecord, simply respond with `y` to the prompt. (If not, enter `n` and the script will skip installing/configuring ActiveRecord and postgresql files.)

Once done installing, use `rake db:create` to create a postgres database, or `rake -T` for a list of available rake tasks.
Based on [JohnrBell's](https://github.com/JohnrBell) rad [Sinatra Touch Project Creator](https://github.com/JohnrBell/Sinatra_Project_Creator)

Check out `example/` for a sample project setup.
