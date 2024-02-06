Object = require 'lib/classic'
Camera = require 'lib/hump.camera'
Timer = require 'lib/hump.timer'
Vector = require 'lib/hump.vector'
Colors = require 'lib/colors' -- où je stocke mes couleurs préférées
require 'lib/misc'
require 'func/mesh'
require 'func/node'
require 'func/player'

--
local screen_ratio = 1920/1080
WIND_H = 600 -- les variables globales sont écrites en majuscule
WIND_W = 600
-- love.graphics.setDefaultFilter('nearest','nearest') -- pas de filtre pour les sprites
love.window.setMode(WIND_W, WIND_H)
love.window.setTitle('node-node')
background = love.graphics.newImage('assets/background/background_600x600.png')

function love.load()
	-- instancier le mesh de jeu
	mesh = Mesh(3, 3)

	-- instancier le joueur
	player = Player(1, mesh)
end


function love.update(dt)
	-- mettre le mesh à jour en fonction des actions du joueur
	mesh:update()

	-- mise à jour du joueur
	player:update(mesh)
end


function love.draw()
	-- dessiner l'arrière plan
	love.graphics.draw(background, 0, 0, 0, 1, 1)

	-- dessiner le mesh
	mesh:draw()

	-- dessiner le joueur
	player:draw()
end


function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.quit()
	end
	-- key player
	if key == "up" or key == "down" or key == "left" or key == "right" then
		player:move(key, mesh)
	end
end


function love.mousereleased(x, y, button)
	if button == 1 then
		mousereleased = true
	end
end


