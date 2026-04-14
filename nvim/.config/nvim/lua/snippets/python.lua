local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

return {
  -- Debugging
  s('bp', t 'breakpoint()'),

  -- Print with label
  s('pp', fmt('print("{}: ", {})', { i(1, 'var'), i(2, 'var') })),

  -- Function definition
  s(
    'def',
    fmt(
      [[
def {}({}):
    {}
]],
      { i(1, 'name'), i(2), i(3, 'pass') }
    )
  ),

  -- Async function definition
  s(
    'adef',
    fmt(
      [[
async def {}({}):
    {}
]],
      { i(1, 'name'), i(2), i(3, 'pass') }
    )
  ),

  -- Class definition
  s(
    'class',
    fmt(
      [[
class {}({}):
    def __init__(self{}):
        {}
]],
      { i(1, 'Name'), i(2, 'object'), i(3), i(4, 'pass') }
    )
  ),

  -- Main guard
  s(
    'main',
    fmt(
      [[
if __name__ == "__main__":
    {}
]],
      { i(1, 'pass') }
    )
  ),

  -- If/elif/else
  s('ife', fmt('if {}:\n    {}\nelse:\n    {}', { i(1, 'condition'), i(2, 'pass'), i(3, 'pass') })),

  -- Try/except
  s(
    'try',
    fmt(
      [[
try:
    {}
except {} as e:
    {}
]],
      { i(1, 'pass'), i(2, 'Exception'), i(3, 'raise') }
    )
  ),

  -- Context manager
  s('with', fmt('with {} as {}:\n    {}', { i(1, 'expr'), i(2, 'f'), i(3, 'pass') })),

  -- List comprehension
  s('lc', fmt('[{} for {} in {}]', { i(1, 'expr'), i(2, 'x'), i(3, 'iterable') })),

  -- Dict comprehension
  s('dc', fmt('{{{}: {} for {} in {}}}', { i(1, 'k'), i(2, 'v'), i(3, 'k'), i(4, 'iterable') })),

  -- Dataclass
  s(
    'dc',
    fmt(
      [[
@dataclass
class {}:
    {}: {}
]],
      { i(1, 'Name'), i(2, 'field'), i(3, 'type') }
    )
  ),

  -- Type alias
  s('ta', fmt('{} = {}', { i(1, 'Name'), i(2, 'type') })),

  -- Lambda
  s('lam', fmt('lambda {}: {}', { i(1, 'args'), i(2, 'expr') })),
}
