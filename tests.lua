require "pcaplua"

local function hexdump(s)
	local sz = string.len(s)
	for l = 1,sz,16 do
		io.write (string.format ("%04X: ", l))
		for l2 = l, math.min(sz,l+15) do
			if (l2-l)==8 then io.write ' ' end
			io.write (string.format ('%02X ', string.byte(s,l2)))
		end
		io.write ('   ')
		for l2 = l, math.min(sz,l+15) do
			if (l2-l)==8 then io.write ' ' end
			local b = string.byte(s,l2)
			if not b or b < 32 or b > 127 then b = string.byte('.') end
			io.write (string.format ('%c', b))
		end
		io.write ('\n')
	end
end

local function hexval(s)
	local fmt = string.rep ('%02X:', string.len(s))
	return string.format (fmt, string.byte(s,1,string.len(s)))
end

p,devname=pcaplua.new_live_capture ()
print ('new_live_capture:', p, devname)
p:set_filter ('port not 22')

local d,t,l = p:next()
print (string.format("%s (%X,%d):\n", os.date('%c',t),l,l))
hexdump (d)
-- for i= 1, 3 do
-- 	print (p:next())
-- end

local eth = pcaplua.decode_ethernet (d)
print (hexval(eth.src), hexval(eth.dst), eth.type)
hexdump (eth.content)