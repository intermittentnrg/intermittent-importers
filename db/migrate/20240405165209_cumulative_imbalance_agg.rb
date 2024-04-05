class CumulativeImbalanceAgg < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
CREATE OR REPLACE FUNCTION int_add_max_terra(double precision, double precision)
RETURNS double precision
AS $$
  BEGIN
    RETURN least($1 + $2, 0);
  END;
$$
LANGUAGE plpgsql
IMMUTABLE;
SQL
    execute <<-SQL
CREATE OR REPLACE AGGREGATE add_max_terra(double precision) (
  SFUNC = int_add_max_terra,
  STYPE = double precision,
  INITCOND = 0
)
SQL
  end
end
