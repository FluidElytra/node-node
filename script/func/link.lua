Link = Object:extend()

local animation_frame = 0
local animation_angles = {}
local new_node_index = 0

function Link:new(node1, node2, mesh, index, angle)
    --[[
    description: 
    ]]

    -- initialization, to clean at some point
    self.command_angle = angle
    self.rotation_center = nil
    self.rotating_node = nil
    self.state = 'idle'
    self.color = {1,1,1,1}
    self.index = index -- index of the link
    self.node_indices = {node1, node2} -- table of the nodes indices
    self.x = {} -- table of the nodes coordinates
    self.y = {} -- table of the nodes coordinates

    -- fill the position table
    for i, node_index in ipairs(self.node_indices) do
        table.insert(self.x, mesh.nodes[node_index].x)
        table.insert(self.y, mesh.nodes[node_index].y)
    end

    -- compute the length of the link
    self.length = math.sqrt((self.x[1]-self.x[2])^2 + (self.y[1]-self.y[2])^2)
end

function Link:update(mesh)
    --[[
    description: 
    ]]

    -- rotation
    if self.state == 'rotate' then
        if animation_frame < #animation_angles then
            -- update the animation frame
            animation_frame = animation_frame + 1

            -- compute the location of the rotating node
            self.x[self.rotating_node] = self.x[self.rotation_center] + self.length * math.cos(animation_angles[animation_frame])
            self.y[self.rotating_node] = self.y[self.rotation_center] + self.length * math.sin(animation_angles[animation_frame])
        else
            -- when the animation is finished, go back to the idle status
            self.state = 'idle'
            
            -- set the new index after the rotation
            self.node_indices[self.rotating_node] = new_node_index
        end
    end
end

function Link:rotate(direction, rotating_node_index)
    --[[
    description: enable rotation motion and animation
    direction (parameter, int): angle multiplicator (clockwise rotation: -1, counterclockwise rotation: 1)
    ]]

    if self.state == 'idle' then
        -- trigger the rotation in the update function
        self.state = 'rotate'
        
        -- find which node should rotate around which one
        for i, node_index in ipairs(self.node_indices) do
            if node_index == rotating_node_index then
                self.rotation_center = i
            end
        end

        if self.rotation_center == 1 then
            self.rotating_node = 2
        else
            self.rotating_node = 1 
        end

        -- after the rotation, the node will be updated
        local center_index = self.node_indices[self.rotation_center]
        local rotating_index = self.node_indices[self.rotating_node]
        new_node_index = self:find_new_index(center_index, rotating_index, mesh, direction * math.pi/2)

        -- initialize the angle
        -- angle = self:get_angle(center_index, rotating_index, mesh)
        local angle = self.command_angle
        animation_angles = {}
        animation_frame = 0

        -- set the new command angle
        self.command_angle = self.command_angle + direction * math.pi/2

        -- compute all the animation positions
        local n_theta = 20 -- to change to accelerate or slow the animation down
        local dtheta = (math.pi/2) / (n_theta)
        for i = 1, n_theta do
            angle = angle + direction * dtheta
            table.insert(animation_angles, angle)
        end
        
    end
end

function Link:draw()
    --[[
    description: 
    ]]

    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(20)
    love.graphics.line(self.x[1], self.y[1], self.x[2], self.y[2])
    love.graphics.setColor(1,1,1,1)
end

function Link:compute_direction(mesh)
    --[[
    description: 
    ]]

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

function Link:find_new_index(center_index, rotating_index, mesh, angle)
    --[[
    description
    ]]

    -- let P (player) be the center of rotation, A the rotating point and 
    -- A' the transform of A by rotation around P

    -- compute the PA vector
    local i_P, j_P = mesh:index_to_ij(center_index)
    local i_A, j_A = mesh:index_to_ij(rotating_index)
    local i_PA = i_A - i_P
    local j_PA = j_A - j_P

    -- compute the rotation matrix elements
    local R_11 = math.cos(angle)
    local R_12 = -math.sin(angle)
    local R_21 = math.sin(angle)
    local R_22 = math.cos(angle)

    -- compute the new rotating point coordinates
    local i_A_prime = i_PA*R_11 + j_PA*R_21 + i_P
    local j_A_prime = i_PA*R_12 + j_PA*R_22 + j_P

    -- translate the coordinates into an index
    index_A_prime = mesh:ij_to_index(i_A_prime, j_A_prime)
    
    return math.ceil(index_A_prime)
end

function Link:get_angle(center_index, rotating_index, mesh)
    --[[
    description
    ]]

    -- let P be the center of the rotation and A the rotating point (ie. toward the vector points to)
    local i_P, j_P = mesh:index_to_ij(center_index)
    local i_A, j_A = mesh:index_to_ij(rotating_index)
    local i_PA = i_A - i_P
    local j_PA = j_A - j_P
    print('i_PA: '..i_PA)
    print('j_PA: '..j_PA)
    local norm_PA = math.sqrt(i_PA^2 + j_PA^2)

    -- coordinates of the n vector, for which theta = 0 rad
    local i_n, j_n = 0, 1
    local norm_n = 1

    -- get the angle between n and PA
    local cosinus_theta = (i_n*i_PA + j_n*j_PA) / (norm_n*norm_PA)

    return math.acos(cosinus_theta)
end