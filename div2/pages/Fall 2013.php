<?php
	global $p;
	$crsdir = $p . 'Courses/';
	require_once($p.'semester.php');
	semester($crsdir, "[3]Fall 2013");
?>