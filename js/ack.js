var main = function () {
    $('.ackbtn').click(function () {
	var ack = function (m, n) {
            if(m==0) {
		return n+1;
	    }
	    if(n==0) {
		return ack(m-1, 1);
	    }
	    return ack(m-1, ack(m, n-1));
        };
		var m = $('.m').text();
		var n = $('.n').text();
        var output = ack(m, n);
        $('.answer').text(output);
    });
};
$(document).ready(main);