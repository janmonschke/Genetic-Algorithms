{Genome} = require 'genome'

# Base class for ranking and creating populations
class Population

  # @property [Float] The chance of a Genome to mutate
  mutationChance: .1

  # @property [Float] The chance of a crossover
  crossoverChance: .8

  # @property [Boolean] If true, the two best Genomes will survive without mutation or mating
  elitism: true

  # @property [Float] Determines the amount of values to be copied from parents
  mixingRatio: .7

  # 
  genomeType: Genome

  # @property [Array<Genome>] All the genomes of this population
  genomes: []

  currentGeneration: 1

  # @param [Integer] populationSize The size of the population
  # @param [Integer] maxGenerationCount The maximum number of generations (iterations)
  constructor: (@populationSize = 1000, @maxGenerationCount = 100000) ->
    @genomes.push new @genomeType() for i in [0...@populationSize]
    @rank()

  # Ranks all genomes according to their cost (lower is better)
  rank: ->
    @genomes = _.sortBy @genomes, (genome) -> genome.cost()

  best: ->
    _.first(@genomes)

  worst: ->
    _.last(@genomes)

  # Creates the next generation
  nextGeneration: ->
    nextGeneration = []
    skip = 0
    @currentGeneration++
    
    # the fittest two survive
    if @elitism
      nextGeneration.push new @genomeType @genomes[0].values
      nextGeneration.push new @genomeType @genomes[1].values
      skip = 2

    for index in [0...@genomes.length-skip] by 2
      a = @genomes[index]
      b = @genomes[index+1]

      if Math.random() <= @crossoverChance
        children = a.crossover b, @mixingRatio
        nextGeneration.push children[0]
        nextGeneration.push children[1]
      else
        a.mutate() if Math.random() < @mutationChance
        b.mutate() if Math.random() < @mutationChance

        nextGeneration.push new @genomeType a.values
        nextGeneration.push new @genomeType b.values

    @genomes = nextGeneration
    
    @rank()

exports.Population = Population