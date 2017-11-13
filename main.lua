----------------------------------------
--         Even more stats
----------------------------------------
-- Binding of Isaac: Afterbirht+ mod
-- Updated: 2017-10-18
----------------------------------------

local moreStats = RegisterMod("Even More Stats", 1)
local game  = Game()

Isaac.DebugString("[EvenMoreStats] Mod loaded")
Isaac.ConsoleOutput("[EvenMoreStats] Mod loaded")

--------------------
-- Options
--------------------

local textScale = 1
local textFormat = 1 -- 1: name: Value (percent), 2: name: ratio

--------------------
-- Variables
--------------------

local player = nil

local statDps = { 
  name = "DPS",
  originalValue = 3.50 * (30 / (10 + 1)),
  currentValue = 0
}
            
local statRange = { 
  name = "R  ",
  originalValue = 23.75 * 1,
  currentValue = 0
}

--------------------
--  Helper Functions
--------------------

local function getTearsPerSecond(v)
  return 30 / (v + 1)
end

function moreStats.checkDelay(delay)
  return Isaac.GetFrameCount() % (delay or 10) == 0
end

function moreStats.printText(name, currentValue, originalValue)
  local ratio = currentValue / originalValue
  local textForRendering = name .. ": " .. string.format("%.2f", currentValue) .. 
    " [" .. string.format("%.0f", ratio * 100) .. "%]"
  if textFormat == 1 then
    return textForRendering
  elseif textFormat == 2 then
    return name .. ": " .. string.format("%.1f", ratio)
  else 
    return textForRendering
  end
end

--------------------
-- Main functions
--------------------

function moreStats:calculate() -- Calculates DPS and effective range
  
  player = Isaac.GetPlayer(0)
  
  --Isaac.ConsoleOutput(player.FrameCount)
  
  if player == nil or game:IsPaused() or not moreStats.checkDelay() then return end
  
  statDps.currentValue = player.Damage * getTearsPerSecond(player.MaxFireDelay)
  
  statRange.currentValue = (-player.TearHeight) * (player.ShotSpeed + player.TearFallingAcceleration)
  
end

function moreStats:render() -- Renders text
  
  statDps.printText = moreStats.printText(statDps.name, statDps.currentValue, statDps.originalValue)
  statRange.printText = moreStats.printText(statRange.name, statRange.currentValue, statRange.originalValue)

  if statDps.currentValue then 
    Isaac.RenderScaledText(statDps.printText, 
      5, 210, textScale, textScale, 1, 1, 1, 1) 
  end
  
  if statRange.currentValue then 
    Isaac.RenderScaledText(statRange.printText, 
      5, 220, textScale, textScale, 1, 1, 1, 1) 
  end

end

--------------------
-- Callbacks
--------------------

moreStats:AddCallback(ModCallbacks.MC_POST_UPDATE, moreStats.calculate)
moreStats:AddCallback(ModCallbacks.MC_POST_RENDER, moreStats.render)