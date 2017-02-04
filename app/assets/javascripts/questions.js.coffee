  ready = ->
    $('.vote-question-link').bind 'ajax:success', (e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText)
      if(response.status = 'success')
       $('.voting .question-errors').empty()
       $('.voting .question-rating').html('<p>Rating: ' + response.rating + '</p>')
      else
      $('.voting .question-errors').append('<p>' + response.data + '</p>')
    .bind 'ajax:error', (e, xhr, status, error) ->
      response = $.parseJSON(xhr.responseText)
      $('.voting .question-errors').html('<p>' + response.data + '</p>')

    App.questions = App.cable.subscriptions.create 'QuestionsChannel',
      connected: ->
        @installPageChangeCallback()
        @followQuestionsStream()
        console.log 'Connected to QuestionsChannel'
        return
      received: (data) ->
        $('#questions-list > tbody:last-child').append data
        return

      followQuestionsStream: ->
        if $('#questions-list').length
          @perform 'follow_questions_stream'
        else
          @perform 'unfollow_questions_stream'

      installPageChangeCallback: ->
        $(document).on('turbolinks:load', -> App.questions.followQuestionsStream())
    return

  $(document).ready(ready)
  $(document).on('page:load', ready)
  $(document).on('page:update', ready)
  $(document).on("turbolinks:load", ready)