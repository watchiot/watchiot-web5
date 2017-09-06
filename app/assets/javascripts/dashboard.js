(function($) {
    "use strict"; // Start of use strict

    $(".nav a").on("click", function(){
       $(".nav").find(".active").removeClass("active");
       $(this).parent().parent().addClass("active");
    });
})(jQuery); // End of use strict
