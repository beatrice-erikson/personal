<html lang="en">
    <?php
		$d = '/home/student/12/bmc12/public_html';
		$p = $d . '/pages/';
		$s = $d . '/shared/';
		include $s . 'head.php';
	?>
    <body>
	<?
			include $s . 'etcnav.php';
			include $p . 'gender.html';
		?>
    <!-- scripts -->
	<?include $s . 'scripts.php';?>
	<script src ="../js/gender.js"></script>
    </body>
</html>