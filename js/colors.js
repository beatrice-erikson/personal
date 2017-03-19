var main = function() {
	$('.colorbtn').click(function () {
		var input = document.getElementById('colortxt').value
		var words = input.match(/[^_\W]+|[\W_]+/g)
		for (var i = 0; i < words.length; i++) {
			if (/^[^_\W]/.test(words[i])) {
				words[i] = [words[i], parseInt(words[i], 36).toString(16)];
				var l = words[i][1].length;
				if (l > 6) {
					words[i][1] = words[i][1].substring(l-6,l);
				} else while (l < 6) {
					words[i][1] = "0"+ words[i][1]
					l++
				}
			} else {
				words[i] = [words[i], "000000"];
			}
		}
		var output = ""
		for (var i = 0; i < words.length; i++) {
			output = output + '<font id="' + i + '">' + words[i][0] + "</font>"
		}
		$('.output').html(output)
		var type = $('input:radio[name=stype]:checked').val();
		if (type == "c") {
		    for (var i = 0; i < words.length; i++) {
				$("#" + i).css({color: "#" + words[i][1]})
			}
		} else {
		    for (var i = 0; i < words.length; i++) {
				$("#" + i).css({backgroundColor: "#" + words[i][1]})
			}
		}
		$('.output').css({maxWidth: "100%"})
	});
};
$(document).ready(main);