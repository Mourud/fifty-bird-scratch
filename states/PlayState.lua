PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0

    self.lastGapY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)

    self.spawnTimer = self.spawnTimer + dt

    spawnTime = math.random(2,30)
    if self.spawnTimer > spawnTime then
        
        local y = math.max(-PIPE_HEIGHT + 10,
        math.min(self.lastGapY + math.random(-40 , 40), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT))
        self.lastGapY = y

        table.insert(self.pipePairs, PipePair(y))
        
        self.spawnTimer = 0
    end

    self.bird:update(dt)

        -- TODO: Why two loops?
    for k,pair in pairs(self.pipePairs) do
        pair:update(dt)
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('title')
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('title')
    end

    for k,pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end
end

function PlayState:render()
    self.bird:render()

    for k,pair in pairs(self.pipePairs) do
        pair:render()
    end
end