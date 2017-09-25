function love.load()
    -- laden van het vogel plaatje
    vogelPlaatje = love.graphics.newImage("plaatjes/vogel.png")
    vogelFladderPlaatje = love.graphics.newImage("plaatjes/vogelfladder.png")

    -- laad het fladdergeluid 
    fladderGeluid = love.audio.newSource("geluiden/fladder.ogg", "static")

    -- laad het botsgeluid
    botsGeluid = love.audio.newSource("geluiden/boing.ogg", "static")

    -- de positie in het begin
    vogelPositieX = love.graphics.getWidth()/3  - vogelPlaatje:getWidth()/2
    vogelPositieY = love.graphics.getHeight()/3 - vogelPlaatje:getHeight()/2

    -- de snelheid in het begin
    snelheidY = 0

    -- de zwaartekracht
    zwaarteKracht = .1

    -- de vliegkracht
    vliegKracht = -4

    -- laden van de achtergrond
    achtergrond = love.graphics.newImage("plaatjes/achtergrond.png")

    -- laden van het obstakel plaatje
    obstakelPlaatje = love.graphics.newImage("plaatjes/obstakel.png")

    -- met dit object verzamelen we alle obstakels
    obstakels = {}

    -- elke 2 seconden wordt er een obstakel geplaatst
    tijdObstakel = 2

    -- dit is de teller die elke keer tot 2 telt
    teller = 0

    -- de snelheid waarmee de obstakels naar de vogel toe bewegen
    snelheidObstakel = 3

    -- de beginscore
    score = 0

    -- de hoogste score 
    hiscore = 0
end

function love.draw()
    -- teken de achtergrond
    love.graphics.draw(achtergrond, 0, 0)

    -- teken de vogel
    if snelheidY > -2 then
        love.graphics.draw(vogelPlaatje, vogelPositieX-vogelPlaatje:getWidth()/2, vogelPositieY-vogelPlaatje:getHeight()/2)
    else
        love.graphics.draw(vogelFladderPlaatje, vogelPositieX-vogelPlaatje:getWidth()/2, vogelPositieY-vogelPlaatje:getHeight()/2)
    end

    -- teken alle obstakels die zijn toegevoegd aan het obstakels object
    for k, obstakel in pairs(obstakels) do
        if obstakel.ondersteBoven then
            rotatie = math.pi
            love.graphics.draw(obstakelPlaatje, obstakel.positieX-obstakelPlaatje:getWidth()/2, obstakel.positieY-obstakelPlaatje:getHeight()/2, rotatie, 1, 1, obstakelPlaatje:getWidth(), obstakelPlaatje:getHeight())
        else
            rotatie = 0
            love.graphics.draw(obstakelPlaatje, obstakel.positieX-obstakelPlaatje:getWidth()/2, obstakel.positieY-obstakelPlaatje:getHeight()/2, rotatie)
        end
    end

    -- teken de hiscore op het scherm
    love.graphics.print("hiscore: " .. hiscore, 5, 5)

    -- teken de score op het scherm
    love.graphics.print("score: " .. score, 5, 20)

    -- tekenGroottePlaatjes()
end

function love.update(tijdTussenElkFrame)
    -- de zwaartekracht beinvloed de verticale snelheid elk frame
    snelheidY = snelheidY + zwaarteKracht

    -- de snelheid beinvloed de verticale positie elk frame
    vogelPositieY = vogelPositieY + snelheidY

    -- verplaats de obstakels in het obstakels object
    for k, obstakel in pairs(obstakels) do
        obstakel.positieX = obstakel.positieX - snelheidObstakel

        -- controleer op botsingen met obstakels
        if controleerBotsingObstakel(obstakel) then
            gameOver()
        end

        -- controleer of de vogel voorbij een obstakel is
        if vogelVoorbijObstakel(obstakel) and not obstakel.voorbij then
            -- hoog de score op
            score = score + 1

            obstakel.voorbij = true
        end
    end

    -- controleer op botsing met de grond
    if controleerBuitenScherm() then
        gameOver()
    end

    -- plaats een obstakel als de teller groter is dan tijdObstakel
    if teller > tijdObstakel then
        plaatsObstakel()

        -- begin opnieuw met tellen voor het plaatsen van het volgende obstakel
        teller = 0
    end

    -- hoog de teller op met de tijd tussen elk frame
    teller = teller + tijdTussenElkFrame
end

function love.keypressed(key)
    -- als er op spatie gedrukt veranderd de snelheid door de vliegkracht
    if key == "space" then
        snelheidY = vliegKracht
        love.audio.play(fladderGeluid)
    end
end

function plaatsObstakel()
    willekeurigeHoogte = math.random(0, 150)
    obstakelGrond = {
        positieX = love.graphics.getWidth() + obstakelPlaatje:getWidth(),
        positieY = love.graphics.getHeight() - obstakelPlaatje:getHeight()/2 - willekeurigeHoogte + 150,
        ondersteBoven = false
    }
    obstakelLucht = {
        positieX = love.graphics.getWidth() + obstakelPlaatje:getWidth(),
        positieY = obstakelPlaatje:getHeight()/2 - willekeurigeHoogte,
        ondersteBoven = true
    }
    table.insert(obstakels, obstakelGrond)
    table.insert(obstakels, obstakelLucht)
end

function controleerBotsingObstakel(obstakel)
    vogelLinkerkant = vogelPositieX - vogelPlaatje:getWidth()/2
    vogelRechterkant = vogelPositieX + vogelPlaatje:getWidth()/2
    vogelBovenkant = vogelPositieY - vogelPlaatje:getHeight()/2
    vogelOnderkant = vogelPositieY + vogelPlaatje:getHeight()/2

    obstakelLinkerkant = obstakel.positieX - obstakelPlaatje:getWidth()/2
    obstakelRechterkant = obstakel.positieX + obstakelPlaatje:getWidth()/2
    obstakelBovenkant = obstakel.positieY - obstakelPlaatje:getHeight()/2
    obstakelOnderkant = obstakel.positieY + obstakelPlaatje:getHeight()/2

    return vogelRechterkant > obstakelLinkerkant and
        vogelLinkerkant < obstakelRechterkant and
        vogelOnderkant > obstakelBovenkant and
        vogelBovenkant < obstakelOnderkant
end

function controleerBuitenScherm()
    vogelOnderkant = vogelPositieY + vogelPlaatje:getHeight()/2
    vogelBovenkant = vogelPositieY - vogelPlaatje:getHeight()/2
    return vogelOnderkant > love.graphics.getHeight() or vogelBovenkant < 0
end

function vogelVoorbijObstakel(obstakel)
    obstakelRechterkant = obstakel.positieX + obstakelPlaatje:getWidth()/2
    vogelLinkerkant = vogelPositieX - vogelPlaatje:getWidth()/2
    return vogelLinkerkant > obstakelRechterkant
end

function gameOver()
    -- speel het bots geluid af
    love.audio.play(botsGeluid)

    -- herstel de positie van de vogel naar de positie in het begin
    vogelPositieY = love.graphics.getHeight()/3 - vogelPlaatje:getHeight()/2

    -- herstel de snelheid naar de snelheid in het begin
    snelheidY = 0

    -- verwijder alle obstakels
    obstakels = {}

    -- begin opnieuw met tellen
    teller = 0

    -- toon de nieuwe hiscore als deze hoger is dan de vorige hiscore
    if score > hiscore then
        hiscore = score
    end

    -- herstel de score
    score = 0
end

function tekenGroottePlaatjes()
    straal = 4

    love.graphics.setColor(0, 0, 0, 255)

    vogelLinkerkant = vogelPositieX - vogelPlaatje:getWidth()/2
    vogelRechterkant = vogelPositieX + vogelPlaatje:getWidth()/2
    vogelBovenkant = vogelPositieY - vogelPlaatje:getHeight()/2
    vogelOnderkant = vogelPositieY + vogelPlaatje:getHeight()/2

    love.graphics.rectangle("line", vogelPositieX-vogelPlaatje:getWidth()/2, vogelPositieY-vogelPlaatje:getHeight()/2, vogelPlaatje:getWidth(), vogelPlaatje:getHeight())

    love.graphics.print("links", vogelLinkerkant, vogelPositieY)
    love.graphics.circle("fill", vogelLinkerkant, vogelPositieY, straal)
    love.graphics.print("rechts", vogelRechterkant, vogelPositieY)
    love.graphics.circle("fill", vogelRechterkant, vogelPositieY, straal)
    love.graphics.print("boven",vogelPositieX, vogelBovenkant)
    love.graphics.circle("fill", vogelPositieX, vogelBovenkant, straal)
    love.graphics.print("onder",vogelPositieX, vogelOnderkant)
    love.graphics.circle("fill", vogelPositieX, vogelOnderkant, straal)

    for k, obstakel in pairs(obstakels) do
        love.graphics.rectangle("line", obstakel.positieX-obstakelPlaatje:getWidth()/2, obstakel.positieY-obstakelPlaatje:getHeight()/2, obstakelPlaatje:getWidth(), obstakelPlaatje:getHeight())

        obstakelLinkerkant = obstakel.positieX - obstakelPlaatje:getWidth()/2
        obstakelRechterkant = obstakel.positieX + obstakelPlaatje:getWidth()/2
        obstakelBovenkant = obstakel.positieY - obstakelPlaatje:getHeight()/2
        obstakelOnderkant = obstakel.positieY + obstakelPlaatje:getHeight()/2

        love.graphics.print("links", obstakelLinkerkant, obstakel.positieY)
        love.graphics.circle("fill", obstakelLinkerkant, obstakel.positieY, straal)
        love.graphics.print("rechts", obstakelRechterkant, obstakel.positieY)
        love.graphics.circle("fill", obstakelRechterkant, obstakel.positieY, straal)
        love.graphics.print("boven", obstakel.positieX, obstakelBovenkant)
        love.graphics.circle("fill", obstakel.positieX, obstakelBovenkant, straal)
        love.graphics.print("onder", obstakel.positieX, obstakelOnderkant)
        love.graphics.circle("fill", obstakel.positieX, obstakelOnderkant, straal)
    end

    love.graphics.setColor(255, 255, 255, 255)
end