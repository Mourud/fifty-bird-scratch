PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    self.score = 0
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

    for k,pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH /2< self.bird.x then
                
                self.score = self.score + 1
                pair.scored = true

                sounds['score']:play()
            end
        end
    end
    for k,pair in pairs(self.pipePairs) do
        pair:update(dt)
    end
    
    for k,pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['hurt']:play()
                sounds['explosion']:play()
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['hurt']:play()
        sounds['explosion']:play()
        gStateMachine:change('score', {
                    score = self.score
                })
    end

    for k,pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    
end


function PlayState:render()

    love.graphics.setFont(flappyFont)
    

    self.bird:render()

    for k,pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
end