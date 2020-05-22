MySQL = {
	Async = {},
	Sync = {},
	IsReady = false,
	ReadyTasks = {}
}
MySQL.__index = MySQL

local function safeQuery(query)
	assert(type(query) == 'string', 'Query must be a string type!')
	assert(query ~= '', 'Query must be a non-empty string!')

	return query
end


local function safeQueries(queries)
	assert(type(queries) == 'table', 'Queries must be in table!')

	for i = 1, #queries, 1 do
		queries[i] = safeQuery(queries[i])
	end

	return queries
end


local function safeParameters(params)
	if params == nil then
        return { [''] = true }
    end

    assert(type(params) == "table", "A table is expected")
    assert(params[1] == nil, "Parameters should not be an array, but a map (key / value pair) instead")

    if next(params) == nil then
        return { [''] = true }
    end

    return params
end

MySQL.ready = function(callback)
	if (MySQL.IsReady) then
        Citizen.CreateThread(callback)
    else
        table.insert(MySQL.ReadyTasks, callback)
    end
end

MySQL.Async.execute = function(query, parameters, callback)
	while not MySQL.IsReady do
		Citizen.Wait(0)
	end

	exports['mysql-async']:execute_async(safeQuery(query), safeParameters(parameters), callback)
end

MySQL.Async.fetchScalar = function(query, parameters, callback)
	while not MySQL.IsReady do
		Citizen.Wait(0)
	end

	exports['mysql-async']:fetch_scalar_async(safeQuery(query), safeParameters(parameters), callback)
end

MySQL.Async.fetchAll = function(query, parameters, callback)
	while not MySQL.IsReady do
		Citizen.Wait(0)
	end

	exports['mysql-async']:fetch_all_async(safeQuery(query), safeParameters(parameters), callback)
end

MySQL.Async.transaction = function(queries, parameters, callback)
	while not MySQL.IsReady do
		Citizen.Wait(0)
	end

	exports['mysql-async']:transaction_async(safeQueries(queries), safeParameters(parameters), callback)
end

MySQL.Sync.execute = function(query, parameters)
	local done, results = false, nil

	MySQL.Async.execute(query, parameters, function(result)
		results = result
		done = true
	end)

	while not done do
		Citizen.Wait(0)
	end

	return results
end

MySQL.Sync.fetchScalar = function(query, parameters)
	local done, results = false, nil

	MySQL.Async.fetchScalar(query, parameters, function(result)
		results = result
		done = true
	end)

	while not done do
		Citizen.Wait(0)
	end

	return results
end

MySQL.Sync.fetchAll = function(query, parameters)
	local done, results = false, nil

	MySQL.Async.fetchAll(query, parameters, function(result)
		results = result
		done = true
	end)

	while not done do
		Citizen.Wait(0)
	end

	return results
end

MySQL.Sync.transaction = function(query, parameters)
	local done, results = false, nil

	MySQL.Async.transaction(query, parameters, function(result)
		results = result
		done = true
	end)

	while not done do
		Citizen.Wait(0)
	end

	return results
end

Citizen.CreateThread(function()
    while not MySQL.IsReady do
        Citizen.Wait(0)
    end

    for i = 1, #MySQL.ReadyTasks, 1 do
		Citizen.CreateThread(MySQL.ReadyTasks[i])
	end
end)

RegisterNetEvent('mysql-async:ready')
AddEventHandler('mysql-async:ready', function()
	MySQL.IsReady = true
end)