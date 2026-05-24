
$content = Get-Content "C:\Users\User\Documents\GitHub\GameDev-Week-6.1\game-dev-week-6.1\scenes\level_1.tscn" -Raw
$new_spawn = "[node name=`"SpawnPoint2`" type=`"Marker2D`" parent=`".`" unique_id=992917276 groups=[`"SpawnPoint`"]]`nposition = Vector2(400, 339)`n"
$content = $content -replace "\[node name=`"SpawnPoint`".*\nposition = Vector2\(498, 339\)", "`$0`n$new_spawn"
Set-Content "C:\Users\User\Documents\GitHub\GameDev-Week-6.1\game-dev-week-6.1\scenes\level_1.tscn" $content

