-- Vector操作库

-- 从自己往directionPos，距离为length的一个点
function DirectVector(self, directionPos, length)
	local direction = (directionPos - self):Normalized()
	return self + direction * length
end