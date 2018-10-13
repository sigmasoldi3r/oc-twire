--[[
  Twire (Testing Wire), simple testing library.
  Pure-lua
]]
local gpu = require('component').gpu;
local term = require('term');

local GREEN = 0x1aa000;
local RED = 0xb20000;
local WHITE = 0xffffff;
local DARK = 0xaaaaaa;

local twire = {};

local newSuite, fail, pass, totalPassed, totalFailed, suites, currentSuite;
do
  local _suite, _tPass, _tFail, _suites = nil, 0, 0, {};
  newSuite = function()
    _suite = {
      failed = 0,
      passed = 0
    };
    _suites[#_suites + 1] = _suite;
  end
  fail = function()
    _tFail = _tFail + 1;
    _suite.failed = _suite.failed + 1;
  end
  pass = function()
    _tPass = _tPass + 1;
    _suite.passed = _suite.passed + 1;
  end
  totalPassed = function() return _tPass; end;
  totalFailed = function() return _tFail; end;
  suites = function() return pairs(_suites); end;
  currentSuite = function()
    return _suite;
  end
end

local push, pop, tab; 
do
  local _describeLevel = 0;
  push = function() _describeLevel = _describeLevel + 1; end;
  pop = function()
    _describeLevel = _describeLevel - 1;
    if _describeLevel < 0 then _describeLevel = 0; end
  end
  tab = function()
    return ('\t'):rep(_describeLevel - 1);
  end
end

--[[
  Colored print.
  First argument is the color code for the gpu.
]]
local function pcolor(color, ...)
  gpu.setForeground(color);
  term.write(table.concat{...});
  gpu.setForeground(WHITE);
end

--[[
  Describes a sub unit of the testing suite.
]]
function twire.describe(name, runner)
  newSuite();
  push();
  print();
  print(tab() .. name);
  local done = pcall(runner);
  if (not done) then
    pcolor(RED, '  Task failed');
  end
  print();
  local count = currentSuite();
  if (count.failed > 0) then
    pcolor(RED, tab() .. 'failed: ' .. count.failed .. '\n');
  end
  if (count.passed > 0) then
    pcolor(GREEN, tab() .. 'passed: ' .. count.passed .. '\n');
  end
  print();
  pop();
end

--[[
  Expects the function not to throw when asserting.
  If any assertion fails inside this function, is reported by the suite.
]]
function twire.it(desc, runner)
  local done, err = pcall(runner);
  if (not done) then
    pcolor(RED, '  × ' .. desc .. '\n' .. tab());
    pcolor(RED, '      Error: ' .. err .. '\n' .. tab());
    fail();
  else
    pcolor(GREEN, tab() ..  '  √ ');
    pcolor(DARK, desc .. '\n' .. tab());
    pass();
  end
end

-- Assertion library.
twire.assert = {};

function twire.assert.equals(a, b)
  assert(a == b, tostring(a) .. ' and ' .. tostring(b) .. ' are not equal!');
end

function twire.assert.notEquals(a, b)
  assert(a ~= b, tostring(a) .. ' and ' .. tostring(b) .. ' are equal!');
end

function twire.assert.notThrow(fn)
  local ok, err = pcall(fn);
  assert(ok, tostring(fn) .. ' thrown an exception!\n           Thrown: ' .. tostring(err));
end

function twire.assert.greaterThan(a, b)
  assert(a > b, tostring(a) .. ' is not greater than ' .. tostring(b) .. '!');
end

function twire.assert.greaterOrEqualThan(a, b)
  assert(a >= b, tostring(a) .. ' is not greater or equal than ' .. tostring(b) .. '!');
end

function twire.assert.lessThan(a, b)
  assert(a < b, tostring(a) .. ' is not less than ' .. tostring(b) .. '!');
end

function twire.assert.lessOrEqualThan(a, b)
  assert(a <= b, tostring(a) .. ' is not less or equal than ' .. tostring(b) .. '!');
end

function twire.assert.notNull(value)
  assert(value ~= nil, 'value is null!');
end

function twire.assert.null(value)
  assert(value == nil, 'value is not null!\n           Value: ' .. tostring(value));
end

function twire.assert.isTrue(value)
  assert(value == true, 'value is not true!');
end

function twire.assert.isFalse(value)
  assert(value == false, 'value is not false!');
end

function twire.assert.isTruthy(value)
  assert(value, 'value evaluates to false!');
end

function twire.assert.isFalsy(value)
  assert(not value, 'value evaluates to true!');
end

-- Treat as library
return twire;