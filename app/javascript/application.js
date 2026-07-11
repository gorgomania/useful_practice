// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"

// Прыжок label при focus
$(document).on("focus.auth", ".auth_input", function() {
  moveLabel($(this), 1);
});

// Прыжок label при blur
$(document).on("blur.auth", ".auth_input", function() {
  if (!this.value) {
    moveLabel($(this), 0);
  }
});

// Событие input - при вводе
$(document).on("input.auth", ".auth_input", function() {
  const hasFocus = $(this).is(":focus");

  if (!this.value && !hasFocus) {
    moveLabel($(this), 0);
  }
  else if (this.value) {
    moveLabel($(this), 1);
  }
});

document.addEventListener("turbo:load", function() {
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
    $('#search_img').mouseenter(function () {
        $('#search_input').css("background", 'white')
        $('#search_input').css("box-shadow", '0 0 0 1px #0000000a,0 4px 4px #0000000a,0 20px 40px #00000014')
    })

    //Обработка нажатий на label чекбокса, перевод состояний соответствующего чекбокса
    $('#auth_checkbox_label').click(function() {
        let checkbox = $(this).prev();
        if (checkbox.prop("checked")) {
            checkbox.prop('checked', false);
        }
        else {
            checkbox.prop('checked', true);
        }
    })
})

function moveLabel($input, move) {
    let $label;
    if ($input.parent().hasClass("field")) {
        $label = $input.prev();
    } else if ($input.parent().prev().hasClass("auth_label")) {
        $label = $input.parent().prev();
    } else {
        $label = $input.parent().prev().children();
    }

    if (!move) {
        $label.animate({ "top": "42px" }, 200).css("font-size", "16px");
    }
    else {
        $label.animate({ "top": "22px" }, 200).css("font-size", "13px");
    }
}