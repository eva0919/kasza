$(function(){
  $('#container').alive(masonry({
    // options
    itemSelector : '.item',
    columnWidth : 320,
    isAnimated: true
  });
  );
});