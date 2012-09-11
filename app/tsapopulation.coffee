{Population} = require 'population'
{TSAGenome} = require 'tsagenome'

class TSAPopulation extends Population
  genomeType: TSAGenome

exports.TSAPopulation = TSAPopulation