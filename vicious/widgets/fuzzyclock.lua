---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
--  * (c) 2009, Lucas de Vries <lucas@glacicle.com>
--  * (c) 2016, Annabelle <annzabelle@gmail.com>
---------------------------------------------------

local setmetatable = setmetatable
local os = os

local fuzzyclock = {}

-- {{{ Date widget type
local function worker(format, warg)
	minute = tonumber(os.date("%M"))
	hour = tonumber(os.date("%H"))
	fuzzy = " "
	if 3 < minute and minute <= 7 then
		fuzzy = "five past "
	elseif 7 < minute and minute<= 13 then
		fuzzy = "ten past "
	elseif 13 < minute and minute<= 17 then
		fuzzy = "quarter past "
	elseif 17 < minute and minute <= 23 then
		fuzzy = "twenty past "
	elseif 23 < minute and minute <= 27 then
		fuzzy = "twenty-five past "
	elseif 27 < minute and minute <= 33 then
		fuzzy = "half past "
	elseif 33 < minute and minute <= 37 then
		fuzzy = "twenty-five \'till "
		hour = (hour + 1) % 24
	elseif 37 < minute and minute <= 43 then
		fuzzy = "twenty \'till "
		hour = (hour + 1) % 24
	elseif 43 < minute and minute <= 47 then
		fuzzy = "quarter \'till "
		hour = (hour + 1) % 24
	elseif 47 < minute and minute <= 53 then
		fuzzy = "ten \'till "
		hour = (hour + 1) % 24
	elseif 53 < minute and minute <= 57 then
		fuzzy = "five \'till "
		hour = (hour + 1) % 24
	end
	if hour == 1 or hour == 13 then
		fuzzy = fuzzy .. "one"
	 elseif hour == 2 or hour == 14 then
		fuzzy = fuzzy .. "two"
	 elseif hour == 3 or hour == 15 then
		fuzzy = fuzzy .. "three"
	 elseif hour == 4 or hour == 16 then
		fuzzy = fuzzy .. "four"
	 elseif hour == 5 or hour == 17 then
		fuzzy = fuzzy .. "five"
	 elseif hour == 6 or hour == 18 then
		fuzzy = fuzzy .. "six"
	 elseif hour == 7 or hour == 19 then
		fuzzy = fuzzy .. "seven"
	 elseif hour == 8 or hour == 20 then
		fuzzy = fuzzy .. "eight"
	 elseif hour == 9 or hour == 21 then
		fuzzy = fuzzy .. "nine"
	 elseif hour == 10 or hour == 22 then
		fuzzy = fuzzy .. "ten"
	 elseif hour == 11 or hour == 23 then
		fuzzy = fuzzy .. "eleven"
	 elseif hour == 0 or hour == 24 then
		fuzzy = fuzzy .. "midnight"
	 elseif hour == 12 then
		fuzzy = fuzzy .. "noon"
	 end
	 if 1 < minute % 5 and minute % 5 < 2.5 then
		fuzzy = "Just after " .. fuzzy
  elseif 2.5 <= minute and minute % 5 <= 4 then
		fuzzy = "Nearly " .. fuzzy
	 else
		fuzzy = "Exactly " .. fuzzy
	 end
	 if format ~= "" then
		 fuzzy = fuzzy .. " on " .. os.date(format)
	 end
	 return fuzzy
end
-- }}}

return setmetatable(fuzzyclock, { __call = function(_, ...) return worker(...) end })
