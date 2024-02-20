Node = Object:extend()

local debug = true
local base_radius = 25

function Node:new(x, y, i, j, index)
    --[[
    description: instanciates the Node object
    x (parameter, int): x-position of the node
    y (parameter, int): y-position of the node
    ]]--

    self.x = x
    self.y = y
    self.i = i
    self.j = j
    self.index = index
    self.color = {1,1,1,1}
    self.neighbors = {} -- table of the indices of the neighbors nodes
    self.connected = {} -- table of the indices of the connected neighbors
    self.enabled = true
    self.scale = 1
    self.radius = base_radius*self.scale
end

function Node:update()
    --[[
    description: 
    ]]--
end

function Node:draw()
    --[[
    description: 
    ]]--
    if self.enabled == true then
        love.graphics.setColor(self.color)
    else
        love.graphics.setColor(1,1,1,0.3)
    end
    love.graphics.circle('fill', self.x, self.y, self.radius)
    love.graphics.setColor(1,1,1,1)

    if debug then
        love.graphics.setColor(0,0,0,1)

        local sweep_i = {0,1,0,-1}
        local sweep_j = {1,0,-1,0}
        for i = 1, #self.neighbors do
            love.graphics.print(tostring(self.neighbors[i]), self.x+sweep_i[i]*1.5*self.radius-3, self.y+sweep_j[i]*1.5*self.radius-5)
        end
        love.graphics.setColor(108/255,1/255,120/255)
        love.graphics.print(tostring(self.index), self.x-7, self.y-13, 0,2,2)
        love.graphics.setColor(1,1,1,1)
    end
end
