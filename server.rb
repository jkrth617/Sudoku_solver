require 'sinatra'

set :port, 3000
set :bind, '0.0.0.0'

get '/index' do
	erb :'index'
end