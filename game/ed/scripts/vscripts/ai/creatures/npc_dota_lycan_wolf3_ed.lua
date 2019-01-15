module("AIThink", package.seeall)


function npc_dota_lycan_wolf3_ed(thisEntity)
    -- 可以跳跃
    return GenericLycanWolfAIThink(thisEntity)
end