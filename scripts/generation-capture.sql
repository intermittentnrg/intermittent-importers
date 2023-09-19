INSERT INTO generation_capture (
       time,
       area_id,
       production_type_id,
       kwh,
       price,
       revenue
)
-- Calculate kWh
SELECT
	time_bucket('1h',g.time) AS time,
	g.area_id::integer,
	g.production_type_id::integer,
	AVG(g.kw) AS kwh,
	AVG(g.price) AS price,
	SUM(g.revenue)/COUNT(*) AS revenue
FROM (
	SELECT
		g.time,
		g.area_id,
		g.production_type_id,
		g.value AS kw,
		p.value AS price,
		p.value*(g.value/1000) AS revenue
	FROM generation g
	INNER JOIN prices p ON(g.area_id=p.area_id AND g.time=p.time)
	-- Joins for WHERE clause
	INNER JOIN areas a ON(g.area_id=a.id)
	INNER JOIN production_types pt ON(g.production_type_id=pt.id)
	WHERE
		a.source='aemo' AND
		pt.name <> 'solar_rooftop'
) g
GROUP BY 1,2,3
ON CONFLICT ON CONSTRAINT generation_capture_pkey DO UPDATE SET
   kwh = EXCLUDED.kwh,
   price = EXCLUDED.price,
   revenue = EXCLUDED.revenue
;
