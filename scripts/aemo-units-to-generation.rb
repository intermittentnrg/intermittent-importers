#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

ActiveRecord::Base.connection.execute <<SQL
INSERT INTO generation (time, area_id, production_type_id, value)
SELECT time, u.area_id, u.production_type_id, SUM(value) AS value
FROM generation_unit g
INNER JOIN units u ON(g.unit_id=u.id)
INNER JOIN areas a ON(u.area_id=a.id)
WHERE a.source='aemo'
GROUP BY 1,2,3
ON CONFLICT ON CONSTRAINT generation_pkey DO UPDATE set value = EXCLUDED.value
SQL
