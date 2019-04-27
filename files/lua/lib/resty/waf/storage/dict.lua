local _M = {}

_M.version = "0.9"

local cjson  = require "cjson"
local logger = require "resty.waf.log"

function _M.initialize(waf, storage, col)
	if (not waf._storage_zone) then
		logger.fatal_fail("No storage_zone configured for memory-based persistent storage")
	end

	local altered, serialized, shm
	shm        = ngx.shared[waf._storage_zone]
	serialized = shm:get(col)
	altered    = false

	if (not serialized) then
		if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', "Initializing an empty collection for " .. col) end
		storage[col] = {}
	else
		local data = cjson.decode(serialized)

		-- because we're serializing out the contents of the collection
		-- we need to roll our own expire handling. lua_shared_dict's
		-- internal expiry can't act on individual collection elements
		for key in pairs(data) do
			if (not key:find("__", 1, true) and data["__expire_" .. key]) then
				if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', "checking " .. key) end
				if (data["__expire_" .. key] < ngx.now()) then
					if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', "Removing expired key: " .. key) end
					data["__expire_" .. key] = nil
					data[key] = nil
					altered = true
				end
			end
		end

		storage[col] = data
	end

	storage[col]["__altered"] = altered
end

function _M.persist(waf, col, data)
	if (not waf._storage_zone) then
		logger.fatal_fail("No storage_zone configured for memory-based persistent storage")
	end

	local shm        = ngx.shared[waf._storage_zone]
	local serialized = cjson.encode(data)

	if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', 'Persisting value: ' .. tostring(serialized)) end

	local ok, err = shm:set(col, serialized)

	if (not ok) then
		logger.warn(waf, "Error adding key to persistent storage, increase the size of the lua_shared_dict " .. waf._storage_zone)
	end
end


return _M
