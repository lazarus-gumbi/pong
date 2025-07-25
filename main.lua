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
sound = love.audio.newSource("hit.mp3","static")
background = love.graphics.newImage("bg.png")
font = love.graphics.newFont("MyFont.ttf",40)



function love.load()
    love.window.setTitle("padel")
    love.window.setMode(window_width, window_height)
    love.graphics.setFont(font)
end

function love.update(dt)
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
    love.graphics.draw(background,0,0)
    love.graphics.rectangle('fill', paddle_x, paddle_y, paddle_width, paddle_height)
    love.graphics.circle('fill', ball_x, ball_y, ball_radius)
    love.graphics.printf(player_score, 0, 20, window_width, 'center')
end

function resetBall()
    ball_x = math.random(window_width)
    ball_y = ball_radius
    player_score = 0
    ball_speedX = 100
    ball_speedY = 200
    paddle_speed = 200
end
