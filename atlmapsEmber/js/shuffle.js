
var shuffle = {
  click: function(elem){
    var $elem = $(elem),
        $items = $(".shuffle-items li.item"),
        len = $items.length,
        zIndex = 5;
    $items.addClass("collapsed");
    $items.each(function(i){
      var z = parseInt( zIndex + parseInt(len) - parseInt(i) );
      $(this).css("z-index", z)
    });
    $elem.removeClass('collapsed').css("z-index", zIndex + parseInt(len)).css("top",0);
    var offset = $elem.height()+$(".shuffle-items li.item.collapsed").first().height()-5
    $(".shuffle-items li.item.collapsed").css("top",offset);
  },
  init: function(){
    var $items = $(".shuffle-items li.item"),
    len = $items.length,
    zIndex = 5;
    $items.each(function(i){
      var z = parseInt( zIndex + parseInt(len) - parseInt(i) );
      $(this).css("z-index", z)
    });
    $items.addClass("collapsed");
    $items.first().removeClass("collapsed");
    var offset = $items.not(".collapsed").height()+$(".shuffle-items li.item.collapsed").first().height()-5;
    $(".shuffle-items li.item.collapsed").css("top",offset);
    
    function set_position(){
      var $items = $(".shuffle-items li.item"),
      len = $items.length,
      zIndex = 5;
      $items.each(function(i){
        var z = parseInt( zIndex + parseInt(len) - parseInt(i) );
        $(this).css("z-index", z)
      });
      $items.not(".collapsed").css("z-index", zIndex + parseInt(len)).css("top",offset);
      var offset = $items.not(".collapsed").height()+$(".shuffle-items li.item.collapsed").first().height()-5;
      $(".shuffle-items li.item.collapsed").css("top",offset);
    }
    
    var rtime = new Date(1, 1, 2000, 12,00,00);
    var timeout = false;
    var delta = 200;
    $(window).resize(function() {
      rtime = new Date();
      if (timeout === false) {
        timeout = true;
        setTimeout(resizeend, delta);
      }
    });
    
    function resizeend() {
      if (new Date() - rtime < delta) {
        setTimeout(resizeend, delta);
      } else {
        timeout = false;
        set_position();
      }               
    }
  }
}
