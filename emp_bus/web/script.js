$(document).ready(function() {

    
    $(".botao2").fadeOut(300);
    window.addEventListener("message", function(event) {

        // UPDATE 0.0.2v:
        // CHANGED "IF" TO "SWITCH"

        if (event.data.action == undefined) {return}
            switch (event.data.action) {

            case 'show':
                $('body').css("display", "block")
            break

            case 'hide':
                $("body").css("display", "none")
            break
            }
        
    })


    $(".botao").click(function(){
        $.post("http://emp_bus/botao")
        $(".botao").fadeOut(300);
        $(".botao2").fadeIn(300);
    })

    $(".botao2").click(function(){
        $.post("http://emp_bus/botao2")
        $(".botao2").fadeOut(300);
        $(".botao").fadeIn(300);
    })
});