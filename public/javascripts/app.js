(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, localRequire(name), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var require = function(name) {
    var path = expand(name, '.');

    if (has(cache, path)) return cache[path];
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex];
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '"');
  };

  var define = function(bundle) {
    for (var key in bundle) {
      if (has(bundle, key)) {
        modules[key] = bundle[key];
      }
    }
  }

  globals.require = require;
  globals.require.define = define;
  globals.require.brunch = true;
})();

window.require.define({"application": function(exports, require, module) {
  

  
}});

window.require.define({"genome": function(exports, require, module) {
  var Genome;

  Genome = (function() {

    Genome.prototype.values = [];

    function Genome(values) {
      this.values = values != null ? values : this.initial();
    }

    Genome.prototype.compare = function(genome) {
      var costThat, costThis;
      costThis = this.cost();
      costThat = genome.cost();
      if (costThis === costThat) {
        return 0;
      } else if (costThis < costThat) {
        return 1;
      } else {
        return -1;
      }
    };

    Genome.prototype.initial = function() {
      return [];
    };

    Genome.prototype.mutate = function() {};

    Genome.prototype.crossover = function(genome) {
      return [this, genome];
    };

    Genome.prototype.cost = function() {
      return 1;
    };

    return Genome;

  })();

  exports.Genome = Genome;
  
}});

window.require.define({"initialize": function(exports, require, module) {
  var TSAPopulation;

  TSAPopulation = require('tsapopulation').TSAPopulation;

  window.population = new TSAPopulation();
  
}});

window.require.define({"population": function(exports, require, module) {
  var Genome, Population;

  Genome = require('genome').Genome;

  Population = (function() {

    Population.prototype.mutationChance = .1;

    Population.prototype.crossoverChance = .8;

    Population.prototype.elitism = true;

    Population.prototype.mixingRatio = .7;

    Population.prototype.genomeType = Genome;

    Population.prototype.genomes = [];

    Population.prototype.currentGeneration = 1;

    function Population(populationSize, maxGenerationCount) {
      var i, _i, _ref;
      this.populationSize = populationSize != null ? populationSize : 1000;
      this.maxGenerationCount = maxGenerationCount != null ? maxGenerationCount : 100000;
      for (i = _i = 0, _ref = this.populationSize; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.genomes.push(new this.genomeType());
      }
      this.rank();
    }

    Population.prototype.rank = function() {
      return this.genomes = _.sortBy(this.genomes, function(genome) {
        return genome.cost();
      });
    };

    Population.prototype.best = function() {
      return _.first(this.genomes);
    };

    Population.prototype.worst = function() {
      return _.last(this.genomes);
    };

    Population.prototype.nextGeneration = function() {
      var a, b, children, index, nextGeneration, skip, _i, _ref;
      nextGeneration = [];
      skip = 0;
      this.currentGeneration++;
      if (this.elitism) {
        nextGeneration.push(new this.genomeType(this.genomes[0].values));
        nextGeneration.push(new this.genomeType(this.genomes[1].values));
        skip = 2;
      }
      for (index = _i = 0, _ref = this.genomes.length - skip; _i < _ref; index = _i += 2) {
        a = this.genomes[index];
        b = this.genomes[index + 1];
        if (Math.random() <= this.crossoverChance) {
          children = a.crossover(b, this.mixingRatio);
          nextGeneration.push(children[0]);
          nextGeneration.push(children[1]);
        } else {
          if (Math.random() < this.mutationChance) {
            a.mutate();
          }
          if (Math.random() < this.mutationChance) {
            b.mutate();
          }
          nextGeneration.push(new this.genomeType(a.values));
          nextGeneration.push(new this.genomeType(b.values));
        }
      }
      this.genomes = nextGeneration;
      return this.rank();
    };

    return Population;

  })();

  exports.Population = Population;
  
}});

window.require.define({"tsagenome": function(exports, require, module) {
  var Genome, TSAGenome, distances,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Genome = require('genome').Genome;

  TSAGenome = (function(_super) {

    __extends(TSAGenome, _super);

    function TSAGenome() {
      return TSAGenome.__super__.constructor.apply(this, arguments);
    }

    TSAGenome.prototype.getRandomIndex = function(array) {
      return Math.floor(array.length * Math.random());
    };

    TSAGenome.prototype.initial = function() {
      var length, possibleCities, randomIndex, values;
      possibleCities = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
      length = possibleCities.length;
      values = [];
      while (values.length < length) {
        randomIndex = this.getRandomIndex(possibleCities);
        values.push(possibleCities[randomIndex]);
        possibleCities[randomIndex] = null;
        possibleCities = _.compact(possibleCities);
      }
      values = _.map(values, function(num) {
        return --num;
      });
      return values;
    };

    TSAGenome.prototype.mutate = function() {
      var buff, indexA, indexB;
      indexA = this.getRandomIndex(this.values);
      indexB = this.getRandomIndex(this.values);
      buff = this.values[indexA];
      this.values[indexA] = this.values[indexB];
      return this.values[indexB] = buff;
    };

    TSAGenome.prototype.crossover = function(genome, mixingRatio) {
      var amount, child1, child2, counter, cpP1, cpP2, index, index2, randomIndex, taken, _i, _j, _k, _ref, _ref1, _ref2;
      cpP1 = _.clone(this.values);
      cpP2 = _.clone(genome.values);
      child1 = new TSAGenome([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]);
      child2 = new TSAGenome([]);
      taken = 0;
      amount = this.values.length;
      while ((taken / amount) < mixingRatio) {
        randomIndex = Math.floor(Math.random() * amount);
        if (child1.values[randomIndex] === -1 && cpP1[randomIndex] && _.indexOf(child1.values, cpP1[randomIndex]) === -1) {
          child1.values[randomIndex] = cpP1[randomIndex];
          cpP1[randomIndex] = -1;
          taken++;
        }
      }
      for (index = _i = 0, _ref = cpP1.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
        if (child1.values[index] === -1) {
          for (index2 = _j = 0, _ref1 = cpP2.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; index2 = 0 <= _ref1 ? ++_j : --_j) {
            if (_.indexOf(child1.values, cpP2[index2]) === -1) {
              child1.values[index] = cpP2[index2];
              cpP2[index2] = -1;
              break;
            }
          }
        }
      }
      for (counter = _k = 0, _ref2 = cpP1.length; 0 <= _ref2 ? _k < _ref2 : _k > _ref2; counter = 0 <= _ref2 ? ++_k : --_k) {
        if (cpP1[counter] !== -1) {
          child2.values.push(cpP1[counter]);
          cpP1[counter] = -1;
        }
        if (cpP2[counter] !== -1) {
          child2.values.push(cpP2[counter]);
          cpP2[counter] = -1;
        }
      }
      return [child1, child2];
    };

    TSAGenome.prototype.cost = function() {
      var city, cost, index, _i, _len, _ref;
      cost = 0;
      _ref = this.values;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        city = _ref[index];
        if (index + 1 < this.values.length) {
          cost += distances[city][this.values[index + 1]];
        } else {
          cost += distances[city][this.values[0]];
        }
      }
      return cost;
    };

    TSAGenome.prototype.isValid = function() {
      var city, _i;
      for (city = _i = 0; _i <= 14; city = ++_i) {
        if (_.indexOf(this.values, city) === -1) {
          return false;
        }
      }
      return true;
    };

    return TSAGenome;

  })(Genome);

  exports.TSAGenome = TSAGenome;

  distances = [[0, 5, 5, 6, 7, 2, 5, 2, 1, 5, 5, 1, 2, 7, 5], [5, 0, 5, 5, 5, 2, 5, 1, 5, 6, 6, 6, 6, 1, 7], [5, 5, 0, 6, 1, 6, 5, 5, 1, 6, 5, 7, 1, 5, 6], [6, 5, 6, 0, 5, 2, 1, 6, 5, 6, 2, 1, 2, 1, 5], [7, 5, 1, 5, 0, 7, 1, 1, 2, 1, 5, 6, 2, 2, 5], [2, 2, 6, 2, 7, 0, 5, 5, 6, 5, 2, 5, 1, 2, 5], [5, 5, 5, 1, 1, 5, 0, 2, 6, 1, 5, 7, 5, 1, 6], [2, 1, 5, 6, 1, 5, 2, 0, 7, 6, 2, 1, 1, 5, 2], [1, 5, 1, 5, 2, 6, 6, 7, 0, 5, 5, 5, 1, 6, 6], [5, 6, 6, 6, 1, 5, 1, 6, 5, 0, 7, 1, 2, 5, 2], [5, 6, 5, 2, 5, 2, 5, 2, 5, 7, 0, 2, 1, 2, 1], [1, 6, 7, 1, 6, 5, 7, 1, 5, 1, 2, 0, 5, 6, 5], [2, 6, 1, 2, 2, 1, 5, 1, 1, 2, 1, 5, 0, 7, 6], [7, 1, 5, 1, 2, 2, 1, 5, 6, 5, 2, 6, 7, 0, 5], [5, 7, 6, 5, 5, 5, 6, 2, 6, 2, 1, 5, 6, 5, 0]];
  
}});

window.require.define({"tsapopulation": function(exports, require, module) {
  var Population, TSAGenome, TSAPopulation,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Population = require('population').Population;

  TSAGenome = require('tsagenome').TSAGenome;

  TSAPopulation = (function(_super) {

    __extends(TSAPopulation, _super);

    function TSAPopulation() {
      return TSAPopulation.__super__.constructor.apply(this, arguments);
    }

    TSAPopulation.prototype.genomeType = TSAGenome;

    return TSAPopulation;

  })(Population);

  exports.TSAPopulation = TSAPopulation;
  
}});

