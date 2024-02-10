Player = Object:extend()

local timer = 0
local blinking_velocity = 0.07

function Player:new(start_node_index, mesh)
    --[[
    description: 
    ]]--
    self.index = start_node_index
    self.x = mesh.nodes[self.index].x
    self.y = mesh.nodes[self.index].y
    self.i = mesh.nodes[self.index].i
    self.j = mesh.nodes[self.index].j
    self.radius = 35
end

function Player:update(mesh)
    --[[
    description: 
    ]]--
    -- compute x, y
    self.index = mesh:ij_to_index(self.i, self.j)
    self.x = mesh.nodes[self.index].x
    self.y = mesh.nodes[self.index].y

    -- blinking effect
    timer = timer + blinking_velocity
    self.alpha = math.abs(math.sin(timer))
end

function Player:move(direction, mesh)
    if direction == "up" then
        if self.i > 1 then
            self.i = self.i - 1
        end
    elseif direction == "down" then
        if self.i < mesh.n_x then
            self.i = self.i + 1
        end
    elseif direction == "left" then
        if self.j > 1 then
            self.j = self.j - 1
        end
    elseif direction == "right" then
        if self.j < mesh.n_y then
            self.j = self.j + 1
        end
    end
end

function Player:rotate(direction, mesh)
    -- get all the links connected to the player's node
    local links = {} -- table of links that can be rotated by the player
    local n_x, n_y = 1, 0 -- reference vector
    for i, link in pairs(mesh.links) do
        if link.node1 == self.index or link.node2 == self.index then
            table.insert(links, link.index)
        end
    end

    -- compute the initial angle for each link
    for i, link in pairs(links) do
        -- find the vector direction of the link
        
    end

    -- rotate those links
    for i, link in pairs(links) do
        if direction == "clockwise" then
            mesh.links[link].state = 'rotate_clockwise'
            mesh.links[link].command_angle = mesh.links[link].command_angle + math.pi/2
        elseif direction == "counterclockwise" then
            mesh.links[link].state = 'rotate_counterclockwise'
            mesh.links[link].command_angle = mesh.links[link].command_angle - math.pi/2
        end
    end
end

function Player:draw()
    --[[
    description: 
    ]]--
    love.graphics.setColor(0,255/255,185/255,self.alpha)
    love.graphics.setLineWidth(9)
    love.graphics.circle('line', self.x, self.y, self.radius)
    love.graphics.setColor(1,1,1,1)
end

