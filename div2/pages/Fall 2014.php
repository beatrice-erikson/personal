<?php
	global $p;
	$crsdir = $p . 'Courses/';
	require_once($p.'semester.php');
	semester($crsdir, "[1]Fall 2014");
?>