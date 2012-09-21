# Base class for ranking and creating populations
class Population
  # @property [Array<Genome>] All the genomes of this population
  genomes: []

  # @property [Float] The chance of a Genome to mutate
  mutationChance: .15

  # @property [Boolean] If true, the two best Genomes will survive without mutation or mating
  elitism: true

  # @property [Float] Determines the amount of values to be copied from parents
  mixingRatio: .8

  # @property [Integer] The number of the current genereation
  currentGeneration: 0

  # @property [Integer] The number of participants for the tournament selection
  tournamentParticipants: 4

  # @property [Float] The chance of having a tournament selection
  tournamentChance: .1

  afterGeneration: ->

  # @param [Integer] populationSize The size of the population
  # @param [Integer] maxGenerationCount The maximum number of generations (iterations)
  constructor: (@populationSize = 1000, @maxGenerationCount = 100000) ->
    @genomes.push new Genome() for i in [0...@populationSize]
    @rank()

  # Ranks all genomes according to their cost (lower is better)
  rank: ->
    @genomes = _.sortBy @genomes, (genome) -> genome.cost()

  # @return [Genome] the best Genome in this population
  best: ->
    _.first(@genomes)

  # @return [Genome] the worst Genome in this population
  worst: ->
    _.last(@genomes)

  # Selects a Genome by tournament selection. The amount of participants is defined by
  # @tournamentParticipants.
  # @return [Genome] the Genome which has won the tournamen selection
  tournamentSelect: ->
    participants = []
    # select random participants
    for index in [0..@tournamentParticipants]
      randomIndex = Math.floor @genomes.length * Math.random()
      participants.push @genomes[randomIndex]
    # rank participants
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
      # do a tournament selection
      a = @tournamentSelect()
      b = @tournamentSelect()

      # perform a crossover if the maximum hasn't been reached
      children = a.crossover b, @mixingRatio
      a = children[0]
      b = children[1]

      # mutate the genomes
      a.mutate() if Math.random() < @mutationChance
      b.mutate() if Math.random() < @mutationChance

      # add the new genomes to the next generation
      nextGeneration.push a
      nextGeneration.push b

    @genomes = nextGeneration
    
    @rank()

    @afterGeneration()

window.Population = Population