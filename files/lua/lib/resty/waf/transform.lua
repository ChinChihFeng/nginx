local _M = {}

local logger = require "resty.waf.log"
local util   = require "resty.waf.util"

local string_char  = string.char
local string_find  = string.find
local string_len   = string.len
local string_lower = string.lower
local string_sub   = string.sub

_M.version = "0.9"

_M.lookup = {
	base64_decode = function(waf, value)
		if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', "Decoding from base64: " .. tostring(value)) end
		local t_val = ngx.decode_base64(tostring(value))
		if (t_val) then
			if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', "Decode successful, decoded value is " .. t_val) end
			return t_val
		else
			if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', "Decode unsuccessful, returning original value " .. value) end
			return value
		end
	end,
	base64_encode = function(waf, value)
		if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', "Encoding to base64: " .. tostring(value)) end
		local t_val = ngx.encode_base64(value)
		if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', "Encoded value is " .. t_val) end
		return t_val
	end,
	cmd_line = function(waf, value)
		local str = tostring(value)
		str = ngx.re.gsub(str, [=[[\\'"^]]=], '',  waf._pcre_flags)
		str = ngx.re.gsub(str, [=[\s+/]=],    '/', waf._pcre_flags)
		str = ngx.re.gsub(str, [=[\s+[(]]=],  '(', waf._pcre_flags)
		str = ngx.re.gsub(str, [=[[,;]]=],    ' ', waf._pcre_flags)
		str = ngx.re.gsub(str, [=[\s+]=],     ' ', waf._pcre_flags)
		return string_lower(str)
	end,
	compress_whitespace = function(waf, value)
		return ngx.re.gsub(value, [=[\s+]=], ' ', waf._pcre_flags)
	end,
	hex_decode = function(waf, value)
		return util.hex_decode(value)
	end,
	hex_encode = function(waf, value)
		return util.hex_encode(value)
	end,
	html_decode = function(waf, value)
		local str = ngx.re.gsub(value, [=[&lt;]=], '<', waf._pcre_flags)
		str = ngx.re.gsub(str, [=[&gt;]=], '>', waf._pcre_flags)
		str = ngx.re.gsub(str, [=[&quot;]=], '"', waf._pcre_flags)
		str = ngx.re.gsub(str, [=[&apos;]=], "'", waf._pcre_flags)
		str = ngx.re.gsub(str, [=[&#(\d+);]=], function(n) return string_char(n[1]) end, waf._pcre_flags)
		str = ngx.re.gsub(str, [=[&#x(\d+);]=], function(n) return string_char(tonumber(n[1],16)) end, waf._pcre_flags)
		str = ngx.re.gsub(str, [=[&amp;]=], '&', waf._pcre_flags)
		if waf._debug == true then ngx.log(waf._debug_log_level, '[', waf.transaction_id, '] ', "html decoded value is " .. str) end
		return str
	end,
	length = function(waf, value)
		return string_len(tostring(value))
	end,
	lowercase = function(waf, value)
		return string_lower(tostring(value))
	end,
	md5 = function(waf, value)
		return ngx.md5_bin(value)
	end,
	normalise_path = function(waf, value)
		while (ngx.re.match(value, [=[[^/][^/]*/\.\./|/\./|/{2,}]=], waf._pcre_flags)) do
			value = ngx.re.gsub(value, [=[[^/][^/]*/\.\./|/\./|/{2,}]=], '/', waf._pcre_flags)
		end
		return value
	end,
	remove_comments = function(waf, value)
		return ngx.re.gsub(value, [=[\/\*(\*(?!\/)|[^\*])*\*\/]=], '', waf._pcre_flags)
	end,
	remove_comments_char = function(waf, value)
		return ngx.re.gsub(value, [=[\/\*|\*\/|--|#]=], '', waf._pcre_flags)
	end,
	remove_whitespace = function(waf, value)
		return ngx.re.gsub(value, [=[\s+]=], '', waf._pcre_flags)
	end,
	replace_comments = function(waf, value)
		return ngx.re.gsub(value, [=[\/\*(\*(?!\/)|[^\*])*\*\/]=], ' ', waf._pcre_flags)
	end,
	sha1 = function(waf, value)
		return ngx.sha1_bin(value)
	end,
	sql_hex_decode = function(waf, value)
		if (string_find(value, '0x', 1, true)) then
			value = string_sub(value, 3)
			return util.hex_decode(value)
		else
			return value
		end
	end,
	trim = function(waf, value)
		return ngx.re.gsub(value, [=[^\s*|\s+$]=], '')
	end,
	trim_left = function(waf, value)
		return ngx.re.sub(value, [=[^\s+]=], '')
	end,
	trim_right = function(waf, value)
		return ngx.re.sub(value, [=[\s+$]=], '')
	end,
	uri_decode = function(waf, value)
		return ngx.unescape_uri(value)
	end,
}

return _M
