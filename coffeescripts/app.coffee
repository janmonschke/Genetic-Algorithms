window.population = new Population()

startButton = document.getElementById 'start-button'
pauseButton = document.getElementById 'pause-button'
resetButton = document.getElementById 'reset-button'

pauseButton.style.display = 'none'
resetButton.style.display = 'none'

startButton.addEventListener 'click', ->
  this.style.display = 'none'
  pauseButton.style.display = ''
  resetButton.style.display = ''

pauseButton.addEventListener 'click', ->


resetButton.addEventListener 'click', ->
  this.style.display = 'none'
  pauseButton.style.display = 'none'
  startButton.style.display = ''

  window.population = new Population()