-- TODO:
-- + Build level outside screen
-- + Move level toward bird

function love.load()
    -- laden van het vogel plaatje
    vogel = love.graphics.newImage("plaatjes/vogel.png")

    -- de positie in het begin
    positieX = love.graphics.getWidth()/3  - vogel:getWidth()/2;
    positieY = love.graphics.getHeight()/3 - vogel:getHeight()/2;

    -- de snelheid in het begin
    snelheidY = 0;

    -- de zwaartekracht
    zwaarteKracht = .2;

    -- de vliegkracht
    vliegKracht = -7

    -- laden van het obstakel plaatje
    obstakel = love.graphics.newImage("plaatjes/obstakel.png")

    obstakels = {}
end

function love.draw()
    -- teken de vogel
    love.graphics.draw(vogel, positieX, positieY)

    -- for o in obstakels do
        love.graphics.draw(obstakel, 30, 40)
    -- end
end

function love.update()
    -- de zwaartekracht beinvloed de verticale snelheid elk frame
    snelheidY = snelheidY + zwaarteKracht

    -- de snelheid beinvloed de verticale positie elk frame
    positieY = positieY + snelheidY
end

function love.keypressed(key)
    -- als er op spatie gedrukt veranderd de snelheid door de vliegkracht
    if key == "space" then
        snelheidY = vliegKracht
    end
end

function plaatsObstakel()
end