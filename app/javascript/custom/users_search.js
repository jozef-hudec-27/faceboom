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
