$ ->
  $(document).on 'change', '#genuses_select', (evt) ->
    $.ajax 'update_specieses',
      type: 'GET'
      dataType: 'script'
      data: {
        country_id: $("#genuses_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")