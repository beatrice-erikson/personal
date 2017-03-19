(function() {
  $(function() {
    return $(document).on('change', '#genuses_select', function(evt) {
      return $.ajax('update_specieses', {
        type: 'GET',
        dataType: 'script',
        data: {
          country_id: $("#genuses_select option:selected").val()
        },
        error: function(jqXHR, textStatus, errorThrown) {
          return console.log("AJAX Error: " + textStatus);
        },
        success: function(data, textStatus, jqXHR) {
          return console.log("Dynamic country select OK!");
        }
      });
    });
  });

}).call(this);
