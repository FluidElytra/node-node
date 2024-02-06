Mesh = Object:extend()

function Mesh:new(n_x, n_y)
    --[[
    description: instanciates the Mesh object, which is the game board
    n_x (parameter, int): number of nodes along the x-axis
    n_y (parameter, int): number of nodes along the y-axis 
    ]]--
    
    -- parameters
    local x_0 = 150
    local y_0 = 150
    local step = 150
    local index = 0
    self.n_x = n_x
    self.n_y = n_y

    -- empty array of nodes
    self.nodes = {}

    -- loop over the dimensions to instanciate the nodes
    for i = 1, self.n_x do
        local x = x_0+(i-1)*step
        for j = 1, self.n_y do
            local y = y_0+(j-1)*step
            index = index + 1

            -- fill the node array
            self.nodes[#self.nodes+1] = Node(x, y, i, j, index)
        end
    end

    -- find the neighbors of each nodes
	local sweep_i = {0,1,0,-1}
	local sweep_j = {1,0,-1,0}

    for index, node in pairs(self.nodes) do
		for i = 1, #sweep_i do
			local i_neighbor = node.i + sweep_i[i]
			local j_neighbor = node.j + sweep_j[i]
			local idx = self:ij_to_index(i_neighbor, j_neighbor)

			if i_neighbor <= self.n_y and i_neighbor >= 1 and
				j_neighbor <= self.n_x and j_neighbor >= 1 then
				table.insert(node.neighbors, idx)
			end
		end
	end
end

function Mesh:update()
    --[[
    description: 
    ]]--
end

function Mesh:draw()
    --[[
    description: 
    ]]--

    -- draw the nodes
    for i = 1, #self.nodes do
        self.nodes[i]:draw()
    end
end

function Mesh:ij_to_index(i,j)
	return j + (i-1) * self.n_x
end