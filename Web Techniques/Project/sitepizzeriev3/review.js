document.addEventListener('DOMContentLoaded', function () {
  let paragrafe = document.querySelectorAll('p');
  for (let p in paragrafe) {
    // let stil = window.getComputedStyle(document.getElementById("debug"));

    //console.log (stil.getPropertyValue("font-size"));
    paragrafe[p].addEventListener('mouseover', addA);
    paragrafe[p].addEventListener('mouseout', removeA);
  }
});
function addA(ev) {
  let p = ev.currentTarget;
  p.classList.add("a");
}
function removeA(ev) {
  let p = ev.currentTarget;
  p.classList.remove("a");
}

window.onload = function () {
  scooter.onclick = function () {
    let start = Date.now();

    let timer = setInterval(function () {
      let timePassed = Date.now() - start;

      scooter.style.left = timePassed / 1.7 + 'px';

      if (timePassed > 2000) clearInterval(timer);

    }, 20);
  }
}