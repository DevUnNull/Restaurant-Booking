/**
 * Theme Manager - Quản lý Dark/Light mode cho toàn bộ ứng dụng
 * Lưu preference vào localStorage
 */

// Load saved theme ngay lập tức (trước khi DOM load) để tránh flash
(function() {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'light') {
        document.documentElement.classList.add('light-mode');
        document.body.classList.add('light-mode');
    }
})();

// Theme toggle function
function toggleTheme() {
    const html = document.documentElement;
    const body = document.body;
    const themeIcon = document.getElementById('themeIcon');
    const themeText = document.getElementById('themeText');

    html.classList.toggle('light-mode');
    body.classList.toggle('light-mode');

    if (body.classList.contains('light-mode')) {
        if (themeIcon) themeIcon.className = 'fas fa-sun';
        if (themeText) themeText.textContent = 'Chế độ sáng';
        localStorage.setItem('theme', 'light');
    } else {
        if (themeIcon) themeIcon.className = 'fas fa-moon';
        if (themeText) themeText.textContent = 'Chế độ tối';
        localStorage.setItem('theme', 'dark');
    }
}

// Initialize theme on page load
window.addEventListener('DOMContentLoaded', function() {
    const savedTheme = localStorage.getItem('theme');
    const html = document.documentElement;
    const body = document.body;
    const themeIcon = document.getElementById('themeIcon');
    const themeText = document.getElementById('themeText');

    if (savedTheme === 'light') {
        html.classList.add('light-mode');
        body.classList.add('light-mode');
        if (themeIcon) themeIcon.className = 'fas fa-sun';
        if (themeText) themeText.textContent = 'Chế độ sáng';
    } else {
        if (themeIcon) themeIcon.className = 'fas fa-moon';
        if (themeText) themeText.textContent = 'Chế độ tối';
    }
});

