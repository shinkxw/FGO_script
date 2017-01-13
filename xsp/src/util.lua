function 点击(x, y, 暂停长度)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))  --设置随机数种子
	local index = math.random(1, 5)
	x = x + math.random(-2, 2)
	y = y + math.random(-2, 2)
	touchDown(index, x, y)
	mSleep(math.random(60, 80))                                --某些情况可能要增大延迟
	touchUp(index, x, y)
	暂停长度 = 暂停长度 or 60
	mSleep(暂停长度)
end

function 色彩判断(x坐标, y坐标, 颜色)
	return getColor(x坐标, y坐标) == 颜色
end

function 状态判断(状态) return 色彩判断(unpack(阶段判断[状态])) end
function 残血判断(次序) return not(色彩判断(unpack(血量判断[次序]))) end
function 有宝具(次序) return not(色彩判断(unpack(NP判断[次序]))) end

function 多状态判断(状态数组)
	for _, 状态 in ipairs(状态数组) do
		if 状态判断(状态) then return true end
	end 
end

function 卡色判断()
	卡色数组 = {}
	for 索引, 坐标 in ipairs(卡色识别坐标) do
		x, y = findColorInRegionFuzzy(0xfd0100, 80, 坐标[1], 坐标[2], 坐标[3], 坐标[4])
		if x > -1 then
			卡色数组[索引] = '红'
		else
			x, y = findColorInRegionFuzzy(0x055cff, 80, 坐标[1], 坐标[2], 坐标[3], 坐标[4])
			if x > -1 then
				卡色数组[索引] = '蓝'
			else
				卡色数组[索引] = '绿'
			end
		end
	end
	return 卡色数组
end

function 等待(...)
	while not 多状态判断(arg) do
		mSleep(300)
	end
	mSleep(800)
end

function 有(卡色数组, 颜色)
	for _, 卡色 in ipairs(卡色数组) do
		if 卡色 == 颜色 then return true end
	end
	return false
end

function 回蓝(卡色数组, 色卡数组)--蓝绿红
	for 次序, 卡色 in ipairs(卡色数组) do
		if 卡色 == '蓝' then table.insert(色卡数组, 次序)  end
	end
	for 次序, 卡色 in ipairs(卡色数组) do
		if 卡色 == '绿' then table.insert(色卡数组, 次序)  end
	end
	for 次序, 卡色 in ipairs(卡色数组) do
		if 卡色 == '红' then table.insert(色卡数组, 次序)  end
	end
	return 色卡数组
end

function 首红(卡色数组, 色卡数组)--红蓝绿
	for 次序, 卡色 in ipairs(卡色数组) do
		if 卡色 == '红' then table.insert(色卡数组, 次序)  end
	end
	for 次序, 卡色 in ipairs(卡色数组) do
		if 卡色 == '蓝' then table.insert(色卡数组, 次序)  end
	end
	for 次序, 卡色 in ipairs(卡色数组) do
		if 卡色 == '绿' then table.insert(色卡数组, 次序)  end
	end
	return 色卡数组
end
