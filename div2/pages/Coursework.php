<?php
	global $p;
	$workdir = $p . 'Coursework/';
	$courses = array_diff(scandir($workdir), array('assets', '.', '..'));
	echo "<table class='courses'>";
	echo "<th><h1>Important Coursework</h1></th>";
	foreach ($courses as $course):
		echo "<tr><td><table class='course'><tr><th colspan='2'><h3>" . $course . "</h3></th></tr>";
		foreach(array_slice(scandir($workdir.$course), 2) as $item):
			$item_parts = pathinfo($workdir.$course.'/'.$item);
			$itemname = $item_parts['filename'];
			if ($item_parts['extension']=="zzz"):
				echo "<td><p>";
				include $item_parts['dirname'].'/'.$item;
				echo "</p></td></tr>";
			else:
				echo "<tr><td><a href='../pages/Coursework/".$course.'/'.$item."'>".$itemname."</a></td>";
			endif;
		endforeach;
		echo "</table></td></tr>";
	endforeach;
	echo "</table>";
?>