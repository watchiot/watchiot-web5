(function($) {
    "use strict"; // Start of use strict

    if (window.location.pathname.indexOf('chart') !== -1) {
      $(".nav li").removeClass("active");
      $("#chart").addClass("active");
    }
    else if (window.location.pathname.indexOf('setting') !== -1) {
      $(".nav li").removeClass("active");
      $("#setting").addClass("active");
    }
    else if (window.location.pathname.indexOf('spaces') !== -1) {
      $(".nav li").removeClass("active");
      $("#spaces").addClass("active");
    }
    else {
      $(".nav li").removeClass("active");
      $("#dashboard").addClass("active");
    }

})(jQuery); // End of use strict
