local setmetatable = setmetatable
local os = os
local textbox = require("wibox.widget.textbox")
local timer = require("gears.timer")
local DateTime = require("lgi").GLib.DateTime
local vicious = require("vicious")

local fuzzyclock = { mt = {} }

--- This lowers the timeout so that it occurs "correctly". For example, a timeout
-- of 60 is rounded so that it occurs the next time the clock reads ":00 seconds".
local function calc_timeout(real_timeout)
    return real_timeout - os.time() % real_timeout
end

--- Create a fuzzyclock widget. It draws the time it is in a textbox.
--
-- @param format The time format. Default is " %a %b %d, %H:%M ".
-- @param timeout How often update the time. Default is 60.
-- @return A textbox widget.
function fuzzyclock.new(format, timeout)
    -- Initialize widget
    datewidget = wibox.widget.textbox()
    -- Register widget
    vicious.register(datewidget, vicious.widgets.date, "%b %d, %R", 60)
    format = format or " %a %b %d"
    timeout = timeout or 60

    local w = textbox()
    local t
    function w._fuzzyclock_update_cb()
      date = DateTime.new_now_local():format(format)
      hour = DateTime.new_now_local():format("%H")
      minute = DateTime.new_now_local():format("%M")
      fuzzy = "nope"
      if 3 < minute<= 7 then
        fuzzy = "five past "
      elseif 7 < minute<= 13 then
        fuzzy = "ten past "
      elseif 13 < minute<= 17 then
        fuzzy = "quarter past "
      elseif 17 < minute<= 23 then
        fuzzy = "twenty past "
      elseif 23 < minute<= 27 then
        fuzzy = "twenty-five past "
      elseif 27 < minute <= 33 then
        fuzzy = "half past "
      elseif 33 < minute <= 37 then
        fuzzy = "twenty-five till "
        hour = (hour + 1) % 24
      elseif 37 < minute <= 43 then
        fuzzy = "twenty till "
        hour = (hour + 1) % 24
      elseif 43 < minute <= 47 then
        fuzzy = "quarter till "
        hour = (hour + 1) % 24
      elseif 47 < minute <= 53 then
        fuzzy = "ten till "
        hour = (hour + 1) % 24
      elseif 53 < minute <= 57 then
        fuzzy = "five till "
        hour = (hour + 1) % 24
      end
      if hour == 1 or hour == 13 then
        fuzzy = fuzzy + "one o'clock"
       elseif hour == 2 or hour == 14 then
        fuzzy = fuzzy + "two o'clock"
       elseif hour == 3 or hour == 15 then
        fuzzy = fuzzy + "three o'clock"
       elseif hour == 4 or hour == 16 then
        fuzzy = fuzzy + "four o'clock"
       elseif hour == 5 or hour == 17 then
        fuzzy = fuzzy + "five o'clock"
       elseif hour == 6 or hour == 18 then
        fuzzy = fuzzy + "six o'clock"
       elseif hour == 7 or hour == 19 then
        fuzzy = fuzzy + "seven o'clock"
       elseif hour == 8 or hour == 20 then
        fuzzy = fuzzy + "eight o'clock"
       elseif hour == 9 or hour == 21 then
        fuzzy = fuzzy + "nine o'clock"
       elseif hour == 10 or hour == 22 then
        fuzzy = fuzzy + "ten o'clock"
       elseif hour == 11 or hour == 23 then
        fuzzy = fuzzy + "eleven o'clock"
       elseif hour == 0 or hour == 24 then
        fuzzy = fuzzy + "midnight"
       elseif hour == 12 then
        fuzzy = fuzzy + "noon"
       end
       if 1 < minute % 5 < 3 then
        fuzzy = "just after " + fuzzy
       elseif 3 <= minute % 5 then
        fuzzy = "nearly " + fuzzy
       end
       w:set_markup(fuzzy)
       t.timeout = calc_timeout(timeout)
       t:again()
       return true -- Continue the timer
    end
    t = timer.weak_start_new(timeout, w._fuzzyclock_update_cb)
    t:emit_signal("timeout")
    return w
end

function fuzzyclock.mt:__call(...)
    return fuzzyclock.new(...)
end

return setmetatable(fuzzyclock, fuzzyclock.mt)
