Link = Object:extend()

local angular_velocity = 0.04
local command_angle = 0

function Link:new(node1, node2, mesh, index, angle)
    self.index = index -- index of the link
    self.node_indices = {node1, node2} -- table of the nodes indices
    self.x = {} -- table of the nodes coordinates
    self.y = {} -- table of the nodes coordinates
    for i, node_index in ipairs(self.node_indices) do
        table.insert(self.x, mesh.nodes[node_index].x)
        table.insert(self.y, mesh.nodes[node_index].y)
    end

    self.length = math.sqrt((self.x[1]-self.x[2])^2 + (self.y[1]-self.y[2])^2)

    self.angle = angle
    self.command_angle = self.angle
    self.rotation_center = 1
    self.state = 'idle'
    self.color = {1,1,1,1}
end

function Link:update()    
    self:rotate()
end

function Link:rotate()
    -- provide rotation parameters
    if self.rotation_center == 1 then
       rotating_node = 2
    else
        rotating_node = 1 
    end

    -- define new nodes

    -- animate the rotation
    if self.state == 'rotate_clockwise' then
        if self.angle <= self.command_angle then 
            self.angle = self.angle + angular_velocity -- radian
            self.x[rotating_node] = self.x[self.rotation_center] + self.length * math.cos(self.angle)
            self.y[rotating_node] = self.y[self.rotation_center] + self.length * math.sin(self.angle)
        else
            self.state = 'idle'
        end
    elseif self.state == 'rotate_counterclockwise' then
        if self.angle >= self.command_angle then 
            self.angle = self.angle - angular_velocity -- radian
            self.x[rotating_node] = self.x[self.rotation_center] + self.length * math.cos(self.angle)
            self.y[rotating_node] = self.y[self.rotation_center] + self.length * math.sin(self.angle)
        else
            self.state = 'idle'
        end
    end
end

function Link:draw()
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(20)
    love.graphics.line(self.x[1], self.y[1], self.x[2], self.y[2])
    love.graphics.setColor(1,1,1,1)
end

function Link:compute_direction(mesh)
    self.directions_x = {}
    self.directions_y = {}

    -- if the first node is the rotation center
    self.directions_x[1] = mesh.nodes[self.node_indices[2]].j - mesh.nodes[self.node_indices[1]].j
    self.directions_y[1] = mesh.nodes[self.node_indices[2]].i - mesh.nodes[self.node_indices[1]].i

    -- if the second node is the rotation center
    self.directions_x[2] = mesh.nodes[self.node_indices[1]].j - mesh.nodes[self.node_indices[2]].j
    self.directions_y[2] = mesh.nodes[self.node_indices[1]].i - mesh.nodes[self.node_indices[2]].i

    return self.directions_x, self.directions_y
end