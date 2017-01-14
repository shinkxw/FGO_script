require "data"
require "util"
local bb = require("badboy")
local json = bb.getJSON()

function 选择敌人(次序) 点击(敌人选择位置[次序], 260, 1000) end
function 英灵技能(技能次序, 英灵次序)
	点击(英灵技能位置[技能次序], 1110, 1000)
	if 英灵次序 then
		点击(英灵选择位置[英灵次序], 925, 3000)
	else
		mSleep(2000)
	end
end

function 御主技能(技能次序, 英灵次序)
	点击(1907, 702, 1000)
	点击(御主技能位置[技能次序], 690, 1000)
	点击(英灵选择位置[英灵次序], 925, 3000)
end

function 进本()
	等待('选本')
	点击(1430, 538, 550)
end

function 选择好友()
	等待('好友')
	点击(1023,660)
end

function 开始任务()
	等待('队伍')
	点击(1896, 1267)
end

function 色卡(次序) 点击(unpack(色卡宝具位置[次序])) end
function 选择色卡(次序数组)
	点击(1810, 1133, 1800)
	色卡(次序数组[1])
	色卡(次序数组[2])
	色卡(次序数组[3])
end
function 战斗(阶段数)
	while getColor(unpack(战斗阶段判断[阶段数])) == 0xffffff do
		选择色卡({1,2,3})
		等待('准备', '羁绊')
	end
end

function 随便打()
	等待('准备')
	战斗(1)
	战斗(2)
	战斗(3)
end

是否治疗过 = false
function 治疗()
	if 是否治疗过 then return end
	for i=1, 3 do
		if 残血判断(i) then
			御主技能(1, i)
			英灵技能(3, i)
			英灵技能(4, i)
			是否治疗过 = true
			return
		end
	end
end

function 圣诞打()
	等待('准备')
	while getColor(unpack(战斗阶段判断[1])) == 0xffffff do
		治疗()
		卡色数组 = 卡色判断()
		if 有(卡色数组, '蓝') then
			色卡数组 = 选卡(卡色数组, {'蓝','绿','红'})
		else
			色卡数组 = 选卡(卡色数组, {'红','蓝','绿'})
		end
		选择色卡(色卡数组)
		等待('准备')
	end
	i = 1
	while getColor(unpack(战斗阶段判断[2])) == 0xffffff do
		治疗()
		if i == 1 then 选择敌人(2) end
		卡色数组 = 卡色判断()
		if 有(卡色数组, '蓝') then
			色卡数组 = 选卡(卡色数组, {'蓝','绿','红'})
		else
			色卡数组 = 选卡(卡色数组, {'红','蓝','绿'})
		end
		选择色卡(色卡数组)
		等待('准备')
		i = i + 1
	end
	i = 1
	while getColor(unpack(战斗阶段判断[3])) == 0xffffff do
		治疗()
		卡色数组 = 卡色判断()
		色卡数组 = {}
		if i == 4 then 御主技能(3, 1) end
		if 有宝具(1) then--杰克有大
			选择敌人(1)
			英灵技能(1)
			table.insert(色卡数组, 6)
		end
		if 有宝具(2) then
			英灵技能(6)
			御主技能(2, 2)
			table.insert(色卡数组, 7)
		end
		if 有宝具(3) then
			英灵技能(9)
			table.insert(色卡数组, 8)
		end
		if ((i < 3) and 有(卡色数组, '蓝')) then
			选卡(卡色数组, {'蓝','绿','红'}, 色卡数组)
		else
			选卡(卡色数组, {'红','蓝','绿'}, 色卡数组)
		end
		选择色卡(色卡数组)
		等待('准备', '羁绊')
		i = i + 1
	end
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

function 体力不足() return 色彩判断(993, 243, 0x876c57) end

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

function 主函数(挂机次数)
	init("0", 1)
	toast("开始挂机")
	sysLog("开始挂机")
	hud = createHUD()
	for i = 1, 挂机次数, 1 do
		是否治疗过 = false
		showHUD(hud, '第'..i..'/'..挂机次数..'次', 30, "0xffffffff", "0x00ffffff", 0, 50, 130, 228, 32)
		进本()
		if 体力不足() then 补充体力() end
		选择好友()
		开始任务()
		--随便打()
		圣诞打()
		结算()
	end
	mSleep(500)
end

主函数(999)

--init("0", 1)
--mSleep(1000)
