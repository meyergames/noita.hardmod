--Useful scripts.


---handy func i stole that converts an entire table to string, grabbed from [here](https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console)
---@param o table
---@return string
---@diagnostic disable-next-line: lowercase-global
function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

---a version of the `dump()` function but with formatting
---@param o table
---@param q bool? should keys be in quotes
---@return string
---@diagnostic disable-next-line: lowercase-global
function dumpf(o, q, r)
	r = r or 0
	local _t = ('    '):rep(r)
	local t = type(o)
	if t == 'table' then
		local s = '{\n'
		local table_is_empty = true
		for k,v in pairs(o) do
			table_is_empty = false
			if type(k) == 'number' then
				k = '['..k..']'
			elseif q then
				k = '["'..k..'"]'
			end
			s = s .. _t .. '    '..k..' = ' .. dumpf(v,q,r+1) .. ',\n'
		end
		if table_is_empty then
			return s:sub(1, -2) .. '}'
		else
			return s .. _t .. '}'
		end
	elseif t == "string" then
		return '"' .. tostring(o):gsub("\n", "\\n") .. '"'
	else
		return tostring(o)
	end
end



function MatchDateLocal(check_date)
	local current = {}
	current.year, current.month, current.day, current.hour, current.minute, current.second, current.jussi, current.mammi = GameGetDateAndTimeLocal()
	for unit,value in pairs(check_date) do
		if current[unit] ~= value then return false end
	end
	return true
end


---@class (exact) Weighted
---@field weight number

---@class (exact) Seed
---@field [1] number
---@field [2] number

---@generic T : Weighted
---@param t T[]
---@return T
---Function for picking a random table entry on `weight` as weight
function RandomFromTable(t)
	local total_weight = 0
	for _, entry in ipairs(t) do
		total_weight = total_weight + entry.weight
	end

	local rnd = Randomf(0, total_weight)
	for _, entry in ipairs(t) do
		if rnd <= entry.weight then
			return entry
		else rnd = rnd - entry.weight end
	end
	return t[#t]
end

---@generic T : Weighted
---@param t T[]
---@param context any This is passed into the condition function
---@param seed Seed|nil If a seed is passed, it will use `ProceduralRandomFromTable` instead of `RandomFromTable`.
---@return T|nil
---Compiles entries from `t` into a new table based on optional `condition` value in the entry and passes it through `RandomFromTable`. `context` is passed into the function as a parameter.
function ConditionalRandomFromTable(t, context, seed)
	local temp = {}
	for _, entry in ipairs(t) do
		if entry.condition and not entry:condition(context) then goto continue end
		temp[#temp+1] = entry
		::continue::
	end

	if #temp == 0 then return end
	if seed then return ProceduralRandomFromTable(temp, seed) else return RandomFromTable(temp) end
end

---@generic T : Weighted
---@param t T[]
---@param seed Seed
---@return T
---Function for picking a procedurally random table entry on `weight` as weight based on `seed`
function ProceduralRandomFromTable(t, seed)
	local total_weight = 0
	for _, entry in ipairs(t) do
		total_weight = total_weight + entry.weight
	end

	local rnd = ProceduralRandomf(seed[1], seed[2], 0, total_weight)
	for _, entry in ipairs(t) do
		if rnd <= entry.weight then
			return entry
		else rnd = rnd - entry.weight end
	end
	return t[#t] --Randomf has a miniscule chance to overflow
end


---simple func to get herd id, mostly for other funcs in this file to utilise
---@param entity_id entity_id
---@return int
function GetHerdID(entity_id)
	local genome_comp = EntityGetFirstComponent(entity_id, "GenomeDataComponent")
	if genome_comp then return ComponentGetValue2(genome_comp, "herd_id")
	else return 0 end
end

---Replacement function for the vanilla `utilities.lua` function, `shoot_projectile()`.
---@param shooter entity_id?
---@param entity_file string filepath to projectile.xml
---@param x number
---@param y number
---@param vel_x number?
---@param vel_y number?
---@param send_message bool?
---@return entity_id
function ShootProjectile(shooter, entity_file, x, y, vel_x, vel_y, send_message)
	---@type entity_id
	shooter = shooter or 0
	local entity_id = EntityLoad(entity_file, x, y)
	vel_x = vel_x or 0
	vel_y = vel_y or 0
	send_message =  send_message or true

	local herd_id = GetHerdID(shooter)

	GameShootProjectile(shooter, x, y, x+vel_x, y+vel_y, entity_id, send_message)

	for _, proj_comp in ipairs(EntityGetComponent(entity_id, "ProjectileComponent") or {}) do
		ComponentSetValue2(proj_comp, "mWhoShot", shooter)
		ComponentSetValue2(proj_comp, "mShooterHerdId", herd_id) --should be fine if nil..?
	end

	for _, vel_comp in ipairs(EntityGetComponent(entity_id, "VelocityComponent") or {}) do
		ComponentSetValue2(vel_comp, "mVelocity", vel_x, vel_y)
	end

	return entity_id
end

---Shorthand for quickly getting the int value of a VSC
---@param entity_id ID of the entity
---@param variable_name Name of the variable
---@param create_if_nil If true, a new VSC of the given name will be created if it doesn't exist
---@return int Value that matches the given VSC name
function GetInternalInt(entity_id, variable_name, create_if_nil)
	local value = nil
	local vscomps = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
	if vscomps ~= nil then
		for key,comp_id in pairs(vscomps) do 
			local var_name = ComponentGetValue2(comp_id, "name")
			if var_name == variable_name then
				value = ComponentGetValue2(comp_id, "value_int")
			end
		end
	end

	if value == nil and create_if_nil then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = variable_name,
			value_int = 0
		})
		value = 0
	end

	return value
end

---Shorthand for quickly setting a VSC's int value, or creating one if a VSC with the same name doesn't exist yet
---@param entity_id ID of the entity
---@param variable_name Name of the variable
---@param new_value New value of the variable (or initial value, if VSC did not exist)
function SetInternalInt(entity_id, variable_name, new_value)
	local variable_found = false
	local vscomps = EntityGetComponent(entity_id, "VariableStorageComponent")	
	if vscomps ~= nil then
		for key,comp_id in pairs(vscomps) do 
			local var_name = ComponentGetValue2(comp_id, "name")
			if var_name == variable_name then
				ComponentSetValue2(comp_id, "value_int", new_value)
				variable_found = true
			end
		end
	end

	if not variable_found then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = variable_name,
			value_int = new_value
		})
	end
end

---Shorthand for quickly raising a VSC's int value, or creating one if a VSC with the same name doesn't exist yet
---@param entity_id ID of the entity
---@param variable_name Name of the variable
---@param increment How much do we add to the existing int value? (or initial value, if VSC did not exist)
function RaiseInternalInt(entity_id, variable_name, increment)
	increment = increment or 1
	local variable_found = false
	local vscomps = EntityGetComponent(entity_id, "VariableStorageComponent")	
	if vscomps ~= nil then
		for key,comp_id in pairs(vscomps) do 
			local var_name = ComponentGetValue2(comp_id, "name")
			if var_name == variable_name then
				local value = ComponentGetValue2(comp_id, "value_int")
				ComponentSetValue2(comp_id, "value_int", value + increment)
				variable_found = true
			end
		end
	end

	if not variable_found then
		EntityAddComponent2(entity_id, "VariableStorageComponent", {
			name = variable_name,
			value_int = increment
		})
	end
end

function Remap( value, inMin, inMax, outMin, outMax )
    if inMax == inMin then
        error( "Input range cannot have zero length" )
    end

    -- normalise the input value to a 0‑1 scale
    local t = (value - inMin) / (inMax - inMin)

    return outMin + t * (outMax - outMin)
end
