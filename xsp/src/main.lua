require "util"
local bb = require("badboy")
local json = bb.getJSON()
local 战斗阶段判断 = {{1383,223},{1368,241},{1386,243}}
local 英灵技能位置 = {111,259,410,615,768,917,1139,1273,1427}
local 御主技能位置 = {{1447,686},{1596,688},{1740,692}}
local 英灵选择位置 = {{537,965},{1048,906},{1546,925}}

function 分辨率检测()
	local 宽度, 高度 = getScreenSize()
	if 宽度 == 1536 and 高度 == 2048 then
		--setScreenScale(540, 960)
		init("0", 1)
	else
		toast("不支持该分辨率!")
		mSleep(2000)
		lua_exit()
	end
end

function 获取挂机参数()
	--local ret, results = showUI("ui.json")
	ret, results = 1, nil
	if ret == 0 then lua_exit() end--取消运行
	sysLog(json.encode_pretty(results))
	return results
end

function 英灵技能(技能次序)
	local x坐标 = 英灵技能位置[技能次序]
	点击(x坐标, 1110, 3000)
end

function 御主技能(技能次序, 英灵次序)
	点击(1907, 702, 1000)
	local 技能位置 = 御主技能位置[技能次序]
	点击(技能位置[1], 技能位置[2], 1000)
	local 英灵位置 = 英灵选择位置[英灵次序]
	点击(英灵位置[1], 英灵位置[2], 3000)
end

function 战斗(阶段数)
	while getColor(unpack(战斗阶段判断[阶段数])) == 0xffffff do
		点击(1810, 1133, 1800)
		点击(221, 1042)
		点击(1033, 1046)
		点击(1880, 1013, 20000)
	end
end

function 随便打()
	战斗(1)
	战斗(2)
	战斗(3)
	mSleep(3000)
end

function 结算()
	点击(221, 1042, 5000)
	点击(221, 1042, 3000)
	点击(1745, 1274, 10000)
end

function 主函数(挂机次数)
	分辨率检测()
	挂机参数 = 获取挂机参数()
	toast("开始挂机")
	sysLog("开始挂机")
	hud = createHUD()
	for i = 1, 挂机次数, 1 do
		showHUD(hud, '第'..i..'次', 30, "0xffffffff", "0x00ffffff", 0, 50, 130, 228, 32)
		点击(1430, 538, 1800)--进本
		点击(1541, 693, 2500)--选择好友
		点击(1896, 1267, 15000)--开始任务
		随便打()
		结算()
	end
	mSleep(500)
end

主函数(50)
