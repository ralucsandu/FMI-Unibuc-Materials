const canvas = document.getElementById('canvas1');
const ctx = canvas.getContext('2d');
canvas.width = 600;
canvas.height = 400;

var buton1 = document.getElementById("first");
var button2 = document.getElementById("again");
let spacePressed = false;
let angle = 0;
let hue = 0;
let frame = 0;
let score = 0;
let gamespeed = 2;

const gradient = ctx.createLinearGradient(0, 0, 0, 50);
gradient.addColorStop('0.4', '#ff3300');
gradient.addColorStop('0.6', '#99ff99');

const background = new Image();
background.src = 'fundallemn.png';
const BG = {
  x1: 0,
  x2: canvas.width,
  y: 0,
  width: canvas.width,
  height: canvas.height
}

function handleBackground() {
  if (BG.x1 <= -BG.width + gamespeed) BG.x1 = BG.width;
  else BG.x1 -= gamespeed;
  if (BG.x2 <= -BG.width + gamespeed) BG.x2 = BG.width;
  else BG.x2 -= gamespeed;
  ctx.drawImage(background, BG.x1, BG.y, BG.width, BG.height);
  ctx.drawImage(background, BG.x2, BG.y, BG.width, BG.height);
}

function animate() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  handleBackground();
  handleObstacles();
  handleParticles();
  bird.update();
  bird.draw();
  ctx.fillStyle = gradient;
  ctx.font = '70px Times New Roman';
  ctx.strokeText(score, 450, 70);
  ctx.fillText(score, 450, 70);
  handleCollisions();
  if (handleCollisions()) return;
  requestAnimationFrame(animate);
  angle += 0.12;
  hue++;
  frame++;
}
animate();

window.addEventListener('keydown', function (e) {
  if (e.code === 'Space') spacePressed = true;
});

window.addEventListener('keyup', function (e) {
  if (e.code === 'Space') spacePressed = false;
  bird.frameX = 0;
});

const bang = new Image()
bang.src = 'bang.png';
function handleCollisions() {
  for (let i = 0; i < obstaclesArray.length; i++) {
    if (bird.x < obstaclesArray[i].x + obstaclesArray[i].width && bird.x + bird.width > obstaclesArray[i].x
      && ((bird.y < 0 + obstaclesArray[i].top && bird.y + bird.height > 0) ||
        (bird.y > canvas.height - obstaclesArray[i].bottom &&
          bird.y + bird.height < canvas.height))) {
      //coliziune detectata
      ctx.drawImage(bang, bird.x, bird.y, 50, 50);
      ctx.font = "18px Times New Roman";
      ctx.fillStyle = 'white';
      if (score < 10)
        ctx.fillText('Jocul s-a terminat, scorul dumneavoastra este ' + score, 120, canvas.height / 2);
      else if (score >= 10 && score < 20)
        ctx.fillText('Felicitari! Ati castigat o doza de Pepsi!', 160, canvas.height / 2 - 10);
      else
        ctx.fillText('Felicitari! Ati castigat o pizza Ulala!', 160, canvas.height / 2 - 10);
      return true;
    }
  }
}