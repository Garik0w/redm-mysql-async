# RedM Async
![RedM-async](https://i.imgur.com/xC0965G.jpg)
MySQL Async for RedM

## INSTALLATION

Set it as a dependency in you **__resource.lua** or **fxmanifest.lua**

```lua
-- client
client_scripts {
	-- Not possible, resource is only server sided
	...
}

-- server
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	...
}
```

## Async

#### MySQL.Async.execute(string query, array params, function callback)

Works like `MySQL.Sync.execute` but will return immediatly instead of waiting for the execution of the query.
To exploit the result of an async method you must use a callback function:

```lua
MySQL.Async.execute('SELECT SLEEP(10)', {}, function(rowsChanged)
    print(rowsChanged)
end)
```

#### MySQL.Async.fetchAll(string query, array params, function callback)

Works like `MySQL.Sync.fetchAll` and provide callback like the `MySQL.Async.execute` method:

```lua
MySQL.Async.fetchAll('SELECT * FROM player', {}, function(players)
    print(players[1].name)
end)
```

#### MySQL.Async.fetchScalar(string query, array params, function callback)

Same as before for the fetchScalar method.

```lua
MySQL.Async.fetchScalar("SELECT COUNT(1) FROM players", function(countPlayer)
    print(countPlayer)
end
```

#### MySQL.Ready(function callback)

When mysql-async has been loaded, trigger callback function

```lua
MySQL.ready(function ()
    print(MySQL.Sync.fetchScalar('SELECT @parameters', {
        ['@parameters'] =  'string'
    }))
end)
```

## Features

 * Async
 * It uses the https://github.com/mysqljs/mysql library to provide a connection to your mysql server.
 * Create and close a connection for each query, the underlying library use a connection pool so only the
mysql auth is done each time, old tcp connections are keeped in memory for performance reasons.