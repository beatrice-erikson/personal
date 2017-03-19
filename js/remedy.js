var main = function () {
	$('.healthbtn').click(function () {
		var problem = ["malaria", "arthritis", "migraines", "the flu", "an upset stomach", "vertigo", "nausea", "mono", "allergies", "a cold", "acne", "an ancient curse", "being on fire", "heart attacks", "heart burn", "sleep apnea", "hair loss", "bad breath", "a bee sting", "a broken arm", "blood clots", "bronchitis", "bunions", "burns", "canker sores", "cavities", "chicken pox", "chronic pain", "constipation", "cysts", "deep vein thrombosis", "dengue fever", "depression", "anxiety", "diabetes", "diarrhea", "dizziness", "tinnitus", "mumps", "measles", "rubella", "polio", "heat exhaustion", "fatigue", "frostbite", "wrinkles", "aging"];
		var substance = ["ginger", "ice", "a heatpack", "St. John's wort", "lavender oil", "rose oil", "peppermint oil", "valerian", "guacamole", "a crystal", "sage", "dirt", "salsa", "witch hazel", "fire", "echinacea", "yogurt", "aloe vera", "skim milk", "liquid oxygen"];
		var practice = ["eliminating stress", "taking a vacation", "yoga", "acupuncture", "meditation", "thinking positively", "sleeping", "meditating", "resting", "making a vision board", "eating", "a breathing exercise", "drinking water"];
		var location = ["your forehead", "your elbow", "the area surrounding your fundament", "your hands", "your entire body", "your face", "the most painful spot", "your eyes", "your teeth", "your tongue"];
		var treatment = substance.concat(practice);

		var ands = [" paired with ", " in combination with ", " combined with ", " and "];


		var choose = function (phrase) {
			var index = Math.round(Math.random() * (phrase.length - 1));
			return phrase[index];
		};

		var t1 = function () {
			var ending = [" Try " + choose(treatment) + ".", " Try putting " + choose(substance) + " on " + choose(location) + ".", " Put " + choose(substance) + " on " + choose(location) + ".", " Have you tried " + choose([choose(substance), choose(practice)]) + choose(["", " " + choose(ands) + " " + choose([choose(practice), choose(substance)]), " or " + choose([choose(practice), choose(substance)])]) + "?"];
			return "Suffering from " + choose(problem) + "?" + choose(ending);
		};

		var t2 = function () {
			var prelude = ["", "Don't let your doctor tell you otherwise - ", "Not many people know that "]
			var ending = choose([".", ", especially when applied to " + choose(location) + "."]);
			if (ending.indexOf(", especially when applied to ") === 0) {
				var thing = choose(substance);
			} else {
				var thing = choose(treatment);
			}
			return choose(prelude) + thing + " is a " + choose(["great treatment", "little-known remedy"]) + " for " + choose(problem) + ending;
		};
		var t3 = function() {
			var ending = [" in no time!", " forever.", " for good.", " for at least a week."];
			return "This one simple trick involving " + choose(treatment) + " will rid you of " + choose(problem) + choose(ending);
		};
		var t4 = function() {
			var ending = [" can be used to combat ", " is a good home remedy for ", " will take care of "];
			var remedies = [choose(treatment), choose(treatment)];
			while (remedies[0] === remedies[1]) {
				remedies[1] = choose(treatment);
			}
			return remedies[0] + choose(ands) + remedies[1] + choose(ending) + choose(problem) + ".";
		};
		var t5 = function () {
			var exclamation = ["Wow! ", "WOW! ", "Amazing! ", "Incredible! ", "Can you believe it? ", "I knew it! ", "I've known this for years. ", "Finally, proof! "];
			var prelude = choose(["", "It's just been discovered that ", "Did you know? Careful application of ", "A new study shows "]);
			var treat = choose(treatment);
			if (!prelude) {
				var treat = treat.substr(0, 1).toUpperCase() + treat.substr(1);
			}
			var bridge = [" will eliminate any issues you have with ", " can be used to prevent ", " is a super-effective cure for ", " is a great treatment for ", " is a promising treatment for"];
			
			return choose(exclamation) + prelude + treat + choose(bridge) + choose(problem) + "!";
		};
		var output = choose([t1(), t2(), t3(), t4(), t5()]);
		var output = output.charAt(0).toUpperCase() + output.substring(1);
		$('.healthgen').text(output);
    });
};
$(document).ready(main);