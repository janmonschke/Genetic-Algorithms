{Genome} = require 'genome'

class TSAGenome extends Genome

  getRandomIndex: (array) ->
    Math.floor array.length * Math.random()

  # create a random array of city values
  initial: ->
    # cities have numbers from 1 to 15
    possibleCities = [1..15]
    length = possibleCities.length
    values = []
    while values.length < length
      # select a random city
      randomIndex = @getRandomIndex possibleCities
      values.push possibleCities[randomIndex]
      possibleCities[randomIndex] = null
      # remove the city from the list
      possibleCities = _.compact possibleCities
    # we are going to deal with zero based indexes
    values = _.map values, (num) -> --num
    values

  # Mutate the Genome by exchanging two random values
  mutate: ->
    indexA = @getRandomIndex @values
    indexB = @getRandomIndex @values
    buff = @values[indexA]
    @values[indexA] = @values[indexB]
    @values[indexB] = buff

  # Perform a uniform crossover with the given genome
  # @param [Genome] genome 
  # @param [Float] mixingRatio How much should get mixed?
  # @return [Array<Genome>] the two new Genomes
  crossover: (genome, mixingRatio) ->
    cpP1 = _.clone @values
    cpP2 = _.clone genome.values
    child1 = new TSAGenome [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    child2 = new TSAGenome []

    taken = 0
    amount = @values.length
    # fill with values from parent until mixingRatio is reached
    while (taken / amount) < mixingRatio
      # select a random index to copy
      randomIndex = Math.floor Math.random() * amount
      
      # only add it when it is not already set
      if child1.values[randomIndex] == -1 and cpP1[randomIndex] and _.indexOf(child1.values, cpP1[randomIndex]) is -1
        child1.values[randomIndex] = cpP1[randomIndex]
        cpP1[randomIndex] = -1
        taken++
    
    # fill the rest from parent2
    for index in [0...cpP1.length]
      if child1.values[index] == -1
        for index2 in [0...cpP2.length]
          if _.indexOf(child1.values, cpP2[index2]) is -1
            child1.values[index] = cpP2[index2]
            cpP2[index2] = -1
            break

    # copy all the rest variables to child 2
    for counter in [0...cpP1.length]
      if cpP1[counter] isnt -1
        child2.values.push cpP1[counter]
        cpP1[counter] = -1
      if cpP2[counter] isnt -1
        child2.values.push cpP2[counter]
        cpP2[counter] = -1
    
    [child1, child2]

  # The cost is the sum of the length of all routes for this solution
  cost: ->
    cost = 0
    for city, index in @values
      # A,B,C: A->B
      if index+1 < @values.length
        cost += distances[city][@values[index+1]]
      else
        # A,B,C: C->A
        cost += distances[city][@values[0]]
    cost

  # Checks if the Genome contains all cities
  # @return [Boolean]
  isValid: ->
    for city in [0..14]
      # if one of the cities is not present, it is not valid
      if _.indexOf(@values, city) is -1
        return false
    true

exports.TSAGenome = TSAGenome

distances = [
  [0, 5, 5, 6, 7, 2, 5, 2, 1, 5, 5, 1, 2, 7, 5]
  [5, 0, 5, 5, 5, 2, 5, 1, 5, 6, 6, 6, 6, 1, 7]
  [5, 5, 0, 6, 1, 6, 5, 5, 1, 6, 5, 7, 1, 5, 6]
  [6, 5, 6, 0, 5, 2, 1, 6, 5, 6, 2, 1, 2, 1, 5]
  [7, 5, 1, 5, 0, 7, 1, 1, 2, 1, 5, 6, 2, 2, 5]
  [2, 2, 6, 2, 7, 0, 5, 5, 6, 5, 2, 5, 1, 2, 5]
  [5, 5, 5, 1, 1, 5, 0, 2, 6, 1, 5, 7, 5, 1, 6]
  [2, 1, 5, 6, 1, 5, 2, 0, 7, 6, 2, 1, 1, 5, 2]
  [1, 5, 1, 5, 2, 6, 6, 7, 0, 5, 5, 5, 1, 6, 6]
  [5, 6, 6, 6, 1, 5, 1, 6, 5, 0, 7, 1, 2, 5, 2]
  [5, 6, 5, 2, 5, 2, 5, 2, 5, 7, 0, 2, 1, 2, 1]
  [1, 6, 7, 1, 6, 5, 7, 1, 5, 1, 2, 0, 5, 6, 5]
  [2, 6, 1, 2, 2, 1, 5, 1, 1, 2, 1, 5, 0, 7, 6]
  [7, 1, 5, 1, 2, 2, 1, 5, 6, 5, 2, 6, 7, 0, 5]
  [5, 7, 6, 5, 5, 5, 6, 2, 6, 2, 1, 5, 6, 5, 0]
]