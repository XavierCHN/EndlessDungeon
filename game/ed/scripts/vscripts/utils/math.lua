if os then
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
end

function math.clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then
        lower, upper = upper, lower
    end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function math.box_muller()
    return math.sqrt(-2 * math.log(math.random())) * math.cos(2 * math.pi * math.random()) / 2
end

function math.unbounded_normal_distribution(average, std_deviation)
	return average + math.box_muller() * std_deviation
end

function math.normal_distribution(average, std_deviation, hard_min, hard_max)
	return math.min(hard_max, math.max(hard_min, average + math.box_muller() * std_deviation))
end