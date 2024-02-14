Mesh = Object:extend()

local start_color = {0,255/255,185/255,1}

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
    self.start = 1 -- set the start node
    self.arrival = 9 -- set the objective node
    

    -- empty array of nodes
    self.nodes = {}

    -- loop over the dimensions to instanciate the nodes
    for i = 1, self.n_x do
        local y = y_0+(i-1)*step
        for j = 1, self.n_y do
            local x = x_0+(j-1)*step
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

    -- find a way between the start and the arrival nodes

    -- set up the first level
    self.links = {}
    self.links[1] = Link(5, 6, self, 1, 0)
    -- self.links[2] = Link(5, 8, self, 2, math.pi/2)

end

function Mesh:update()
    --[[
    description: 
    ]]--
    for i = 1, #self.links do
        self.links[i]:update(self)
    end
end

function Mesh:draw()
    --[[
    description: 
    ]]--

    -- draw the links
    for i = 1, #self.links do
        self.links[i]:draw()
    end

    -- draw the nodes
    for i = 1, #self.nodes do
        if i == self.start or i == self.arrival then
            self.nodes[i].color = start_color
        end
        self.nodes[i]:draw()
    end

end

function Mesh:ij_to_index(i,j)
	return j + (i-1) * self.n_x
end

function Mesh:index_to_ij(index)
	i = math.ceil((index) / self.n_x)
	j = index - (i-1)*self.n_x
	return i,j
end