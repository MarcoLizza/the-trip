--[[

Copyright (c) 2016 by Marco Lizza (marco.lizza@gmail.com)

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgement in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

]]--

-- MODULE INCLUSIONS -----------------------------------------------------------

local Audio = require('lib.audio')
local graphics = require('lib.graphics')
local tweener = require('lib.tweener')

-- MODULE DECLARATION ----------------------------------------------------------

local game = {
  world = require('game.world'),
}

-- MODULE FUNCTIONS ------------------------------------------------------------

function game:initialize(environment)
  self.environment = environment

  self.world:initialize()

  self.audio = Audio.new()
  self.audio:initialize({
      ['bgm'] = { file = 'assets/sounds/everyday.ogg', overlayed = false, looping = true, mode = 'stream' }
    })
end

function game:enter()
  self.world:reset()

  -- Start the background music and create a tweener to fade in both the
  -- graphics and the audio.
  local bgm = self.audio:play('bgm', 0)
  self.fader = tweener.linear(5, function(ratio)
        bgm:setVolume(ratio)
        self.alpha = math.floor((1 - ratio) * 255)
        return ratio >= 1.0
      end)
end

function game:leave()
  self.audio:halt('bgm')
end

function game:input(keys, dt)
  self.world:input(keys, dt)
end

function game:update(dt)
  if self.fader then
    local finished = self.fader(dt)
    if finished then
      self.fader = nil
    end
  end
  
  self.world:update(dt)
  
  self.audio:update(dt)

  return nil
end

function game:draw()
  self.world:draw()
  graphics.fill('black', self.alpha)
  love.graphics.setColor(255, 255, 255)
end

-- END OF MODULE ---------------------------------------------------------------

return game

-- END OF FILE -----------------------------------------------------------------
