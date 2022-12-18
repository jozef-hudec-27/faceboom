document.addEventListener('turbo:load', function() {
  let anchor = window.location.hash.slice(1);
  
  if (anchor) {
    let elementToScrollTo = document.getElementById(anchor);

    if (elementToScrollTo) {
      let headerOffset = document.querySelector('.navbar').offsetHeight + 10;
      let elementPosition = elementToScrollTo.getBoundingClientRect().top;
      let offsetPosition = elementPosition + window.pageYOffset - headerOffset;

      window.scrollTo({
          top: offsetPosition,
      });
    }
  }
})
