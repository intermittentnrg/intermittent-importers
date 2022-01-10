SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';


--
-- Name: entsoe_production_types; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.entsoe_production_types AS ENUM (
    'biomass',
    'fossil_brown_coal/lignite',
    'fossil_coal-derived_gas',
    'fossil_gas',
    'fossil_hard_coal',
    'fossil_oil',
    'fossil_oil_shale',
    'fossil_peat',
    'geothermal',
    'hydro_pumped_storage',
    'hydro_run-of-river_and_poundage',
    'hydro_water_reservoir',
    'marine',
    'nuclear',
    'other',
    'other_renewable',
    'solar',
    'waste',
    'wind_offshore',
    'wind_onshore'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: entsoe_generation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entsoe_generation (
    country character varying NOT NULL,
    production_type public.entsoe_production_types NOT NULL,
    process_type character varying,
    business_type character varying,
    value integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT no_wind_onshore CHECK ((NOT (((country)::text = 'NO'::text) AND (production_type = 'wind_onshore'::public.entsoe_production_types) AND (value > 10000))))
);


--
-- Name: _hyper_1_100_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_100_chunk (
    CONSTRAINT constraint_100 CHECK (((created_at >= '2016-09-22 00:00:00'::timestamp without time zone) AND (created_at < '2016-09-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_101_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_101_chunk (
    CONSTRAINT constraint_101 CHECK (((created_at >= '2016-09-29 00:00:00'::timestamp without time zone) AND (created_at < '2016-10-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_102_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_102_chunk (
    CONSTRAINT constraint_102 CHECK (((created_at >= '2016-10-06 00:00:00'::timestamp without time zone) AND (created_at < '2016-10-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_103_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_103_chunk (
    CONSTRAINT constraint_103 CHECK (((created_at >= '2016-10-13 00:00:00'::timestamp without time zone) AND (created_at < '2016-10-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_104_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_104_chunk (
    CONSTRAINT constraint_104 CHECK (((created_at >= '2016-10-20 00:00:00'::timestamp without time zone) AND (created_at < '2016-10-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_105_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_105_chunk (
    CONSTRAINT constraint_105 CHECK (((created_at >= '2016-10-27 00:00:00'::timestamp without time zone) AND (created_at < '2016-11-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_106_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_106_chunk (
    CONSTRAINT constraint_106 CHECK (((created_at >= '2016-11-03 00:00:00'::timestamp without time zone) AND (created_at < '2016-11-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_107_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_107_chunk (
    CONSTRAINT constraint_107 CHECK (((created_at >= '2016-11-10 00:00:00'::timestamp without time zone) AND (created_at < '2016-11-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_108_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_108_chunk (
    CONSTRAINT constraint_108 CHECK (((created_at >= '2016-11-17 00:00:00'::timestamp without time zone) AND (created_at < '2016-11-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_109_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_109_chunk (
    CONSTRAINT constraint_109 CHECK (((created_at >= '2016-11-24 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_10_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_10_chunk (
    CONSTRAINT constraint_10 CHECK (((created_at >= '2015-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2015-01-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_110_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_110_chunk (
    CONSTRAINT constraint_110 CHECK (((created_at >= '2016-12-01 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_111_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_111_chunk (
    CONSTRAINT constraint_111 CHECK (((created_at >= '2016-12-08 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_112_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_112_chunk (
    CONSTRAINT constraint_112 CHECK (((created_at >= '2016-12-15 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_113_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_113_chunk (
    CONSTRAINT constraint_113 CHECK (((created_at >= '2016-12-22 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_114_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_114_chunk (
    CONSTRAINT constraint_114 CHECK (((created_at >= '2016-12-29 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_115_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_115_chunk (
    CONSTRAINT constraint_115 CHECK (((created_at >= '2017-01-05 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_116_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_116_chunk (
    CONSTRAINT constraint_116 CHECK (((created_at >= '2017-01-12 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_117_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_117_chunk (
    CONSTRAINT constraint_117 CHECK (((created_at >= '2017-01-19 00:00:00'::timestamp without time zone) AND (created_at < '2017-01-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_118_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_118_chunk (
    CONSTRAINT constraint_118 CHECK (((created_at >= '2017-01-26 00:00:00'::timestamp without time zone) AND (created_at < '2017-02-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_119_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_119_chunk (
    CONSTRAINT constraint_119 CHECK (((created_at >= '2017-02-02 00:00:00'::timestamp without time zone) AND (created_at < '2017-02-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_11_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_11_chunk (
    CONSTRAINT constraint_11 CHECK (((created_at >= '2015-01-08 00:00:00'::timestamp without time zone) AND (created_at < '2015-01-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_120_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_120_chunk (
    CONSTRAINT constraint_120 CHECK (((created_at >= '2017-02-09 00:00:00'::timestamp without time zone) AND (created_at < '2017-02-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_121_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_121_chunk (
    CONSTRAINT constraint_121 CHECK (((created_at >= '2017-02-16 00:00:00'::timestamp without time zone) AND (created_at < '2017-02-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_122_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_122_chunk (
    CONSTRAINT constraint_122 CHECK (((created_at >= '2017-02-23 00:00:00'::timestamp without time zone) AND (created_at < '2017-03-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_123_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_123_chunk (
    CONSTRAINT constraint_123 CHECK (((created_at >= '2017-03-02 00:00:00'::timestamp without time zone) AND (created_at < '2017-03-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_124_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_124_chunk (
    CONSTRAINT constraint_124 CHECK (((created_at >= '2017-03-09 00:00:00'::timestamp without time zone) AND (created_at < '2017-03-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_125_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_125_chunk (
    CONSTRAINT constraint_125 CHECK (((created_at >= '2017-03-16 00:00:00'::timestamp without time zone) AND (created_at < '2017-03-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_126_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_126_chunk (
    CONSTRAINT constraint_126 CHECK (((created_at >= '2017-03-23 00:00:00'::timestamp without time zone) AND (created_at < '2017-03-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_127_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_127_chunk (
    CONSTRAINT constraint_127 CHECK (((created_at >= '2017-03-30 00:00:00'::timestamp without time zone) AND (created_at < '2017-04-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_128_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_128_chunk (
    CONSTRAINT constraint_128 CHECK (((created_at >= '2017-04-06 00:00:00'::timestamp without time zone) AND (created_at < '2017-04-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_129_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_129_chunk (
    CONSTRAINT constraint_129 CHECK (((created_at >= '2017-04-13 00:00:00'::timestamp without time zone) AND (created_at < '2017-04-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_12_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_12_chunk (
    CONSTRAINT constraint_12 CHECK (((created_at >= '2015-01-15 00:00:00'::timestamp without time zone) AND (created_at < '2015-01-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_130_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_130_chunk (
    CONSTRAINT constraint_130 CHECK (((created_at >= '2017-04-20 00:00:00'::timestamp without time zone) AND (created_at < '2017-04-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_131_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_131_chunk (
    CONSTRAINT constraint_131 CHECK (((created_at >= '2017-04-27 00:00:00'::timestamp without time zone) AND (created_at < '2017-05-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_132_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_132_chunk (
    CONSTRAINT constraint_132 CHECK (((created_at >= '2017-05-04 00:00:00'::timestamp without time zone) AND (created_at < '2017-05-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_133_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_133_chunk (
    CONSTRAINT constraint_133 CHECK (((created_at >= '2017-05-11 00:00:00'::timestamp without time zone) AND (created_at < '2017-05-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_134_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_134_chunk (
    CONSTRAINT constraint_134 CHECK (((created_at >= '2017-05-18 00:00:00'::timestamp without time zone) AND (created_at < '2017-05-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_135_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_135_chunk (
    CONSTRAINT constraint_135 CHECK (((created_at >= '2017-05-25 00:00:00'::timestamp without time zone) AND (created_at < '2017-06-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_136_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_136_chunk (
    CONSTRAINT constraint_136 CHECK (((created_at >= '2017-06-01 00:00:00'::timestamp without time zone) AND (created_at < '2017-06-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_137_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_137_chunk (
    CONSTRAINT constraint_137 CHECK (((created_at >= '2017-06-08 00:00:00'::timestamp without time zone) AND (created_at < '2017-06-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_138_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_138_chunk (
    CONSTRAINT constraint_138 CHECK (((created_at >= '2017-06-15 00:00:00'::timestamp without time zone) AND (created_at < '2017-06-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_139_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_139_chunk (
    CONSTRAINT constraint_139 CHECK (((created_at >= '2017-06-22 00:00:00'::timestamp without time zone) AND (created_at < '2017-06-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_13_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_13_chunk (
    CONSTRAINT constraint_13 CHECK (((created_at >= '2015-01-22 00:00:00'::timestamp without time zone) AND (created_at < '2015-01-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_140_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_140_chunk (
    CONSTRAINT constraint_140 CHECK (((created_at >= '2017-06-29 00:00:00'::timestamp without time zone) AND (created_at < '2017-07-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_141_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_141_chunk (
    CONSTRAINT constraint_141 CHECK (((created_at >= '2017-07-06 00:00:00'::timestamp without time zone) AND (created_at < '2017-07-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_142_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_142_chunk (
    CONSTRAINT constraint_142 CHECK (((created_at >= '2017-07-13 00:00:00'::timestamp without time zone) AND (created_at < '2017-07-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_143_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_143_chunk (
    CONSTRAINT constraint_143 CHECK (((created_at >= '2017-07-20 00:00:00'::timestamp without time zone) AND (created_at < '2017-07-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_144_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_144_chunk (
    CONSTRAINT constraint_144 CHECK (((created_at >= '2017-07-27 00:00:00'::timestamp without time zone) AND (created_at < '2017-08-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_145_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_145_chunk (
    CONSTRAINT constraint_145 CHECK (((created_at >= '2017-08-03 00:00:00'::timestamp without time zone) AND (created_at < '2017-08-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_146_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_146_chunk (
    CONSTRAINT constraint_146 CHECK (((created_at >= '2017-08-10 00:00:00'::timestamp without time zone) AND (created_at < '2017-08-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_147_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_147_chunk (
    CONSTRAINT constraint_147 CHECK (((created_at >= '2017-08-17 00:00:00'::timestamp without time zone) AND (created_at < '2017-08-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_148_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_148_chunk (
    CONSTRAINT constraint_148 CHECK (((created_at >= '2017-08-24 00:00:00'::timestamp without time zone) AND (created_at < '2017-08-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_149_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_149_chunk (
    CONSTRAINT constraint_149 CHECK (((created_at >= '2017-08-31 00:00:00'::timestamp without time zone) AND (created_at < '2017-09-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_14_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_14_chunk (
    CONSTRAINT constraint_14 CHECK (((created_at >= '2015-01-29 00:00:00'::timestamp without time zone) AND (created_at < '2015-02-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_150_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_150_chunk (
    CONSTRAINT constraint_150 CHECK (((created_at >= '2017-09-07 00:00:00'::timestamp without time zone) AND (created_at < '2017-09-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_151_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_151_chunk (
    CONSTRAINT constraint_151 CHECK (((created_at >= '2017-09-14 00:00:00'::timestamp without time zone) AND (created_at < '2017-09-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_152_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_152_chunk (
    CONSTRAINT constraint_152 CHECK (((created_at >= '2017-09-21 00:00:00'::timestamp without time zone) AND (created_at < '2017-09-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_153_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_153_chunk (
    CONSTRAINT constraint_153 CHECK (((created_at >= '2017-09-28 00:00:00'::timestamp without time zone) AND (created_at < '2017-10-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_154_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_154_chunk (
    CONSTRAINT constraint_154 CHECK (((created_at >= '2017-10-05 00:00:00'::timestamp without time zone) AND (created_at < '2017-10-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_155_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_155_chunk (
    CONSTRAINT constraint_155 CHECK (((created_at >= '2017-10-12 00:00:00'::timestamp without time zone) AND (created_at < '2017-10-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_156_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_156_chunk (
    CONSTRAINT constraint_156 CHECK (((created_at >= '2017-10-19 00:00:00'::timestamp without time zone) AND (created_at < '2017-10-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_157_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_157_chunk (
    CONSTRAINT constraint_157 CHECK (((created_at >= '2017-10-26 00:00:00'::timestamp without time zone) AND (created_at < '2017-11-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_158_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_158_chunk (
    CONSTRAINT constraint_158 CHECK (((created_at >= '2017-11-02 00:00:00'::timestamp without time zone) AND (created_at < '2017-11-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_159_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_159_chunk (
    CONSTRAINT constraint_159 CHECK (((created_at >= '2017-11-09 00:00:00'::timestamp without time zone) AND (created_at < '2017-11-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_15_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_15_chunk (
    CONSTRAINT constraint_15 CHECK (((created_at >= '2015-02-05 00:00:00'::timestamp without time zone) AND (created_at < '2015-02-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_160_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_160_chunk (
    CONSTRAINT constraint_160 CHECK (((created_at >= '2017-11-16 00:00:00'::timestamp without time zone) AND (created_at < '2017-11-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_161_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_161_chunk (
    CONSTRAINT constraint_161 CHECK (((created_at >= '2017-11-23 00:00:00'::timestamp without time zone) AND (created_at < '2017-11-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_162_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_162_chunk (
    CONSTRAINT constraint_162 CHECK (((created_at >= '2017-11-30 00:00:00'::timestamp without time zone) AND (created_at < '2017-12-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_163_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_163_chunk (
    CONSTRAINT constraint_163 CHECK (((created_at >= '2017-12-07 00:00:00'::timestamp without time zone) AND (created_at < '2017-12-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_164_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_164_chunk (
    CONSTRAINT constraint_164 CHECK (((created_at >= '2017-12-14 00:00:00'::timestamp without time zone) AND (created_at < '2017-12-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_165_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_165_chunk (
    CONSTRAINT constraint_165 CHECK (((created_at >= '2017-12-21 00:00:00'::timestamp without time zone) AND (created_at < '2017-12-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_166_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_166_chunk (
    CONSTRAINT constraint_166 CHECK (((created_at >= '2017-12-28 00:00:00'::timestamp without time zone) AND (created_at < '2018-01-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_167_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_167_chunk (
    CONSTRAINT constraint_167 CHECK (((created_at >= '2018-01-04 00:00:00'::timestamp without time zone) AND (created_at < '2018-01-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_168_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_168_chunk (
    CONSTRAINT constraint_168 CHECK (((created_at >= '2018-01-11 00:00:00'::timestamp without time zone) AND (created_at < '2018-01-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_169_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_169_chunk (
    CONSTRAINT constraint_169 CHECK (((created_at >= '2018-01-18 00:00:00'::timestamp without time zone) AND (created_at < '2018-01-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_16_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_16_chunk (
    CONSTRAINT constraint_16 CHECK (((created_at >= '2015-02-12 00:00:00'::timestamp without time zone) AND (created_at < '2015-02-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_170_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_170_chunk (
    CONSTRAINT constraint_170 CHECK (((created_at >= '2018-01-25 00:00:00'::timestamp without time zone) AND (created_at < '2018-02-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_171_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_171_chunk (
    CONSTRAINT constraint_171 CHECK (((created_at >= '2018-02-01 00:00:00'::timestamp without time zone) AND (created_at < '2018-02-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_172_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_172_chunk (
    CONSTRAINT constraint_172 CHECK (((created_at >= '2018-02-08 00:00:00'::timestamp without time zone) AND (created_at < '2018-02-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_173_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_173_chunk (
    CONSTRAINT constraint_173 CHECK (((created_at >= '2018-02-15 00:00:00'::timestamp without time zone) AND (created_at < '2018-02-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_174_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_174_chunk (
    CONSTRAINT constraint_174 CHECK (((created_at >= '2018-02-22 00:00:00'::timestamp without time zone) AND (created_at < '2018-03-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_175_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_175_chunk (
    CONSTRAINT constraint_175 CHECK (((created_at >= '2018-03-01 00:00:00'::timestamp without time zone) AND (created_at < '2018-03-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_176_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_176_chunk (
    CONSTRAINT constraint_176 CHECK (((created_at >= '2018-03-08 00:00:00'::timestamp without time zone) AND (created_at < '2018-03-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_177_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_177_chunk (
    CONSTRAINT constraint_177 CHECK (((created_at >= '2018-03-15 00:00:00'::timestamp without time zone) AND (created_at < '2018-03-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_178_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_178_chunk (
    CONSTRAINT constraint_178 CHECK (((created_at >= '2018-03-22 00:00:00'::timestamp without time zone) AND (created_at < '2018-03-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_179_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_179_chunk (
    CONSTRAINT constraint_179 CHECK (((created_at >= '2018-03-29 00:00:00'::timestamp without time zone) AND (created_at < '2018-04-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_17_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_17_chunk (
    CONSTRAINT constraint_17 CHECK (((created_at >= '2015-02-19 00:00:00'::timestamp without time zone) AND (created_at < '2015-02-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_180_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_180_chunk (
    CONSTRAINT constraint_180 CHECK (((created_at >= '2018-04-05 00:00:00'::timestamp without time zone) AND (created_at < '2018-04-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_181_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_181_chunk (
    CONSTRAINT constraint_181 CHECK (((created_at >= '2018-04-12 00:00:00'::timestamp without time zone) AND (created_at < '2018-04-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_182_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_182_chunk (
    CONSTRAINT constraint_182 CHECK (((created_at >= '2018-04-19 00:00:00'::timestamp without time zone) AND (created_at < '2018-04-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_183_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_183_chunk (
    CONSTRAINT constraint_183 CHECK (((created_at >= '2018-04-26 00:00:00'::timestamp without time zone) AND (created_at < '2018-05-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_184_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_184_chunk (
    CONSTRAINT constraint_184 CHECK (((created_at >= '2018-05-03 00:00:00'::timestamp without time zone) AND (created_at < '2018-05-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_185_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_185_chunk (
    CONSTRAINT constraint_185 CHECK (((created_at >= '2018-05-10 00:00:00'::timestamp without time zone) AND (created_at < '2018-05-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_186_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_186_chunk (
    CONSTRAINT constraint_186 CHECK (((created_at >= '2018-05-17 00:00:00'::timestamp without time zone) AND (created_at < '2018-05-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_187_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_187_chunk (
    CONSTRAINT constraint_187 CHECK (((created_at >= '2018-05-24 00:00:00'::timestamp without time zone) AND (created_at < '2018-05-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_188_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_188_chunk (
    CONSTRAINT constraint_188 CHECK (((created_at >= '2018-05-31 00:00:00'::timestamp without time zone) AND (created_at < '2018-06-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_189_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_189_chunk (
    CONSTRAINT constraint_189 CHECK (((created_at >= '2018-06-07 00:00:00'::timestamp without time zone) AND (created_at < '2018-06-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_18_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_18_chunk (
    CONSTRAINT constraint_18 CHECK (((created_at >= '2015-02-26 00:00:00'::timestamp without time zone) AND (created_at < '2015-03-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_190_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_190_chunk (
    CONSTRAINT constraint_190 CHECK (((created_at >= '2018-06-14 00:00:00'::timestamp without time zone) AND (created_at < '2018-06-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_191_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_191_chunk (
    CONSTRAINT constraint_191 CHECK (((created_at >= '2018-06-21 00:00:00'::timestamp without time zone) AND (created_at < '2018-06-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_192_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_192_chunk (
    CONSTRAINT constraint_192 CHECK (((created_at >= '2018-06-28 00:00:00'::timestamp without time zone) AND (created_at < '2018-07-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_193_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_193_chunk (
    CONSTRAINT constraint_193 CHECK (((created_at >= '2018-07-05 00:00:00'::timestamp without time zone) AND (created_at < '2018-07-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_194_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_194_chunk (
    CONSTRAINT constraint_194 CHECK (((created_at >= '2018-07-12 00:00:00'::timestamp without time zone) AND (created_at < '2018-07-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_195_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_195_chunk (
    CONSTRAINT constraint_195 CHECK (((created_at >= '2018-07-19 00:00:00'::timestamp without time zone) AND (created_at < '2018-07-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_196_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_196_chunk (
    CONSTRAINT constraint_196 CHECK (((created_at >= '2018-07-26 00:00:00'::timestamp without time zone) AND (created_at < '2018-08-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_197_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_197_chunk (
    CONSTRAINT constraint_197 CHECK (((created_at >= '2018-08-02 00:00:00'::timestamp without time zone) AND (created_at < '2018-08-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_198_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_198_chunk (
    CONSTRAINT constraint_198 CHECK (((created_at >= '2018-08-09 00:00:00'::timestamp without time zone) AND (created_at < '2018-08-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_199_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_199_chunk (
    CONSTRAINT constraint_199 CHECK (((created_at >= '2018-08-16 00:00:00'::timestamp without time zone) AND (created_at < '2018-08-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_19_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_19_chunk (
    CONSTRAINT constraint_19 CHECK (((created_at >= '2015-03-05 00:00:00'::timestamp without time zone) AND (created_at < '2015-03-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_1_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1_chunk (
    CONSTRAINT constraint_1 CHECK (((created_at >= '2014-10-30 00:00:00'::timestamp without time zone) AND (created_at < '2014-11-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_200_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_200_chunk (
    CONSTRAINT constraint_200 CHECK (((created_at >= '2018-08-23 00:00:00'::timestamp without time zone) AND (created_at < '2018-08-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_201_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_201_chunk (
    CONSTRAINT constraint_201 CHECK (((created_at >= '2018-08-30 00:00:00'::timestamp without time zone) AND (created_at < '2018-09-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_202_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_202_chunk (
    CONSTRAINT constraint_202 CHECK (((created_at >= '2018-09-06 00:00:00'::timestamp without time zone) AND (created_at < '2018-09-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_203_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_203_chunk (
    CONSTRAINT constraint_203 CHECK (((created_at >= '2018-09-13 00:00:00'::timestamp without time zone) AND (created_at < '2018-09-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_204_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_204_chunk (
    CONSTRAINT constraint_204 CHECK (((created_at >= '2018-09-20 00:00:00'::timestamp without time zone) AND (created_at < '2018-09-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_205_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_205_chunk (
    CONSTRAINT constraint_205 CHECK (((created_at >= '2018-09-27 00:00:00'::timestamp without time zone) AND (created_at < '2018-10-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_206_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_206_chunk (
    CONSTRAINT constraint_206 CHECK (((created_at >= '2018-10-04 00:00:00'::timestamp without time zone) AND (created_at < '2018-10-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_207_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_207_chunk (
    CONSTRAINT constraint_207 CHECK (((created_at >= '2018-10-11 00:00:00'::timestamp without time zone) AND (created_at < '2018-10-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_208_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_208_chunk (
    CONSTRAINT constraint_208 CHECK (((created_at >= '2018-10-18 00:00:00'::timestamp without time zone) AND (created_at < '2018-10-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_209_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_209_chunk (
    CONSTRAINT constraint_209 CHECK (((created_at >= '2018-10-25 00:00:00'::timestamp without time zone) AND (created_at < '2018-11-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_20_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_20_chunk (
    CONSTRAINT constraint_20 CHECK (((created_at >= '2015-03-12 00:00:00'::timestamp without time zone) AND (created_at < '2015-03-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_210_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_210_chunk (
    CONSTRAINT constraint_210 CHECK (((created_at >= '2018-11-01 00:00:00'::timestamp without time zone) AND (created_at < '2018-11-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_211_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_211_chunk (
    CONSTRAINT constraint_211 CHECK (((created_at >= '2018-11-08 00:00:00'::timestamp without time zone) AND (created_at < '2018-11-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_212_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_212_chunk (
    CONSTRAINT constraint_212 CHECK (((created_at >= '2018-11-15 00:00:00'::timestamp without time zone) AND (created_at < '2018-11-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_213_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_213_chunk (
    CONSTRAINT constraint_213 CHECK (((created_at >= '2018-11-22 00:00:00'::timestamp without time zone) AND (created_at < '2018-11-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_214_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_214_chunk (
    CONSTRAINT constraint_214 CHECK (((created_at >= '2018-11-29 00:00:00'::timestamp without time zone) AND (created_at < '2018-12-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_215_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_215_chunk (
    CONSTRAINT constraint_215 CHECK (((created_at >= '2018-12-06 00:00:00'::timestamp without time zone) AND (created_at < '2018-12-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_216_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_216_chunk (
    CONSTRAINT constraint_216 CHECK (((created_at >= '2018-12-13 00:00:00'::timestamp without time zone) AND (created_at < '2018-12-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_217_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_217_chunk (
    CONSTRAINT constraint_217 CHECK (((created_at >= '2018-12-20 00:00:00'::timestamp without time zone) AND (created_at < '2018-12-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_218_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_218_chunk (
    CONSTRAINT constraint_218 CHECK (((created_at >= '2018-12-27 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_219_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_219_chunk (
    CONSTRAINT constraint_219 CHECK (((created_at >= '2019-01-03 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_21_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_21_chunk (
    CONSTRAINT constraint_21 CHECK (((created_at >= '2015-03-19 00:00:00'::timestamp without time zone) AND (created_at < '2015-03-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_220_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_220_chunk (
    CONSTRAINT constraint_220 CHECK (((created_at >= '2019-01-10 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_221_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_221_chunk (
    CONSTRAINT constraint_221 CHECK (((created_at >= '2019-01-17 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_222_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_222_chunk (
    CONSTRAINT constraint_222 CHECK (((created_at >= '2019-01-24 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_223_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_223_chunk (
    CONSTRAINT constraint_223 CHECK (((created_at >= '2019-01-31 00:00:00'::timestamp without time zone) AND (created_at < '2019-02-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_224_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_224_chunk (
    CONSTRAINT constraint_224 CHECK (((created_at >= '2019-02-07 00:00:00'::timestamp without time zone) AND (created_at < '2019-02-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_225_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_225_chunk (
    CONSTRAINT constraint_225 CHECK (((created_at >= '2019-02-14 00:00:00'::timestamp without time zone) AND (created_at < '2019-02-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_226_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_226_chunk (
    CONSTRAINT constraint_226 CHECK (((created_at >= '2019-02-21 00:00:00'::timestamp without time zone) AND (created_at < '2019-02-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_227_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_227_chunk (
    CONSTRAINT constraint_227 CHECK (((created_at >= '2019-02-28 00:00:00'::timestamp without time zone) AND (created_at < '2019-03-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_228_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_228_chunk (
    CONSTRAINT constraint_228 CHECK (((created_at >= '2019-03-07 00:00:00'::timestamp without time zone) AND (created_at < '2019-03-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_229_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_229_chunk (
    CONSTRAINT constraint_229 CHECK (((created_at >= '2019-03-14 00:00:00'::timestamp without time zone) AND (created_at < '2019-03-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_22_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_22_chunk (
    CONSTRAINT constraint_22 CHECK (((created_at >= '2015-03-26 00:00:00'::timestamp without time zone) AND (created_at < '2015-04-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_230_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_230_chunk (
    CONSTRAINT constraint_230 CHECK (((created_at >= '2019-03-21 00:00:00'::timestamp without time zone) AND (created_at < '2019-03-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_231_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_231_chunk (
    CONSTRAINT constraint_231 CHECK (((created_at >= '2019-03-28 00:00:00'::timestamp without time zone) AND (created_at < '2019-04-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_232_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_232_chunk (
    CONSTRAINT constraint_232 CHECK (((created_at >= '2019-04-04 00:00:00'::timestamp without time zone) AND (created_at < '2019-04-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_233_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_233_chunk (
    CONSTRAINT constraint_233 CHECK (((created_at >= '2019-04-11 00:00:00'::timestamp without time zone) AND (created_at < '2019-04-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_234_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_234_chunk (
    CONSTRAINT constraint_234 CHECK (((created_at >= '2019-04-18 00:00:00'::timestamp without time zone) AND (created_at < '2019-04-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_235_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_235_chunk (
    CONSTRAINT constraint_235 CHECK (((created_at >= '2019-04-25 00:00:00'::timestamp without time zone) AND (created_at < '2019-05-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_236_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_236_chunk (
    CONSTRAINT constraint_236 CHECK (((created_at >= '2019-05-02 00:00:00'::timestamp without time zone) AND (created_at < '2019-05-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_237_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_237_chunk (
    CONSTRAINT constraint_237 CHECK (((created_at >= '2019-05-09 00:00:00'::timestamp without time zone) AND (created_at < '2019-05-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_238_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_238_chunk (
    CONSTRAINT constraint_238 CHECK (((created_at >= '2019-05-16 00:00:00'::timestamp without time zone) AND (created_at < '2019-05-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_239_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_239_chunk (
    CONSTRAINT constraint_239 CHECK (((created_at >= '2019-05-23 00:00:00'::timestamp without time zone) AND (created_at < '2019-05-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_23_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_23_chunk (
    CONSTRAINT constraint_23 CHECK (((created_at >= '2015-04-02 00:00:00'::timestamp without time zone) AND (created_at < '2015-04-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_240_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_240_chunk (
    CONSTRAINT constraint_240 CHECK (((created_at >= '2019-05-30 00:00:00'::timestamp without time zone) AND (created_at < '2019-06-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_241_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_241_chunk (
    CONSTRAINT constraint_241 CHECK (((created_at >= '2019-06-06 00:00:00'::timestamp without time zone) AND (created_at < '2019-06-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_242_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_242_chunk (
    CONSTRAINT constraint_242 CHECK (((created_at >= '2019-06-13 00:00:00'::timestamp without time zone) AND (created_at < '2019-06-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_243_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_243_chunk (
    CONSTRAINT constraint_243 CHECK (((created_at >= '2019-06-20 00:00:00'::timestamp without time zone) AND (created_at < '2019-06-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_244_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_244_chunk (
    CONSTRAINT constraint_244 CHECK (((created_at >= '2019-06-27 00:00:00'::timestamp without time zone) AND (created_at < '2019-07-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_245_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_245_chunk (
    CONSTRAINT constraint_245 CHECK (((created_at >= '2019-07-04 00:00:00'::timestamp without time zone) AND (created_at < '2019-07-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_246_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_246_chunk (
    CONSTRAINT constraint_246 CHECK (((created_at >= '2019-07-11 00:00:00'::timestamp without time zone) AND (created_at < '2019-07-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_247_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_247_chunk (
    CONSTRAINT constraint_247 CHECK (((created_at >= '2019-07-18 00:00:00'::timestamp without time zone) AND (created_at < '2019-07-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_248_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_248_chunk (
    CONSTRAINT constraint_248 CHECK (((created_at >= '2019-07-25 00:00:00'::timestamp without time zone) AND (created_at < '2019-08-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_249_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_249_chunk (
    CONSTRAINT constraint_249 CHECK (((created_at >= '2019-08-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-08-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_24_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_24_chunk (
    CONSTRAINT constraint_24 CHECK (((created_at >= '2015-04-09 00:00:00'::timestamp without time zone) AND (created_at < '2015-04-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_250_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_250_chunk (
    CONSTRAINT constraint_250 CHECK (((created_at >= '2019-08-08 00:00:00'::timestamp without time zone) AND (created_at < '2019-08-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_251_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_251_chunk (
    CONSTRAINT constraint_251 CHECK (((created_at >= '2019-08-15 00:00:00'::timestamp without time zone) AND (created_at < '2019-08-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_252_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_252_chunk (
    CONSTRAINT constraint_252 CHECK (((created_at >= '2019-08-22 00:00:00'::timestamp without time zone) AND (created_at < '2019-08-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_253_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_253_chunk (
    CONSTRAINT constraint_253 CHECK (((created_at >= '2019-08-29 00:00:00'::timestamp without time zone) AND (created_at < '2019-09-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_254_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_254_chunk (
    CONSTRAINT constraint_254 CHECK (((created_at >= '2019-09-05 00:00:00'::timestamp without time zone) AND (created_at < '2019-09-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_255_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_255_chunk (
    CONSTRAINT constraint_255 CHECK (((created_at >= '2019-09-12 00:00:00'::timestamp without time zone) AND (created_at < '2019-09-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_256_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_256_chunk (
    CONSTRAINT constraint_256 CHECK (((created_at >= '2019-09-19 00:00:00'::timestamp without time zone) AND (created_at < '2019-09-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_257_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_257_chunk (
    CONSTRAINT constraint_257 CHECK (((created_at >= '2019-09-26 00:00:00'::timestamp without time zone) AND (created_at < '2019-10-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_258_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_258_chunk (
    CONSTRAINT constraint_258 CHECK (((created_at >= '2019-10-03 00:00:00'::timestamp without time zone) AND (created_at < '2019-10-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_259_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_259_chunk (
    CONSTRAINT constraint_259 CHECK (((created_at >= '2019-10-10 00:00:00'::timestamp without time zone) AND (created_at < '2019-10-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_25_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_25_chunk (
    CONSTRAINT constraint_25 CHECK (((created_at >= '2015-04-16 00:00:00'::timestamp without time zone) AND (created_at < '2015-04-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_260_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_260_chunk (
    CONSTRAINT constraint_260 CHECK (((created_at >= '2019-10-17 00:00:00'::timestamp without time zone) AND (created_at < '2019-10-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_261_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_261_chunk (
    CONSTRAINT constraint_261 CHECK (((created_at >= '2019-10-24 00:00:00'::timestamp without time zone) AND (created_at < '2019-10-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_262_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_262_chunk (
    CONSTRAINT constraint_262 CHECK (((created_at >= '2019-10-31 00:00:00'::timestamp without time zone) AND (created_at < '2019-11-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_263_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_263_chunk (
    CONSTRAINT constraint_263 CHECK (((created_at >= '2019-11-07 00:00:00'::timestamp without time zone) AND (created_at < '2019-11-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_264_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_264_chunk (
    CONSTRAINT constraint_264 CHECK (((created_at >= '2019-11-14 00:00:00'::timestamp without time zone) AND (created_at < '2019-11-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_265_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_265_chunk (
    CONSTRAINT constraint_265 CHECK (((created_at >= '2019-11-21 00:00:00'::timestamp without time zone) AND (created_at < '2019-11-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_266_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_266_chunk (
    CONSTRAINT constraint_266 CHECK (((created_at >= '2019-11-28 00:00:00'::timestamp without time zone) AND (created_at < '2019-12-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_267_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_267_chunk (
    CONSTRAINT constraint_267 CHECK (((created_at >= '2019-12-05 00:00:00'::timestamp without time zone) AND (created_at < '2019-12-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_268_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_268_chunk (
    CONSTRAINT constraint_268 CHECK (((created_at >= '2019-12-12 00:00:00'::timestamp without time zone) AND (created_at < '2019-12-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_269_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_269_chunk (
    CONSTRAINT constraint_269 CHECK (((created_at >= '2019-12-19 00:00:00'::timestamp without time zone) AND (created_at < '2019-12-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_26_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_26_chunk (
    CONSTRAINT constraint_26 CHECK (((created_at >= '2015-04-23 00:00:00'::timestamp without time zone) AND (created_at < '2015-04-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_270_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_270_chunk (
    CONSTRAINT constraint_270 CHECK (((created_at >= '2019-12-26 00:00:00'::timestamp without time zone) AND (created_at < '2020-01-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_271_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_271_chunk (
    CONSTRAINT constraint_271 CHECK (((created_at >= '2020-01-02 00:00:00'::timestamp without time zone) AND (created_at < '2020-01-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_272_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_272_chunk (
    CONSTRAINT constraint_272 CHECK (((created_at >= '2020-01-09 00:00:00'::timestamp without time zone) AND (created_at < '2020-01-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_273_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_273_chunk (
    CONSTRAINT constraint_273 CHECK (((created_at >= '2020-01-16 00:00:00'::timestamp without time zone) AND (created_at < '2020-01-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_274_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_274_chunk (
    CONSTRAINT constraint_274 CHECK (((created_at >= '2020-01-23 00:00:00'::timestamp without time zone) AND (created_at < '2020-01-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_275_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_275_chunk (
    CONSTRAINT constraint_275 CHECK (((created_at >= '2020-01-30 00:00:00'::timestamp without time zone) AND (created_at < '2020-02-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_276_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_276_chunk (
    CONSTRAINT constraint_276 CHECK (((created_at >= '2020-02-06 00:00:00'::timestamp without time zone) AND (created_at < '2020-02-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_277_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_277_chunk (
    CONSTRAINT constraint_277 CHECK (((created_at >= '2020-02-13 00:00:00'::timestamp without time zone) AND (created_at < '2020-02-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_278_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_278_chunk (
    CONSTRAINT constraint_278 CHECK (((created_at >= '2020-02-20 00:00:00'::timestamp without time zone) AND (created_at < '2020-02-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_279_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_279_chunk (
    CONSTRAINT constraint_279 CHECK (((created_at >= '2020-02-27 00:00:00'::timestamp without time zone) AND (created_at < '2020-03-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_27_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_27_chunk (
    CONSTRAINT constraint_27 CHECK (((created_at >= '2015-04-30 00:00:00'::timestamp without time zone) AND (created_at < '2015-05-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_280_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_280_chunk (
    CONSTRAINT constraint_280 CHECK (((created_at >= '2020-03-05 00:00:00'::timestamp without time zone) AND (created_at < '2020-03-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_281_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_281_chunk (
    CONSTRAINT constraint_281 CHECK (((created_at >= '2020-03-12 00:00:00'::timestamp without time zone) AND (created_at < '2020-03-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_282_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_282_chunk (
    CONSTRAINT constraint_282 CHECK (((created_at >= '2020-03-19 00:00:00'::timestamp without time zone) AND (created_at < '2020-03-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_283_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_283_chunk (
    CONSTRAINT constraint_283 CHECK (((created_at >= '2020-03-26 00:00:00'::timestamp without time zone) AND (created_at < '2020-04-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_284_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_284_chunk (
    CONSTRAINT constraint_284 CHECK (((created_at >= '2020-04-02 00:00:00'::timestamp without time zone) AND (created_at < '2020-04-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_285_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_285_chunk (
    CONSTRAINT constraint_285 CHECK (((created_at >= '2020-04-09 00:00:00'::timestamp without time zone) AND (created_at < '2020-04-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_286_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_286_chunk (
    CONSTRAINT constraint_286 CHECK (((created_at >= '2020-04-16 00:00:00'::timestamp without time zone) AND (created_at < '2020-04-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_287_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_287_chunk (
    CONSTRAINT constraint_287 CHECK (((created_at >= '2020-04-23 00:00:00'::timestamp without time zone) AND (created_at < '2020-04-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_288_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_288_chunk (
    CONSTRAINT constraint_288 CHECK (((created_at >= '2020-04-30 00:00:00'::timestamp without time zone) AND (created_at < '2020-05-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_289_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_289_chunk (
    CONSTRAINT constraint_289 CHECK (((created_at >= '2020-05-07 00:00:00'::timestamp without time zone) AND (created_at < '2020-05-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_28_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_28_chunk (
    CONSTRAINT constraint_28 CHECK (((created_at >= '2015-05-07 00:00:00'::timestamp without time zone) AND (created_at < '2015-05-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_290_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_290_chunk (
    CONSTRAINT constraint_290 CHECK (((created_at >= '2020-05-14 00:00:00'::timestamp without time zone) AND (created_at < '2020-05-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_291_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_291_chunk (
    CONSTRAINT constraint_291 CHECK (((created_at >= '2020-05-21 00:00:00'::timestamp without time zone) AND (created_at < '2020-05-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_292_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_292_chunk (
    CONSTRAINT constraint_292 CHECK (((created_at >= '2020-05-28 00:00:00'::timestamp without time zone) AND (created_at < '2020-06-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_293_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_293_chunk (
    CONSTRAINT constraint_293 CHECK (((created_at >= '2020-06-04 00:00:00'::timestamp without time zone) AND (created_at < '2020-06-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_294_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_294_chunk (
    CONSTRAINT constraint_294 CHECK (((created_at >= '2020-06-11 00:00:00'::timestamp without time zone) AND (created_at < '2020-06-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_295_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_295_chunk (
    CONSTRAINT constraint_295 CHECK (((created_at >= '2020-06-18 00:00:00'::timestamp without time zone) AND (created_at < '2020-06-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_296_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_296_chunk (
    CONSTRAINT constraint_296 CHECK (((created_at >= '2020-06-25 00:00:00'::timestamp without time zone) AND (created_at < '2020-07-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_297_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_297_chunk (
    CONSTRAINT constraint_297 CHECK (((created_at >= '2020-07-02 00:00:00'::timestamp without time zone) AND (created_at < '2020-07-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_298_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_298_chunk (
    CONSTRAINT constraint_298 CHECK (((created_at >= '2020-07-09 00:00:00'::timestamp without time zone) AND (created_at < '2020-07-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_299_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_299_chunk (
    CONSTRAINT constraint_299 CHECK (((created_at >= '2020-07-16 00:00:00'::timestamp without time zone) AND (created_at < '2020-07-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_29_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_29_chunk (
    CONSTRAINT constraint_29 CHECK (((created_at >= '2015-05-14 00:00:00'::timestamp without time zone) AND (created_at < '2015-05-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_2_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_2_chunk (
    CONSTRAINT constraint_2 CHECK (((created_at >= '2014-11-06 00:00:00'::timestamp without time zone) AND (created_at < '2014-11-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_300_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_300_chunk (
    CONSTRAINT constraint_300 CHECK (((created_at >= '2020-07-23 00:00:00'::timestamp without time zone) AND (created_at < '2020-07-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_301_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_301_chunk (
    CONSTRAINT constraint_301 CHECK (((created_at >= '2020-07-30 00:00:00'::timestamp without time zone) AND (created_at < '2020-08-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_302_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_302_chunk (
    CONSTRAINT constraint_302 CHECK (((created_at >= '2020-08-06 00:00:00'::timestamp without time zone) AND (created_at < '2020-08-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_303_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_303_chunk (
    CONSTRAINT constraint_303 CHECK (((created_at >= '2020-08-13 00:00:00'::timestamp without time zone) AND (created_at < '2020-08-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_304_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_304_chunk (
    CONSTRAINT constraint_304 CHECK (((created_at >= '2020-08-20 00:00:00'::timestamp without time zone) AND (created_at < '2020-08-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_305_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_305_chunk (
    CONSTRAINT constraint_305 CHECK (((created_at >= '2020-08-27 00:00:00'::timestamp without time zone) AND (created_at < '2020-09-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_306_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_306_chunk (
    CONSTRAINT constraint_306 CHECK (((created_at >= '2020-09-03 00:00:00'::timestamp without time zone) AND (created_at < '2020-09-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_307_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_307_chunk (
    CONSTRAINT constraint_307 CHECK (((created_at >= '2020-09-10 00:00:00'::timestamp without time zone) AND (created_at < '2020-09-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_308_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_308_chunk (
    CONSTRAINT constraint_308 CHECK (((created_at >= '2020-09-17 00:00:00'::timestamp without time zone) AND (created_at < '2020-09-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_309_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_309_chunk (
    CONSTRAINT constraint_309 CHECK (((created_at >= '2020-09-24 00:00:00'::timestamp without time zone) AND (created_at < '2020-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_30_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_30_chunk (
    CONSTRAINT constraint_30 CHECK (((created_at >= '2015-05-21 00:00:00'::timestamp without time zone) AND (created_at < '2015-05-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_310_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_310_chunk (
    CONSTRAINT constraint_310 CHECK (((created_at >= '2020-10-01 00:00:00'::timestamp without time zone) AND (created_at < '2020-10-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_311_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_311_chunk (
    CONSTRAINT constraint_311 CHECK (((created_at >= '2020-10-08 00:00:00'::timestamp without time zone) AND (created_at < '2020-10-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_312_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_312_chunk (
    CONSTRAINT constraint_312 CHECK (((created_at >= '2020-10-15 00:00:00'::timestamp without time zone) AND (created_at < '2020-10-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_313_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_313_chunk (
    CONSTRAINT constraint_313 CHECK (((created_at >= '2020-10-22 00:00:00'::timestamp without time zone) AND (created_at < '2020-10-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_314_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_314_chunk (
    CONSTRAINT constraint_314 CHECK (((created_at >= '2020-10-29 00:00:00'::timestamp without time zone) AND (created_at < '2020-11-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_315_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_315_chunk (
    CONSTRAINT constraint_315 CHECK (((created_at >= '2020-11-05 00:00:00'::timestamp without time zone) AND (created_at < '2020-11-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_316_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_316_chunk (
    CONSTRAINT constraint_316 CHECK (((created_at >= '2020-11-12 00:00:00'::timestamp without time zone) AND (created_at < '2020-11-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_317_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_317_chunk (
    CONSTRAINT constraint_317 CHECK (((created_at >= '2020-11-19 00:00:00'::timestamp without time zone) AND (created_at < '2020-11-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_318_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_318_chunk (
    CONSTRAINT constraint_318 CHECK (((created_at >= '2020-11-26 00:00:00'::timestamp without time zone) AND (created_at < '2020-12-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_319_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_319_chunk (
    CONSTRAINT constraint_319 CHECK (((created_at >= '2020-12-03 00:00:00'::timestamp without time zone) AND (created_at < '2020-12-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_31_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_31_chunk (
    CONSTRAINT constraint_31 CHECK (((created_at >= '2015-05-28 00:00:00'::timestamp without time zone) AND (created_at < '2015-06-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_320_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_320_chunk (
    CONSTRAINT constraint_320 CHECK (((created_at >= '2020-12-10 00:00:00'::timestamp without time zone) AND (created_at < '2020-12-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_321_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_321_chunk (
    CONSTRAINT constraint_321 CHECK (((created_at >= '2020-12-17 00:00:00'::timestamp without time zone) AND (created_at < '2020-12-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_322_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_322_chunk (
    CONSTRAINT constraint_322 CHECK (((created_at >= '2020-12-24 00:00:00'::timestamp without time zone) AND (created_at < '2020-12-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_323_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_323_chunk (
    CONSTRAINT constraint_323 CHECK (((created_at >= '2020-12-31 00:00:00'::timestamp without time zone) AND (created_at < '2021-01-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_324_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_324_chunk (
    CONSTRAINT constraint_324 CHECK (((created_at >= '2021-01-07 00:00:00'::timestamp without time zone) AND (created_at < '2021-01-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_325_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_325_chunk (
    CONSTRAINT constraint_325 CHECK (((created_at >= '2021-01-14 00:00:00'::timestamp without time zone) AND (created_at < '2021-01-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_326_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_326_chunk (
    CONSTRAINT constraint_326 CHECK (((created_at >= '2021-01-21 00:00:00'::timestamp without time zone) AND (created_at < '2021-01-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_327_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_327_chunk (
    CONSTRAINT constraint_327 CHECK (((created_at >= '2021-01-28 00:00:00'::timestamp without time zone) AND (created_at < '2021-02-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_328_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_328_chunk (
    CONSTRAINT constraint_328 CHECK (((created_at >= '2021-02-04 00:00:00'::timestamp without time zone) AND (created_at < '2021-02-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_329_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_329_chunk (
    CONSTRAINT constraint_329 CHECK (((created_at >= '2021-02-11 00:00:00'::timestamp without time zone) AND (created_at < '2021-02-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_32_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_32_chunk (
    CONSTRAINT constraint_32 CHECK (((created_at >= '2015-06-04 00:00:00'::timestamp without time zone) AND (created_at < '2015-06-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_330_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_330_chunk (
    CONSTRAINT constraint_330 CHECK (((created_at >= '2021-02-18 00:00:00'::timestamp without time zone) AND (created_at < '2021-02-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_331_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_331_chunk (
    CONSTRAINT constraint_331 CHECK (((created_at >= '2021-02-25 00:00:00'::timestamp without time zone) AND (created_at < '2021-03-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_332_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_332_chunk (
    CONSTRAINT constraint_332 CHECK (((created_at >= '2021-03-04 00:00:00'::timestamp without time zone) AND (created_at < '2021-03-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_333_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_333_chunk (
    CONSTRAINT constraint_333 CHECK (((created_at >= '2021-03-11 00:00:00'::timestamp without time zone) AND (created_at < '2021-03-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_334_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_334_chunk (
    CONSTRAINT constraint_334 CHECK (((created_at >= '2021-03-18 00:00:00'::timestamp without time zone) AND (created_at < '2021-03-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_335_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_335_chunk (
    CONSTRAINT constraint_335 CHECK (((created_at >= '2021-03-25 00:00:00'::timestamp without time zone) AND (created_at < '2021-04-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_336_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_336_chunk (
    CONSTRAINT constraint_336 CHECK (((created_at >= '2021-04-01 00:00:00'::timestamp without time zone) AND (created_at < '2021-04-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_337_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_337_chunk (
    CONSTRAINT constraint_337 CHECK (((created_at >= '2021-04-08 00:00:00'::timestamp without time zone) AND (created_at < '2021-04-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_338_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_338_chunk (
    CONSTRAINT constraint_338 CHECK (((created_at >= '2021-04-15 00:00:00'::timestamp without time zone) AND (created_at < '2021-04-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_339_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_339_chunk (
    CONSTRAINT constraint_339 CHECK (((created_at >= '2021-04-22 00:00:00'::timestamp without time zone) AND (created_at < '2021-04-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_33_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_33_chunk (
    CONSTRAINT constraint_33 CHECK (((created_at >= '2015-06-11 00:00:00'::timestamp without time zone) AND (created_at < '2015-06-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_340_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_340_chunk (
    CONSTRAINT constraint_340 CHECK (((created_at >= '2021-04-29 00:00:00'::timestamp without time zone) AND (created_at < '2021-05-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_341_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_341_chunk (
    CONSTRAINT constraint_341 CHECK (((created_at >= '2021-05-06 00:00:00'::timestamp without time zone) AND (created_at < '2021-05-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_342_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_342_chunk (
    CONSTRAINT constraint_342 CHECK (((created_at >= '2021-05-13 00:00:00'::timestamp without time zone) AND (created_at < '2021-05-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_343_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_343_chunk (
    CONSTRAINT constraint_343 CHECK (((created_at >= '2021-05-20 00:00:00'::timestamp without time zone) AND (created_at < '2021-05-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_344_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_344_chunk (
    CONSTRAINT constraint_344 CHECK (((created_at >= '2021-05-27 00:00:00'::timestamp without time zone) AND (created_at < '2021-06-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_345_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_345_chunk (
    CONSTRAINT constraint_345 CHECK (((created_at >= '2021-06-03 00:00:00'::timestamp without time zone) AND (created_at < '2021-06-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_346_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_346_chunk (
    CONSTRAINT constraint_346 CHECK (((created_at >= '2021-06-10 00:00:00'::timestamp without time zone) AND (created_at < '2021-06-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_347_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_347_chunk (
    CONSTRAINT constraint_347 CHECK (((created_at >= '2021-06-17 00:00:00'::timestamp without time zone) AND (created_at < '2021-06-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_348_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_348_chunk (
    CONSTRAINT constraint_348 CHECK (((created_at >= '2021-06-24 00:00:00'::timestamp without time zone) AND (created_at < '2021-07-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_349_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_349_chunk (
    CONSTRAINT constraint_349 CHECK (((created_at >= '2021-07-01 00:00:00'::timestamp without time zone) AND (created_at < '2021-07-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_34_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_34_chunk (
    CONSTRAINT constraint_34 CHECK (((created_at >= '2015-06-18 00:00:00'::timestamp without time zone) AND (created_at < '2015-06-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_350_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_350_chunk (
    CONSTRAINT constraint_350 CHECK (((created_at >= '2021-07-08 00:00:00'::timestamp without time zone) AND (created_at < '2021-07-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_351_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_351_chunk (
    CONSTRAINT constraint_351 CHECK (((created_at >= '2021-07-15 00:00:00'::timestamp without time zone) AND (created_at < '2021-07-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_352_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_352_chunk (
    CONSTRAINT constraint_352 CHECK (((created_at >= '2021-07-22 00:00:00'::timestamp without time zone) AND (created_at < '2021-07-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_353_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_353_chunk (
    CONSTRAINT constraint_353 CHECK (((created_at >= '2021-07-29 00:00:00'::timestamp without time zone) AND (created_at < '2021-08-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_354_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_354_chunk (
    CONSTRAINT constraint_354 CHECK (((created_at >= '2021-08-05 00:00:00'::timestamp without time zone) AND (created_at < '2021-08-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_355_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_355_chunk (
    CONSTRAINT constraint_355 CHECK (((created_at >= '2021-08-12 00:00:00'::timestamp without time zone) AND (created_at < '2021-08-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_356_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_356_chunk (
    CONSTRAINT constraint_356 CHECK (((created_at >= '2021-08-19 00:00:00'::timestamp without time zone) AND (created_at < '2021-08-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_357_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_357_chunk (
    CONSTRAINT constraint_357 CHECK (((created_at >= '2021-08-26 00:00:00'::timestamp without time zone) AND (created_at < '2021-09-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_358_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_358_chunk (
    CONSTRAINT constraint_358 CHECK (((created_at >= '2021-09-02 00:00:00'::timestamp without time zone) AND (created_at < '2021-09-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_359_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_359_chunk (
    CONSTRAINT constraint_359 CHECK (((created_at >= '2021-09-09 00:00:00'::timestamp without time zone) AND (created_at < '2021-09-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_35_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_35_chunk (
    CONSTRAINT constraint_35 CHECK (((created_at >= '2015-06-25 00:00:00'::timestamp without time zone) AND (created_at < '2015-07-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_360_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_360_chunk (
    CONSTRAINT constraint_360 CHECK (((created_at >= '2021-09-16 00:00:00'::timestamp without time zone) AND (created_at < '2021-09-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_361_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_361_chunk (
    CONSTRAINT constraint_361 CHECK (((created_at >= '2021-09-23 00:00:00'::timestamp without time zone) AND (created_at < '2021-09-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_362_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_362_chunk (
    CONSTRAINT constraint_362 CHECK (((created_at >= '2021-09-30 00:00:00'::timestamp without time zone) AND (created_at < '2021-10-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_363_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_363_chunk (
    CONSTRAINT constraint_363 CHECK (((created_at >= '2021-10-07 00:00:00'::timestamp without time zone) AND (created_at < '2021-10-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_364_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_364_chunk (
    CONSTRAINT constraint_364 CHECK (((created_at >= '2021-10-14 00:00:00'::timestamp without time zone) AND (created_at < '2021-10-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_365_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_365_chunk (
    CONSTRAINT constraint_365 CHECK (((created_at >= '2021-10-21 00:00:00'::timestamp without time zone) AND (created_at < '2021-10-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_366_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_366_chunk (
    CONSTRAINT constraint_366 CHECK (((created_at >= '2021-10-28 00:00:00'::timestamp without time zone) AND (created_at < '2021-11-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_367_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_367_chunk (
    CONSTRAINT constraint_367 CHECK (((created_at >= '2021-11-04 00:00:00'::timestamp without time zone) AND (created_at < '2021-11-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_368_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_368_chunk (
    CONSTRAINT constraint_368 CHECK (((created_at >= '2021-11-11 00:00:00'::timestamp without time zone) AND (created_at < '2021-11-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_369_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_369_chunk (
    CONSTRAINT constraint_369 CHECK (((created_at >= '2021-11-18 00:00:00'::timestamp without time zone) AND (created_at < '2021-11-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_36_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_36_chunk (
    CONSTRAINT constraint_36 CHECK (((created_at >= '2015-07-02 00:00:00'::timestamp without time zone) AND (created_at < '2015-07-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_370_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_370_chunk (
    CONSTRAINT constraint_370 CHECK (((created_at >= '2021-11-25 00:00:00'::timestamp without time zone) AND (created_at < '2021-12-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_371_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_371_chunk (
    CONSTRAINT constraint_371 CHECK (((created_at >= '2021-12-02 00:00:00'::timestamp without time zone) AND (created_at < '2021-12-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_372_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_372_chunk (
    CONSTRAINT constraint_372 CHECK (((created_at >= '2021-12-09 00:00:00'::timestamp without time zone) AND (created_at < '2021-12-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_373_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_373_chunk (
    CONSTRAINT constraint_373 CHECK (((created_at >= '2021-12-16 00:00:00'::timestamp without time zone) AND (created_at < '2021-12-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_374_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_374_chunk (
    CONSTRAINT constraint_374 CHECK (((created_at >= '2021-12-23 00:00:00'::timestamp without time zone) AND (created_at < '2021-12-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_375_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_375_chunk (
    CONSTRAINT constraint_375 CHECK (((created_at >= '2021-12-30 00:00:00'::timestamp without time zone) AND (created_at < '2022-01-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_376_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_376_chunk (
    CONSTRAINT constraint_376 CHECK (((created_at >= '2022-01-06 00:00:00'::timestamp without time zone) AND (created_at < '2022-01-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_37_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_37_chunk (
    CONSTRAINT constraint_37 CHECK (((created_at >= '2015-07-09 00:00:00'::timestamp without time zone) AND (created_at < '2015-07-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_38_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_38_chunk (
    CONSTRAINT constraint_38 CHECK (((created_at >= '2015-07-16 00:00:00'::timestamp without time zone) AND (created_at < '2015-07-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_39_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_39_chunk (
    CONSTRAINT constraint_39 CHECK (((created_at >= '2015-07-23 00:00:00'::timestamp without time zone) AND (created_at < '2015-07-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_3_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_3_chunk (
    CONSTRAINT constraint_3 CHECK (((created_at >= '2014-11-13 00:00:00'::timestamp without time zone) AND (created_at < '2014-11-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_40_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_40_chunk (
    CONSTRAINT constraint_40 CHECK (((created_at >= '2015-07-30 00:00:00'::timestamp without time zone) AND (created_at < '2015-08-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_41_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_41_chunk (
    CONSTRAINT constraint_41 CHECK (((created_at >= '2015-08-06 00:00:00'::timestamp without time zone) AND (created_at < '2015-08-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_42_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_42_chunk (
    CONSTRAINT constraint_42 CHECK (((created_at >= '2015-08-13 00:00:00'::timestamp without time zone) AND (created_at < '2015-08-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_43_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_43_chunk (
    CONSTRAINT constraint_43 CHECK (((created_at >= '2015-08-20 00:00:00'::timestamp without time zone) AND (created_at < '2015-08-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_44_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_44_chunk (
    CONSTRAINT constraint_44 CHECK (((created_at >= '2015-08-27 00:00:00'::timestamp without time zone) AND (created_at < '2015-09-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_45_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_45_chunk (
    CONSTRAINT constraint_45 CHECK (((created_at >= '2015-09-03 00:00:00'::timestamp without time zone) AND (created_at < '2015-09-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_46_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_46_chunk (
    CONSTRAINT constraint_46 CHECK (((created_at >= '2015-09-10 00:00:00'::timestamp without time zone) AND (created_at < '2015-09-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_47_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_47_chunk (
    CONSTRAINT constraint_47 CHECK (((created_at >= '2015-09-17 00:00:00'::timestamp without time zone) AND (created_at < '2015-09-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_48_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_48_chunk (
    CONSTRAINT constraint_48 CHECK (((created_at >= '2015-09-24 00:00:00'::timestamp without time zone) AND (created_at < '2015-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_49_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_49_chunk (
    CONSTRAINT constraint_49 CHECK (((created_at >= '2015-10-01 00:00:00'::timestamp without time zone) AND (created_at < '2015-10-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_4_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_4_chunk (
    CONSTRAINT constraint_4 CHECK (((created_at >= '2014-11-20 00:00:00'::timestamp without time zone) AND (created_at < '2014-11-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_50_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_50_chunk (
    CONSTRAINT constraint_50 CHECK (((created_at >= '2015-10-08 00:00:00'::timestamp without time zone) AND (created_at < '2015-10-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_51_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_51_chunk (
    CONSTRAINT constraint_51 CHECK (((created_at >= '2015-10-15 00:00:00'::timestamp without time zone) AND (created_at < '2015-10-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_52_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_52_chunk (
    CONSTRAINT constraint_52 CHECK (((created_at >= '2015-10-22 00:00:00'::timestamp without time zone) AND (created_at < '2015-10-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_53_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_53_chunk (
    CONSTRAINT constraint_53 CHECK (((created_at >= '2015-10-29 00:00:00'::timestamp without time zone) AND (created_at < '2015-11-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_54_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_54_chunk (
    CONSTRAINT constraint_54 CHECK (((created_at >= '2015-11-05 00:00:00'::timestamp without time zone) AND (created_at < '2015-11-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_55_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_55_chunk (
    CONSTRAINT constraint_55 CHECK (((created_at >= '2015-11-12 00:00:00'::timestamp without time zone) AND (created_at < '2015-11-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_56_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_56_chunk (
    CONSTRAINT constraint_56 CHECK (((created_at >= '2015-11-19 00:00:00'::timestamp without time zone) AND (created_at < '2015-11-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_57_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_57_chunk (
    CONSTRAINT constraint_57 CHECK (((created_at >= '2015-11-26 00:00:00'::timestamp without time zone) AND (created_at < '2015-12-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_58_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_58_chunk (
    CONSTRAINT constraint_58 CHECK (((created_at >= '2015-12-03 00:00:00'::timestamp without time zone) AND (created_at < '2015-12-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_59_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_59_chunk (
    CONSTRAINT constraint_59 CHECK (((created_at >= '2015-12-10 00:00:00'::timestamp without time zone) AND (created_at < '2015-12-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_5_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_5_chunk (
    CONSTRAINT constraint_5 CHECK (((created_at >= '2014-11-27 00:00:00'::timestamp without time zone) AND (created_at < '2014-12-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_60_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_60_chunk (
    CONSTRAINT constraint_60 CHECK (((created_at >= '2015-12-17 00:00:00'::timestamp without time zone) AND (created_at < '2015-12-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_61_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_61_chunk (
    CONSTRAINT constraint_61 CHECK (((created_at >= '2015-12-24 00:00:00'::timestamp without time zone) AND (created_at < '2015-12-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_62_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_62_chunk (
    CONSTRAINT constraint_62 CHECK (((created_at >= '2015-12-31 00:00:00'::timestamp without time zone) AND (created_at < '2016-01-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_63_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_63_chunk (
    CONSTRAINT constraint_63 CHECK (((created_at >= '2016-01-07 00:00:00'::timestamp without time zone) AND (created_at < '2016-01-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_64_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_64_chunk (
    CONSTRAINT constraint_64 CHECK (((created_at >= '2016-01-14 00:00:00'::timestamp without time zone) AND (created_at < '2016-01-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_65_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_65_chunk (
    CONSTRAINT constraint_65 CHECK (((created_at >= '2016-01-21 00:00:00'::timestamp without time zone) AND (created_at < '2016-01-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_66_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_66_chunk (
    CONSTRAINT constraint_66 CHECK (((created_at >= '2016-01-28 00:00:00'::timestamp without time zone) AND (created_at < '2016-02-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_67_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_67_chunk (
    CONSTRAINT constraint_67 CHECK (((created_at >= '2016-02-04 00:00:00'::timestamp without time zone) AND (created_at < '2016-02-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_68_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_68_chunk (
    CONSTRAINT constraint_68 CHECK (((created_at >= '2016-02-11 00:00:00'::timestamp without time zone) AND (created_at < '2016-02-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_69_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_69_chunk (
    CONSTRAINT constraint_69 CHECK (((created_at >= '2016-02-18 00:00:00'::timestamp without time zone) AND (created_at < '2016-02-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_6_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_6_chunk (
    CONSTRAINT constraint_6 CHECK (((created_at >= '2014-12-04 00:00:00'::timestamp without time zone) AND (created_at < '2014-12-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_70_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_70_chunk (
    CONSTRAINT constraint_70 CHECK (((created_at >= '2016-02-25 00:00:00'::timestamp without time zone) AND (created_at < '2016-03-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_71_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_71_chunk (
    CONSTRAINT constraint_71 CHECK (((created_at >= '2016-03-03 00:00:00'::timestamp without time zone) AND (created_at < '2016-03-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_72_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_72_chunk (
    CONSTRAINT constraint_72 CHECK (((created_at >= '2016-03-10 00:00:00'::timestamp without time zone) AND (created_at < '2016-03-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_73_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_73_chunk (
    CONSTRAINT constraint_73 CHECK (((created_at >= '2016-03-17 00:00:00'::timestamp without time zone) AND (created_at < '2016-03-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_74_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_74_chunk (
    CONSTRAINT constraint_74 CHECK (((created_at >= '2016-03-24 00:00:00'::timestamp without time zone) AND (created_at < '2016-03-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_75_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_75_chunk (
    CONSTRAINT constraint_75 CHECK (((created_at >= '2016-03-31 00:00:00'::timestamp without time zone) AND (created_at < '2016-04-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_76_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_76_chunk (
    CONSTRAINT constraint_76 CHECK (((created_at >= '2016-04-07 00:00:00'::timestamp without time zone) AND (created_at < '2016-04-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_77_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_77_chunk (
    CONSTRAINT constraint_77 CHECK (((created_at >= '2016-04-14 00:00:00'::timestamp without time zone) AND (created_at < '2016-04-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_78_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_78_chunk (
    CONSTRAINT constraint_78 CHECK (((created_at >= '2016-04-21 00:00:00'::timestamp without time zone) AND (created_at < '2016-04-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_79_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_79_chunk (
    CONSTRAINT constraint_79 CHECK (((created_at >= '2016-04-28 00:00:00'::timestamp without time zone) AND (created_at < '2016-05-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_7_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_7_chunk (
    CONSTRAINT constraint_7 CHECK (((created_at >= '2014-12-11 00:00:00'::timestamp without time zone) AND (created_at < '2014-12-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_80_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_80_chunk (
    CONSTRAINT constraint_80 CHECK (((created_at >= '2016-05-05 00:00:00'::timestamp without time zone) AND (created_at < '2016-05-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_81_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_81_chunk (
    CONSTRAINT constraint_81 CHECK (((created_at >= '2016-05-12 00:00:00'::timestamp without time zone) AND (created_at < '2016-05-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_82_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_82_chunk (
    CONSTRAINT constraint_82 CHECK (((created_at >= '2016-05-19 00:00:00'::timestamp without time zone) AND (created_at < '2016-05-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_83_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_83_chunk (
    CONSTRAINT constraint_83 CHECK (((created_at >= '2016-05-26 00:00:00'::timestamp without time zone) AND (created_at < '2016-06-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_84_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_84_chunk (
    CONSTRAINT constraint_84 CHECK (((created_at >= '2016-06-02 00:00:00'::timestamp without time zone) AND (created_at < '2016-06-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_85_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_85_chunk (
    CONSTRAINT constraint_85 CHECK (((created_at >= '2016-06-09 00:00:00'::timestamp without time zone) AND (created_at < '2016-06-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_86_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_86_chunk (
    CONSTRAINT constraint_86 CHECK (((created_at >= '2016-06-16 00:00:00'::timestamp without time zone) AND (created_at < '2016-06-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_87_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_87_chunk (
    CONSTRAINT constraint_87 CHECK (((created_at >= '2016-06-23 00:00:00'::timestamp without time zone) AND (created_at < '2016-06-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_88_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_88_chunk (
    CONSTRAINT constraint_88 CHECK (((created_at >= '2016-06-30 00:00:00'::timestamp without time zone) AND (created_at < '2016-07-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_89_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_89_chunk (
    CONSTRAINT constraint_89 CHECK (((created_at >= '2016-07-07 00:00:00'::timestamp without time zone) AND (created_at < '2016-07-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_8_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_8_chunk (
    CONSTRAINT constraint_8 CHECK (((created_at >= '2014-12-18 00:00:00'::timestamp without time zone) AND (created_at < '2014-12-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_90_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_90_chunk (
    CONSTRAINT constraint_90 CHECK (((created_at >= '2016-07-14 00:00:00'::timestamp without time zone) AND (created_at < '2016-07-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_91_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_91_chunk (
    CONSTRAINT constraint_91 CHECK (((created_at >= '2016-07-21 00:00:00'::timestamp without time zone) AND (created_at < '2016-07-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_92_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_92_chunk (
    CONSTRAINT constraint_92 CHECK (((created_at >= '2016-07-28 00:00:00'::timestamp without time zone) AND (created_at < '2016-08-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_93_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_93_chunk (
    CONSTRAINT constraint_93 CHECK (((created_at >= '2016-08-04 00:00:00'::timestamp without time zone) AND (created_at < '2016-08-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_94_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_94_chunk (
    CONSTRAINT constraint_94 CHECK (((created_at >= '2016-08-11 00:00:00'::timestamp without time zone) AND (created_at < '2016-08-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_95_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_95_chunk (
    CONSTRAINT constraint_95 CHECK (((created_at >= '2016-08-18 00:00:00'::timestamp without time zone) AND (created_at < '2016-08-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_96_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_96_chunk (
    CONSTRAINT constraint_96 CHECK (((created_at >= '2016-08-25 00:00:00'::timestamp without time zone) AND (created_at < '2016-09-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_97_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_97_chunk (
    CONSTRAINT constraint_97 CHECK (((created_at >= '2016-09-01 00:00:00'::timestamp without time zone) AND (created_at < '2016-09-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_98_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_98_chunk (
    CONSTRAINT constraint_98 CHECK (((created_at >= '2016-09-08 00:00:00'::timestamp without time zone) AND (created_at < '2016-09-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_99_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_99_chunk (
    CONSTRAINT constraint_99 CHECK (((created_at >= '2016-09-15 00:00:00'::timestamp without time zone) AND (created_at < '2016-09-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_9_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_9_chunk (
    CONSTRAINT constraint_9 CHECK (((created_at >= '2014-12-25 00:00:00'::timestamp without time zone) AND (created_at < '2015-01-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: _hyper_1_100_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_100_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_100_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_100_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_100_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_100_chunk USING btree (country);


--
-- Name: _hyper_1_100_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_100_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_100_chunk USING btree (production_type);


--
-- Name: _hyper_1_100_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_100_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_100_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_101_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_101_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_101_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_101_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_101_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_101_chunk USING btree (country);


--
-- Name: _hyper_1_101_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_101_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_101_chunk USING btree (production_type);


--
-- Name: _hyper_1_101_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_101_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_101_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_102_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_102_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_102_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_102_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_102_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_102_chunk USING btree (country);


--
-- Name: _hyper_1_102_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_102_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_102_chunk USING btree (production_type);


--
-- Name: _hyper_1_102_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_102_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_102_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_103_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_103_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_103_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_103_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_103_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_103_chunk USING btree (country);


--
-- Name: _hyper_1_103_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_103_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_103_chunk USING btree (production_type);


--
-- Name: _hyper_1_103_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_103_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_103_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_104_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_104_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_104_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_104_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_104_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_104_chunk USING btree (country);


--
-- Name: _hyper_1_104_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_104_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_104_chunk USING btree (production_type);


--
-- Name: _hyper_1_104_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_104_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_104_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_105_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_105_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_105_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_105_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_105_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_105_chunk USING btree (country);


--
-- Name: _hyper_1_105_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_105_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_105_chunk USING btree (production_type);


--
-- Name: _hyper_1_105_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_105_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_105_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_106_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_106_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_106_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_106_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_106_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_106_chunk USING btree (country);


--
-- Name: _hyper_1_106_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_106_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_106_chunk USING btree (production_type);


--
-- Name: _hyper_1_106_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_106_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_106_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_107_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_107_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_107_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_107_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_107_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_107_chunk USING btree (country);


--
-- Name: _hyper_1_107_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_107_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_107_chunk USING btree (production_type);


--
-- Name: _hyper_1_107_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_107_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_107_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_108_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_108_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_108_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_108_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_108_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_108_chunk USING btree (country);


--
-- Name: _hyper_1_108_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_108_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_108_chunk USING btree (production_type);


--
-- Name: _hyper_1_108_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_108_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_108_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_109_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_109_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_109_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_109_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_109_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_109_chunk USING btree (country);


--
-- Name: _hyper_1_109_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_109_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_109_chunk USING btree (production_type);


--
-- Name: _hyper_1_109_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_109_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_109_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_10_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_10_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_10_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_10_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_10_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_10_chunk USING btree (country);


--
-- Name: _hyper_1_10_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_10_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_10_chunk USING btree (production_type);


--
-- Name: _hyper_1_10_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_10_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_10_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_110_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_110_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_110_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_110_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_110_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_110_chunk USING btree (country);


--
-- Name: _hyper_1_110_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_110_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_110_chunk USING btree (production_type);


--
-- Name: _hyper_1_110_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_110_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_110_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_111_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_111_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_111_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_111_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_111_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_111_chunk USING btree (country);


--
-- Name: _hyper_1_111_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_111_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_111_chunk USING btree (production_type);


--
-- Name: _hyper_1_111_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_111_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_111_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_112_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_112_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_112_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_112_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_112_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_112_chunk USING btree (country);


--
-- Name: _hyper_1_112_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_112_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_112_chunk USING btree (production_type);


--
-- Name: _hyper_1_112_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_112_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_112_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_113_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_113_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_113_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_113_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_113_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_113_chunk USING btree (country);


--
-- Name: _hyper_1_113_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_113_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_113_chunk USING btree (production_type);


--
-- Name: _hyper_1_113_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_113_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_113_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_114_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_114_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_114_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_114_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_114_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_114_chunk USING btree (country);


--
-- Name: _hyper_1_114_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_114_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_114_chunk USING btree (production_type);


--
-- Name: _hyper_1_114_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_114_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_114_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_115_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_115_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_115_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_115_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_115_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_115_chunk USING btree (country);


--
-- Name: _hyper_1_115_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_115_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_115_chunk USING btree (production_type);


--
-- Name: _hyper_1_115_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_115_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_115_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_116_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_116_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_116_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_116_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_116_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_116_chunk USING btree (country);


--
-- Name: _hyper_1_116_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_116_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_116_chunk USING btree (production_type);


--
-- Name: _hyper_1_116_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_116_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_116_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_117_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_117_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_117_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_117_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_117_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_117_chunk USING btree (country);


--
-- Name: _hyper_1_117_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_117_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_117_chunk USING btree (production_type);


--
-- Name: _hyper_1_117_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_117_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_117_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_118_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_118_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_118_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_118_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_118_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_118_chunk USING btree (country);


--
-- Name: _hyper_1_118_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_118_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_118_chunk USING btree (production_type);


--
-- Name: _hyper_1_118_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_118_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_118_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_119_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_119_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_119_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_119_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_119_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_119_chunk USING btree (country);


--
-- Name: _hyper_1_119_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_119_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_119_chunk USING btree (production_type);


--
-- Name: _hyper_1_119_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_119_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_119_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_11_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_11_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_11_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_11_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_11_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_11_chunk USING btree (country);


--
-- Name: _hyper_1_11_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_11_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_11_chunk USING btree (production_type);


--
-- Name: _hyper_1_11_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_11_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_11_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_120_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_120_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_120_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_120_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_120_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_120_chunk USING btree (country);


--
-- Name: _hyper_1_120_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_120_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_120_chunk USING btree (production_type);


--
-- Name: _hyper_1_120_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_120_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_120_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_121_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_121_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_121_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_121_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_121_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_121_chunk USING btree (country);


--
-- Name: _hyper_1_121_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_121_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_121_chunk USING btree (production_type);


--
-- Name: _hyper_1_121_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_121_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_121_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_122_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_122_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_122_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_122_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_122_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_122_chunk USING btree (country);


--
-- Name: _hyper_1_122_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_122_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_122_chunk USING btree (production_type);


--
-- Name: _hyper_1_122_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_122_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_122_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_123_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_123_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_123_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_123_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_123_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_123_chunk USING btree (country);


--
-- Name: _hyper_1_123_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_123_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_123_chunk USING btree (production_type);


--
-- Name: _hyper_1_123_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_123_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_123_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_124_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_124_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_124_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_124_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_124_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_124_chunk USING btree (country);


--
-- Name: _hyper_1_124_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_124_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_124_chunk USING btree (production_type);


--
-- Name: _hyper_1_124_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_124_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_124_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_125_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_125_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_125_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_125_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_125_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_125_chunk USING btree (country);


--
-- Name: _hyper_1_125_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_125_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_125_chunk USING btree (production_type);


--
-- Name: _hyper_1_125_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_125_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_125_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_126_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_126_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_126_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_126_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_126_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_126_chunk USING btree (country);


--
-- Name: _hyper_1_126_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_126_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_126_chunk USING btree (production_type);


--
-- Name: _hyper_1_126_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_126_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_126_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_127_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_127_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_127_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_127_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_127_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_127_chunk USING btree (country);


--
-- Name: _hyper_1_127_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_127_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_127_chunk USING btree (production_type);


--
-- Name: _hyper_1_127_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_127_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_127_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_128_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_128_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_128_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_128_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_128_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_128_chunk USING btree (country);


--
-- Name: _hyper_1_128_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_128_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_128_chunk USING btree (production_type);


--
-- Name: _hyper_1_128_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_128_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_128_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_129_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_129_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_129_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_129_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_129_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_129_chunk USING btree (country);


--
-- Name: _hyper_1_129_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_129_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_129_chunk USING btree (production_type);


--
-- Name: _hyper_1_129_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_129_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_129_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_12_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_12_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_12_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_12_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_12_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_12_chunk USING btree (country);


--
-- Name: _hyper_1_12_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_12_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_12_chunk USING btree (production_type);


--
-- Name: _hyper_1_12_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_12_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_12_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_130_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_130_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_130_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_130_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_130_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_130_chunk USING btree (country);


--
-- Name: _hyper_1_130_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_130_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_130_chunk USING btree (production_type);


--
-- Name: _hyper_1_130_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_130_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_130_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_131_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_131_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_131_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_131_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_131_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_131_chunk USING btree (country);


--
-- Name: _hyper_1_131_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_131_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_131_chunk USING btree (production_type);


--
-- Name: _hyper_1_131_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_131_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_131_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_132_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_132_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_132_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_132_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_132_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_132_chunk USING btree (country);


--
-- Name: _hyper_1_132_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_132_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_132_chunk USING btree (production_type);


--
-- Name: _hyper_1_132_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_132_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_132_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_133_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_133_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_133_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_133_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_133_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_133_chunk USING btree (country);


--
-- Name: _hyper_1_133_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_133_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_133_chunk USING btree (production_type);


--
-- Name: _hyper_1_133_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_133_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_133_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_134_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_134_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_134_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_134_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_134_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_134_chunk USING btree (country);


--
-- Name: _hyper_1_134_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_134_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_134_chunk USING btree (production_type);


--
-- Name: _hyper_1_134_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_134_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_134_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_135_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_135_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_135_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_135_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_135_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_135_chunk USING btree (country);


--
-- Name: _hyper_1_135_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_135_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_135_chunk USING btree (production_type);


--
-- Name: _hyper_1_135_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_135_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_135_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_136_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_136_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_136_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_136_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_136_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_136_chunk USING btree (country);


--
-- Name: _hyper_1_136_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_136_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_136_chunk USING btree (production_type);


--
-- Name: _hyper_1_136_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_136_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_136_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_137_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_137_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_137_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_137_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_137_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_137_chunk USING btree (country);


--
-- Name: _hyper_1_137_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_137_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_137_chunk USING btree (production_type);


--
-- Name: _hyper_1_137_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_137_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_137_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_138_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_138_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_138_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_138_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_138_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_138_chunk USING btree (country);


--
-- Name: _hyper_1_138_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_138_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_138_chunk USING btree (production_type);


--
-- Name: _hyper_1_138_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_138_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_138_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_139_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_139_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_139_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_139_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_139_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_139_chunk USING btree (country);


--
-- Name: _hyper_1_139_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_139_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_139_chunk USING btree (production_type);


--
-- Name: _hyper_1_139_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_139_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_139_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_13_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_13_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_13_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_13_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_13_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_13_chunk USING btree (country);


--
-- Name: _hyper_1_13_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_13_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_13_chunk USING btree (production_type);


--
-- Name: _hyper_1_13_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_13_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_13_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_140_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_140_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_140_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_140_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_140_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_140_chunk USING btree (country);


--
-- Name: _hyper_1_140_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_140_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_140_chunk USING btree (production_type);


--
-- Name: _hyper_1_140_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_140_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_140_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_141_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_141_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_141_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_141_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_141_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_141_chunk USING btree (country);


--
-- Name: _hyper_1_141_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_141_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_141_chunk USING btree (production_type);


--
-- Name: _hyper_1_141_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_141_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_141_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_142_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_142_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_142_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_142_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_142_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_142_chunk USING btree (country);


--
-- Name: _hyper_1_142_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_142_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_142_chunk USING btree (production_type);


--
-- Name: _hyper_1_142_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_142_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_142_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_143_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_143_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_143_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_143_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_143_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_143_chunk USING btree (country);


--
-- Name: _hyper_1_143_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_143_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_143_chunk USING btree (production_type);


--
-- Name: _hyper_1_143_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_143_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_143_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_144_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_144_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_144_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_144_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_144_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_144_chunk USING btree (country);


--
-- Name: _hyper_1_144_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_144_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_144_chunk USING btree (production_type);


--
-- Name: _hyper_1_144_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_144_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_144_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_145_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_145_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_145_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_145_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_145_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_145_chunk USING btree (country);


--
-- Name: _hyper_1_145_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_145_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_145_chunk USING btree (production_type);


--
-- Name: _hyper_1_145_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_145_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_145_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_146_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_146_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_146_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_146_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_146_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_146_chunk USING btree (country);


--
-- Name: _hyper_1_146_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_146_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_146_chunk USING btree (production_type);


--
-- Name: _hyper_1_146_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_146_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_146_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_147_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_147_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_147_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_147_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_147_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_147_chunk USING btree (country);


--
-- Name: _hyper_1_147_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_147_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_147_chunk USING btree (production_type);


--
-- Name: _hyper_1_147_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_147_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_147_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_148_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_148_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_148_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_148_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_148_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_148_chunk USING btree (country);


--
-- Name: _hyper_1_148_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_148_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_148_chunk USING btree (production_type);


--
-- Name: _hyper_1_148_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_148_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_148_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_149_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_149_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_149_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_149_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_149_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_149_chunk USING btree (country);


--
-- Name: _hyper_1_149_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_149_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_149_chunk USING btree (production_type);


--
-- Name: _hyper_1_149_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_149_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_149_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_14_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_14_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_14_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_14_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_14_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_14_chunk USING btree (country);


--
-- Name: _hyper_1_14_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_14_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_14_chunk USING btree (production_type);


--
-- Name: _hyper_1_14_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_14_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_14_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_150_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_150_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_150_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_150_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_150_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_150_chunk USING btree (country);


--
-- Name: _hyper_1_150_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_150_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_150_chunk USING btree (production_type);


--
-- Name: _hyper_1_150_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_150_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_150_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_151_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_151_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_151_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_151_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_151_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_151_chunk USING btree (country);


--
-- Name: _hyper_1_151_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_151_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_151_chunk USING btree (production_type);


--
-- Name: _hyper_1_151_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_151_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_151_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_152_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_152_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_152_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_152_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_152_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_152_chunk USING btree (country);


--
-- Name: _hyper_1_152_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_152_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_152_chunk USING btree (production_type);


--
-- Name: _hyper_1_152_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_152_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_152_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_153_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_153_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_153_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_153_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_153_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_153_chunk USING btree (country);


--
-- Name: _hyper_1_153_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_153_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_153_chunk USING btree (production_type);


--
-- Name: _hyper_1_153_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_153_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_153_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_154_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_154_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_154_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_154_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_154_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_154_chunk USING btree (country);


--
-- Name: _hyper_1_154_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_154_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_154_chunk USING btree (production_type);


--
-- Name: _hyper_1_154_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_154_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_154_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_155_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_155_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_155_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_155_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_155_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_155_chunk USING btree (country);


--
-- Name: _hyper_1_155_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_155_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_155_chunk USING btree (production_type);


--
-- Name: _hyper_1_155_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_155_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_155_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_156_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_156_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_156_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_156_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_156_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_156_chunk USING btree (country);


--
-- Name: _hyper_1_156_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_156_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_156_chunk USING btree (production_type);


--
-- Name: _hyper_1_156_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_156_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_156_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_157_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_157_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_157_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_157_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_157_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_157_chunk USING btree (country);


--
-- Name: _hyper_1_157_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_157_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_157_chunk USING btree (production_type);


--
-- Name: _hyper_1_157_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_157_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_157_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_158_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_158_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_158_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_158_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_158_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_158_chunk USING btree (country);


--
-- Name: _hyper_1_158_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_158_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_158_chunk USING btree (production_type);


--
-- Name: _hyper_1_158_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_158_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_158_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_159_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_159_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_159_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_159_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_159_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_159_chunk USING btree (country);


--
-- Name: _hyper_1_159_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_159_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_159_chunk USING btree (production_type);


--
-- Name: _hyper_1_159_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_159_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_159_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_15_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_15_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_15_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_15_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_15_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_15_chunk USING btree (country);


--
-- Name: _hyper_1_15_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_15_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_15_chunk USING btree (production_type);


--
-- Name: _hyper_1_15_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_15_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_15_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_160_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_160_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_160_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_160_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_160_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_160_chunk USING btree (country);


--
-- Name: _hyper_1_160_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_160_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_160_chunk USING btree (production_type);


--
-- Name: _hyper_1_160_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_160_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_160_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_161_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_161_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_161_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_161_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_161_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_161_chunk USING btree (country);


--
-- Name: _hyper_1_161_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_161_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_161_chunk USING btree (production_type);


--
-- Name: _hyper_1_161_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_161_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_161_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_162_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_162_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_162_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_162_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_162_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_162_chunk USING btree (country);


--
-- Name: _hyper_1_162_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_162_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_162_chunk USING btree (production_type);


--
-- Name: _hyper_1_162_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_162_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_162_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_163_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_163_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_163_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_163_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_163_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_163_chunk USING btree (country);


--
-- Name: _hyper_1_163_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_163_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_163_chunk USING btree (production_type);


--
-- Name: _hyper_1_163_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_163_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_163_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_164_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_164_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_164_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_164_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_164_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_164_chunk USING btree (country);


--
-- Name: _hyper_1_164_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_164_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_164_chunk USING btree (production_type);


--
-- Name: _hyper_1_164_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_164_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_164_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_165_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_165_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_165_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_165_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_165_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_165_chunk USING btree (country);


--
-- Name: _hyper_1_165_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_165_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_165_chunk USING btree (production_type);


--
-- Name: _hyper_1_165_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_165_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_165_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_166_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_166_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_166_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_166_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_166_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_166_chunk USING btree (country);


--
-- Name: _hyper_1_166_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_166_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_166_chunk USING btree (production_type);


--
-- Name: _hyper_1_166_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_166_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_166_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_167_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_167_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_167_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_167_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_167_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_167_chunk USING btree (country);


--
-- Name: _hyper_1_167_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_167_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_167_chunk USING btree (production_type);


--
-- Name: _hyper_1_167_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_167_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_167_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_168_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_168_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_168_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_168_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_168_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_168_chunk USING btree (country);


--
-- Name: _hyper_1_168_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_168_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_168_chunk USING btree (production_type);


--
-- Name: _hyper_1_168_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_168_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_168_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_169_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_169_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_169_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_169_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_169_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_169_chunk USING btree (country);


--
-- Name: _hyper_1_169_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_169_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_169_chunk USING btree (production_type);


--
-- Name: _hyper_1_169_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_169_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_169_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_16_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_16_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_16_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_16_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_16_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_16_chunk USING btree (country);


--
-- Name: _hyper_1_16_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_16_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_16_chunk USING btree (production_type);


--
-- Name: _hyper_1_16_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_16_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_16_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_170_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_170_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_170_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_170_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_170_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_170_chunk USING btree (country);


--
-- Name: _hyper_1_170_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_170_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_170_chunk USING btree (production_type);


--
-- Name: _hyper_1_170_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_170_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_170_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_171_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_171_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_171_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_171_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_171_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_171_chunk USING btree (country);


--
-- Name: _hyper_1_171_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_171_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_171_chunk USING btree (production_type);


--
-- Name: _hyper_1_171_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_171_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_171_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_172_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_172_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_172_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_172_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_172_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_172_chunk USING btree (country);


--
-- Name: _hyper_1_172_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_172_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_172_chunk USING btree (production_type);


--
-- Name: _hyper_1_172_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_172_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_172_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_173_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_173_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_173_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_173_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_173_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_173_chunk USING btree (country);


--
-- Name: _hyper_1_173_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_173_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_173_chunk USING btree (production_type);


--
-- Name: _hyper_1_173_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_173_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_173_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_174_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_174_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_174_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_174_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_174_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_174_chunk USING btree (country);


--
-- Name: _hyper_1_174_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_174_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_174_chunk USING btree (production_type);


--
-- Name: _hyper_1_174_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_174_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_174_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_175_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_175_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_175_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_175_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_175_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_175_chunk USING btree (country);


--
-- Name: _hyper_1_175_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_175_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_175_chunk USING btree (production_type);


--
-- Name: _hyper_1_175_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_175_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_175_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_176_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_176_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_176_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_176_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_176_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_176_chunk USING btree (country);


--
-- Name: _hyper_1_176_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_176_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_176_chunk USING btree (production_type);


--
-- Name: _hyper_1_176_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_176_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_176_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_177_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_177_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_177_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_177_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_177_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_177_chunk USING btree (country);


--
-- Name: _hyper_1_177_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_177_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_177_chunk USING btree (production_type);


--
-- Name: _hyper_1_177_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_177_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_177_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_178_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_178_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_178_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_178_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_178_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_178_chunk USING btree (country);


--
-- Name: _hyper_1_178_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_178_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_178_chunk USING btree (production_type);


--
-- Name: _hyper_1_178_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_178_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_178_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_179_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_179_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_179_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_179_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_179_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_179_chunk USING btree (country);


--
-- Name: _hyper_1_179_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_179_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_179_chunk USING btree (production_type);


--
-- Name: _hyper_1_179_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_179_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_179_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_17_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_17_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_17_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_17_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_17_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_17_chunk USING btree (country);


--
-- Name: _hyper_1_17_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_17_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_17_chunk USING btree (production_type);


--
-- Name: _hyper_1_17_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_17_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_17_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_180_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_180_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_180_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_180_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_180_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_180_chunk USING btree (country);


--
-- Name: _hyper_1_180_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_180_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_180_chunk USING btree (production_type);


--
-- Name: _hyper_1_180_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_180_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_180_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_181_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_181_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_181_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_181_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_181_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_181_chunk USING btree (country);


--
-- Name: _hyper_1_181_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_181_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_181_chunk USING btree (production_type);


--
-- Name: _hyper_1_181_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_181_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_181_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_182_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_182_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_182_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_182_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_182_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_182_chunk USING btree (country);


--
-- Name: _hyper_1_182_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_182_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_182_chunk USING btree (production_type);


--
-- Name: _hyper_1_182_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_182_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_182_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_183_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_183_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_183_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_183_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_183_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_183_chunk USING btree (country);


--
-- Name: _hyper_1_183_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_183_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_183_chunk USING btree (production_type);


--
-- Name: _hyper_1_183_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_183_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_183_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_184_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_184_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_184_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_184_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_184_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_184_chunk USING btree (country);


--
-- Name: _hyper_1_184_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_184_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_184_chunk USING btree (production_type);


--
-- Name: _hyper_1_184_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_184_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_184_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_185_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_185_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_185_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_185_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_185_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_185_chunk USING btree (country);


--
-- Name: _hyper_1_185_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_185_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_185_chunk USING btree (production_type);


--
-- Name: _hyper_1_185_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_185_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_185_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_186_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_186_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_186_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_186_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_186_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_186_chunk USING btree (country);


--
-- Name: _hyper_1_186_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_186_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_186_chunk USING btree (production_type);


--
-- Name: _hyper_1_186_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_186_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_186_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_187_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_187_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_187_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_187_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_187_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_187_chunk USING btree (country);


--
-- Name: _hyper_1_187_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_187_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_187_chunk USING btree (production_type);


--
-- Name: _hyper_1_187_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_187_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_187_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_188_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_188_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_188_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_188_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_188_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_188_chunk USING btree (country);


--
-- Name: _hyper_1_188_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_188_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_188_chunk USING btree (production_type);


--
-- Name: _hyper_1_188_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_188_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_188_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_189_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_189_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_189_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_189_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_189_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_189_chunk USING btree (country);


--
-- Name: _hyper_1_189_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_189_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_189_chunk USING btree (production_type);


--
-- Name: _hyper_1_189_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_189_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_189_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_18_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_18_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_18_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_18_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_18_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_18_chunk USING btree (country);


--
-- Name: _hyper_1_18_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_18_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_18_chunk USING btree (production_type);


--
-- Name: _hyper_1_18_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_18_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_18_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_190_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_190_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_190_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_190_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_190_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_190_chunk USING btree (country);


--
-- Name: _hyper_1_190_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_190_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_190_chunk USING btree (production_type);


--
-- Name: _hyper_1_190_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_190_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_190_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_191_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_191_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_191_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_191_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_191_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_191_chunk USING btree (country);


--
-- Name: _hyper_1_191_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_191_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_191_chunk USING btree (production_type);


--
-- Name: _hyper_1_191_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_191_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_191_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_192_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_192_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_192_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_192_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_192_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_192_chunk USING btree (country);


--
-- Name: _hyper_1_192_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_192_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_192_chunk USING btree (production_type);


--
-- Name: _hyper_1_192_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_192_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_192_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_193_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_193_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_193_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_193_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_193_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_193_chunk USING btree (country);


--
-- Name: _hyper_1_193_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_193_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_193_chunk USING btree (production_type);


--
-- Name: _hyper_1_193_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_193_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_193_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_194_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_194_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_194_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_194_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_194_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_194_chunk USING btree (country);


--
-- Name: _hyper_1_194_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_194_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_194_chunk USING btree (production_type);


--
-- Name: _hyper_1_194_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_194_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_194_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_195_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_195_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_195_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_195_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_195_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_195_chunk USING btree (country);


--
-- Name: _hyper_1_195_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_195_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_195_chunk USING btree (production_type);


--
-- Name: _hyper_1_195_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_195_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_195_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_196_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_196_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_196_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_196_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_196_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_196_chunk USING btree (country);


--
-- Name: _hyper_1_196_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_196_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_196_chunk USING btree (production_type);


--
-- Name: _hyper_1_196_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_196_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_196_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_197_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_197_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_197_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_197_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_197_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_197_chunk USING btree (country);


--
-- Name: _hyper_1_197_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_197_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_197_chunk USING btree (production_type);


--
-- Name: _hyper_1_197_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_197_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_197_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_198_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_198_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_198_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_198_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_198_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_198_chunk USING btree (country);


--
-- Name: _hyper_1_198_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_198_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_198_chunk USING btree (production_type);


--
-- Name: _hyper_1_198_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_198_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_198_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_199_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_199_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_199_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_199_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_199_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_199_chunk USING btree (country);


--
-- Name: _hyper_1_199_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_199_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_199_chunk USING btree (production_type);


--
-- Name: _hyper_1_199_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_199_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_199_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_19_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_19_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_19_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_19_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_19_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_19_chunk USING btree (country);


--
-- Name: _hyper_1_19_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_19_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_19_chunk USING btree (production_type);


--
-- Name: _hyper_1_19_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_19_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_19_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_1_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_1_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_1_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_1_chunk USING btree (country);


--
-- Name: _hyper_1_1_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_1_chunk USING btree (production_type);


--
-- Name: _hyper_1_1_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_1_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_1_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_200_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_200_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_200_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_200_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_200_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_200_chunk USING btree (country);


--
-- Name: _hyper_1_200_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_200_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_200_chunk USING btree (production_type);


--
-- Name: _hyper_1_200_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_200_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_200_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_201_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_201_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_201_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_201_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_201_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_201_chunk USING btree (country);


--
-- Name: _hyper_1_201_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_201_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_201_chunk USING btree (production_type);


--
-- Name: _hyper_1_201_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_201_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_201_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_202_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_202_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_202_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_202_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_202_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_202_chunk USING btree (country);


--
-- Name: _hyper_1_202_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_202_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_202_chunk USING btree (production_type);


--
-- Name: _hyper_1_202_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_202_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_202_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_203_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_203_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_203_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_203_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_203_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_203_chunk USING btree (country);


--
-- Name: _hyper_1_203_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_203_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_203_chunk USING btree (production_type);


--
-- Name: _hyper_1_203_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_203_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_203_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_204_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_204_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_204_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_204_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_204_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_204_chunk USING btree (country);


--
-- Name: _hyper_1_204_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_204_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_204_chunk USING btree (production_type);


--
-- Name: _hyper_1_204_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_204_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_204_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_205_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_205_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_205_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_205_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_205_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_205_chunk USING btree (country);


--
-- Name: _hyper_1_205_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_205_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_205_chunk USING btree (production_type);


--
-- Name: _hyper_1_205_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_205_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_205_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_206_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_206_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_206_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_206_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_206_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_206_chunk USING btree (country);


--
-- Name: _hyper_1_206_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_206_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_206_chunk USING btree (production_type);


--
-- Name: _hyper_1_206_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_206_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_206_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_207_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_207_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_207_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_207_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_207_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_207_chunk USING btree (country);


--
-- Name: _hyper_1_207_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_207_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_207_chunk USING btree (production_type);


--
-- Name: _hyper_1_207_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_207_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_207_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_208_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_208_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_208_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_208_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_208_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_208_chunk USING btree (country);


--
-- Name: _hyper_1_208_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_208_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_208_chunk USING btree (production_type);


--
-- Name: _hyper_1_208_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_208_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_208_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_209_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_209_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_209_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_209_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_209_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_209_chunk USING btree (country);


--
-- Name: _hyper_1_209_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_209_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_209_chunk USING btree (production_type);


--
-- Name: _hyper_1_209_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_209_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_209_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_20_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_20_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_20_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_20_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_20_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_20_chunk USING btree (country);


--
-- Name: _hyper_1_20_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_20_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_20_chunk USING btree (production_type);


--
-- Name: _hyper_1_20_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_20_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_20_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_210_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_210_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_210_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_210_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_210_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_210_chunk USING btree (country);


--
-- Name: _hyper_1_210_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_210_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_210_chunk USING btree (production_type);


--
-- Name: _hyper_1_210_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_210_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_210_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_211_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_211_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_211_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_211_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_211_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_211_chunk USING btree (country);


--
-- Name: _hyper_1_211_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_211_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_211_chunk USING btree (production_type);


--
-- Name: _hyper_1_211_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_211_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_211_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_212_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_212_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_212_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_212_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_212_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_212_chunk USING btree (country);


--
-- Name: _hyper_1_212_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_212_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_212_chunk USING btree (production_type);


--
-- Name: _hyper_1_212_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_212_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_212_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_213_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_213_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_213_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_213_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_213_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_213_chunk USING btree (country);


--
-- Name: _hyper_1_213_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_213_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_213_chunk USING btree (production_type);


--
-- Name: _hyper_1_213_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_213_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_213_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_214_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_214_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_214_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_214_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_214_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_214_chunk USING btree (country);


--
-- Name: _hyper_1_214_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_214_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_214_chunk USING btree (production_type);


--
-- Name: _hyper_1_214_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_214_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_214_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_215_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_215_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_215_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_215_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_215_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_215_chunk USING btree (country);


--
-- Name: _hyper_1_215_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_215_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_215_chunk USING btree (production_type);


--
-- Name: _hyper_1_215_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_215_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_215_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_216_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_216_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_216_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_216_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_216_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_216_chunk USING btree (country);


--
-- Name: _hyper_1_216_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_216_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_216_chunk USING btree (production_type);


--
-- Name: _hyper_1_216_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_216_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_216_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_217_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_217_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_217_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_217_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_217_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_217_chunk USING btree (country);


--
-- Name: _hyper_1_217_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_217_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_217_chunk USING btree (production_type);


--
-- Name: _hyper_1_217_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_217_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_217_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_218_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_218_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_218_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_218_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_218_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_218_chunk USING btree (country);


--
-- Name: _hyper_1_218_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_218_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_218_chunk USING btree (production_type);


--
-- Name: _hyper_1_218_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_218_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_218_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_219_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_219_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_219_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_219_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_219_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_219_chunk USING btree (country);


--
-- Name: _hyper_1_219_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_219_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_219_chunk USING btree (production_type);


--
-- Name: _hyper_1_219_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_219_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_219_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_21_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_21_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_21_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_21_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_21_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_21_chunk USING btree (country);


--
-- Name: _hyper_1_21_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_21_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_21_chunk USING btree (production_type);


--
-- Name: _hyper_1_21_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_21_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_21_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_220_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_220_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_220_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_220_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_220_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_220_chunk USING btree (country);


--
-- Name: _hyper_1_220_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_220_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_220_chunk USING btree (production_type);


--
-- Name: _hyper_1_220_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_220_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_220_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_221_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_221_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_221_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_221_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_221_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_221_chunk USING btree (country);


--
-- Name: _hyper_1_221_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_221_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_221_chunk USING btree (production_type);


--
-- Name: _hyper_1_221_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_221_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_221_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_222_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_222_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_222_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_222_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_222_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_222_chunk USING btree (country);


--
-- Name: _hyper_1_222_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_222_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_222_chunk USING btree (production_type);


--
-- Name: _hyper_1_222_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_222_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_222_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_223_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_223_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_223_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_223_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_223_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_223_chunk USING btree (country);


--
-- Name: _hyper_1_223_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_223_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_223_chunk USING btree (production_type);


--
-- Name: _hyper_1_223_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_223_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_223_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_224_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_224_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_224_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_224_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_224_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_224_chunk USING btree (country);


--
-- Name: _hyper_1_224_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_224_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_224_chunk USING btree (production_type);


--
-- Name: _hyper_1_224_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_224_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_224_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_225_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_225_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_225_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_225_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_225_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_225_chunk USING btree (country);


--
-- Name: _hyper_1_225_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_225_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_225_chunk USING btree (production_type);


--
-- Name: _hyper_1_225_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_225_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_225_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_226_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_226_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_226_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_226_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_226_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_226_chunk USING btree (country);


--
-- Name: _hyper_1_226_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_226_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_226_chunk USING btree (production_type);


--
-- Name: _hyper_1_226_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_226_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_226_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_227_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_227_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_227_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_227_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_227_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_227_chunk USING btree (country);


--
-- Name: _hyper_1_227_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_227_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_227_chunk USING btree (production_type);


--
-- Name: _hyper_1_227_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_227_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_227_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_228_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_228_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_228_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_228_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_228_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_228_chunk USING btree (country);


--
-- Name: _hyper_1_228_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_228_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_228_chunk USING btree (production_type);


--
-- Name: _hyper_1_228_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_228_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_228_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_229_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_229_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_229_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_229_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_229_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_229_chunk USING btree (country);


--
-- Name: _hyper_1_229_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_229_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_229_chunk USING btree (production_type);


--
-- Name: _hyper_1_229_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_229_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_229_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_22_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_22_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_22_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_22_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_22_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_22_chunk USING btree (country);


--
-- Name: _hyper_1_22_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_22_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_22_chunk USING btree (production_type);


--
-- Name: _hyper_1_22_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_22_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_22_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_230_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_230_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_230_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_230_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_230_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_230_chunk USING btree (country);


--
-- Name: _hyper_1_230_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_230_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_230_chunk USING btree (production_type);


--
-- Name: _hyper_1_230_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_230_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_230_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_231_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_231_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_231_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_231_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_231_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_231_chunk USING btree (country);


--
-- Name: _hyper_1_231_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_231_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_231_chunk USING btree (production_type);


--
-- Name: _hyper_1_231_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_231_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_231_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_232_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_232_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_232_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_232_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_232_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_232_chunk USING btree (country);


--
-- Name: _hyper_1_232_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_232_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_232_chunk USING btree (production_type);


--
-- Name: _hyper_1_232_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_232_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_232_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_233_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_233_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_233_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_233_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_233_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_233_chunk USING btree (country);


--
-- Name: _hyper_1_233_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_233_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_233_chunk USING btree (production_type);


--
-- Name: _hyper_1_233_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_233_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_233_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_234_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_234_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_234_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_234_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_234_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_234_chunk USING btree (country);


--
-- Name: _hyper_1_234_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_234_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_234_chunk USING btree (production_type);


--
-- Name: _hyper_1_234_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_234_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_234_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_235_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_235_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_235_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_235_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_235_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_235_chunk USING btree (country);


--
-- Name: _hyper_1_235_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_235_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_235_chunk USING btree (production_type);


--
-- Name: _hyper_1_235_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_235_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_235_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_236_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_236_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_236_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_236_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_236_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_236_chunk USING btree (country);


--
-- Name: _hyper_1_236_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_236_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_236_chunk USING btree (production_type);


--
-- Name: _hyper_1_236_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_236_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_236_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_237_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_237_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_237_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_237_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_237_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_237_chunk USING btree (country);


--
-- Name: _hyper_1_237_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_237_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_237_chunk USING btree (production_type);


--
-- Name: _hyper_1_237_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_237_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_237_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_238_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_238_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_238_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_238_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_238_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_238_chunk USING btree (country);


--
-- Name: _hyper_1_238_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_238_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_238_chunk USING btree (production_type);


--
-- Name: _hyper_1_238_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_238_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_238_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_239_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_239_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_239_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_239_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_239_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_239_chunk USING btree (country);


--
-- Name: _hyper_1_239_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_239_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_239_chunk USING btree (production_type);


--
-- Name: _hyper_1_239_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_239_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_239_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_23_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_23_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_23_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_23_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_23_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_23_chunk USING btree (country);


--
-- Name: _hyper_1_23_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_23_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_23_chunk USING btree (production_type);


--
-- Name: _hyper_1_23_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_23_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_23_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_240_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_240_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_240_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_240_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_240_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_240_chunk USING btree (country);


--
-- Name: _hyper_1_240_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_240_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_240_chunk USING btree (production_type);


--
-- Name: _hyper_1_240_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_240_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_240_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_241_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_241_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_241_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_241_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_241_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_241_chunk USING btree (country);


--
-- Name: _hyper_1_241_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_241_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_241_chunk USING btree (production_type);


--
-- Name: _hyper_1_241_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_241_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_241_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_242_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_242_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_242_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_242_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_242_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_242_chunk USING btree (country);


--
-- Name: _hyper_1_242_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_242_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_242_chunk USING btree (production_type);


--
-- Name: _hyper_1_242_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_242_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_242_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_243_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_243_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_243_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_243_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_243_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_243_chunk USING btree (country);


--
-- Name: _hyper_1_243_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_243_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_243_chunk USING btree (production_type);


--
-- Name: _hyper_1_243_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_243_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_243_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_244_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_244_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_244_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_244_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_244_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_244_chunk USING btree (country);


--
-- Name: _hyper_1_244_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_244_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_244_chunk USING btree (production_type);


--
-- Name: _hyper_1_244_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_244_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_244_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_245_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_245_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_245_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_245_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_245_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_245_chunk USING btree (country);


--
-- Name: _hyper_1_245_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_245_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_245_chunk USING btree (production_type);


--
-- Name: _hyper_1_245_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_245_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_245_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_246_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_246_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_246_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_246_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_246_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_246_chunk USING btree (country);


--
-- Name: _hyper_1_246_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_246_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_246_chunk USING btree (production_type);


--
-- Name: _hyper_1_246_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_246_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_246_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_247_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_247_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_247_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_247_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_247_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_247_chunk USING btree (country);


--
-- Name: _hyper_1_247_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_247_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_247_chunk USING btree (production_type);


--
-- Name: _hyper_1_247_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_247_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_247_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_248_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_248_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_248_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_248_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_248_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_248_chunk USING btree (country);


--
-- Name: _hyper_1_248_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_248_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_248_chunk USING btree (production_type);


--
-- Name: _hyper_1_248_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_248_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_248_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_249_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_249_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_249_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_249_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_249_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_249_chunk USING btree (country);


--
-- Name: _hyper_1_249_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_249_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_249_chunk USING btree (production_type);


--
-- Name: _hyper_1_249_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_249_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_249_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_24_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_24_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_24_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_24_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_24_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_24_chunk USING btree (country);


--
-- Name: _hyper_1_24_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_24_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_24_chunk USING btree (production_type);


--
-- Name: _hyper_1_24_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_24_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_24_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_250_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_250_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_250_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_250_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_250_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_250_chunk USING btree (country);


--
-- Name: _hyper_1_250_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_250_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_250_chunk USING btree (production_type);


--
-- Name: _hyper_1_250_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_250_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_250_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_251_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_251_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_251_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_251_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_251_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_251_chunk USING btree (country);


--
-- Name: _hyper_1_251_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_251_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_251_chunk USING btree (production_type);


--
-- Name: _hyper_1_251_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_251_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_251_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_252_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_252_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_252_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_252_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_252_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_252_chunk USING btree (country);


--
-- Name: _hyper_1_252_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_252_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_252_chunk USING btree (production_type);


--
-- Name: _hyper_1_252_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_252_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_252_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_253_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_253_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_253_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_253_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_253_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_253_chunk USING btree (country);


--
-- Name: _hyper_1_253_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_253_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_253_chunk USING btree (production_type);


--
-- Name: _hyper_1_253_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_253_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_253_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_254_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_254_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_254_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_254_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_254_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_254_chunk USING btree (country);


--
-- Name: _hyper_1_254_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_254_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_254_chunk USING btree (production_type);


--
-- Name: _hyper_1_254_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_254_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_254_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_255_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_255_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_255_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_255_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_255_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_255_chunk USING btree (country);


--
-- Name: _hyper_1_255_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_255_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_255_chunk USING btree (production_type);


--
-- Name: _hyper_1_255_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_255_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_255_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_256_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_256_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_256_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_256_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_256_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_256_chunk USING btree (country);


--
-- Name: _hyper_1_256_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_256_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_256_chunk USING btree (production_type);


--
-- Name: _hyper_1_256_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_256_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_256_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_257_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_257_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_257_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_257_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_257_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_257_chunk USING btree (country);


--
-- Name: _hyper_1_257_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_257_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_257_chunk USING btree (production_type);


--
-- Name: _hyper_1_257_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_257_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_257_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_258_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_258_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_258_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_258_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_258_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_258_chunk USING btree (country);


--
-- Name: _hyper_1_258_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_258_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_258_chunk USING btree (production_type);


--
-- Name: _hyper_1_258_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_258_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_258_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_259_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_259_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_259_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_259_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_259_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_259_chunk USING btree (country);


--
-- Name: _hyper_1_259_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_259_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_259_chunk USING btree (production_type);


--
-- Name: _hyper_1_259_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_259_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_259_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_25_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_25_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_25_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_25_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_25_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_25_chunk USING btree (country);


--
-- Name: _hyper_1_25_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_25_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_25_chunk USING btree (production_type);


--
-- Name: _hyper_1_25_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_25_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_25_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_260_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_260_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_260_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_260_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_260_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_260_chunk USING btree (country);


--
-- Name: _hyper_1_260_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_260_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_260_chunk USING btree (production_type);


--
-- Name: _hyper_1_260_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_260_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_260_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_261_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_261_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_261_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_261_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_261_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_261_chunk USING btree (country);


--
-- Name: _hyper_1_261_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_261_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_261_chunk USING btree (production_type);


--
-- Name: _hyper_1_261_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_261_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_261_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_262_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_262_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_262_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_262_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_262_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_262_chunk USING btree (country);


--
-- Name: _hyper_1_262_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_262_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_262_chunk USING btree (production_type);


--
-- Name: _hyper_1_262_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_262_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_262_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_263_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_263_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_263_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_263_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_263_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_263_chunk USING btree (country);


--
-- Name: _hyper_1_263_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_263_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_263_chunk USING btree (production_type);


--
-- Name: _hyper_1_263_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_263_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_263_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_264_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_264_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_264_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_264_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_264_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_264_chunk USING btree (country);


--
-- Name: _hyper_1_264_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_264_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_264_chunk USING btree (production_type);


--
-- Name: _hyper_1_264_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_264_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_264_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_265_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_265_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_265_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_265_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_265_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_265_chunk USING btree (country);


--
-- Name: _hyper_1_265_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_265_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_265_chunk USING btree (production_type);


--
-- Name: _hyper_1_265_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_265_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_265_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_266_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_266_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_266_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_266_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_266_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_266_chunk USING btree (country);


--
-- Name: _hyper_1_266_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_266_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_266_chunk USING btree (production_type);


--
-- Name: _hyper_1_266_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_266_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_266_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_267_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_267_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_267_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_267_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_267_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_267_chunk USING btree (country);


--
-- Name: _hyper_1_267_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_267_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_267_chunk USING btree (production_type);


--
-- Name: _hyper_1_267_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_267_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_267_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_268_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_268_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_268_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_268_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_268_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_268_chunk USING btree (country);


--
-- Name: _hyper_1_268_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_268_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_268_chunk USING btree (production_type);


--
-- Name: _hyper_1_268_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_268_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_268_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_269_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_269_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_269_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_269_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_269_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_269_chunk USING btree (country);


--
-- Name: _hyper_1_269_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_269_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_269_chunk USING btree (production_type);


--
-- Name: _hyper_1_269_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_269_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_269_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_26_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_26_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_26_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_26_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_26_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_26_chunk USING btree (country);


--
-- Name: _hyper_1_26_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_26_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_26_chunk USING btree (production_type);


--
-- Name: _hyper_1_26_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_26_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_26_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_270_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_270_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_270_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_270_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_270_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_270_chunk USING btree (country);


--
-- Name: _hyper_1_270_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_270_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_270_chunk USING btree (production_type);


--
-- Name: _hyper_1_270_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_270_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_270_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_271_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_271_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_271_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_271_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_271_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_271_chunk USING btree (country);


--
-- Name: _hyper_1_271_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_271_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_271_chunk USING btree (production_type);


--
-- Name: _hyper_1_271_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_271_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_271_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_272_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_272_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_272_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_272_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_272_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_272_chunk USING btree (country);


--
-- Name: _hyper_1_272_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_272_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_272_chunk USING btree (production_type);


--
-- Name: _hyper_1_272_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_272_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_272_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_273_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_273_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_273_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_273_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_273_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_273_chunk USING btree (country);


--
-- Name: _hyper_1_273_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_273_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_273_chunk USING btree (production_type);


--
-- Name: _hyper_1_273_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_273_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_273_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_274_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_274_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_274_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_274_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_274_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_274_chunk USING btree (country);


--
-- Name: _hyper_1_274_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_274_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_274_chunk USING btree (production_type);


--
-- Name: _hyper_1_274_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_274_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_274_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_275_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_275_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_275_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_275_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_275_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_275_chunk USING btree (country);


--
-- Name: _hyper_1_275_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_275_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_275_chunk USING btree (production_type);


--
-- Name: _hyper_1_275_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_275_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_275_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_276_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_276_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_276_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_276_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_276_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_276_chunk USING btree (country);


--
-- Name: _hyper_1_276_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_276_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_276_chunk USING btree (production_type);


--
-- Name: _hyper_1_276_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_276_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_276_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_277_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_277_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_277_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_277_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_277_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_277_chunk USING btree (country);


--
-- Name: _hyper_1_277_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_277_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_277_chunk USING btree (production_type);


--
-- Name: _hyper_1_277_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_277_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_277_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_278_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_278_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_278_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_278_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_278_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_278_chunk USING btree (country);


--
-- Name: _hyper_1_278_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_278_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_278_chunk USING btree (production_type);


--
-- Name: _hyper_1_278_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_278_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_278_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_279_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_279_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_279_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_279_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_279_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_279_chunk USING btree (country);


--
-- Name: _hyper_1_279_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_279_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_279_chunk USING btree (production_type);


--
-- Name: _hyper_1_279_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_279_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_279_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_27_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_27_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_27_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_27_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_27_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_27_chunk USING btree (country);


--
-- Name: _hyper_1_27_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_27_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_27_chunk USING btree (production_type);


--
-- Name: _hyper_1_27_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_27_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_27_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_280_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_280_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_280_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_280_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_280_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_280_chunk USING btree (country);


--
-- Name: _hyper_1_280_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_280_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_280_chunk USING btree (production_type);


--
-- Name: _hyper_1_280_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_280_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_280_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_281_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_281_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_281_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_281_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_281_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_281_chunk USING btree (country);


--
-- Name: _hyper_1_281_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_281_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_281_chunk USING btree (production_type);


--
-- Name: _hyper_1_281_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_281_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_281_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_282_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_282_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_282_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_282_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_282_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_282_chunk USING btree (country);


--
-- Name: _hyper_1_282_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_282_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_282_chunk USING btree (production_type);


--
-- Name: _hyper_1_282_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_282_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_282_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_283_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_283_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_283_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_283_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_283_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_283_chunk USING btree (country);


--
-- Name: _hyper_1_283_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_283_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_283_chunk USING btree (production_type);


--
-- Name: _hyper_1_283_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_283_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_283_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_284_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_284_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_284_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_284_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_284_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_284_chunk USING btree (country);


--
-- Name: _hyper_1_284_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_284_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_284_chunk USING btree (production_type);


--
-- Name: _hyper_1_284_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_284_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_284_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_285_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_285_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_285_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_285_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_285_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_285_chunk USING btree (country);


--
-- Name: _hyper_1_285_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_285_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_285_chunk USING btree (production_type);


--
-- Name: _hyper_1_285_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_285_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_285_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_286_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_286_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_286_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_286_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_286_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_286_chunk USING btree (country);


--
-- Name: _hyper_1_286_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_286_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_286_chunk USING btree (production_type);


--
-- Name: _hyper_1_286_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_286_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_286_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_287_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_287_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_287_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_287_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_287_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_287_chunk USING btree (country);


--
-- Name: _hyper_1_287_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_287_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_287_chunk USING btree (production_type);


--
-- Name: _hyper_1_287_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_287_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_287_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_288_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_288_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_288_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_288_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_288_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_288_chunk USING btree (country);


--
-- Name: _hyper_1_288_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_288_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_288_chunk USING btree (production_type);


--
-- Name: _hyper_1_288_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_288_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_288_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_289_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_289_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_289_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_289_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_289_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_289_chunk USING btree (country);


--
-- Name: _hyper_1_289_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_289_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_289_chunk USING btree (production_type);


--
-- Name: _hyper_1_289_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_289_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_289_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_28_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_28_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_28_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_28_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_28_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_28_chunk USING btree (country);


--
-- Name: _hyper_1_28_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_28_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_28_chunk USING btree (production_type);


--
-- Name: _hyper_1_28_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_28_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_28_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_290_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_290_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_290_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_290_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_290_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_290_chunk USING btree (country);


--
-- Name: _hyper_1_290_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_290_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_290_chunk USING btree (production_type);


--
-- Name: _hyper_1_290_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_290_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_290_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_291_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_291_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_291_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_291_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_291_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_291_chunk USING btree (country);


--
-- Name: _hyper_1_291_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_291_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_291_chunk USING btree (production_type);


--
-- Name: _hyper_1_291_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_291_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_291_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_292_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_292_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_292_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_292_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_292_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_292_chunk USING btree (country);


--
-- Name: _hyper_1_292_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_292_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_292_chunk USING btree (production_type);


--
-- Name: _hyper_1_292_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_292_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_292_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_293_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_293_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_293_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_293_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_293_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_293_chunk USING btree (country);


--
-- Name: _hyper_1_293_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_293_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_293_chunk USING btree (production_type);


--
-- Name: _hyper_1_293_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_293_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_293_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_294_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_294_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_294_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_294_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_294_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_294_chunk USING btree (country);


--
-- Name: _hyper_1_294_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_294_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_294_chunk USING btree (production_type);


--
-- Name: _hyper_1_294_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_294_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_294_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_295_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_295_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_295_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_295_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_295_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_295_chunk USING btree (country);


--
-- Name: _hyper_1_295_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_295_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_295_chunk USING btree (production_type);


--
-- Name: _hyper_1_295_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_295_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_295_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_296_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_296_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_296_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_296_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_296_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_296_chunk USING btree (country);


--
-- Name: _hyper_1_296_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_296_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_296_chunk USING btree (production_type);


--
-- Name: _hyper_1_296_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_296_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_296_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_297_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_297_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_297_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_297_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_297_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_297_chunk USING btree (country);


--
-- Name: _hyper_1_297_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_297_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_297_chunk USING btree (production_type);


--
-- Name: _hyper_1_297_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_297_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_297_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_298_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_298_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_298_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_298_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_298_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_298_chunk USING btree (country);


--
-- Name: _hyper_1_298_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_298_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_298_chunk USING btree (production_type);


--
-- Name: _hyper_1_298_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_298_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_298_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_299_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_299_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_299_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_299_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_299_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_299_chunk USING btree (country);


--
-- Name: _hyper_1_299_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_299_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_299_chunk USING btree (production_type);


--
-- Name: _hyper_1_299_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_299_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_299_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_29_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_29_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_29_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_29_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_29_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_29_chunk USING btree (country);


--
-- Name: _hyper_1_29_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_29_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_29_chunk USING btree (production_type);


--
-- Name: _hyper_1_29_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_29_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_29_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_2_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_2_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_2_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_2_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_2_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_2_chunk USING btree (country);


--
-- Name: _hyper_1_2_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_2_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_2_chunk USING btree (production_type);


--
-- Name: _hyper_1_2_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_2_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_2_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_300_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_300_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_300_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_300_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_300_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_300_chunk USING btree (country);


--
-- Name: _hyper_1_300_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_300_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_300_chunk USING btree (production_type);


--
-- Name: _hyper_1_300_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_300_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_300_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_301_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_301_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_301_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_301_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_301_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_301_chunk USING btree (country);


--
-- Name: _hyper_1_301_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_301_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_301_chunk USING btree (production_type);


--
-- Name: _hyper_1_301_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_301_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_301_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_302_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_302_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_302_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_302_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_302_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_302_chunk USING btree (country);


--
-- Name: _hyper_1_302_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_302_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_302_chunk USING btree (production_type);


--
-- Name: _hyper_1_302_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_302_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_302_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_303_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_303_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_303_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_303_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_303_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_303_chunk USING btree (country);


--
-- Name: _hyper_1_303_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_303_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_303_chunk USING btree (production_type);


--
-- Name: _hyper_1_303_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_303_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_303_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_304_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_304_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_304_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_304_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_304_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_304_chunk USING btree (country);


--
-- Name: _hyper_1_304_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_304_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_304_chunk USING btree (production_type);


--
-- Name: _hyper_1_304_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_304_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_304_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_305_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_305_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_305_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_305_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_305_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_305_chunk USING btree (country);


--
-- Name: _hyper_1_305_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_305_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_305_chunk USING btree (production_type);


--
-- Name: _hyper_1_305_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_305_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_305_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_306_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_306_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_306_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_306_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_306_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_306_chunk USING btree (country);


--
-- Name: _hyper_1_306_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_306_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_306_chunk USING btree (production_type);


--
-- Name: _hyper_1_306_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_306_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_306_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_307_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_307_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_307_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_307_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_307_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_307_chunk USING btree (country);


--
-- Name: _hyper_1_307_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_307_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_307_chunk USING btree (production_type);


--
-- Name: _hyper_1_307_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_307_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_307_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_308_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_308_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_308_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_308_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_308_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_308_chunk USING btree (country);


--
-- Name: _hyper_1_308_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_308_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_308_chunk USING btree (production_type);


--
-- Name: _hyper_1_308_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_308_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_308_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_309_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_309_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_309_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_309_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_309_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_309_chunk USING btree (country);


--
-- Name: _hyper_1_309_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_309_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_309_chunk USING btree (production_type);


--
-- Name: _hyper_1_309_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_309_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_309_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_30_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_30_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_30_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_30_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_30_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_30_chunk USING btree (country);


--
-- Name: _hyper_1_30_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_30_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_30_chunk USING btree (production_type);


--
-- Name: _hyper_1_30_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_30_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_30_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_310_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_310_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_310_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_310_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_310_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_310_chunk USING btree (country);


--
-- Name: _hyper_1_310_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_310_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_310_chunk USING btree (production_type);


--
-- Name: _hyper_1_310_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_310_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_310_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_311_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_311_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_311_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_311_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_311_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_311_chunk USING btree (country);


--
-- Name: _hyper_1_311_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_311_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_311_chunk USING btree (production_type);


--
-- Name: _hyper_1_311_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_311_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_311_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_312_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_312_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_312_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_312_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_312_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_312_chunk USING btree (country);


--
-- Name: _hyper_1_312_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_312_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_312_chunk USING btree (production_type);


--
-- Name: _hyper_1_312_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_312_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_312_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_313_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_313_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_313_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_313_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_313_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_313_chunk USING btree (country);


--
-- Name: _hyper_1_313_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_313_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_313_chunk USING btree (production_type);


--
-- Name: _hyper_1_313_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_313_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_313_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_314_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_314_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_314_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_314_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_314_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_314_chunk USING btree (country);


--
-- Name: _hyper_1_314_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_314_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_314_chunk USING btree (production_type);


--
-- Name: _hyper_1_314_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_314_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_314_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_315_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_315_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_315_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_315_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_315_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_315_chunk USING btree (country);


--
-- Name: _hyper_1_315_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_315_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_315_chunk USING btree (production_type);


--
-- Name: _hyper_1_315_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_315_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_315_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_316_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_316_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_316_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_316_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_316_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_316_chunk USING btree (country);


--
-- Name: _hyper_1_316_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_316_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_316_chunk USING btree (production_type);


--
-- Name: _hyper_1_316_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_316_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_316_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_317_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_317_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_317_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_317_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_317_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_317_chunk USING btree (country);


--
-- Name: _hyper_1_317_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_317_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_317_chunk USING btree (production_type);


--
-- Name: _hyper_1_317_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_317_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_317_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_318_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_318_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_318_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_318_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_318_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_318_chunk USING btree (country);


--
-- Name: _hyper_1_318_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_318_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_318_chunk USING btree (production_type);


--
-- Name: _hyper_1_318_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_318_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_318_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_319_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_319_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_319_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_319_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_319_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_319_chunk USING btree (country);


--
-- Name: _hyper_1_319_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_319_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_319_chunk USING btree (production_type);


--
-- Name: _hyper_1_319_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_319_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_319_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_31_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_31_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_31_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_31_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_31_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_31_chunk USING btree (country);


--
-- Name: _hyper_1_31_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_31_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_31_chunk USING btree (production_type);


--
-- Name: _hyper_1_31_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_31_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_31_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_320_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_320_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_320_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_320_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_320_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_320_chunk USING btree (country);


--
-- Name: _hyper_1_320_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_320_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_320_chunk USING btree (production_type);


--
-- Name: _hyper_1_320_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_320_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_320_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_321_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_321_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_321_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_321_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_321_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_321_chunk USING btree (country);


--
-- Name: _hyper_1_321_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_321_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_321_chunk USING btree (production_type);


--
-- Name: _hyper_1_321_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_321_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_321_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_322_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_322_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_322_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_322_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_322_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_322_chunk USING btree (country);


--
-- Name: _hyper_1_322_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_322_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_322_chunk USING btree (production_type);


--
-- Name: _hyper_1_322_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_322_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_322_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_323_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_323_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_323_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_323_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_323_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_323_chunk USING btree (country);


--
-- Name: _hyper_1_323_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_323_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_323_chunk USING btree (production_type);


--
-- Name: _hyper_1_323_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_323_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_323_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_324_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_324_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_324_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_324_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_324_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_324_chunk USING btree (country);


--
-- Name: _hyper_1_324_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_324_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_324_chunk USING btree (production_type);


--
-- Name: _hyper_1_324_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_324_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_324_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_325_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_325_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_325_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_325_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_325_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_325_chunk USING btree (country);


--
-- Name: _hyper_1_325_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_325_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_325_chunk USING btree (production_type);


--
-- Name: _hyper_1_325_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_325_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_325_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_326_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_326_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_326_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_326_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_326_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_326_chunk USING btree (country);


--
-- Name: _hyper_1_326_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_326_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_326_chunk USING btree (production_type);


--
-- Name: _hyper_1_326_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_326_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_326_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_327_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_327_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_327_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_327_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_327_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_327_chunk USING btree (country);


--
-- Name: _hyper_1_327_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_327_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_327_chunk USING btree (production_type);


--
-- Name: _hyper_1_327_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_327_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_327_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_328_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_328_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_328_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_328_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_328_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_328_chunk USING btree (country);


--
-- Name: _hyper_1_328_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_328_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_328_chunk USING btree (production_type);


--
-- Name: _hyper_1_328_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_328_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_328_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_329_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_329_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_329_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_329_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_329_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_329_chunk USING btree (country);


--
-- Name: _hyper_1_329_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_329_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_329_chunk USING btree (production_type);


--
-- Name: _hyper_1_329_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_329_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_329_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_32_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_32_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_32_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_32_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_32_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_32_chunk USING btree (country);


--
-- Name: _hyper_1_32_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_32_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_32_chunk USING btree (production_type);


--
-- Name: _hyper_1_32_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_32_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_32_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_330_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_330_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_330_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_330_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_330_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_330_chunk USING btree (country);


--
-- Name: _hyper_1_330_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_330_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_330_chunk USING btree (production_type);


--
-- Name: _hyper_1_330_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_330_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_330_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_331_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_331_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_331_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_331_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_331_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_331_chunk USING btree (country);


--
-- Name: _hyper_1_331_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_331_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_331_chunk USING btree (production_type);


--
-- Name: _hyper_1_331_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_331_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_331_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_332_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_332_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_332_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_332_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_332_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_332_chunk USING btree (country);


--
-- Name: _hyper_1_332_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_332_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_332_chunk USING btree (production_type);


--
-- Name: _hyper_1_332_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_332_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_332_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_333_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_333_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_333_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_333_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_333_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_333_chunk USING btree (country);


--
-- Name: _hyper_1_333_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_333_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_333_chunk USING btree (production_type);


--
-- Name: _hyper_1_333_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_333_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_333_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_334_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_334_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_334_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_334_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_334_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_334_chunk USING btree (country);


--
-- Name: _hyper_1_334_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_334_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_334_chunk USING btree (production_type);


--
-- Name: _hyper_1_334_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_334_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_334_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_335_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_335_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_335_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_335_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_335_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_335_chunk USING btree (country);


--
-- Name: _hyper_1_335_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_335_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_335_chunk USING btree (production_type);


--
-- Name: _hyper_1_335_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_335_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_335_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_336_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_336_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_336_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_336_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_336_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_336_chunk USING btree (country);


--
-- Name: _hyper_1_336_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_336_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_336_chunk USING btree (production_type);


--
-- Name: _hyper_1_336_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_336_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_336_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_337_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_337_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_337_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_337_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_337_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_337_chunk USING btree (country);


--
-- Name: _hyper_1_337_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_337_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_337_chunk USING btree (production_type);


--
-- Name: _hyper_1_337_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_337_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_337_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_338_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_338_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_338_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_338_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_338_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_338_chunk USING btree (country);


--
-- Name: _hyper_1_338_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_338_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_338_chunk USING btree (production_type);


--
-- Name: _hyper_1_338_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_338_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_338_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_339_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_339_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_339_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_339_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_339_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_339_chunk USING btree (country);


--
-- Name: _hyper_1_339_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_339_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_339_chunk USING btree (production_type);


--
-- Name: _hyper_1_339_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_339_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_339_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_33_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_33_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_33_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_33_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_33_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_33_chunk USING btree (country);


--
-- Name: _hyper_1_33_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_33_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_33_chunk USING btree (production_type);


--
-- Name: _hyper_1_33_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_33_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_33_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_340_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_340_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_340_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_340_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_340_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_340_chunk USING btree (country);


--
-- Name: _hyper_1_340_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_340_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_340_chunk USING btree (production_type);


--
-- Name: _hyper_1_340_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_340_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_340_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_341_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_341_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_341_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_341_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_341_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_341_chunk USING btree (country);


--
-- Name: _hyper_1_341_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_341_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_341_chunk USING btree (production_type);


--
-- Name: _hyper_1_341_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_341_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_341_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_342_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_342_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_342_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_342_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_342_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_342_chunk USING btree (country);


--
-- Name: _hyper_1_342_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_342_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_342_chunk USING btree (production_type);


--
-- Name: _hyper_1_342_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_342_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_342_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_343_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_343_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_343_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_343_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_343_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_343_chunk USING btree (country);


--
-- Name: _hyper_1_343_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_343_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_343_chunk USING btree (production_type);


--
-- Name: _hyper_1_343_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_343_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_343_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_344_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_344_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_344_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_344_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_344_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_344_chunk USING btree (country);


--
-- Name: _hyper_1_344_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_344_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_344_chunk USING btree (production_type);


--
-- Name: _hyper_1_344_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_344_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_344_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_345_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_345_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_345_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_345_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_345_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_345_chunk USING btree (country);


--
-- Name: _hyper_1_345_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_345_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_345_chunk USING btree (production_type);


--
-- Name: _hyper_1_345_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_345_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_345_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_346_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_346_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_346_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_346_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_346_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_346_chunk USING btree (country);


--
-- Name: _hyper_1_346_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_346_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_346_chunk USING btree (production_type);


--
-- Name: _hyper_1_346_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_346_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_346_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_347_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_347_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_347_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_347_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_347_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_347_chunk USING btree (country);


--
-- Name: _hyper_1_347_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_347_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_347_chunk USING btree (production_type);


--
-- Name: _hyper_1_347_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_347_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_347_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_348_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_348_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_348_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_348_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_348_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_348_chunk USING btree (country);


--
-- Name: _hyper_1_348_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_348_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_348_chunk USING btree (production_type);


--
-- Name: _hyper_1_348_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_348_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_348_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_349_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_349_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_349_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_349_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_349_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_349_chunk USING btree (country);


--
-- Name: _hyper_1_349_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_349_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_349_chunk USING btree (production_type);


--
-- Name: _hyper_1_349_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_349_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_349_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_34_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_34_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_34_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_34_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_34_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_34_chunk USING btree (country);


--
-- Name: _hyper_1_34_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_34_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_34_chunk USING btree (production_type);


--
-- Name: _hyper_1_34_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_34_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_34_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_350_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_350_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_350_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_350_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_350_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_350_chunk USING btree (country);


--
-- Name: _hyper_1_350_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_350_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_350_chunk USING btree (production_type);


--
-- Name: _hyper_1_350_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_350_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_350_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_351_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_351_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_351_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_351_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_351_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_351_chunk USING btree (country);


--
-- Name: _hyper_1_351_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_351_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_351_chunk USING btree (production_type);


--
-- Name: _hyper_1_351_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_351_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_351_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_352_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_352_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_352_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_352_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_352_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_352_chunk USING btree (country);


--
-- Name: _hyper_1_352_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_352_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_352_chunk USING btree (production_type);


--
-- Name: _hyper_1_352_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_352_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_352_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_353_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_353_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_353_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_353_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_353_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_353_chunk USING btree (country);


--
-- Name: _hyper_1_353_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_353_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_353_chunk USING btree (production_type);


--
-- Name: _hyper_1_353_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_353_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_353_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_354_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_354_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_354_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_354_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_354_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_354_chunk USING btree (country);


--
-- Name: _hyper_1_354_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_354_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_354_chunk USING btree (production_type);


--
-- Name: _hyper_1_354_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_354_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_354_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_355_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_355_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_355_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_355_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_355_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_355_chunk USING btree (country);


--
-- Name: _hyper_1_355_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_355_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_355_chunk USING btree (production_type);


--
-- Name: _hyper_1_355_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_355_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_355_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_356_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_356_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_356_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_356_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_356_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_356_chunk USING btree (country);


--
-- Name: _hyper_1_356_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_356_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_356_chunk USING btree (production_type);


--
-- Name: _hyper_1_356_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_356_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_356_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_357_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_357_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_357_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_357_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_357_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_357_chunk USING btree (country);


--
-- Name: _hyper_1_357_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_357_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_357_chunk USING btree (production_type);


--
-- Name: _hyper_1_357_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_357_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_357_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_358_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_358_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_358_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_358_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_358_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_358_chunk USING btree (country);


--
-- Name: _hyper_1_358_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_358_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_358_chunk USING btree (production_type);


--
-- Name: _hyper_1_358_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_358_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_358_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_359_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_359_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_359_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_359_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_359_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_359_chunk USING btree (country);


--
-- Name: _hyper_1_359_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_359_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_359_chunk USING btree (production_type);


--
-- Name: _hyper_1_359_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_359_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_359_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_35_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_35_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_35_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_35_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_35_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_35_chunk USING btree (country);


--
-- Name: _hyper_1_35_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_35_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_35_chunk USING btree (production_type);


--
-- Name: _hyper_1_35_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_35_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_35_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_360_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_360_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_360_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_360_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_360_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_360_chunk USING btree (country);


--
-- Name: _hyper_1_360_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_360_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_360_chunk USING btree (production_type);


--
-- Name: _hyper_1_360_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_360_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_360_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_361_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_361_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_361_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_361_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_361_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_361_chunk USING btree (country);


--
-- Name: _hyper_1_361_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_361_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_361_chunk USING btree (production_type);


--
-- Name: _hyper_1_361_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_361_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_361_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_362_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_362_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_362_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_362_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_362_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_362_chunk USING btree (country);


--
-- Name: _hyper_1_362_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_362_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_362_chunk USING btree (production_type);


--
-- Name: _hyper_1_362_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_362_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_362_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_363_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_363_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_363_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_363_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_363_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_363_chunk USING btree (country);


--
-- Name: _hyper_1_363_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_363_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_363_chunk USING btree (production_type);


--
-- Name: _hyper_1_363_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_363_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_363_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_364_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_364_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_364_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_364_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_364_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_364_chunk USING btree (country);


--
-- Name: _hyper_1_364_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_364_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_364_chunk USING btree (production_type);


--
-- Name: _hyper_1_364_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_364_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_364_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_365_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_365_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_365_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_365_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_365_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_365_chunk USING btree (country);


--
-- Name: _hyper_1_365_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_365_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_365_chunk USING btree (production_type);


--
-- Name: _hyper_1_365_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_365_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_365_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_366_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_366_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_366_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_366_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_366_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_366_chunk USING btree (country);


--
-- Name: _hyper_1_366_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_366_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_366_chunk USING btree (production_type);


--
-- Name: _hyper_1_366_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_366_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_366_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_367_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_367_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_367_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_367_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_367_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_367_chunk USING btree (country);


--
-- Name: _hyper_1_367_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_367_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_367_chunk USING btree (production_type);


--
-- Name: _hyper_1_367_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_367_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_367_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_368_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_368_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_368_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_368_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_368_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_368_chunk USING btree (country);


--
-- Name: _hyper_1_368_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_368_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_368_chunk USING btree (production_type);


--
-- Name: _hyper_1_368_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_368_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_368_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_369_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_369_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_369_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_369_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_369_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_369_chunk USING btree (country);


--
-- Name: _hyper_1_369_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_369_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_369_chunk USING btree (production_type);


--
-- Name: _hyper_1_369_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_369_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_369_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_36_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_36_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_36_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_36_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_36_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_36_chunk USING btree (country);


--
-- Name: _hyper_1_36_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_36_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_36_chunk USING btree (production_type);


--
-- Name: _hyper_1_36_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_36_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_36_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_370_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_370_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_370_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_370_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_370_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_370_chunk USING btree (country);


--
-- Name: _hyper_1_370_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_370_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_370_chunk USING btree (production_type);


--
-- Name: _hyper_1_370_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_370_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_370_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_371_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_371_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_371_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_371_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_371_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_371_chunk USING btree (country);


--
-- Name: _hyper_1_371_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_371_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_371_chunk USING btree (production_type);


--
-- Name: _hyper_1_371_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_371_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_371_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_372_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_372_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_372_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_372_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_372_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_372_chunk USING btree (country);


--
-- Name: _hyper_1_372_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_372_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_372_chunk USING btree (production_type);


--
-- Name: _hyper_1_372_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_372_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_372_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_373_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_373_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_373_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_373_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_373_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_373_chunk USING btree (country);


--
-- Name: _hyper_1_373_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_373_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_373_chunk USING btree (production_type);


--
-- Name: _hyper_1_373_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_373_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_373_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_374_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_374_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_374_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_374_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_374_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_374_chunk USING btree (country);


--
-- Name: _hyper_1_374_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_374_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_374_chunk USING btree (production_type);


--
-- Name: _hyper_1_374_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_374_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_374_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_375_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_375_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_375_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_375_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_375_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_375_chunk USING btree (country);


--
-- Name: _hyper_1_375_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_375_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_375_chunk USING btree (production_type);


--
-- Name: _hyper_1_375_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_375_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_375_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_376_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_376_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_376_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_376_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_376_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_376_chunk USING btree (country);


--
-- Name: _hyper_1_376_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_376_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_376_chunk USING btree (production_type);


--
-- Name: _hyper_1_376_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_376_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_376_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_37_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_37_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_37_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_37_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_37_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_37_chunk USING btree (country);


--
-- Name: _hyper_1_37_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_37_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_37_chunk USING btree (production_type);


--
-- Name: _hyper_1_37_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_37_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_37_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_38_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_38_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_38_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_38_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_38_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_38_chunk USING btree (country);


--
-- Name: _hyper_1_38_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_38_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_38_chunk USING btree (production_type);


--
-- Name: _hyper_1_38_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_38_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_38_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_39_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_39_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_39_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_39_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_39_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_39_chunk USING btree (country);


--
-- Name: _hyper_1_39_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_39_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_39_chunk USING btree (production_type);


--
-- Name: _hyper_1_39_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_39_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_39_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_3_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_3_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_3_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_3_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_3_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_3_chunk USING btree (country);


--
-- Name: _hyper_1_3_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_3_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_3_chunk USING btree (production_type);


--
-- Name: _hyper_1_3_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_3_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_3_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_40_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_40_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_40_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_40_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_40_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_40_chunk USING btree (country);


--
-- Name: _hyper_1_40_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_40_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_40_chunk USING btree (production_type);


--
-- Name: _hyper_1_40_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_40_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_40_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_41_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_41_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_41_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_41_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_41_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_41_chunk USING btree (country);


--
-- Name: _hyper_1_41_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_41_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_41_chunk USING btree (production_type);


--
-- Name: _hyper_1_41_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_41_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_41_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_42_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_42_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_42_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_42_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_42_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_42_chunk USING btree (country);


--
-- Name: _hyper_1_42_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_42_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_42_chunk USING btree (production_type);


--
-- Name: _hyper_1_42_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_42_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_42_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_43_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_43_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_43_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_43_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_43_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_43_chunk USING btree (country);


--
-- Name: _hyper_1_43_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_43_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_43_chunk USING btree (production_type);


--
-- Name: _hyper_1_43_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_43_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_43_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_44_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_44_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_44_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_44_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_44_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_44_chunk USING btree (country);


--
-- Name: _hyper_1_44_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_44_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_44_chunk USING btree (production_type);


--
-- Name: _hyper_1_44_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_44_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_44_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_45_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_45_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_45_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_45_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_45_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_45_chunk USING btree (country);


--
-- Name: _hyper_1_45_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_45_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_45_chunk USING btree (production_type);


--
-- Name: _hyper_1_45_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_45_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_45_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_46_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_46_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_46_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_46_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_46_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_46_chunk USING btree (country);


--
-- Name: _hyper_1_46_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_46_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_46_chunk USING btree (production_type);


--
-- Name: _hyper_1_46_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_46_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_46_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_47_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_47_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_47_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_47_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_47_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_47_chunk USING btree (country);


--
-- Name: _hyper_1_47_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_47_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_47_chunk USING btree (production_type);


--
-- Name: _hyper_1_47_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_47_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_47_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_48_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_48_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_48_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_48_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_48_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_48_chunk USING btree (country);


--
-- Name: _hyper_1_48_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_48_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_48_chunk USING btree (production_type);


--
-- Name: _hyper_1_48_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_48_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_48_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_49_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_49_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_49_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_49_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_49_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_49_chunk USING btree (country);


--
-- Name: _hyper_1_49_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_49_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_49_chunk USING btree (production_type);


--
-- Name: _hyper_1_49_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_49_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_49_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_4_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_4_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_4_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_4_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_4_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_4_chunk USING btree (country);


--
-- Name: _hyper_1_4_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_4_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_4_chunk USING btree (production_type);


--
-- Name: _hyper_1_4_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_4_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_4_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_50_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_50_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_50_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_50_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_50_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_50_chunk USING btree (country);


--
-- Name: _hyper_1_50_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_50_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_50_chunk USING btree (production_type);


--
-- Name: _hyper_1_50_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_50_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_50_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_51_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_51_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_51_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_51_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_51_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_51_chunk USING btree (country);


--
-- Name: _hyper_1_51_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_51_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_51_chunk USING btree (production_type);


--
-- Name: _hyper_1_51_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_51_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_51_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_52_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_52_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_52_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_52_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_52_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_52_chunk USING btree (country);


--
-- Name: _hyper_1_52_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_52_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_52_chunk USING btree (production_type);


--
-- Name: _hyper_1_52_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_52_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_52_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_53_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_53_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_53_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_53_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_53_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_53_chunk USING btree (country);


--
-- Name: _hyper_1_53_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_53_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_53_chunk USING btree (production_type);


--
-- Name: _hyper_1_53_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_53_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_53_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_54_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_54_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_54_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_54_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_54_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_54_chunk USING btree (country);


--
-- Name: _hyper_1_54_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_54_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_54_chunk USING btree (production_type);


--
-- Name: _hyper_1_54_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_54_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_54_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_55_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_55_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_55_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_55_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_55_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_55_chunk USING btree (country);


--
-- Name: _hyper_1_55_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_55_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_55_chunk USING btree (production_type);


--
-- Name: _hyper_1_55_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_55_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_55_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_56_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_56_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_56_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_56_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_56_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_56_chunk USING btree (country);


--
-- Name: _hyper_1_56_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_56_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_56_chunk USING btree (production_type);


--
-- Name: _hyper_1_56_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_56_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_56_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_57_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_57_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_57_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_57_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_57_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_57_chunk USING btree (country);


--
-- Name: _hyper_1_57_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_57_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_57_chunk USING btree (production_type);


--
-- Name: _hyper_1_57_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_57_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_57_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_58_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_58_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_58_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_58_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_58_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_58_chunk USING btree (country);


--
-- Name: _hyper_1_58_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_58_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_58_chunk USING btree (production_type);


--
-- Name: _hyper_1_58_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_58_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_58_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_59_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_59_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_59_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_59_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_59_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_59_chunk USING btree (country);


--
-- Name: _hyper_1_59_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_59_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_59_chunk USING btree (production_type);


--
-- Name: _hyper_1_59_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_59_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_59_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_5_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_5_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_5_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_5_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_5_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_5_chunk USING btree (country);


--
-- Name: _hyper_1_5_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_5_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_5_chunk USING btree (production_type);


--
-- Name: _hyper_1_5_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_5_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_5_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_60_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_60_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_60_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_60_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_60_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_60_chunk USING btree (country);


--
-- Name: _hyper_1_60_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_60_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_60_chunk USING btree (production_type);


--
-- Name: _hyper_1_60_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_60_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_60_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_61_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_61_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_61_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_61_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_61_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_61_chunk USING btree (country);


--
-- Name: _hyper_1_61_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_61_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_61_chunk USING btree (production_type);


--
-- Name: _hyper_1_61_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_61_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_61_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_62_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_62_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_62_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_62_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_62_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_62_chunk USING btree (country);


--
-- Name: _hyper_1_62_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_62_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_62_chunk USING btree (production_type);


--
-- Name: _hyper_1_62_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_62_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_62_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_63_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_63_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_63_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_63_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_63_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_63_chunk USING btree (country);


--
-- Name: _hyper_1_63_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_63_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_63_chunk USING btree (production_type);


--
-- Name: _hyper_1_63_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_63_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_63_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_64_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_64_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_64_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_64_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_64_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_64_chunk USING btree (country);


--
-- Name: _hyper_1_64_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_64_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_64_chunk USING btree (production_type);


--
-- Name: _hyper_1_64_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_64_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_64_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_65_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_65_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_65_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_65_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_65_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_65_chunk USING btree (country);


--
-- Name: _hyper_1_65_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_65_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_65_chunk USING btree (production_type);


--
-- Name: _hyper_1_65_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_65_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_65_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_66_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_66_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_66_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_66_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_66_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_66_chunk USING btree (country);


--
-- Name: _hyper_1_66_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_66_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_66_chunk USING btree (production_type);


--
-- Name: _hyper_1_66_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_66_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_66_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_67_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_67_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_67_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_67_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_67_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_67_chunk USING btree (country);


--
-- Name: _hyper_1_67_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_67_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_67_chunk USING btree (production_type);


--
-- Name: _hyper_1_67_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_67_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_67_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_68_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_68_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_68_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_68_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_68_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_68_chunk USING btree (country);


--
-- Name: _hyper_1_68_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_68_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_68_chunk USING btree (production_type);


--
-- Name: _hyper_1_68_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_68_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_68_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_69_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_69_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_69_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_69_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_69_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_69_chunk USING btree (country);


--
-- Name: _hyper_1_69_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_69_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_69_chunk USING btree (production_type);


--
-- Name: _hyper_1_69_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_69_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_69_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_6_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_6_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_6_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_6_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_6_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_6_chunk USING btree (country);


--
-- Name: _hyper_1_6_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_6_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_6_chunk USING btree (production_type);


--
-- Name: _hyper_1_6_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_6_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_6_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_70_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_70_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_70_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_70_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_70_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_70_chunk USING btree (country);


--
-- Name: _hyper_1_70_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_70_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_70_chunk USING btree (production_type);


--
-- Name: _hyper_1_70_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_70_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_70_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_71_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_71_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_71_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_71_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_71_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_71_chunk USING btree (country);


--
-- Name: _hyper_1_71_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_71_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_71_chunk USING btree (production_type);


--
-- Name: _hyper_1_71_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_71_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_71_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_72_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_72_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_72_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_72_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_72_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_72_chunk USING btree (country);


--
-- Name: _hyper_1_72_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_72_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_72_chunk USING btree (production_type);


--
-- Name: _hyper_1_72_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_72_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_72_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_73_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_73_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_73_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_73_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_73_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_73_chunk USING btree (country);


--
-- Name: _hyper_1_73_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_73_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_73_chunk USING btree (production_type);


--
-- Name: _hyper_1_73_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_73_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_73_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_74_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_74_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_74_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_74_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_74_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_74_chunk USING btree (country);


--
-- Name: _hyper_1_74_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_74_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_74_chunk USING btree (production_type);


--
-- Name: _hyper_1_74_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_74_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_74_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_75_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_75_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_75_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_75_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_75_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_75_chunk USING btree (country);


--
-- Name: _hyper_1_75_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_75_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_75_chunk USING btree (production_type);


--
-- Name: _hyper_1_75_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_75_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_75_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_76_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_76_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_76_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_76_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_76_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_76_chunk USING btree (country);


--
-- Name: _hyper_1_76_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_76_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_76_chunk USING btree (production_type);


--
-- Name: _hyper_1_76_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_76_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_76_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_77_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_77_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_77_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_77_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_77_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_77_chunk USING btree (country);


--
-- Name: _hyper_1_77_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_77_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_77_chunk USING btree (production_type);


--
-- Name: _hyper_1_77_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_77_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_77_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_78_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_78_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_78_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_78_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_78_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_78_chunk USING btree (country);


--
-- Name: _hyper_1_78_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_78_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_78_chunk USING btree (production_type);


--
-- Name: _hyper_1_78_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_78_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_78_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_79_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_79_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_79_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_79_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_79_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_79_chunk USING btree (country);


--
-- Name: _hyper_1_79_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_79_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_79_chunk USING btree (production_type);


--
-- Name: _hyper_1_79_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_79_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_79_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_7_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_7_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_7_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_7_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_7_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_7_chunk USING btree (country);


--
-- Name: _hyper_1_7_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_7_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_7_chunk USING btree (production_type);


--
-- Name: _hyper_1_7_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_7_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_7_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_80_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_80_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_80_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_80_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_80_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_80_chunk USING btree (country);


--
-- Name: _hyper_1_80_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_80_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_80_chunk USING btree (production_type);


--
-- Name: _hyper_1_80_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_80_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_80_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_81_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_81_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_81_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_81_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_81_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_81_chunk USING btree (country);


--
-- Name: _hyper_1_81_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_81_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_81_chunk USING btree (production_type);


--
-- Name: _hyper_1_81_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_81_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_81_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_82_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_82_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_82_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_82_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_82_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_82_chunk USING btree (country);


--
-- Name: _hyper_1_82_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_82_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_82_chunk USING btree (production_type);


--
-- Name: _hyper_1_82_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_82_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_82_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_83_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_83_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_83_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_83_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_83_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_83_chunk USING btree (country);


--
-- Name: _hyper_1_83_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_83_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_83_chunk USING btree (production_type);


--
-- Name: _hyper_1_83_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_83_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_83_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_84_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_84_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_84_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_84_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_84_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_84_chunk USING btree (country);


--
-- Name: _hyper_1_84_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_84_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_84_chunk USING btree (production_type);


--
-- Name: _hyper_1_84_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_84_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_84_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_85_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_85_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_85_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_85_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_85_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_85_chunk USING btree (country);


--
-- Name: _hyper_1_85_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_85_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_85_chunk USING btree (production_type);


--
-- Name: _hyper_1_85_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_85_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_85_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_86_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_86_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_86_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_86_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_86_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_86_chunk USING btree (country);


--
-- Name: _hyper_1_86_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_86_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_86_chunk USING btree (production_type);


--
-- Name: _hyper_1_86_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_86_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_86_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_87_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_87_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_87_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_87_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_87_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_87_chunk USING btree (country);


--
-- Name: _hyper_1_87_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_87_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_87_chunk USING btree (production_type);


--
-- Name: _hyper_1_87_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_87_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_87_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_88_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_88_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_88_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_88_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_88_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_88_chunk USING btree (country);


--
-- Name: _hyper_1_88_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_88_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_88_chunk USING btree (production_type);


--
-- Name: _hyper_1_88_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_88_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_88_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_89_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_89_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_89_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_89_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_89_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_89_chunk USING btree (country);


--
-- Name: _hyper_1_89_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_89_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_89_chunk USING btree (production_type);


--
-- Name: _hyper_1_89_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_89_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_89_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_8_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_8_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_8_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_8_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_8_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_8_chunk USING btree (country);


--
-- Name: _hyper_1_8_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_8_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_8_chunk USING btree (production_type);


--
-- Name: _hyper_1_8_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_8_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_8_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_90_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_90_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_90_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_90_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_90_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_90_chunk USING btree (country);


--
-- Name: _hyper_1_90_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_90_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_90_chunk USING btree (production_type);


--
-- Name: _hyper_1_90_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_90_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_90_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_91_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_91_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_91_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_91_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_91_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_91_chunk USING btree (country);


--
-- Name: _hyper_1_91_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_91_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_91_chunk USING btree (production_type);


--
-- Name: _hyper_1_91_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_91_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_91_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_92_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_92_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_92_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_92_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_92_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_92_chunk USING btree (country);


--
-- Name: _hyper_1_92_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_92_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_92_chunk USING btree (production_type);


--
-- Name: _hyper_1_92_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_92_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_92_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_93_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_93_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_93_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_93_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_93_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_93_chunk USING btree (country);


--
-- Name: _hyper_1_93_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_93_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_93_chunk USING btree (production_type);


--
-- Name: _hyper_1_93_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_93_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_93_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_94_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_94_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_94_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_94_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_94_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_94_chunk USING btree (country);


--
-- Name: _hyper_1_94_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_94_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_94_chunk USING btree (production_type);


--
-- Name: _hyper_1_94_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_94_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_94_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_95_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_95_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_95_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_95_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_95_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_95_chunk USING btree (country);


--
-- Name: _hyper_1_95_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_95_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_95_chunk USING btree (production_type);


--
-- Name: _hyper_1_95_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_95_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_95_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_96_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_96_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_96_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_96_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_96_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_96_chunk USING btree (country);


--
-- Name: _hyper_1_96_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_96_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_96_chunk USING btree (production_type);


--
-- Name: _hyper_1_96_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_96_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_96_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_97_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_97_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_97_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_97_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_97_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_97_chunk USING btree (country);


--
-- Name: _hyper_1_97_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_97_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_97_chunk USING btree (production_type);


--
-- Name: _hyper_1_97_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_97_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_97_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_98_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_98_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_98_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_98_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_98_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_98_chunk USING btree (country);


--
-- Name: _hyper_1_98_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_98_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_98_chunk USING btree (production_type);


--
-- Name: _hyper_1_98_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_98_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_98_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_99_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_99_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_99_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_99_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_99_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_99_chunk USING btree (country);


--
-- Name: _hyper_1_99_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_99_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_99_chunk USING btree (production_type);


--
-- Name: _hyper_1_99_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_99_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_99_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_9_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_9_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_9_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_9_chunk_index_entsoe_generation_on_country; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_9_chunk_index_entsoe_generation_on_country ON _timescaledb_internal._hyper_1_9_chunk USING btree (country);


--
-- Name: _hyper_1_9_chunk_index_entsoe_generation_on_production_type; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_9_chunk_index_entsoe_generation_on_production_type ON _timescaledb_internal._hyper_1_9_chunk USING btree (production_type);


--
-- Name: _hyper_1_9_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_9_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_9_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: entsoe_generation_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entsoe_generation_created_at_idx ON public.entsoe_generation USING btree (created_at DESC);


--
-- Name: index_entsoe_generation_on_country; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entsoe_generation_on_country ON public.entsoe_generation USING btree (country);


--
-- Name: index_entsoe_generation_on_production_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entsoe_generation_on_production_type ON public.entsoe_generation USING btree (production_type);


--
-- Name: intermittency_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX intermittency_unique ON public.entsoe_generation USING btree (created_at, country, production_type, process_type);


--
-- Name: entsoe_generation ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.entsoe_generation FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('0'),
('1'),
('2'),
('3'),
('4');


