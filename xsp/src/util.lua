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
function 宝具判断(次序) return not(色彩判断(unpack(NP判断[次序]))) end

function 多状态判断(状态数组)
	for _, 状态 in ipairs(状态数组) do
		if 状态判断(状态) then return true end
	end 
end

function 等待(...)
	while not 多状态判断(arg) do
		mSleep(300)
	end
	mSleep(800)
end
