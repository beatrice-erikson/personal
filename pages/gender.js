var main = function () {
	$('.genderbtn').click(function () {
		pieces = ["men", "women", "girl", "boy", "slime", "glitch", "gender", "queer", "kin", "type", "demi", "bit", "bot", "hell", "demon", "anarcho", "neo", "neither", "nano", "magi", "flux", "fluid"]
		j = ["", "", "", " ", " ", " ", "-"]
		
		function shuffle(array) {
			var currentIndex = array.length, temporaryValue, randomIndex ;
			// While there remain elements to shuffle...
			while (0 !== currentIndex) {
				// Pick a remaining element...
				randomIndex = Math.floor(Math.random() * currentIndex);
				currentIndex -= 1;
				// And swap it with the current element.
				temporaryValue = array[currentIndex];
				array[currentIndex] = array[randomIndex];
				array[randomIndex] = temporaryValue;
			}

			return array;
		}
		
		var g = function (n) {
			var slist = shuffle(pieces).slice(0,n);
			s = slist.pop();
			while (slist.length > 0) {
				s = s + j[Math.floor(Math.random()*j.length)] + slist.pop();
			}
		};
		g(Math.floor(Math.random() * 4) + 1);
		$('.gendergen').text(s)
	});
};

$(document).ready(main);
