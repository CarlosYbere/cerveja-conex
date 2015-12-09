Rails.application.routes.draw do
	get '/luzes'=>'data#light'
	get '/sensores'=>'data#sensors'
	get '/audio-e-video'=>'data#multimedia'
	get '/graficos'=>'data#plot'
end
