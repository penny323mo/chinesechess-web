import './style.css'

const COLS = 9
const ROWS = 10
const CELL = 50
const WIDTH = COLS * CELL
const HEIGHT = ROWS * CELL

function createBoard() {
  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg')
  svg.setAttribute('width', WIDTH)
  svg.setAttribute('height', HEIGHT)
  svg.setAttribute('viewBox', `0 0 ${WIDTH} ${HEIGHT}`)
  svg.style.background = '#f5deb3'

  for (let row = 0; row < ROWS; row++) {
    for (let col = 0; col < COLS; col++) {
      const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect')
      rect.setAttribute('x', col * CELL)
      rect.setAttribute('y', row * CELL)
      rect.setAttribute('width', CELL)
      rect.setAttribute('height', CELL)
      rect.setAttribute('fill', 'none')
      rect.setAttribute('stroke', '#000')
      rect.setAttribute('stroke-width', '1')
      rect.dataset.col = col
      rect.dataset.row = row
      svg.appendChild(rect)
    }
  }

  const riverText = document.createElementNS('http://www.w3.org/2000/svg', 'text')
  riverText.setAttribute('x', WIDTH / 2)
  riverText.setAttribute('y', (4.5 + 0.5) * CELL)
  riverText.setAttribute('text-anchor', 'middle')
  riverText.setAttribute('dominant-baseline', 'middle')
  riverText.setAttribute('font-size', '24')
  riverText.setAttribute('fill', '#000')
  riverText.textContent = '楚河  漢界'
  svg.appendChild(riverText)

  svg.addEventListener('click', (e) => {
    if (e.target.tagName === 'rect') {
      const col = parseInt(e.target.dataset.col)
      const row = parseInt(e.target.dataset.row)
      console.log(`Clicked: (${col}, ${row})`)
    }
  })

  return svg
}

document.querySelector('#app').innerHTML = ''
document.querySelector('#app').appendChild(createBoard())
