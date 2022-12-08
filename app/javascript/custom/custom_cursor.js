const initCursor = () => {
  let cursor = document.querySelector('.cursor');
  let cursorinner = document.querySelector('.cursor2');
  let a = document.querySelectorAll('a');

  document.addEventListener('mousemove', function(e){
    let x = e.clientX;
    let y = e.clientY;
    cursor.style.transform = `translate3d(calc(${e.clientX}px - 50%), calc(${e.clientY}px - 50%), 0)`
  });

  document.addEventListener('mousemove', function(e){
    let x = e.clientX;
    let y = e.clientY;
    cursorinner.style.left = x + 'px';
    cursorinner.style.top = y + 'px';
  });

  document.addEventListener('mousedown', function(){
    cursor.classList.add('click');
    cursorinner.classList.add('cursorinnerhover')
  });

  document.addEventListener('mouseup', function(){
    cursor.classList.remove('click')
    cursorinner.classList.remove('cursorinnerhover')
  });

  a.forEach(item => {
    item.addEventListener('mouseover', () => {
      cursor.classList.add('hover');
    });
    item.addEventListener('mouseleave', () => {
      cursor.classList.remove('hover');
    });
  })
}
export { initCursor }
