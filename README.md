[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php) [![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/) 

# GlideUI
A lightweight Love2d GUI library with the purpouse of making easy and fast interfaces for fast debugging, ultra-customizable menus and more.

## Glide's unique feature
Glide's elements are not `button`, `slider`, etc. They are objects with `OnPress`, `OnHold`, etc. events, various functions, style options like `color` and basic parameters like `x` or `w` *(width)*.
This makes it so you can build your GUI elements step by step, but without being too tedious, allowing for incredible customization. If you don't like building GUI elements manually, you can also use the prefabs.
> Prefabs are not made at this moment.

## Frames
Frames in Glide work as an element storer, you can align (easier) or attach (more precise) an element to a frame and then move the frame with `Frame:Drag()` or manually changing `frame.x` and `frame.y`. Frames also have mouse grabbing (with `Frame:GrabMouse()`) and *(will)* have resizing.

## Simple GUI example
This will produce a GUI with a button in the middle of a draggable frame.
```lua
function love.load()
    local glide = require("lib.glide")

    --make a new element
    --parameters: x, y, w, h, color
    BUTTON = glide.New(200, 300, 125, 25, {0.25, 0.25, 0.75})
    BUTTON:SetText("Press me!") --set the button's text

    --make a new frame
    --parameters: x, y, w, h, color
    FRAME = glide.NewFrame(100, 200, 200, 200, {0.5, 0.5, 0.5})
end

function love.update(dt)
    glide.Update() --IMPORTANT: call this before any other glide event

    --use the button's OnPress event
    BUTTON:OnPress(1, function()
        BUTTON:SetText("Pressed!")
    end)

    --make the button be in the middle of the frame
    BUTTON:AlignToFrameX(FRAME, "center")
    BUTTON:AlignToFrameY(FRAME, "center")

    --make the frame draggable
    FRAME:Drag()
end

function love.draw()
    --draw both button and frame
    --draw first the frame to not make it draw over the button
    FRAME:Draw() 
    BUTTON:Draw()
end
```

# Installation
1. Download the library:\
There are three methods:
- Clone the library:
```bash
git clone https://github.com/Nykenik24/GlideUI.git path/to/glide
```
- Add as a submodule **(recommended)**:
```bash
git submodule add https://github.com/Nykenik24/GlideUI.git path/to/glide
```
- Download the latest release.
2. Require the library:
```lua
local glide = require("path.to.glide")
```
Now you can use GlideUI!

# More

## Demo
To run the demo, run the `main.lua` file with `love`.

## Recipes
<details>
<summary>Button with hover</summary>

```lua
function love.load()
    local glide = require("glide")
    BUTTON = glide.New(200, 300, 125, 25, {1, 0, 0})
end

function love.update()
    glide.Update()

    BUTTON:OnHover(function()
        BUTTON:Darken(0.25)
    end)
    BUTTON:OnUnhover(function()
        BUTTON:RestoreColor()
    end)
end

function love.draw()
    BUTTON:Draw()
end
```
