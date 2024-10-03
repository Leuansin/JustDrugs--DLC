DrugsDLC = {}

-- Crear el trait "Drogadicto"
DrugsDLC.TraitDrogadicto = function()
    local TraitAdicto = TraitFactory.addTrait("Drogadicto", "Drug  Addict", -8,
        "You like to confront problems in a different way. But your body will ask for more every 12 hours.\nYou can eventually outgrow your addiction if you don't consume for 21 days in a row.",
        false, false);

    TraitFactory.sortList();
    local traitList = TraitFactory.getTraits()

    for i = 1, traitList:size() do
        local trait = traitList:get(i - 1)
        BaseGameCharacterDetails.SetTraitDescription(trait)
    end
end
-- Fin Creación Trait

-- Crear el trait "Drug Lord"
DrugsDLC.TraitWalterWhite = function()
    local TraitWalterWhite = TraitFactory.addTrait("WalterWhite", "Drug Lord", 4,
        "You were always smarter than the rest. ¡You were the one making & selling the drugs to them!\nSpawn with all the recipes learned, no need to find the books to craft drugs!", false, false);

    TraitWalterWhite:getFreeRecipes():add("Make Ephedrine Compound");
    TraitWalterWhite:getFreeRecipes():add("Produce Meth Compound");
    TraitWalterWhite:getFreeRecipes():add("Dry the Meth Compound");

    TraitWalterWhite:getFreeRecipes():add("Make Acid Base");
    TraitWalterWhite:getFreeRecipes():add("Make Acid Compound");
    TraitWalterWhite:getFreeRecipes():add("Dry the Acid Compound");

    TraitWalterWhite:getFreeRecipes():add("Make Benzodiazepine Compound");
    TraitWalterWhite:getFreeRecipes():add("Produce Xanax Compound");
    TraitWalterWhite:getFreeRecipes():add("Dry Xanax Compound");

    TraitWalterWhite:getFreeRecipes():add("Make Raw Cocaine Compound");
    TraitWalterWhite:getFreeRecipes():add("Refine Cocaine Compound");
    TraitWalterWhite:getFreeRecipes():add("Dry Refined Cocaine");

    TraitWalterWhite:getFreeRecipes():add("Extract Psilocybin");
    TraitWalterWhite:getFreeRecipes():add("Mix Psilocybin Compound");
    TraitWalterWhite:getFreeRecipes():add("Grow and Pack Shrooms");

    TraitWalterWhite:getFreeRecipes():add("Extract Morphine Compound");
    TraitWalterWhite:getFreeRecipes():add("Produce Refined Heroin");
    TraitWalterWhite:getFreeRecipes():add("Dry Refined Morphine");

    TraitWalterWhite:getFreeRecipes():add("Make Fentanyl Compound");
    TraitWalterWhite:getFreeRecipes():add("Dry and Pack Fentanyl");

    TraitWalterWhite:getFreeRecipes():add("Make Amphetamine Salts");
    TraitWalterWhite:getFreeRecipes():add("Dry Amphetamine Salts");

    TraitWalterWhite:getFreeRecipes():add("Extract Crack Compound");
    TraitWalterWhite:getFreeRecipes():add("Dry and Pack the Crack");

    TraitWalterWhite:getFreeRecipes():add("Extract Phenylethylamine");


    TraitFactory.sortList();
    local traitList = TraitFactory.getTraits()

    for i = 1, traitList:size() do
        local trait = traitList:get(i - 1)
        BaseGameCharacterDetails.SetTraitDescription(trait)
    end
end
-- Fin Creación Trait

-- Dar el item "DrugsDLC.DrugPipe" al spawnear el personaje
DrugsDLC.GivePlayerItem = function()
    local player = getPlayer() -- Obtener el jugador
    if player:HasTrait("Drogadicto") then
        player:getInventory():AddItem("DrugsDLC.Cocaine")
        player:getInventory():AddItem("DrugsDLC.Fentanyl")
        player:getInventory():AddItem("DrugsDLC.5ShroomsPack")
        player:getInventory():AddItem("DrugsDLC.NarcanSOS")
        player:getInventory():AddItem("DrugsDLC.Bismuth")
        player:getInventory():AddItem("DrugsDLC.Loperamide")
    end
end
-- Fin Dar el Item

-- Efecto de abstinencia para los Drogadictos
DrugsDLC.IncreaseEffectsEveryHour = function()
    local player = getPlayer()
    local bodyDamage = player:getBodyDamage()

    local Intoxicacion = bodyDamage:getPoisonLevel()

    if Intoxicacion >= 5 then
        player:Say("Im a little intoxicated, should find Loperamide.")

        if Intoxicacion == 60 then
            player:Say("Im having an Overdose. I Need Narcan ASAP!")
        end

    end

    if player:HasTrait("Drogadicto") then
        local bodyDamage = player:getBodyDamage()

        -- Aumentar aburrimiento, dolor y sudor
        local boredomLevel = bodyDamage:getBoredomLevel()

        bodyDamage:setBoredomLevel(boredomLevel + 3) -- Aumentar aburrimiento
    end
end

-- Temporizador de abstinencia y sus efectos
DrugsDLC.AbstinenceSystem = function()
    local player = getPlayer()

    local stats = player:getStats()

    if player:HasTrait("Drogadicto") then
        -- Obtener el mod data para guardar el estado de abstinencia
        local modData = player:getModData()

        -- Inicializar el temporizador si no existe
        if not modData.abstinenceTimer then
            modData.abstinenceTimer = 0
        end

        -- Comprobar si el jugador tiene drogas en el inventario
        local hasDrugs = player:getInventory():contains("DrugsDLC.Cocaine") or
            player:getInventory():contains("DrugsDLC.Meth") or
            player:getInventory():contains("DrugsDLC.Fentanyl") or
            player:getInventory():contains("DrugsDLC.Shrooms") or
            player:getInventory():contains("DrugsDLC.Crack") or
            player:getInventory():contains("DrugsDLC.Heroin") or
            player:getInventory():contains("DrugsDLC.HeroinNeedle") or
            player:getInventory():contains("DrugsDLC.Amphetamine") or
            player:getInventory():contains("DrugsDLC.Xanax") or
            player:getInventory():contains("DrugsDLC.MethPipe") or
            player:getInventory():contains("DrugsDLC.CrackPipe") or
            player:getInventory():contains("DrugsDLC.Acid") or
            player:getInventory():contains("DrugsDLC.Percocet") or
            player:getInventory():contains("DrugsDLC.Lean")


        -- Si tiene drogas, reiniciar el temporizador de abstinencia
        if hasDrugs then
            modData.abstinenceTimer = 0
        else
            -- Incrementar el temporizador de abstinencia cada hora
            modData.abstinenceTimer = modData.abstinenceTimer + 1
        end

        -- Si han pasado 12 horas sin consumir drogas, aplicar efectos de abstinencia
        if modData.abstinenceTimer >= 12 then
            local stats = player:getStats()
            local currentFatigue = stats:getFatigue() -- Obtener la fatiga actual
            local newFatigue = currentFatigue - 1 -- Restar 1 a la fatiga
            local currentPain = stats:getPain()
            local newPain = currentPain + 1
            local currentAnger = stats:getAnger()
            local newAnger = currentAnger + 2

            -- Asegurarse de que no sea menor a 0
            if newFatigue < 0 then
                newFatigue = 0
            end
            
            if newAnger < 0 then
                newAnger = 0
            end

            -- Si es mayor a 100, dejarlo en 100
            if newPain >= 100 then
                newPain = 90
            end

            if newAnger >= 100 then
                newAnger = 90
            end
            
            stats:setStress(3)  -- Aumentar estrés
            stats:setFatigue(newFatigue) -- Aumentar fatiga
            stats:setPain(newPain)
            stats:setAnger(newAnger)

            player:Say("¡Damn!, I feel like i need some drugs...")
            
        end

        -- Este 'if' es utilizado solamente, para poder colapsar todo y asi ahorrar espacio visual
        if modData.abstinenceTimer >= 0 then
            -- 2 Days
            if modData.abstinenceTimer == 48 then
                player:Say("Damn, I'm starting to feel the abstinence...")
            end

            -- 3 Days
            if modData.abstinenceTimer == 72 then
                player:Say("72 Hours, this should be the peak of abstinence...")
            end

            if modData.abstinenceTimer == 73 then
                player:Say("¡I NEED THEM!")
            end

            if modData.abstinenceTimer == 96 then
                player:Say("I would kill for some Shrooms.")
            end

            if modData.abstinenceTimer == 115 then
                player:Say("115 Hours without Drugs... Im really proud.")
            end

            if modData.abstinenceTimer == 168 then
                player:Say("1 Week without them, i gotta stop thinking about it.")
            end

            if modData.abstinenceTimer == 300 then
                player:Say("I kinda like being sober...")
            end

            if modData.abstinenceTimer == 400 then
                player:Say("I really like being sober")
            end
        end

        -- Si han pasado 504 horas (21 Días) sin consumir drogas, Remover Trait
        if modData.abstinenceTimer == 504 then
            local bodyDamage = player:getBodyDamage()

            modData.abstinenceTimer = 0
            player:getTraits():remove("Drogadicto")
            player:Say("¿21 Days in a row? Huh, Guess i don't need them anymore.")
            bodyDamage:setFoodSicknessLevel(0) -- Reestablecemos el Food Poisoning
        end
    else
        -- Obtener el mod data para guardar el estado de abstinencia
        local modData = player:getModData()

        -- Inicializar el temporizador si no existe
        if not modData.consumidoTimer then
            modData.consumidoTimer = 0
        end

        -- Comprobar si el jugador tiene drogas en el inventario
        local hasDrugs1 = player:getInventory():contains("DrugsDLC.Cocaine") or
            player:getInventory():contains("DrugsDLC.Meth") or
            player:getInventory():contains("DrugsDLC.Fentanyl") or
            player:getInventory():contains("DrugsDLC.Shrooms") or
            player:getInventory():contains("DrugsDLC.Crack") or
            player:getInventory():contains("DrugsDLC.Heroin") or
            player:getInventory():contains("DrugsDLC.HeroinNeedle") or
            player:getInventory():contains("DrugsDLC.Amphetamine") or
            player:getInventory():contains("DrugsDLC.Xanax") or
            player:getInventory():contains("DrugsDLC.MethPipe") or
            player:getInventory():contains("DrugsDLC.CrackPipe") or
            player:getInventory():contains("DrugsDLC.Acid") or
            player:getInventory():contains("DrugsDLC.Percocet") or
            player:getInventory():contains("DrugsDLC.Lean")


        -- Si tiene drogas, reiniciar el temporizador de abstinencia
        if hasDrugs1 then
            modData.consumidoTimer = 1
        else
            -- Incrementar el temporizador de abstinencia cada hora
            modData.consumidoTimer = modData.consumidoTimer - 1
        end

        if modData.consumidoTimer >= 100 then
            player:getTraits():add("Drogadicto")
        end
    end
end

-- Añadir Funciones a Eventos
Events.OnNewGame.Add(DrugsDLC.GivePlayerItem)
Events.EveryHours.Add(DrugsDLC.IncreaseEffectsEveryHour)
Events.EveryHours.Add(DrugsDLC.AbstinenceSystem)

-- Añadir el trait al juego
Events.OnGameBoot.Add(DrugsDLC.TraitDrogadicto)
Events.OnGameBoot.Add(DrugsDLC.TraitWalterWhite)
