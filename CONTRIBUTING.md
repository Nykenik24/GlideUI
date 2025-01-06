# Contribute
To contribute, follow these steps:
1. Fork the repository.
2. Make all the changes you want in your forked repository, following the stablished rules [below](<CONTRIBUTING.md#Contributing rules>).
3. [Open a pull request](https://github.com/Nykenik24/GlideUI/pulls).

# Contributing rules
1. Use `PascalCase` for methods and `snake_case` for variables.
2. Use this syntax for new methods:
```lua
--add a new method to glide
--if the method is related to elements or frames, please see the syntax below this.
function glide.MethodName() end

--add a new element/frame method
function glide.New(x, y, w, h, color) --or glide.NewFrame if you want to implement a frame method
    return {
        --other variables and methods...
        YourMethodName = function(self) end,
    }
end
```
3. Make readable and understandable code:\

**Wrong:**
```lua
if this then that() end
t = {a = {b = {}, c = {}}}
```
**Right:**
```lua
if this then
    that()
end
t = {
    a = {
        b = {},
        c = {}
    }
}
```
4. If you remove a method, deprecate it to avoid breaking other user's projects.
5. If you rename a method/variable, add a version with the same name or mention it in your pull request so i can communicate it in the merge commit.
```lua
function NewMethodName()
    print("foo")
end
OriginalMethodName = NewMethodName
```
6. If you remove a variable, change the methods where that variable was used to not break anything.
7. **Never** implement a breaking change without mentioning it in the pull request.
8. Avoid significant performance impact when adding methods.
9. If you use a `love` callback, change `glide.Update` to avoid issues.
```lua
function OnMouseMove(self)
    if self:Hovering() then
        love.mousemoved(x, y, dx, dy)
                --...
        end
    end
end

function glide.Update()
    --other things...
    
    --to avoid the callback being used even when `self` in `OnMouseMoved` is not
    --being hovered.
    love.mousemoved = function() end
end
```
