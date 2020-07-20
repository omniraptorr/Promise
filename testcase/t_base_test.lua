---------------------------------------------------------------
---		Base demo of promise framework
---------------------------------------------------------------
-- The testcase: Do A(), and do B,C,D, and do E() base a,b,c
--	*) print messages:
--		20
--		andThen:	nil
--		40
--		30
--		nil	ok	nil
--	*) and catch a reson:
--		FIRE
---------------------------------------------------------------

local inspect = require "IO/inspect"

 Promise = require('Promise')
--Promise = require("promises/Promise/Promise")
print("---")
return10 = function() return 10 end
returnDoubled = function(a) print(a * 2) ; return a * 2 end
printX4 = function(a)
	print(a * 4)
	return Promise.resolve('ok')
	-- return 'ok'
end
printX3 = function(a) print(a * 3) ; return a * 3 end
unpackAndReject = function(result)
	local b, c, d = unpack(result)
	print(b, c, d)
	return Promise.reject('FIRE')
end

-- promise_A = Promise.resolve(A())
promise_r10 = Promise.new(function(resolve, reject)
	local ok, result = pcall(return10)
	print("after pcall " .. tostring(ok) .. " " .. result .. ".")
	return (ok and resolve or reject)(result)
end)
promise_r10 = Promise.resolve(10)
-- promise_B = promise_A:andThen(B)
local err = function(r) print("catch:", r) end
local log = function(r) print("andThen:", r); return r end
promise_B = promise_r10:andThen(returnDoubled):catch(err):andThen(log)

promise_C = promise_r10:andThen(printX4)
promise_D = promise_r10:andThen(printX3)


print(inspect({"hi"}))
promises = {promise_B, promise_C, promise_D}
Promise.all(promises):andThen(function(o) print(inspect(o)) return o end)
	:andThen(unpackAndReject)
	:catch(print)
