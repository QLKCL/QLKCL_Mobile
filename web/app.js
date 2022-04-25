// file: /web/app.js
function sendNavigation(location) {
    // Replace UA-XXXXXXXXX-X with Google Analytics ID
    gtag('config', 'UA-195998067-1', { page_path: location });
}