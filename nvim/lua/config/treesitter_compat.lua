-- Compatibility shim for nvim-treesitter's `master` branch on Neovim 0.12.
--
-- 0.12 dropped the `all = false` option on `vim.treesitter.query.add_predicate` and
-- `add_directive`: handlers now always receive `match[capture_id]` as a *list* of nodes.
-- nvim-treesitter `master` still registers its handlers with `all = false` and indexes
-- `match[id]` as a single node, so any query reaching one of them dies with
--
--   vim/treesitter.lua:197: attempt to call method 'range' (a nil value)
--
-- In practice that's `#set-lang-from-info-string!` (markdown fenced code blocks) and
-- `#downcase!` (bash heredocs) — so it surfaces as an error banner whenever Telescope
-- previews such a file. `master` is archived upstream and won't be fixed, so re-register
-- its handlers here, wrapped to see the single-node shape they were written against.

local M = {}

--- Collapse a 0.12-style `table<integer, TSNode[]>` match into the legacy
--- `table<integer, TSNode>` shape.
local function unwrap(match)
  local single = {}
  for id, nodes in pairs(match) do
    single[id] = type(nodes) == "table" and nodes[1] or nodes
  end
  return single
end

function M.apply()
  local query = require("vim.treesitter.query")
  local add_predicate, add_directive = query.add_predicate, query.add_directive

  -- Intercept registration rather than re-implementing each handler: we keep
  -- upstream's logic and only fix up the argument it receives.
  local function wrapping(register)
    return function(name, handler, opts)
      register(name, function(match, ...)
        return handler(unwrap(match), ...)
      end, opts)
    end
  end

  query.add_predicate = wrapping(add_predicate)
  query.add_directive = wrapping(add_directive)

  -- The module registers on load, so drop it from the cache to re-run registration.
  -- Its handlers are declared with `force = true`, so overriding is allowed.
  package.loaded["nvim-treesitter.query_predicates"] = nil
  local ok, err = pcall(require, "nvim-treesitter.query_predicates")

  query.add_predicate = add_predicate
  query.add_directive = add_directive

  if not ok then
    vim.notify("treesitter_compat: " .. tostring(err), vim.log.levels.WARN)
  end
end

return M
