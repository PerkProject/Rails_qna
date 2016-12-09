# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.vote-question-link').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    if(response.status = 'success')
     $('.voting .question-errors').empty() #не хочет обнулять
     $('.voting .question-rating').html('<p>Rating: ' + response.rating + '</p>')
    else
    $('.voting .question-errors').append('<p>' + response.data + '</p>') #а добавлять - пожалуйста
 #.bind 'ajax:error', (e, xhr, status, error) ->
 #  response = $.parseJSON(xhr.responseText)
 #  $('.voting .question-errors').html('<p>' + response.data + '</p>')

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)