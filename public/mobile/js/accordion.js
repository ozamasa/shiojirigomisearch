$(function() {
	$('dl.accordion>dd').hide();
	$('dl.accordion>dt.opened').nextUntil('dl.accordion>dt').show('slow');
	$('dl.accordion>dt').click(function(e) {
		$('dl.accordion>dt').not(this).removeClass('opened');
		$(this).toggleClass('opened');
		$('dl.accordion>dt').not(this).nextUntil('dl.accordion>dt').hide('slow');
		$(this).nextUntil('dl.accordion>dt').toggle('slow');
	});
});