<?php
	global $p;
	$crsdir = $p . 'Courses/';
	require_once($p.'semester.php');
	semester($crsdir, "[0]Spring 2015");
?>