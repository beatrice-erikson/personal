<?php
	$rows = array();
	for ($i = 0; $i <= 10; $i++):
		$row = array();
		for ($j = 0; $j <= 10; $j++):
			$row[] = rand(0, 1);
		endfor;
		$rows[] = $row;
	endfor;

	$columns = array();
	for ($i = 0; $i <= 10; $i++):
		$column = array();
		for ($j = 0; $j <= 10; $j++):
			$column[$j] = $rows[$j][$i];
		endfor;
		$columns[] = $column;
	endfor;

	$rowsclues = array();
	for ($i = 0; $i < count($rows); $i++):
		$rowclues = array();
		for ($j = 0; $j < count($rows[$i]); $j++):
			if ($rows[$i][$j] == 1):
				$count = 0;
				while ($j < count($rows[$i]) && $rows[$i][$j] == 1):
					$count++;
					$j++;
				endwhile;
				$rowclues[] = $count;
			endif;
		endfor;
		$rowsclues[] = $rowclues;
	endfor;

	echo "<table><tr>";
	foreach ($rowsclues as $rowclues):
		foreach ($rowclues as $clue):
			echo "<td style='border:1px solid Gray;'>" . $clue."</td>";
		endforeach;
		echo "</tr>";
	endforeach;
	echo "</table><table>";
	foreach ($rows as $row):
		echo "<tr>";
		foreach ($row as $cell):
			echo "<td style='border:1px solid black;'>".$cell."</td>";
		endforeach;
		echo "</tr>";
	endforeach;
	echo "</table>";
?>