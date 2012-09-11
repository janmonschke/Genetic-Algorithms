# Base class for a Genome.
# 
# Genomes are able to mate and mutate. 
# They contain the logic to get a so called cost which is needed to compare
# a Population.
class Genome

  # @property [Array] This genome's values
  values: []

  # If no values are given, it defaults to `@initial()`
  constructor: (@values = @initial()) ->

  # Compares this genome to the given genome.
  # Comparison is based on cost and therefore a lower cost is better.
  # @param [Genome] genome The genome you want to compare to this one
  # @return [Integer] Returns 1 if this one is better, -1 if the other one is better or 0 when they're the same
  # when they have the same cost
  compare: (genome) ->
    costThis = @cost()
    costThat = genome.cost()
    if costThis is costThat
      0
    else if costThis < costThat
      1
    else
      -1

  # Creates the initial set of values
  initial: ->
    []

  # Mutate this genome
  mutate: ->

  # Perform a crossover on this genome with the the given genome
  # Crossover means that both solutions are being mixed together.
  # @param [Genome] genome to perform a crossover with
  # @return [Array<Genome>] the resulting Genomes
  crossover: (genome) ->
    [@, genome]

  # The cost function is used to compare genomes. The cost is described as a measure of how optimal a
  # Genome is. Sometimes this function also called `fitness` function.
  #
  # @return [Integer] the cost for this genome
  cost: ->
    1

exports.Genome = Genome