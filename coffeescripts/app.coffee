window.population = new Population()

startButton = document.getElementById 'start-button'
pauseButton = document.getElementById 'pause-button'
resetButton = document.getElementById 'reset-button'
outputList = document.getElementById 'output-list'

generationSize = Number document.getElementById('generation-size').value
populationSize = Number document.getElementById('population-size').value

pauseButton.style.display = 'none'
resetButton.style.display = 'none'

paused = true

results = null

reset = ->
  results = [['Generation', 'Best', 'Worst']]
  generationSize = Number document.getElementById('generation-size').value
  populationSize = Number document.getElementById('population-size').value
  
  window.population = new Population populationSize, generationSize
  
  outputList.innerHTML = ''

  window.population.afterGeneration = ->
    cg = window.population.currentGeneration

    if cg % 3 is 0 or cg is 1 or cg is 2
      newLi = document.createElement('li')
      best = window.population.best().cost()
      worst = window.population.worst().cost()
      newLi.innerHTML = "Generation ##{window.population.currentGeneration}, best: #{best}, worst: #{worst}"
      outputList.appendChild newLi
      results.push [cg, best, worst]

startButton.addEventListener 'click', ->
  this.style.display = 'none'
  pauseButton.style.display = ''
  resetButton.style.display = ''

  reset()

  paused = false
  next()

pauseButton.addEventListener 'click', ->
  paused = true

resetButton.addEventListener 'click', ->
  this.style.display = 'none'
  pauseButton.style.display = 'none'
  startButton.style.display = ''

  paused = true
  
  reset()

drawResults = ->
  data = google.visualization.arrayToDataTable(results)

  options = title: 'Performance'

  chart = new google.visualization.LineChart(document.getElementById('chart'))
  chart.draw(data, options)

next = ->
  if window.population.currentGeneration == generationSize
    drawResults()
    paused = true
    reset()
  if !paused and not (window.population.currentGeneration >= generationSize)
    window.population.nextGeneration()
    setTimeout ->
      next()
    , 1