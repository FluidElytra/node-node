Link = Object:extend()

local angular_velocity = 0.04
local command_angle = 0

function Link:new(node1, node2, mesh, index, angle)
    self.index = index -- index of the link
    self.node1 = node1 -- index of the first node
    self.node2 = node2 -- index of the second node

    -- self.node_indices = {node1, node2}
    -- self.x = {}
    -- self.y = {}
    -- for node_index in self.node_indices do
    --     table.insert(self.x, mesh.nodes[node_index].x)
    --     table.insert(self.y, mesh.nodes[node_index].y)
    -- end

    -- self.length = math.sqrt((self.x[1]-self.x[2])^2 + (self.y[1]-self.y[2])^2)

    -- position on the screen
    self.x1 = mesh.nodes[node1].x
    self.y1 = mesh.nodes[node1].y
    self.x2 = mesh.nodes[node2].x
    self.y2 = mesh.nodes[node2].y
    self.length = math.sqrt((self.x1-self.x2)^2 + (self.y1-self.y2)^2) -- length on the screen

    self.angle = angle
    self.command_angle = self.angle

    self.state = 'stable'
    self.color = {1,1,1,1}
end

function Link:update()    
    self:rotate()
end

function Link:rotate()
    if self.state == 'rotate_clockwise' then
        if self.angle <= self.command_angle then 
            self.angle = self.angle + angular_velocity -- radian
            self.x2 = self.x1 + self.length * math.cos(self.angle)
            self.y2 = self.y1 + self.length * math.sin(self.angle)
        else
            self.state = 'stable'
        end
    elseif self.state == 'rotate_counterclockwise' then
        if self.angle >= self.command_angle then 
            self.angle = self.angle - angular_velocity -- radian
            self.x2 = self.x1 + self.length * math.cos(self.angle)
            self.y2 = self.y1 + self.length * math.sin(self.angle)
        else
            self.state = 'stable'
        end
    end
end

function Link:draw()
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(20)
    love.graphics.line(self.x1, self.y1, self.x2, self.y2)
    love.graphics.setColor(1,1,1,1)
end