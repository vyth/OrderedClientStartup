# Ordered Client Startup
## AwesomeWM 4.2 module

### About

Module created to allow clients to be spawned in a specified order and then moved to the proper screen, tag, position and dimensions. The currently unreleased AwesomeWM version 4.3 fixes this issue which can be built from [their official repo.](https://github.com/awesomeWM/awesome)

For those who are using 4.2 until 4.3 is officially released, this module will make it easier to get the clients positioned. And likely still work in 4.3, but their new way of doing it is less messy than this.

### How to Use

**(1)** Place the [OrderedClientStartup.lua](https://github.com/vyth/OrderedClientStartup/blob/master/OrderedClientStartup.lua) file in your lua's path, for example:

```
~/.luarocks/share/lua/5.2/
~/.luarocks/share/lua/5.2/
/usr/local/share/lua/5.2/
/usr/local/share/lua/5.2/
/usr/local/lib/lua/5.2/
/usr/local/lib/lua/5.2/
/usr/share/lua/5.2/
/usr/share/lua/5.2/
```

or in the same folder as your rc.lua.

**(2)** Sample code to ad to end of your rc.lua file.


```lua
local OCS = require("OrderedClientStartup")

-- Set layouts **before** spawning apps
screen[1].tags[1].layout = awful.layout.suit.floating
screen[2].tags[1].layout = awful.layout.suit.tile.left;


-- popen not the best way to check if startup already happened...but good enough
-- until 4.3 comes out, and pgrep is quick enough to not block for periods of
-- time
local fd = io.popen("pgrep bash | wc -l")
local num_bash = tonumber(fd:read('*all'))
fd:close()
if(num_bash < 1) then 

  --USAGE: OCS:add_app(index, command, tag, screen, [geo={x,y,w,h}])
 
                             -- MONITOR 1 (RHS) --
                             
  OCS:add_app(1,"lxterminal", screen[1].tags[1], screen[1], 
              {x=1920,y=25,w=1000,h=530})
  OCS:add_app(2,"firefox", screen[1].tags[1], screen[1],
              {x=2335,y=25,w=1504,h=1055})
  OCS:add_app(3,"lxterminal -e \"deluge-console\"", 
              screen[1].tags[1], screen[1],
              {x=1920,y=764,w=1920,h=316})

                             -- MONITOR 2 (LHS) --

  OCS:add_app(4,"lxterminal --working-directory=\"/your/proj/dir\""
              screen[2].tags[1], screen[2])
  OCS:add_app(5,"lxterminal --working-directory=\"/your/proj/dir/includes\""
              screen[2].tags[1], screen[2])
  OCS:add_app(6,"lxterminal --working-directory=\"/your/proj/dir/src\""
              screen[2].tags[1], screen[2])


  -- starts spawning apps
  OCS:begin_startup()
end
```
To view a more indepth autostart script, look at the [end of the provided rc.lua.](https://github.com/vyth/OrderedClientStartup/blob/b13bd3f7c225fa28f278c95d8251e8729b6347c1/rc.lua#L589)

### Tips

- Use this command to find the (x,y) coordinates on your screen to help client's placement:
```
watch -t -n 0.0001 xdotool getmouselocation 
```
- Order of spawning matters for tiled layouts, an example of tile.left window order:
```
+----------------------------------------------+
|                       |                      |
|                       |                      |
|          2            |                      |
|                       |                      |
+------------------------            3         |
|                       |                      |
|                       |                      |
|          1            |                      |
|                       |                      |
+----------------------------------------------+
```
