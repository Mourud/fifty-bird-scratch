PipePair = Class{}

GAP_HEIGHT = 80

function PipePair:init(y)
    GAP_HEIGHT = math.random(80, 120)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
-- TODO: Why?
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        for k, pipe in pairs(self.pipes) do
            pipe: update(dt)
        end
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe: render()
    end
end
