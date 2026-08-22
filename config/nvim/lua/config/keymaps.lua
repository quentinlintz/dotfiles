-- Loaded by LazyVim in addition to its own keymaps.
--
-- Deliberately almost empty: the whole point of running LazyVim is that its
-- keymap vocabulary is already in muscle memory. Project-specific bindings live
-- in the repo's own .nvim.lua under <leader>m, which LazyVim leaves free.
--
-- What is here is the gap LazyVim leaves: snacks ships zen mode but binds
-- nothing to it. Filed under <leader>u with the rest of the UI toggles, next
-- door to <leader>um, which is what you press to see a README's raw markup.

-- Reading mode. Centers the buffer and drops the statusline and gutter, which
-- is the difference between skimming a long README and actually reading it.
vim.keymap.set("n", "<leader>uz", function()
  Snacks.zen()
end, { desc = "Toggle Zen Mode" })

-- Same idea, minus the centering: one window, full width, everything else out
-- of the way. Better for code than for prose.
vim.keymap.set("n", "<leader>uZ", function()
  Snacks.zen.zoom()
end, { desc = "Toggle Zoom" })
