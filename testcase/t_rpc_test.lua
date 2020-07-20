---------------------------------------------------------------
---		RPC demo of promise framework
---------------------------------------------------------------
-- The testcase: Do A(), and do B,C,D, and do E() base a,b,c
-- The B() is simulated remote call
--	*) print messages:
--		40
--		30
--	*) and waiting
--		waiting a moment...
--		andThen:	20
--	*) and output promise's results for arr {B, C, D}
--		20	ok	nil
--	*) and catch a reson, done:
--		FIRE
--		Done
---------------------------------------------------------------

-- Promise = require('Promise')
Promise = dofile('Promise.lua')
sleep = function(n) os.execute("sleep " .. n) end

local co_remote
return10 = function() return 10 end
returnDoubled = function(a)
	return Promise.new(function(...)
		-- start coroutine and wait
		co_remote = coroutine.create(function(y, n)
			coroutine.yield()
			y(a * 2)
		end)
		coroutine.resume(co_remote, ...)
	end)
end
printX4 = function(a)
	print(a * 4)
	return Promise.resolve('ok')
end
printX3 = function(a) print(a * 3) end
unpackAndReject = function(...)
	local b, c, d = ...
	print(b, c, d)
	return Promise.reject('FIRE')
end

-- promise_A = Promise.resolve(A())
promise_r10 = Promise.new(function(resolve, reject)
	local ok, result = pcall(return10)
	return (ok and resolve or reject)(result)
end)

local err = function(r) print("catch:", r) end
local log = function(r) print("andThen:", r); return r end
promise_B = promise_r10:andThen(returnDoubled):catch(err):andThen(log)
promise_C = promise_r10:andThen(printX4)
promise_D = promise_r10:andThen(printX3)

promises = {promise_B, promise_C, promise_D}
Promise.all(promises)
	:andThen(unpackAndReject)
	:catch(function(reson)
		print(reson)
	end)

-- pring local meessage
print('waiting a moment...')

-- fake: get some stauts from remote, and resume <promise_B> in promises array
sleep(3)
coroutine.resume(co_remote)

print('Done')
