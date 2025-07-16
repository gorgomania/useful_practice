//= require jquery

$(document).ready(function() {
    var input_focus = 1, input_hover = 1;
    //Эффект для поля поиска хедера
    $('#search_input').focus(function () {
        $('#search_input').css("background", 'white')
        $('#search_input').css("box-shadow", '0 0 0 1px #0000000a,0 4px 4px #0000000a,0 20px 40px #00000014')
        input_focus = 0
    })
    //Эффект для поля поиска хедера
    $('#search_input').blur(function () {
        input_focus = 1
        if (input_hover) {
            $('#search_input').css("background", '#f2f2f2')
            $('#search_input').css("box-shadow", 'none')
        }
    })
    //Эффект для поля поиска хедера
    $('#search_input').mouseenter(function () {
        $('#search_input').css("background", 'white')
        $('#search_input').css("box-shadow", '0 0 0 1px #0000000a,0 4px 4px #0000000a,0 20px 40px #00000014')
        input_hover = 0
    })
    //Эффект для поля поиска хедера
    $('#search_input').mouseleave(function () {
        input_hover = 1
        if (input_focus) {
            $('#search_input').css("background", '#f2f2f2')
            $('#search_input').css("box-shadow", 'none')
        }
    })
    //Эффект для поля поиска хедера
    $('.search_img').mouseenter(function () {
        $('#search_input').css("background", 'white')
        $('#search_input').css("box-shadow", '0 0 0 1px #0000000a,0 4px 4px #0000000a,0 20px 40px #00000014')
    })

    //Прыжок label поля перед рендером, если в нём имеется текст
    $('.auth_input').each(function() {
        if (this.value) {
            label = $(this).prev();
            label.css("font-size", "13px");
            label.css("top", "22px");
        }
    })
    //Прыжок label поля, если на него нажали
    $('.auth_input').focus(function() {
        if ($(this).parent().attr("class") == "field") {
            label = $(this).prev();
        }
        else {
            label = $(this).parent().prev()
        }
        label.animate({"top":22}, 250)
        label.css("font-size", "13px");
    })
    //Прыжок label поля, если его деактивировали
    $('.auth_input').blur(function() {
        if (!this.value) {
            if ($(this).parent().attr("class") == "field") {
                label = $(this).prev();
            }
            else {
                label = $(this).parent().prev()
            }
            label.animate({"top":42}, 250)
            label.css("font-size", "16px");
        }
    })
    //Обработка нажатий на label чекбокса, перевод состояний соответствующего чекбокса
    $('.auth_checkbox_label').click(function() {
        checkbox = $(this).prev();
        if (checkbox.prop("checked")) {
            checkbox.prop('checked', false);
        }
        else {
            checkbox.prop('checked', true);
        }
    })
    //Опускает футер вниз если страница меньше окна
    if ($("body").height() + $(".header").height() < $(window).height() - 30) {
        $("footer").addClass("fix_footer")
        $(".header").css("padding-right", "91.5px")
    }
})