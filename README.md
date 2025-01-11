<!-- TOC start (generated with https://github.com/derlin/bitdowntoc) -->
- [Overview](#overview)
   * [Disclaimer](#disclaimer)
      + [Helping in development](#helping-in-development)
- [Features](#features)
   * [Elements 🟦](#elements-)
   * [Frames 🖼️](#frames-)
   * [Flexible and Powerful UIs 🔨](#flexible-and-powerful-uis-)
   * [Events 📥](#events-)
- [Simple GUI example](#simple-gui-example)
- [Installation](#installation)
- [Roadmap](#roadmap)
- [More](#more)
   * [Demo](#demo)
   * [Recipes](#recipes)


<!-- TOC end -->

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/Nykenik24/GlideUI/total) ![GitHub Repo stars](https://img.shields.io/github/stars/Nykenik24/GlideUI?style=flat) ![GitHub last commit](https://img.shields.io/github/last-commit/Nykenik24/GlideUI) ![GitHub Release Date](https://img.shields.io/github/release-date/Nykenik24/GlideUI)
        
### GlideUI is under the MIT license.
# Overview
A lightweight Love2d GUI library with the purpose of creating easy and fast interfaces for quick debugging, ultra-customizable menus and more.

## Disclaimer
GlideUI is currently **W.I.P** *(Work In Progress)*, so expect bugs and missing features. I am working hard on making it fully stable, but for now, do not expect perfect behavior from the library.

### Helping in development
- If you encounter any bug or have suggestions, you can [open an issue](https://github.com/Nykenik24/GlideUI/issues).
- If you want to contribute, please see [CONTRIBUTING.md](./CONTRIBUTING.md).

# Features
## Elements 🟦
Glide's elements are not `button`, `slider`, etc. They are objects with various useful events, methods, style options, and basic parameters. This makes it so you can build your GUI elements step by step, but without being too tedious, allowing for incredible customization.

## Frames 🖼️
Frames in Glide act as element containers. You can align (more easily) or attach (more precisely) an element to a frame, and then move the frame with `Frame:Drag()` or by manually changing `frame.x` and `frame.y`. Frames also have mouse grabbing (with `Frame:GrabMouse(true)`).

## Flexible and Powerful UIs 🔨
GlideUI allows for infinite customization of [elements](README.md#elements) and [frames](README.md#frames). You can lighten or darken your elements with methods, or restore their color completely. Set and adjust properties as needed. Set and align the text inside elements, or align elements inside frames. The possibilites are infinite!

## Events 📥
Glide's elements have easy-to-use events, such as `OnPress(button: number, func: function)`, `OnHover(func: function)`, `OnUnhover(func: function)`, `OnHold(button: number, func: function)`, and more.

# Simple GUI example
This will produce a GUI with a button in the middle of a draggable frame.
```lua
function love.load()
    glide = require("lib.glide")

    --make a new element
    --parameters: x, y, width, height, color
    BUTTON = glide.New(200, 300, 125, 25, {0.25, 0.25, 0.75})
    BUTTON:SetText("Press me!") --set the button's text

    --make a new frame
    --parameters: x, y, width, height, color
    FRAME = glide.NewFrame(100, 200, 200, 200, {0.5, 0.5, 0.5})
end

function love.update(dt) -- called every frame

    glide.Update() --IMPORTANT: call this before any other glide call

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
1. ## Download the library:
There are three methods to download the library:
### Clone the library:
<details>
<summary>Pros/Cons</summary>
    
#### Pros:
- Easy to use.
- Doesn't require a git repository.
#### Cons:
- Has to be manually updated.
- Harder to manage long-term.
</details>

```bash
git clone https://github.com/Nykenik24/GlideUI.git path/to/glide
```
### Add as a submodule **(recommended)**:
<details>
<summary>Pros/Cons</summary>
    
#### Pros:
- Easier to update.
- Easy to use.
#### Cons:
- A git repository is necessary.
</details>

```bash
git submodule add https://github.com/Nykenik24/GlideUI.git path/to/glide
```
### Download the latest release.
- Go to the repository main page.
- At the bottom-right, go to the latest release.
- Download the `.zip` file attached.
- Put it in your project.
- Extract it.
<details>
<summary>Pros/Cons</summary>
    
#### Pros:
- Releases are usually stable and rarely have bugs.
#### Cons:
- You don't have the latest features.
</details>

2. ## Require the library:
```lua
local glide = require("path.to.glide")
```
Now you can use GlideUI!

# Roadmap
- ~Make a better frame dragging system.~
- Make all the functionality you need.
- Make it as stable as possible.
<!--
- Make a layer system for frames and elements.
I want GlideUI to not have any element/frame registry or table, so making a layer system is basically impossible. I also don't want to interfere
on how you draw and manage your UIs
-->
<!-- 
- Fix all visual and interactive bugs (Such as dragging multiple elements at the same time unintentionally).
This doesn't make sense as bugs will appear and disappear over time, so it's not really an objective; it is a task.
-->

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

![Hovered](screenshots/hover_button_1.png) ![Not hovered](screenshots/hover_button_2.png)
</details>
