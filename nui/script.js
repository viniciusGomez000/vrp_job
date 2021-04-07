$(() => {
    
    $("body").hide()
    window.addEventListener("message", function(event) {
        if (event.data.mostre != undefined) {
            let status = event.data.mostre
            if (status) {
                $("body").show()
            } else {
                $("body").hide()
            }
        }
    })


    $(".botao").click(function(){
        $.post("http://vrp_job/botao")
    })

    $(".botao2").click(function(){
        $.post("http://vrp_job/botao2")
    })
})