ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
    return

  $('.vote-answer-link').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    if(answer.status == "success")
      $('#answer-'+ answer.id + ' .voting .answer-errors').empty()
      $('#answer-'+ answer.id + ' .answer-rating').html('<p>Rating: ' + answer.rating + '</p>')
    else
      $('#answer-'+ answer.id + ' .voting .answer-errors').append(answer.data)
  #.bind 'ajax:error', (e, xhr, status, error) ->
  #  response = $.parseJSON(xhr.responseText)
  #  $('#answer-'+ response.id + ' .voting .answer-errors').html(response.error)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)