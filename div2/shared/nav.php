<nav>
	<div style='max-width:100%'>
		<ul><li><a href='/~bmc12/div2'>Division II Home</a></li>
		<?php
			function contains_dirs($dir) {
				$result = false;
				if($dh = opendir($dir)):
					while (!$result && ($file = readdir($dh))):
						$result = $file !== "." && $file !== ".." && is_dir($dir.'/'.$file);
					endwhile;
					closedir($dh);
				endif;
				return $result;
			}
			$divdir = '/home/student/12/bmc12/public_html/div2';
			$dircont = scandir($divdir);
			foreach ($dircont as $i):
				if (!in_array($i, array('.','..','shared','pages','index.php','css'))):
					echo " | <li><a href='/~bmc12/div2/" . $i . "'>". $i . "</a>";
					if (contains_dirs($divdir.'/'.$i)):
						echo "<ul class='subnav'>";
						foreach (scandir($divdir.'/'.$i) as $ni):
							if (!in_array($ni, array('.','..')) && is_dir($divdir.'/'.$i.'/'.$ni)):
								echo "<li><a href='/~bmc12/div2/".$i."/".$ni."'>".$ni."</a></li>";
							endif;
						endforeach;
						echo "</ul>";
					endif;
					echo "</li>";
				endif;
			endforeach;
		?>
	</div>
</nav>
