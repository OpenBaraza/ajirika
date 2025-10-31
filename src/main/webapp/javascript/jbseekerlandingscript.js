const loginModal = document.getElementById('loginModal');
const signupModal = document.getElementById('signupModal');

document.getElementById('openLoginModal').addEventListener('click', () => loginModal.classList.remove('hidden'));
document.getElementById('openSignupModal').addEventListener('click', () => signupModal.classList.remove('hidden'));

document.getElementById('closeLogin').addEventListener('click', () => loginModal.classList.add('hidden'));
document.getElementById('closeSignup').addEventListener('click', () => signupModal.classList.add('hidden'));

document.getElementById('openSignupFromLogin').addEventListener('click', (e) => {
  e.preventDefault();
  loginModal.classList.add('hidden');
  signupModal.classList.remove('hidden');
});

document.getElementById('openLoginFromSignup').addEventListener('click', (e) => {
  e.preventDefault();
  signupModal.classList.add('hidden');
  loginModal.classList.remove('hidden');
});

// Close when clicking outside modal
[loginModal, signupModal].forEach(modal => {
  modal.addEventListener('click', (e) => {
    if (e.target === modal) modal.classList.add('hidden');
  });
});