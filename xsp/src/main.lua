require "util"
local bb = require("badboy")
local json = bb.getJSON()
local 战斗阶段 = {{1383,223},{1368,241},{1386,243}}
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
	点击(1907,702, 1000)
	local 技能位置 = 御主技能位置[技能次序]
	点击(技能位置[1], 技能位置[2], 1000)
	local 英灵位置 = 英灵选择位置[英灵次序]
	点击(英灵位置[1], 英灵位置[2], 3000)
end

function 战斗(阶段数)
	local 判断坐标 = 战斗阶段[阶段数]
	while getColor(判断坐标[1], 判断坐标[2]) == 0xffffff do
		点击(1810, 1133, 1500)
		点击(221, 1042)
		点击(1033, 1046)
		点击(1880, 1013, 20000)
	end
end

function 黑森林()
	--第一阶段
	英灵技能(2)--旧狗避矢加护
	战斗(1)
	--第二阶段
	战斗(2)
	--boss阶段
	英灵技能(3)--旧狗兽杀
	英灵技能(8)--孔明忠言
	英灵技能(9)--孔明指挥
	御主技能(2, 1)
	点击(1810, 1133, 1500)
		点击(682, 515, 200)--宝具
		点击(221, 1042)
		点击(1033, 1046, 25000)
end

function 随便打()
	英灵技能(9)--孔明指挥
	战斗(1)
	战斗(2)
	战斗(3)
	mSleep(5000)
end

function 主函数()
	分辨率检测()
	挂机参数 = 获取挂机参数()
	toast("开始挂机")
	sysLog("开始挂机")
	local 挂机次数 = 99
	id = createHUD()
	for i = 1, 挂机次数, 1 do
		sysLog(i)
		showHUD(id, '第'..i..'次', 30, "0xffffffff", "0x00ffffff", 0, 50, 130, 228, 32)
		--进本
		点击(1430, 538, 1500)
		--选择好友
		点击(1541, 693, 2000)
		--开始任务
		点击(1896, 1267, 15000)
		--黑森林()
		随便打()
		--结算阶段
		点击(221, 1042, 5000)
		点击(221, 1042, 3000)
		点击(1745, 1274, 10000)
	end
	mSleep(500)end

主函数()
