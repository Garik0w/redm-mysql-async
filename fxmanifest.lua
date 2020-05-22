fx_version 'adamant'

games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'Async for RedM, this is a completely rewritten resource by TigoDevelopment, will also work on FiveM'

server_scripts {
    'vSql/vSql.net.dll'
}

files {
    'vSql/System.Threading.Tasks.Extensions.dll',
    'vSql/System.Runtime.CompilerServices.Unsafe.dll',
    'vSql/System.Memory.dll',
    'vSql/System.Buffers.dll',
    'vSql/MySqlConnector.dll'
}