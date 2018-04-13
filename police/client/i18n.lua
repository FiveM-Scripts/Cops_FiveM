i18n = setmetatable({}, i18n)
i18n.__index = i18n

local store = {}
local lang = {}
avalLangs = {}

function i18n.setup(l)
	
	if(l ~= nil)then
		lang = l
	end
	
end

function i18n.exportData()
	local result = store
	return result
end

function i18n.importData(l,s)
	table.insert( avalLangs, l)
	store[l] = s
end

function i18n.setLang(l)
	lang = l
end

function i18n.translate(key)
	local result = ""
	if(store == nil) then
		result = "Error 502 : no translation available !"
	else
		result = store[lang][key]
		if(result == nil) then
			result = "Error 404 : key not found !"
		end
	end
	
	return result
end