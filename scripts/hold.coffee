# Inspect the data in redis easily
#
# take <item> - Give hubot an item to hold
#
class BagOfHolding
  constructor: (@robot) ->
    @bag = []
    @capacity = 15

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.bag
        @bag = @robot.brain.data.bag
        @capacity ?= @robot.brain.data.bagSize

        updateSize = ->
          @robot.brain.data.bagSize = @capacity += 3
        setTimeout updateSize, 600000

  take: (item) ->
    has = @bag.some (obj) ->
      return obj is item
    if has
      @robot.brain.data.bag = @bag
      return "I already have one of those."
    else if @bag.length >= @capacity
      pos = Math.floor(Math.random() * @bag.length)
      drop = @bag.splice(pos, 1, item)
      @robot.brain.data.bag = @bag
      return "Took " + item + " and dropped " + drop + "."
    else
      @bag.push item
      @robot.brain.data.bag = @bag
      return "Took the " + item + "."

module.exports = (robot) ->
  bag = new BagOfHolding robot
  robot.respond /take (.*)\s*$/i, (msg) ->
    msg.send bag.take msg.match[1]
