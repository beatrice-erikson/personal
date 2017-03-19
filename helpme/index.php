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
			include $p . 'helpme.html';
		?>
        <!-- scripts -->
		<?include $s . 'scripts.php';?>
        <script src ="../js/remedy.js"></script>

		<?include $s . 'statcounter.html';?>
    </body>
</html>