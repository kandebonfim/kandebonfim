document.addEventListener("DOMContentLoaded", function() {
  var logo = document.querySelector(".logo");

  logo.addEventListener("click", function( event ) {
    document.body.classList.toggle('blink');
    console.log('ee');
  }, false);
});