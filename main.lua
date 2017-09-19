-- TODO:
-- + Build level outside screen
-- + Move level toward bird

function love.load()
    -- laden van het vogel plaatje
    vogelPlaatje = love.graphics.newImage("plaatjes/vogel.png")

    -- de positie in het begin
    positieX = love.graphics.getWidth()/3  - vogelPlaatje:getWidth()/2
    positieY = love.graphics.getHeight()/3 - vogelPlaatje:getHeight()/2

    -- de snelheid in het begin
    snelheidY = 0

    -- de zwaartekracht
    zwaarteKracht = .2

    -- de vliegkracht
    vliegKracht = -7

    -- laden van het obstakel plaatje
    obstakelPlaatje = love.graphics.newImage("plaatjes/obstakel.png")

    -- met dit object verzamelen we alle obstakels
    obstakels = {}

    -- elke 3 seconden wordt er een obstakel geplaatst
    tijdObstakel = 3

    -- dit is de teller die elke keer tot 3 telt
    teller = 0

    -- de snelheid waarmee de obstakels naar de vogel toe bewegen
    snelheidObstakel = 3
end

function love.draw()
    -- teken de vogel
    love.graphics.draw(vogelPlaatje, positieX, positieY)

    -- teken alle obstakels die zijn toegevoegd aan het obstakels object
    for k, obstakel in pairs(obstakels) do
        love.graphics.draw(obstakelPlaatje, 30, 40)
    end
end

function love.update(tijdTussenElkFrame)
    -- de zwaartekracht beinvloed de verticale snelheid elk frame
    snelheidY = snelheidY + zwaarteKracht

    -- de snelheid beinvloed de verticale positie elk frame
    positieY = positieY + snelheidY

    -- verplaats de obstakels in het obstakels object
    for k, obstakel in pairs(obstakels) do
        obstakel.positieX = obstakel.positieX - snelheidObstakel
    end

    -- plaats een obstakel als de teller groter is dan tijdObstakel
    if teller > tijdObstakel then
        plaatsObstakel()

        -- begin opnieuw met tellen voor het plaatsen van het volgende obstakel
        tijdObstakel = 0
    end

    -- hoog de teller op met de tijd tussen elk frame
    teller = teller + tijdTussenElkFrame
end

function love.keypressed(key)
    -- als er op spatie gedrukt veranderd de snelheid door de vliegkracht
    if key == "space" then
        snelheidY = vliegKracht
    end
end

function plaatsObstakel()
    nieuwObstakel = {
        positieX = love.graphics.getWidth(),
        pisitieY = love.graphics.getHeight()
    }
    table.insert(obstakels, nieuwObstakel)
end