{Genome} = require 'genome'

# Base class for ranking and creating populations
class Population

  # @property [Float] The chance of a Genome to mutate
  mutationChance: .1

  # @property [Float] The rate of genes being crossovered
  crossoverRate: .45

  # @property [Boolean] If true, the two best Genomes will survive without mutation or mating
  elitism: true

  # @property [Float] Determines the amount of values to be copied from parents
  mixingRatio: .7

  # @property [Array<Genome>] All the genomes of this population
  genomes: []

  # @property [Integer] The number of the current genereation
  currentGeneration: 1

  # @property [Integer] The number of participants for the tournament selection
  tournamentParticipants: 3

  # @property [Float] The chance of having a tournament selection
  tournamentChance: .1

  # @param [Integer] populationSize The size of the population
  # @param [Integer] maxGenerationCount The maximum number of generations (iterations)
  constructor: (@populationSize = 1000, @maxGenerationCount = 100000) ->
    @genomes.push new Genome() for i in [0...@populationSize]
    @rank()

  # Ranks all genomes according to their cost (lower is better)
  rank: ->
    @genomes = _.sortBy @genomes, (genome) -> genome.cost()

  best: ->
    _.first(@genomes)

  worst: ->
    _.last(@genomes)

  tournamentSelect: ->
    participants = []
    for index in [0..@tournamentParticipants]
      randomIndex = Math.floor @genomes.length * Math.random()
      participants.push @genomes[randomIndex]
    participants = _.sortBy participants, (genome) -> genome.cost()
    participants[0]

  # Creates the next generation
  nextGeneration: ->
    nextGeneration = []
    skip = 0
    @currentGeneration++
    
    # the fittest two survive
    if @elitism
      nextGeneration.push new Genome @genomes[0].values
      nextGeneration.push new Genome @genomes[1].values
      skip = 2

    for index in [0...@genomes.length-skip] by 2
      # simply select two solutions that are next to each other
      a = @genomes[index]
      b = @genomes[index + 1]

      # perform a crossover if the maximum hasn't been reached
      if index / @populationSize <= @crossoverRate
        children = a.crossover b, @mixingRatio
        a = children[0]
        b = children[1]
      else
        # Perform a tournament selection to have some spread
        if Math.random() < @tournamentChance
          a = @tournamentSelect()
          b = @tournamentSelect()

      # mutate the genomes
      a.mutate() if Math.random() < @mutationChance
      b.mutate() if Math.random() < @mutationChance

      # add the new genomes to the next generation
      nextGeneration.push a
      nextGeneration.push b

    @genomes = nextGeneration
    
    @rank()

exports.Population = Population