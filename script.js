const video = document.getElementById('zoomVideo');
const container = document.getElementById('videoContainer');
const slider = document.getElementById('zoomSlider');
const playBtn = document.getElementById('playBtn');
const pauseBtn = document.getElementById('pauseBtn');

let scale = 1.0;
let isDragging = false;
let origin = { x: 0, y: 0 };
let offset = { x: 0, y: 0 };
let moved = false;  // ← nuovo flag per distinguere drag da click

function updateTransform() {
  video.style.transform = `translate(calc(-50% + ${offset.x}px), calc(-50% + ${offset.y}px)) scale(${scale})`;
}

slider.oninput = () => {
  scale = parseFloat(slider.value);
  updateTransform();
};

// Mouse pan
container.addEventListener('mousedown', e => {
  isDragging = true;
  moved = false;
  container.style.cursor = "grabbing";
  origin = { x: e.clientX - offset.x, y: e.clientY - offset.y };
});

window.addEventListener('mousemove', e => {
  if (!isDragging) return;
  const dx = e.clientX - origin.x;
  const dy = e.clientY - origin.y;
  if (Math.abs(dx) > 2 || Math.abs(dy) > 2) moved = true;
  offset = { x: dx, y: dy };
  updateTransform();
});

window.addEventListener('mouseup', e => {
  if (isDragging && moved) {
    e.preventDefault();  // ← blocca il click solo se è stato un drag reale
    e.stopPropagation();
  }
  isDragging = false;
  container.style.cursor = "grab";
});

// Touch pan
container.addEventListener('touchstart', e => {
  if (e.touches.length === 1) {
    isDragging = true;
    moved = false;
    origin = {
      x: e.touches[0].clientX - offset.x,
      y: e.touches[0].clientY - offset.y
    };
  }
});

container.addEventListener('touchmove', e => {
  if (!isDragging || e.touches.length !== 1) return;
  const dx = e.touches[0].clientX - origin.x;
  const dy = e.touches[0].clientY - origin.y;
  if (Math.abs(dx) > 2 || Math.abs(dy) > 2) moved = true;
  offset = { x: dx, y: dy };
  updateTransform();
});

container.addEventListener('touchend', e => {
  isDragging = false;
});

// Disattiva play/pause del video su click se era un drag
video.addEventListener('click', e => {
  if (moved) {
    e.preventDefault();
    e.stopPropagation();
  }
});

playBtn.addEventListener('click', () => video.play());
pauseBtn.addEventListener('click', () => video.pause());

// Init
slider.value = scale;
updateTransform();
