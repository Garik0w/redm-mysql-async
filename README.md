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

## API

#### `MySQL.Async.execute(query, parameters, callback)`
#### `MySQL.Async.fetchAll(query, parameters, callback)`
#### `MySQL.Async.fetchScalar(query, parameters, callback)`
#### `MySQL.Async.transaction(queries, parameters, callback)`
#### `MySQL.Sync.execute(query, parameters)`
#### `MySQL.Sync.fetchAll(query, parameters)`
#### `MySQL.Sync.fetchScalar(query, parameters)`
#### `MySQL.Sync.transaction(queries, parameters, callback)`
#### `MySQL.ready(callback)`

## INFO
It uses the https://github.com/warxander/vSql library to provide a connection to your mysql server.