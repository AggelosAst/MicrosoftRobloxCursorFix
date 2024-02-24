--[[
    Roblox MS Cursor Fix
    sturmgeist#0001
]]
-- key handling keys
getgenv().enable_key = 'C';
getgenv().terminate_key = 'B';
getgenv().enabled = false; -- idc about your script please tell the skid who made your script to use other key names
-- position related keys
getgenv().y_offset = 50; -- how much it will reduce the pos if the mouse is at the top of the screen
getgenv().negative_y_offset = -50 -- how much it will reduce the pos if the mouse is at the bottom of the screen
getgenv().accurate_negative_y_offset = 45; -- keep this here, only modify if you know what you are doing
getgenv().accurate_positive_y_offset = 10; -- keep this here, only modify if you know what you are doing
--------------------------------------------
connections = {}; -- for mouse stuff
other_connections = {}; -- for keyboard input
--------------------------------------------
workspace = workspace;
Players = game:GetService('Players');
RunService = game:GetService('RunService');
VirtualInputManager = game:GetService('VirtualInputManager');
UserInputService = game:GetService('UserInputService');
--------------------------------------------
function getClientScreenResolution() 
    return workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y;
end; -- this will change if in first person
function getMousePos() 
    local _ = Players.LocalPlayer:GetMouse();
    return Vector2.new(_.X, _.Y)
end;

table.insert(connections, RunService.RenderStepped:Connect(function()
    -- mouse pos y negative = top of screen
    -- mouse pos y positive - resolution y > 400 bottom of screen
    if (getgenv().enabled) then 
      local screen_res = table.pack(getClientScreenResolution());
      local mouse_pos = getMousePos();
      if (mouse_pos.Y < accurate_positive_y_offset) then
        if not mousemoverel then 
            VirtualInputManager:SendMouseMoveEvent(mouse_pos.X, mouse_pos.Y + y_offset, game);
        else
            mousemoverel(mouse_pos.X, mouse_pos.Y + y_offset);
        end; -- if top
      elseif (mouse_pos.Y >= (screen_res[2] - accurate_negative_y_offset)) then
        if not mousemoverel then 
            VirtualInputManager:SendMouseMoveEvent(mouse_pos.X, mouse_pos.Y + negative_y_offset, game);
        else
            mousemoverel(mouse_pos.X, mouse_pos.Y + negative_y_offset);
        end; -- if bottom
       ----------------end
      end;  
    end;
end));

table.insert(other_connections, UserInputService.InputBegan:Connect(function(keyboardInput, istextbox)
  if (not(istextbox)) then
      -- enum checking
      if (typeof(getgenv().enable_key) == 'EnumItem') then 
        local old_key = getgenv().enable_key;
        getgenv().enable_key = string.upper(old_key.Name);
      end;
      if (typeof(getgenv().terminate_key) == 'EnumItem') then 
        local old_key = getgenv().terminate_key;
        getgenv().terminate_key = string.upper(old_key.Name);
      end;
      -- keycode checking
      if (keyboardInput.KeyCode == Enum.KeyCode[getgenv().enable_key:upper()]) then 
        getgenv().enabled = not getgenv().enabled;
      elseif (keyboardInput.KeyCode == Enum.KeyCode[getgenv().terminate_key:upper()]) then
        for index, key in next, connections do 
          key:Disconnect();
          rawset(connections, index, nil);
        end;
        for index, key in next, other_connections do 
            key:Disconnect();
            rawset(other_connections, index, nil);
        end;
      end;
  end;
end));
-- dm sturmgeist#0001 if broken or smth <:happy:1145312378028818452> 🎉✨✨
