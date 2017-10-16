# Twire
Testing Wire

### What is twire?
Twire is a small suite of unit testing for [OpenComputers](https://oc.cil.li/)

![twire in action](/docs/twire-v1-0-0.png)

## Simple to use
The philosophy of _twire_ is to keep things simple, so it's usage is far simple:

```lua
local twire = require('twire');
local describe = twire.describe;
local it = twire.it;
local assert = twire.assert;

describe('what you\'re testing', function()
  -- Example of a test that will pass
  it('what it should do', function()
    assert.equals(5, 5);
  end);
  -- Example of test that will not
  it('should not pass this test', function()
    assert.isTrue(false);
  end);
end);
```

### Planned to-do:
- [ ] Add nested **describe** (At the moment you can nest them, but it will show bad formatted)
- [ ] Add a module that exposes directly functions to global scope
- [ ] More asserts
- [ ] Document the API
- [ ] Count the delay of the tests and warn about it
- [ ] Count the total of specs that passed or failed
- [ ] Exit non zero if some spec fails (Ideal for test runners)
