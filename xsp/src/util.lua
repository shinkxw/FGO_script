function 点击(x, y, 暂停长度)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))  --设置随机数种子
	local index = math.random(1,5)
	x = x + math.random(-2,2)
	y = y + math.random(-2,2)
	touchDown(index,x, y)
	mSleep(math.random(40,60))                                --某些情况可能要增大延迟
	touchUp(index, x, y)
	暂停长度 = 暂停长度 or 60
	mSleep(暂停长度)
end
