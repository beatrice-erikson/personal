<?php
	function semester($crsdir, $semester) {
		$sname = preg_replace('/\[\d+\]/','',$semester);
		echo "<tr><td><table class='semester'><tr><th colspan='2'><h3>" . $sname . "</h3></th></tr>";
		foreach(array_slice(scandir($crsdir.$semester), 2) as $eval):
			$evalname = preg_replace('/\.[^.]+$/','',$eval);
			echo "<tr><td colspan='2'><span class='title'><h4>".$evalname."</h4></span></td></tr><tr>";
			include $crsdir.$semester.'/'.$eval;
			echo "</tr>";
		endforeach;
		echo "</table></td></tr>";
	}
?>