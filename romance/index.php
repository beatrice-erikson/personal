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
			include $p . 'romance.html';
		?>
        <!-- scripts -->
		<?include $s . 'scripts.php';?>
        <script src ="../js/romance.js"></script>
    </body>
</html>