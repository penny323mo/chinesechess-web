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

  function createDiagonal(x1, y1, x2, y2) {
    const line = document.createElementNS('http://www.w3.org/2000/svg', 'line')
    line.setAttribute('x1', x1)
    line.setAttribute('y1', y1)
    line.setAttribute('x2', x2)
    line.setAttribute('y2', y2)
    line.setAttribute('stroke', '#000')
    line.setAttribute('stroke-width', '1')
    return line
  }

  function addPalaceDiagonals() {
    const palaceTop = { colStart: 3, colEnd: 5, rowStart: 0, rowEnd: 2 }
    const palaceBottom = { colStart: 3, colEnd: 5, rowStart: 7, rowEnd: 9 }

    ;[palaceTop, palaceBottom].forEach((palace) => {
      const { colStart, colEnd, rowStart, rowEnd } = palace
      svg.appendChild(createDiagonal(
        colStart * CELL, rowStart * CELL,
        colEnd * CELL, rowEnd * CELL
      ))
      svg.appendChild(createDiagonal(
        colStart * CELL, rowEnd * CELL,
        colEnd * CELL, rowStart * CELL
      ))
    })
  }

  addPalaceDiagonals()

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
      const col = Math.min(8, Math.max(0, parseInt(e.target.dataset.col)))
      const row = Math.min(9, Math.max(0, parseInt(e.target.dataset.row)))
      console.log(`Clicked: (${col}, ${row})`)
    }
  })

  return svg
}

document.querySelector('#app').innerHTML = ''
document.querySelector('#app').appendChild(createBoard())
