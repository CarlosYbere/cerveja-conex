class DataController < ApplicationController
	def light
		#aqui eu vejo a luz
	end
	def sensors
		#aqui eu me comunico com os sensores...
		#criando variavel global com @
		@temperature = 40
	end
	def multimedia

	end
	def plot

	end
end
