MySQL = {
    Async = {},
    ReadyTasks = {},
    IsReady = false
}

MySQL.SafeParameters = function(params)
    if nil == params then
        return {[''] = ''}
    end

    assert(type(params) == "table", "A table is expected")
    assert(params[1] == nil, "Parameters should not be an array, but a map (key / value pair) instead")

    if next(params) == nil then
        return {[''] = ''}
    end

    return params
end

---
-- Execute a query with no result required, async version
--
-- @param query
-- @param params
-- @param func(int)
--
MySQL.Async.Execute = function(query, params, func)
    Citizen.CreateThread(function()
        assert(type(query) == "string", "The SQL Query must be a string")

        exports['mysql-async']:mysql_execute(query, MySQL.SafeParameters(params), func)
    end)
end

---
-- Execute a query and fetch all results in an async way
--
-- @param query
-- @param params
-- @param func(table)
--
MySQL.Async.FetchAll = function(query, params, func)
    Citizen.CreateThread(function()
        assert(type(query) == "string", "The SQL Query must be a string")

        exports['mysql-async']:mysql_fetch_all(query, MySQL.SafeParameters(params), func)
    end)
end

---
-- Execute a query and fetch the first column of the first row, async version
-- Useful for count function by example
--
-- @param query
-- @param params
-- @param func(mixed)
--
MySQL.Async.FetchScalar = function(query, params, func)
    Citizen.CreateThread(function()
        assert(type(query) == "string", "The SQL Query must be a string")

        exports['mysql-async']:mysql_fetch_scalar(query, MySQL.SafeParameters(params), func)
    end)
end

---
-- Execute a query and retrieve the last id insert, async version
--
-- @param query
-- @param params
-- @param func(string)
--
MySQL.Async.Insert = function(query, params, func)
    Citizen.CreateThread(function()
        assert(type(query) == "string", "The SQL Query must be a string")

        exports['mysql-async']:mysql_insert(query, MySQL.SafeParameters(params), func)
    end)
end

MySQL.Ready = function(callback)
    if (MySQL.IsReady) then
        Citizen.CreateThread(callback)
    else
        table.insert(MySQL.ReadyTasks, callback)
    end
end

---
-- Handle MySQL.Ready(function() ... end) when mysql-async has been loaded
---
Citizen.CreateThread(function()
    while not MySQL.IsReady do
        local status = GetResourceState('mysql-async')

        if status == 'started' or status == 'starting' then
            while GetResourceState('mysql-async') == 'starting' do
                Citizen.Wait(0)
            end

            while not exports['mysql-async']:is_ready() do
                Citizen.Wait(0)
            end

            MySQL.IsReady = true
        else
            return
        end

        Citizen.Wait(0)
    end

    if (MySQL.IsReady) then
        for _, task in ipairs(MySQL.ReadyTasks) do
            Citizen.CreateThread(task)
        end
    end
end)

MySQL.Async.execute = MySQL.Async.Execute
MySQL.Async.fetchAll = MySQL.Async.FetchAll
MySQL.Async.fetchScalar = MySQL.Async.FetchScalar
MySQL.Async.insert = MySQL.Async.Insert
MySQL.Async.transaction = MySQL.Async.Transaction
MySQL.ready = MySQL.Ready