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
    self.x = mesh.nodes[self.index].x
    self.y = mesh.nodes[self.index].y

    -- blinking effect
    timer = timer + blinking_velocity
    self.alpha = math.abs(math.sin(timer))
end

function Player:move(direction, mesh)
    local i_temp = self.i
    local j_temp = self.j

    if direction == "up" then
        if self.i > 1 then
            i_temp = self.i - 1
        end
    elseif direction == "down" then
        if self.i < mesh.n_x then
            i_temp = self.i + 1
        end
    elseif direction == "left" then
        if self.j > 1 then
            j_temp = self.j - 1
        end
    elseif direction == "right" then
        if self.j < mesh.n_y then
            j_temp = self.j + 1
        end
    end

    -- move 
    index_temp = mesh:ij_to_index(i_temp, j_temp)
    if mesh.nodes[index_temp].enabled == true then
        self.i = i_temp
        self.j = j_temp
        self.index = index_temp
    end
end

function Player:rotate(direction, mesh)
    -- get all the links connected to the player's node
    local link_indices = {} -- table of links that can be rotated by the player
    local rotation_centers = {}
    for i, link in pairs(mesh.links) do
        for j, node_index in ipairs(link.node_indices) do
            if node_index == self.index then
                table.insert(link_indices, link.index)
                table.insert(rotation_centers, j)
            end
        end
    end

    -- rotate those links
    for i, link_index in pairs(link_indices) do
        mesh.links[link_index]:rotate(direction, self.index)
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
