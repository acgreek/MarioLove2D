require "subclass/class.lua"

sdata = class:new()

function sdata:getShape()
  return self.shape
end

function sdata:setShape(newShape)
  self.shape = newShape
end

function sdata:getBody()
  return self.body
end

function sdata:setBody(newBody)
  self.body = newBody
end

function sdata:getString()
  return self.string
end

function sdata:setString(newString)
  self.string = newString
end

function sdata:getIsLethal()
  return self.isLethal
end

function sdata:setIsLethal(newIsLethal)
  self.isLethal = newIsLethal
end

function sdata:setObject(newObject)
  self.object = newObject
end

function sdata:getObject()
  return self.object
end

function sdata:setWidth(newWidth)
  self.width = newWidth
end

function sdata:getWidth()
  return self.width
end

function sdata:setHeight(newHeight)
  self.height = newHeight
end

function sdata:getHeight()
  return self.height
end

function sdata:setIsJumpable(newJumpable)
  self.jumpable = newJumpable
end

function sdata:getIsJumpable()
  return self.jumpable
end