$(document).on 'turbolinks:load', ->
  $(document).on('ajax:beforeSend', 'form.new_comment', ->
    $(this).find('.alert-danger').remove()
    return
  ).on('ajax:success', 'form.new_comment', ->
    $form_container = $(this).closest('.comment-form')
    $form_container.find('.row').remove()
    $form_container.find('.add-comment').show()
    return
  ).on 'ajax:error', 'form.new_comment', (e, xhr) ->
    $(this).prepend JST['templates/errors'](xhr.responseJSON)
    return
  $(document).on 'ajax:success', '.comment-delete', ->
    $(this).closest('.comment').fadeOut().remove()
    return
  return

question_id = $("#question").data("id")

App.cable.subscriptions.create({ channel: 'CommentsChannel', id: gon.question_id }, {
  connected: ->
    console.log 'Connected to CommentsChannel, question_id:', gon.question_id
    @perform 'follow_comment'

  received: (data) ->
    console.log 'Received!', data
    comment = $.parseJSON(data)
    if comment.commentable_type is 'Question'
      return if $("#comment_#{comment.id}")[0]?
      $('.comments').append(JST["comment"]({comment: comment}));
    else
      return if $("#comment_#{comment.id}")[0]?
      $('#comment_answer_' + comment.commentable_id).append(JST["comment"]({comment: comment}));
})