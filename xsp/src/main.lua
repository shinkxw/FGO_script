require "data"
require "util"
local bb = require("badboy")
local json = bb.getJSON()

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

function 英灵技能(技能次序) 点击(英灵技能位置[技能次序], 1110, 3000) end

function 御主技能(技能次序, 英灵次序)
	点击(1907, 702, 1000)
	local 技能位置 = 御主技能位置[技能次序]
	点击(技能位置[1], 技能位置[2], 1000)
	local 英灵位置 = 英灵选择位置[英灵次序]
	点击(英灵位置[1], 英灵位置[2], 3000)
end

function 进本()
	等待('选本')
	点击(1430, 538)
	mSleep(500)
end

function 选择好友()
	等待('好友')
	点击(1541, 693)
end

function 开始任务()
	等待('队伍')
	点击(1896, 1267)
end

function 战斗(阶段数)
	while getColor(unpack(战斗阶段判断[阶段数])) == 0xffffff do
		点击(1810, 1133, 1800)
		点击(221, 1042)
		点击(1033, 1046)
		点击(1880, 1013)
		等待('准备', '羁绊')
	end
end

function 随便打()
	等待('准备')
	战斗(1)
	战斗(2)
	战斗(3)
end

function 结算()
	等待('羁绊')
	mSleep(1500)
	点击(221, 1042)
	等待('经验')
	mSleep(1500)
	点击(221, 1042)
	等待('掉落')
	mSleep(1500)
	点击(1745, 1274)
end

function 体力不足() return 色彩判断(571, 477, 0xa169cf) end

function 补充体力()
	if 色彩判断(1055, 763, 0x09fd05) then--有苹果吃苹果
	  点击(1055, 763, 1000)
	elseif 色彩判断(1055, 524, 0x09fd05) then--有石头吃石头
		点击(1055, 524, 1000)
	else--没石头退出挂机
		lua_exit()
	end
	点击(1314, 1095, 3000)--确认
	进本()
end

function 主函数(挂机次数, 自动补充体力)
	分辨率检测()
	挂机参数 = 获取挂机参数()
	toast("开始挂机")
	sysLog("开始挂机")
	hud = createHUD()
	for i = 1, 挂机次数, 1 do
		showHUD(hud, '第'..i..'/'..挂机次数..'次', 30, "0xffffffff", "0x00ffffff", 0, 50, 130, 228, 32)
		进本()
		if 体力不足() then if 自动补充体力 then 补充体力() else lua_exit() end end
		选择好友()
		开始任务()
		随便打()
		结算()
	end
	mSleep(500)
end

主函数(999, true)
