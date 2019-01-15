module("AIThink", package.seeall)


function npc_dota_lycan_wolf2_ed(thisEntity)
    -- 可以跳跃
    return GenericLycanWolfAIThink(thisEntity)
end