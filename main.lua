window_width = 500
window_height = 300

-- Paddle
paddle_x = window_width / 2 - 40
paddle_height = 10
paddle_width = 80
paddle_y = window_height - paddle_height
paddle_speed = 200

-- Ball
ball_x = window_width / 2
ball_y = window_height / 2
ball_radius = 10
ball_speedX = 100
ball_speedY = 200

player_score = 0
sound = love.audio.newSource("hit.mp3", "static")
background = love.graphics.newImage("bg.png")
font = love.graphics.newFont("MyFont.ttf", 40)

local particles = {}

function spawnParticle(x, y)
    local p = {
        x = x,
        y = y,
        radius = math.random(2, 5),
        dx = math.random(-50, 50),
        dy = math.random(-50, 50),
        life = 1 -- seconds
    }
    table.insert(particles, p)
end

function love.load()
    love.window.setTitle("padel")
    love.window.setMode(window_width, window_height)
    love.graphics.setFont(font)
end

function love.update(dt)
    -- Update particles
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x = p.x + p.dx * dt
        p.y = p.y + p.dy * dt
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(particles, i)
        end
    end

    if love.keyboard.isDown('a') then
        if paddle_x > 0 then
            paddle_x = paddle_x - (paddle_speed * dt)
        end
    end

    if love.keyboard.isDown('d') then
        if paddle_x < window_width - paddle_width then
            paddle_x = paddle_x + (paddle_speed * dt)
        end
    end

    ball_x = ball_x + ball_speedX * dt
    ball_y = ball_y + -ball_speedY * dt

    -- top bounce
    if ball_y - ball_radius < 0 then
        ball_y = ball_radius
        -- ball_y = ball_y
        ball_speedY = -ball_speedY
        playSound()
    end

    -- right bounce
    if ball_x + ball_radius > window_width then
        ball_x = window_width - ball_radius
        ball_speedX = -ball_speedX
        playSound()
    end

    -- left bounce
    if ball_x - ball_radius < 0 then
        ball_x = ball_radius
        ball_speedX = -ball_speedX
        playSound()
    end

    -- paddle bounce
    if ball_y + ball_radius > paddle_y then
        if ball_x + ball_radius >= paddle_x and ball_x - ball_radius <= paddle_x + paddle_width then
            ball_y = paddle_y - paddle_height
            ball_speedY = -ball_speedY
            player_score = player_score + 1
            playSound()
            for i = 1, 30 do
                spawnParticle(ball_x, ball_y)
            end


            if player_score % 10 == 0 then
                paddle_speed = paddle_speed + 100
                ball_speedX = ball_speedX + 50
                ball_speedY = ball_speedY + 50
            end
        end
    end

    if ball_y + ball_radius > window_height then
        resetBall()
    end
end

function playSound()
    sound:stop()
    sound:play()
end

function love.draw()
    -- love.graphics.print("Hello World",300t,200)
    -- reset color

    love.graphics.draw(background, 0, 0)
    love.graphics.rectangle('fill', paddle_x, paddle_y, paddle_width, paddle_height)
    love.graphics.circle('fill', ball_x, ball_y, ball_radius)
    love.graphics.printf(player_score, 0, 20, window_width, 'center')
    for _, p in ipairs(particles) do
        local alpha = p.life / 1               -- fade out over lifetime
        love.graphics.setColor(1, 1, 1, alpha) -- white, fade with life
        love.graphics.circle("fill", p.x, p.y, p.radius)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function resetBall()
    ball_x = math.random(window_width)
    ball_y = ball_radius
    player_score = 0
    ball_speedX = 100
    ball_speedY = 200
    paddle_speed = 200
end
