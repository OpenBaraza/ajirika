document.addEventListener('DOMContentLoaded', () => {

  const gallery = document.getElementById('launchGallery');
  const leftArrow = document.getElementById('leftArrow');
  const rightArrow = document.getElementById('rightArrow');

  const scrollAmount = 300;
  let currentTranslate = 0;

  function updateArrows() {
    const parentWidth = gallery.parentElement.offsetWidth;
    const maxTranslate = gallery.scrollWidth - parentWidth;

    leftArrow.style.display = currentTranslate <= 0 ? 'none' : 'flex';
    rightArrow.style.display = currentTranslate >= maxTranslate ? 'none' : 'flex';
  }

  function scrollGallery(direction) {
    const parentWidth = gallery.parentElement.offsetWidth;
    const maxTranslate = gallery.scrollWidth - parentWidth;

    currentTranslate += direction * scrollAmount;

    if (currentTranslate < 0) currentTranslate = 0;
    if (currentTranslate > maxTranslate) currentTranslate = maxTranslate;

    gallery.style.transform = `translateX(-${currentTranslate}px)`;
    updateArrows();
  }

  leftArrow.addEventListener('click', () => scrollGallery(-1));
  rightArrow.addEventListener('click', () => scrollGallery(1));

  window.addEventListener('load', updateArrows);
  window.addEventListener('resize', () => {
    currentTranslate = 0;
    gallery.style.transform = 'translateX(0)';
    updateArrows();
  });


  const lightbox = document.getElementById('lightbox');
  const lightboxImage = document.getElementById('lightboxImage');
  const lightboxLeft = document.getElementById('lightboxLeft');
  const lightboxRight = document.getElementById('lightboxRight');
  const lightboxClose = document.querySelector('#lightbox button[onclick="closeLightbox()"]');

  const carouselImages = Array.from(document.querySelectorAll('#launchGallery img'));
  let currentIndex = 0;

  // Open lightbox
  function openLightbox(index) {
    currentIndex = index;
    lightboxImage.src = carouselImages[currentIndex].src;
    lightbox.classList.remove('hidden');
    updateLightboxArrows();
  }

  // Close lightbox
  function closeLightbox() {
    lightbox.classList.add('hidden');
  }

  // Navigate lightbox
  function lightboxNavigate(direction) {
    currentIndex += direction;
    if (currentIndex < 0) currentIndex = 0;
    if (currentIndex >= carouselImages.length) currentIndex = carouselImages.length - 1;

    lightboxImage.src = carouselImages[currentIndex].src;
    updateLightboxArrows();
  }

  // Show/hide arrows
  function updateLightboxArrows() {
    lightboxLeft.style.display = currentIndex > 0 ? 'flex' : 'none';
    lightboxRight.style.display = currentIndex < carouselImages.length - 1 ? 'flex' : 'none';
  }

  // Attach event listeners
  lightboxLeft.addEventListener('click', () => lightboxNavigate(-1));
  lightboxRight.addEventListener('click', () => lightboxNavigate(1));
  lightboxClose.addEventListener('click', closeLightbox);

  // Click outside image closes lightbox
  lightbox.addEventListener('click', (e) => {
    if (e.target.id === 'lightbox') closeLightbox();
  });

  // Keyboard navigation
  document.addEventListener('keydown', (e) => {
    if (!lightbox.classList.contains('hidden')) {
      if (e.key === 'ArrowLeft') lightboxNavigate(-1);
      if (e.key === 'ArrowRight') lightboxNavigate(1);
      if (e.key === 'Escape') closeLightbox();
    }
  });

  // Make carousel images clickable
  carouselImages.forEach((img, i) => {
    img.style.cursor = 'pointer';
    img.addEventListener('click', () => openLightbox(i));
  });

});
