document.addEventListener('keydown', e => {
  if (e.code == 'Enter' && document.activeElement == document.getElementById('search-faceboom-input')) {
      window.location.href = '/users/?q=' + document.getElementById('search-faceboom-input').value;
  }
});

document.getElementById('search-faceboom-input').value = new URLSearchParams(window.location.search).get('q');
