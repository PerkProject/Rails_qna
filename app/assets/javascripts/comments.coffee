ready = ->
  $('.new-comment-form_submit-button').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    if(response.status = 'success')
      $('').empty() 
      $('').html('<p>Rating: ' + response.rating + '</p>')
    else
    $('').append('<p>' + response.data + '</p>') 
#.bind 'ajax:error', (e, xhr, status, error) ->
#  response = $.parseJSON(xhr.responseText)
#  $('.voting .question-errors').html('<p>' + response.data + '</p>')

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)