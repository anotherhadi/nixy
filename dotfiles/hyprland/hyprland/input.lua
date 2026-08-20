-- input.lua 
-- https://wiki.hypr.land/Configuring/Variables/#input

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    repeat_delay = 300,
    repeat_rate = 50,
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    follow_mouse= 1,
    sensitivity = 0, -- -1.0 - 1.0, M means no modifcation. 
    touchpad = {
      natural_scroll = false,
    },
  },
  })


-- Gesture 
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
  })


-- Per-device config 
-- hl.device({
--   name = "epic-mouse-v1",
--   sensitivity = -0.5,
--   })

hl.config{
  input = { -- config global for all input device. 
    sensitivity = 2.0,
    accel_profile = "flat",
    -- force_no_accel = true, -- use it if really you think there is mouse acceleration
  }
}
