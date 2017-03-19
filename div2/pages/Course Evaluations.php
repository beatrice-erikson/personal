<?php
	global $p;
	$crsdir = $p . 'Courses/';
	$semesters = array_slice(scandir($crsdir), 2);
	echo "<table class='courses'>";
	echo "<th><h1>Course Evaluations</h1></th>";
	foreach ($semesters as $semester):
		$sname = preg_replace('/\[\d+\]/','',$semester);
		include $p.$sname.'.php';
	endforeach;
	echo "</table>";
?>