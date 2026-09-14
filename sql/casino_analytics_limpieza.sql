SELECT provider, COUNT(*) AS cantidad_registros
FROM casino_games_clean
GROUP BY provider
ORDER BY cantidad_registros DESC
LIMIT 10;