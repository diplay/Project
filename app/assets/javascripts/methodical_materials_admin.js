//= require jquery_ujs


$(document).on('click', '.inline-content', function(evt) {
    $div = $(this);
    $textArea = $(this).prev();
    $div.hide();
    $textArea.show().val($div.html());
    CKEDITOR.inline($textArea[0], {
        on: {
            'destroy': function (evt) {
                $div.show().html($textArea.val())
            }
        }
    });
});

$(document).on('click', '.mm-edit-name-off', function(evt) {
    $this = $(this);
    $a = $this.closest('li').find('.mm-name');
    $this.text('Ок').removeClass('mm-edit-name-off').addClass('mm-edit-name-on');
    $a.attr('contenteditable', 'true');
});

$(document).on('click', '.mm-edit-name-on', function(evt) {
    $this = $(this);
    $a = $this.closest('li').find('.mm-name');
    $this.text('Правка').removeClass('mm-edit-name-on').addClass('mm-edit-name-off');
    $a.attr('contenteditable', 'false');

    $.ajax({
        type: "patch",
        url: "/methodical_materials/" + $this.data('id'),
        data: {
            methodical_material: {name: $a.text()}
        }
    });
});

$(document).on('click', '.mm-delete-remote', function(evt) {
    $li = $(this).closest('li');
    $.ajax({
        type: "DELETE",
        url: "/methodical_materials/" + $(this).data('id'),
        data: {
            current_id: $('#current_id').val()
        },
        success: function() {
            $li.remove();
        }
    });
});