<!-- Registration Modal -->
<div id="registrationModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
    <div class="modal-content bg-white rounded-xl shadow-2xl w-full max-w-md p-6 relative animate-fadeIn">
        <button id="closeModal" class="absolute top-4 right-4 text-gray-500 hover:text-gray-700 text-2xl font-bold">
            &times;
        </button>
        <h3 class="text-2xl font-bold text-center text-gray-800 mb-6">Event Registration</h3>
        <form id="registrationForm">
            <div class="mb-5">
                <label for="fullName" class="block text-gray-700 font-medium mb-2">Full Name</label>
                <input 
                    type="text" 
                    id="fullName" 
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition" 
                    placeholder="Enter your full name" 
                    required
                >
            </div>
            <div class="mb-5">
                <label for="email" class="block text-gray-700 font-medium mb-2">Email Address</label>
                <input 
                    type="email" 
                    id="email" 
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition" 
                    placeholder="Enter your email" 
                    required
                >
            </div>
            <div class="mb-6">
                <label for="phone" class="block text-gray-700 font-medium mb-2">Phone Number</label>
                <input 
                    type="tel" 
                    id="phone" 
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition" 
                    placeholder="Enter your phone number" 
                    required
                >
            </div>
            <button 
                type="submit" 
                class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-lg transition duration-300 shadow-md"
            >
                Register Now
            </button>
        </form>
    </div>
</div>