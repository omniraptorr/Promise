# Promise
The Promise module in Lua. Simple, Fast and ES6 Promises full supported/compatibled.

About ES6 Promises see here: [Promise in MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)

A chinese document at here: [The Promise's World](http://blog.csdn.net/aimingoo/article/details/47401961)

### Table of Contents

* [Install &amp; Usage](#install--usage)
* [Interface](#interface)
* [testcase or samples](#testcase-or-samples)
* [History](#history)


# Install & Usage
Download the file `Promise.lua` and put it into lua search path or current directory, and load as module from lua.

Or use luarocks and require as module:

```bash
> luarocks install promise-es6
```

and, use `Promise.new()` or use `Promise.xxx` method to get promise object.

```lua
Promise = require('Promise')

p1 = Promise.new(function(resolve, reject)
  resolve('your immediate value, or result from remote query or asynchronous call')
end)

p2 = Promise.resolve('immediate value')

p1:andThen(function(value)
  print(value)
  return 'something'
end):andThen(..)   -- more
```

# Interface

* **For the Promsie class, call with '.'**

**Promise.new(executor)**

> ```lua
> promise = Promise.new(function(resolve, reject) .. end);
> ```

**Promise.all(array)**

> ```
> promise = Promise.all(array)	-- a table as array
> ```

**Promise.race(array)**

> ```lua
> promise = Promise.race(array)	-- a table as array
> ```

**Promise.reject(reason)**

> ```lua
> promise = Promise.reject(reason);	-- reason is anything
> ```

**Promise.resolve(value)**

> ```lua
> promise = Promise.resolve(value);
> promise = Promise.resolve(thenable);
> promise = Promise.resolve(promise);
> ```

* **For promise instance, call with ':'**

**promise:andThen(onFulfilled, onRejected)**

> ```lua
> promise2 = promise:andThen(functoin(value) ... end);
> promise2 = promise:andThen(nil, functoin(reson) ... end);
> ```

**promise:catch(onRejected)**

> ```lua
> promise2 = promise:catch(functoin(reson) ... end)
> ```

# testcase or samples

This is a base testcase:

```lua
---
--- from testcase/t_base_test.lua
---
Promise = require('Promise')

return10 = function() return 10 end
returnDoubled = function(a) print(a * 2) end
printX4 = function(a)
	print(a * 4)
	return Promise.resolve('ok')  -- or direct return 'ok'
end
printX3 = function(a) print(a * 3) end
unpackAndReject = function(result)
	local b, c, d = unpack(result)
	print(b, c, d)
	return Promise.reject('FIRE')
end

-- promise_A = Promise.resolve(A())
promise_r10 = Promise.new(function(resolve, reject)
	local ok, result = pcall(return10)
	return (ok and resolve or reject)(result)
end)
promise_B = promise_r10:andThen(returnDoubled)
promise_C = promise_r10:andThen(printX4)
promise_D = promise_r10:andThen(printX3)

promises = {promise_B, promise_C, promise_D}
Promise.all(promises)
	:andThen(unpackAndReject)
	:catch(function(reson)
		print(reson)
	end)
```

# History

* 2017.04.26	release v1.2, fix some bugs

```
	- fix bug: value deliver on promise chain, about issue-#3, thanks for @stakira
	- ignore rewrite promised value
```

* 2015.10.29	release v1.1, fix some bugs

```
 	- update testcases
 	- update: add .catch() for promised string
 	- update: protect call in .new method
 	- fix bug: resolver values when multi call .then()
 	- fix bug: non standard .reject() implement
 	- fix bug: some error in .all() and .race() methods
```

* 2015.08.10	release v1.0.1, full testcases, minor fix and publish on github

* 2015.03	release v1.0.0
