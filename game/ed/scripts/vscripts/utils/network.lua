local ServerAddress = "http://localhost"
local ServerAuth = "T(U!G@FYGFY!I^%YUHGFRITUGFUYFDTRGCFGJHIYGUOYRT^RTYUIVBN"
function CreatePostRequest(url, kv, callback)
	local req = CreateHTTPRequest("POST",ServerAddress .. url)
	req:SetHTTPRequestPostOrGetParameter("Auth", ServerAuth)
	for k, v in pairs(kv) do
		req:SetHTTPRequestPostOrGetParameter(k, v)
	end
	req:Send(callback)
end