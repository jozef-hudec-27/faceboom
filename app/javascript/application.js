// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "channels";

// Custom JS to make top searchbar work
document.addEventListener('turbo:load', () => {
  let searchFaceboomInput = document.getElementById('search-faceboom-input');

  if (searchFaceboomInput) {
    searchFaceboomInput.value = new URLSearchParams(window.location.search).get('q');
    
    document.addEventListener('keydown', e => {
      if (e.code == 'Enter' && document.activeElement == searchFaceboomInput) {
          window.location.href = '/users/?q=' + searchFaceboomInput.value;
      };
    });
  };
});
