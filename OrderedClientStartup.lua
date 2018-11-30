local awful = require("awful")


local OrderedClientStartup = {} 

-- Structure per app: 
-- { cmd="command" ,  tag = t , screen = s, geo={x=x0, y=y0, w=w0, h=h0} }
OrderedClientStartup.my_apps = {}

-- Nested callbacks to ensure the applications' respective clients spawn
--  in the correct order and are then moved to the correct tab in
--  that order
function OrderedClientStartup:begin_startup()
  local i = 1 -- start at first index

  local callback
  callback = function(c) 
    -- set correct focus, just in case
    if(OrderedClientStartup.my_apps[i].screen) then 
      awful.screen.focus(OrderedClientStartup.my_apps[i].screen) 
    end

    -- move client to correct tag
    if(OrderedClientStartup.my_apps[i].tag) then
      OrderedClientStartup.my_apps[i].tag:view_only()
      c:move_to_tag(OrderedClientStartup.my_apps[i].tag)
    end

    -- set correct position, if provided
    if(OrderedClientStartup.my_apps[i].geo) then
      local geo = OrderedClientStartup.my_apps[i].geo
      c:geometry({x = geo.x, y = geo.y, 
                  width = geo.w, height = geo.h})  
    end

    -- continue if more apps to launch
    if(i < #(OrderedClientStartup.my_apps)) then
      i = i + 1
      awful.spawn.with_shell(OrderedClientStartup.my_apps[i].cmd)
    else
      -- set focus back to your primary screen/tab
      for s in screen do
        s.tags[1]:view_only()
      end
      awful.screen.focus(screen[1] or screen)
      client.disconnect_signal("manage", callback) 
    end
  end

  -- launch first app to get this started
  client.connect_signal("manage", callback)
  awful.spawn.with_shell(OrderedClientStartup.my_apps[i].cmd)
end

-- adds an application to launch
-- i   : client will be the i-th app launched
-- cm  : command of application to be execute 
--        eg "firefox" 
-- t   : tag to spawn the client on  
--        eg screen[2].tag[2]
-- s   : screen the client should launch on 
--        eg screen[1]
-- geo : position and dimensions of client (optional)
--        eg {x=0, y=0, w=1000, h=640}
function OrderedClientStartup:add_app(i,cm,t,s,g) 
  OrderedClientStartup.my_apps[i] = { cmd = cm, tag = t, screen = s, geo=g }
end

return OrderedClientStartup
