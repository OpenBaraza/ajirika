
const signupModal = document.getElementById('signupModal');

const openLoginBtn = document.getElementById('openLoginPage');
if (openLoginBtn) {
  openLoginBtn.addEventListener('click', () => {
    console.log('Redirecting to login.jsp');
    window.location.href = 'profile.jsp';
  });
}

const openSignupBtn = document.getElementById('openSignupModal');
if (openSignupBtn && signupModal) {
  openSignupBtn.addEventListener('click', () => {
    console.log('Opening signup modal');
    signupModal.classList.remove('hidden');
  });
}

const closeSignupBtn = document.getElementById('closeSignup');
if (closeSignupBtn && signupModal) {
  closeSignupBtn.addEventListener('click', () => {
    signupModal.classList.add('hidden');
  });
}

const openLoginFromSignup = document.getElementById('openLoginFromSignup');
if (openLoginFromSignup) {
  openLoginFromSignup.addEventListener('click', (e) => {
    e.preventDefault();
    console.log('Going to login page from signup modal');
    window.location.href = 'profile.jsp';
  });
}

if (signupModal) {
  signupModal.addEventListener('click', (e) => {
    if (e.target === signupModal) {
      signupModal.classList.add('hidden');
    }
  });
}
