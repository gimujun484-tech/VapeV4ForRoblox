local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/gimujun484-tech/VapeV4ForRoblox/'..readfile('newpinghyu/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after pinghyu updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after pinghyu updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'newpinghyu', 'newpinghyu/games', 'newpinghyu/profiles', 'newpinghyu/assets', 'newpinghyu/libraries', 'newpinghyu/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.vapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/7GrandDadPGN/VapeCompiled')
	end)

	local assetVer = '1'
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'

	if commit == 'main' or (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit then
		wipeFolder('newpinghyu')
		wipeFolder('newpinghyu/games')
		wipeFolder('newpinghyu/guis')
		wipeFolder('newpinghyu/libraries')
	end

	if (isfile('newvape/profiles/asset.txt') and readfile('newvape/profiles/asset.txt') or '') ~= assetVer then
		wipeFolder('newpinghyu/assets')
	end

	writefile('newvape/profiles/asset.txt', assetVer)
	writefile('newpinghyu/profiles/commit.txt', commit)
end

return loadstring(downloadFile('newpinghyu/main.lua'), 'main')()
