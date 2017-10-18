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

local count = {
  failed = 0,
  passed = 0
};

local function clear()
  count.failed = 0;
  count.passed = 0;
end

local function fail()
  count.failed = count.failed + 1;
end

local function pass()
  count.passed = count.passed + 1;
end

local function pcolor(color, ...)
  gpu.setForeground(color);
  term.write(tostring(table.concat{...}));
  gpu.setForeground(WHITE);
end

function twire.describe(name, runner)
  clear();
  print();
  print(name);
  local done = pcall(runner);
  if (not done) then
    pcolor(RED, '  Task failed');
  end
  print();
  if (count.failed > 0) then
    pcolor(RED, 'failed: ' .. count.failed .. '\n');
  end
  if (count.passed > 0) then
    pcolor(GREEN, 'passed: ' .. count.passed .. '\n');
  end
  print();
end

function twire.it(desc, runner)
  local done, err = pcall(runner);
  if (not done) then
    pcolor(RED, '  × ' .. desc .. '\n');
    pcolor(RED, '      Error: ' .. err .. '\n');
    fail();
  else
    pcolor(GREEN, '  √ ');
    pcolor(DARK, desc .. '\n');
    pass();
  end
end

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
  assert(value, 'value evaluates to false!');
end

function twire.assert.isFalse(value)
  assert(not value, 'value evaluates to true!');
end

return twire;
