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
    "time" timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    CONSTRAINT no_wind_onshore CHECK ((NOT (((country)::text = 'NO'::text) AND (production_type = 'wind_onshore'::public.entsoe_production_types) AND (value > 10000))))
);


--
-- Name: _hyper_1_100_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_100_chunk (
    CONSTRAINT constraint_100 CHECK ((("time" >= '2016-09-22 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_101_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_101_chunk (
    CONSTRAINT constraint_101 CHECK ((("time" >= '2016-09-29 00:00:00'::timestamp without time zone) AND ("time" < '2016-10-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_102_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_102_chunk (
    CONSTRAINT constraint_102 CHECK ((("time" >= '2016-10-06 00:00:00'::timestamp without time zone) AND ("time" < '2016-10-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_103_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_103_chunk (
    CONSTRAINT constraint_103 CHECK ((("time" >= '2016-10-13 00:00:00'::timestamp without time zone) AND ("time" < '2016-10-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_104_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_104_chunk (
    CONSTRAINT constraint_104 CHECK ((("time" >= '2016-10-20 00:00:00'::timestamp without time zone) AND ("time" < '2016-10-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_105_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_105_chunk (
    CONSTRAINT constraint_105 CHECK ((("time" >= '2016-10-27 00:00:00'::timestamp without time zone) AND ("time" < '2016-11-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_106_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_106_chunk (
    CONSTRAINT constraint_106 CHECK ((("time" >= '2016-11-03 00:00:00'::timestamp without time zone) AND ("time" < '2016-11-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_107_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_107_chunk (
    CONSTRAINT constraint_107 CHECK ((("time" >= '2016-11-10 00:00:00'::timestamp without time zone) AND ("time" < '2016-11-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_108_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_108_chunk (
    CONSTRAINT constraint_108 CHECK ((("time" >= '2016-11-17 00:00:00'::timestamp without time zone) AND ("time" < '2016-11-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_109_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_109_chunk (
    CONSTRAINT constraint_109 CHECK ((("time" >= '2016-11-24 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_10_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_10_chunk (
    CONSTRAINT constraint_10 CHECK ((("time" >= '2015-01-01 00:00:00'::timestamp without time zone) AND ("time" < '2015-01-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_110_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_110_chunk (
    CONSTRAINT constraint_110 CHECK ((("time" >= '2016-12-01 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_111_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_111_chunk (
    CONSTRAINT constraint_111 CHECK ((("time" >= '2016-12-08 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_112_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_112_chunk (
    CONSTRAINT constraint_112 CHECK ((("time" >= '2016-12-15 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_113_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_113_chunk (
    CONSTRAINT constraint_113 CHECK ((("time" >= '2016-12-22 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_114_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_114_chunk (
    CONSTRAINT constraint_114 CHECK ((("time" >= '2016-12-29 00:00:00'::timestamp without time zone) AND ("time" < '2017-01-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_115_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_115_chunk (
    CONSTRAINT constraint_115 CHECK ((("time" >= '2017-01-05 00:00:00'::timestamp without time zone) AND ("time" < '2017-01-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_116_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_116_chunk (
    CONSTRAINT constraint_116 CHECK ((("time" >= '2017-01-12 00:00:00'::timestamp without time zone) AND ("time" < '2017-01-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_117_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_117_chunk (
    CONSTRAINT constraint_117 CHECK ((("time" >= '2017-01-19 00:00:00'::timestamp without time zone) AND ("time" < '2017-01-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_118_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_118_chunk (
    CONSTRAINT constraint_118 CHECK ((("time" >= '2017-01-26 00:00:00'::timestamp without time zone) AND ("time" < '2017-02-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_119_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_119_chunk (
    CONSTRAINT constraint_119 CHECK ((("time" >= '2017-02-02 00:00:00'::timestamp without time zone) AND ("time" < '2017-02-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_11_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_11_chunk (
    CONSTRAINT constraint_11 CHECK ((("time" >= '2015-01-08 00:00:00'::timestamp without time zone) AND ("time" < '2015-01-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_120_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_120_chunk (
    CONSTRAINT constraint_120 CHECK ((("time" >= '2017-02-09 00:00:00'::timestamp without time zone) AND ("time" < '2017-02-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_121_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_121_chunk (
    CONSTRAINT constraint_121 CHECK ((("time" >= '2017-02-16 00:00:00'::timestamp without time zone) AND ("time" < '2017-02-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_122_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_122_chunk (
    CONSTRAINT constraint_122 CHECK ((("time" >= '2017-02-23 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_123_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_123_chunk (
    CONSTRAINT constraint_123 CHECK ((("time" >= '2017-03-02 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_124_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_124_chunk (
    CONSTRAINT constraint_124 CHECK ((("time" >= '2017-03-09 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_125_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_125_chunk (
    CONSTRAINT constraint_125 CHECK ((("time" >= '2017-03-16 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_126_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_126_chunk (
    CONSTRAINT constraint_126 CHECK ((("time" >= '2017-03-23 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_127_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_127_chunk (
    CONSTRAINT constraint_127 CHECK ((("time" >= '2017-03-30 00:00:00'::timestamp without time zone) AND ("time" < '2017-04-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_128_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_128_chunk (
    CONSTRAINT constraint_128 CHECK ((("time" >= '2017-04-06 00:00:00'::timestamp without time zone) AND ("time" < '2017-04-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_129_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_129_chunk (
    CONSTRAINT constraint_129 CHECK ((("time" >= '2017-04-13 00:00:00'::timestamp without time zone) AND ("time" < '2017-04-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_12_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_12_chunk (
    CONSTRAINT constraint_12 CHECK ((("time" >= '2015-01-15 00:00:00'::timestamp without time zone) AND ("time" < '2015-01-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_130_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_130_chunk (
    CONSTRAINT constraint_130 CHECK ((("time" >= '2017-04-20 00:00:00'::timestamp without time zone) AND ("time" < '2017-04-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_131_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_131_chunk (
    CONSTRAINT constraint_131 CHECK ((("time" >= '2017-04-27 00:00:00'::timestamp without time zone) AND ("time" < '2017-05-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_132_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_132_chunk (
    CONSTRAINT constraint_132 CHECK ((("time" >= '2017-05-04 00:00:00'::timestamp without time zone) AND ("time" < '2017-05-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_133_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_133_chunk (
    CONSTRAINT constraint_133 CHECK ((("time" >= '2017-05-11 00:00:00'::timestamp without time zone) AND ("time" < '2017-05-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_134_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_134_chunk (
    CONSTRAINT constraint_134 CHECK ((("time" >= '2017-05-18 00:00:00'::timestamp without time zone) AND ("time" < '2017-05-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_135_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_135_chunk (
    CONSTRAINT constraint_135 CHECK ((("time" >= '2017-05-25 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_136_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_136_chunk (
    CONSTRAINT constraint_136 CHECK ((("time" >= '2017-06-01 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_137_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_137_chunk (
    CONSTRAINT constraint_137 CHECK ((("time" >= '2017-06-08 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_138_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_138_chunk (
    CONSTRAINT constraint_138 CHECK ((("time" >= '2017-06-15 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_139_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_139_chunk (
    CONSTRAINT constraint_139 CHECK ((("time" >= '2017-06-22 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_13_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_13_chunk (
    CONSTRAINT constraint_13 CHECK ((("time" >= '2015-01-22 00:00:00'::timestamp without time zone) AND ("time" < '2015-01-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_140_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_140_chunk (
    CONSTRAINT constraint_140 CHECK ((("time" >= '2017-06-29 00:00:00'::timestamp without time zone) AND ("time" < '2017-07-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_141_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_141_chunk (
    CONSTRAINT constraint_141 CHECK ((("time" >= '2017-07-06 00:00:00'::timestamp without time zone) AND ("time" < '2017-07-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_142_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_142_chunk (
    CONSTRAINT constraint_142 CHECK ((("time" >= '2017-07-13 00:00:00'::timestamp without time zone) AND ("time" < '2017-07-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_143_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_143_chunk (
    CONSTRAINT constraint_143 CHECK ((("time" >= '2017-07-20 00:00:00'::timestamp without time zone) AND ("time" < '2017-07-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_144_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_144_chunk (
    CONSTRAINT constraint_144 CHECK ((("time" >= '2017-07-27 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_145_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_145_chunk (
    CONSTRAINT constraint_145 CHECK ((("time" >= '2017-08-03 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_146_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_146_chunk (
    CONSTRAINT constraint_146 CHECK ((("time" >= '2017-08-10 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_147_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_147_chunk (
    CONSTRAINT constraint_147 CHECK ((("time" >= '2017-08-17 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_148_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_148_chunk (
    CONSTRAINT constraint_148 CHECK ((("time" >= '2017-08-24 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_149_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_149_chunk (
    CONSTRAINT constraint_149 CHECK ((("time" >= '2017-08-31 00:00:00'::timestamp without time zone) AND ("time" < '2017-09-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_14_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_14_chunk (
    CONSTRAINT constraint_14 CHECK ((("time" >= '2015-01-29 00:00:00'::timestamp without time zone) AND ("time" < '2015-02-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_150_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_150_chunk (
    CONSTRAINT constraint_150 CHECK ((("time" >= '2017-09-07 00:00:00'::timestamp without time zone) AND ("time" < '2017-09-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_151_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_151_chunk (
    CONSTRAINT constraint_151 CHECK ((("time" >= '2017-09-14 00:00:00'::timestamp without time zone) AND ("time" < '2017-09-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_152_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_152_chunk (
    CONSTRAINT constraint_152 CHECK ((("time" >= '2017-09-21 00:00:00'::timestamp without time zone) AND ("time" < '2017-09-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_153_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_153_chunk (
    CONSTRAINT constraint_153 CHECK ((("time" >= '2017-09-28 00:00:00'::timestamp without time zone) AND ("time" < '2017-10-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_154_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_154_chunk (
    CONSTRAINT constraint_154 CHECK ((("time" >= '2017-10-05 00:00:00'::timestamp without time zone) AND ("time" < '2017-10-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_155_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_155_chunk (
    CONSTRAINT constraint_155 CHECK ((("time" >= '2017-10-12 00:00:00'::timestamp without time zone) AND ("time" < '2017-10-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_156_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_156_chunk (
    CONSTRAINT constraint_156 CHECK ((("time" >= '2017-10-19 00:00:00'::timestamp without time zone) AND ("time" < '2017-10-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_157_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_157_chunk (
    CONSTRAINT constraint_157 CHECK ((("time" >= '2017-10-26 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_158_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_158_chunk (
    CONSTRAINT constraint_158 CHECK ((("time" >= '2017-11-02 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_159_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_159_chunk (
    CONSTRAINT constraint_159 CHECK ((("time" >= '2017-11-09 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_15_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_15_chunk (
    CONSTRAINT constraint_15 CHECK ((("time" >= '2015-02-05 00:00:00'::timestamp without time zone) AND ("time" < '2015-02-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_160_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_160_chunk (
    CONSTRAINT constraint_160 CHECK ((("time" >= '2017-11-16 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_161_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_161_chunk (
    CONSTRAINT constraint_161 CHECK ((("time" >= '2017-11-23 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_162_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_162_chunk (
    CONSTRAINT constraint_162 CHECK ((("time" >= '2017-11-30 00:00:00'::timestamp without time zone) AND ("time" < '2017-12-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_163_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_163_chunk (
    CONSTRAINT constraint_163 CHECK ((("time" >= '2017-12-07 00:00:00'::timestamp without time zone) AND ("time" < '2017-12-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_164_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_164_chunk (
    CONSTRAINT constraint_164 CHECK ((("time" >= '2017-12-14 00:00:00'::timestamp without time zone) AND ("time" < '2017-12-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_165_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_165_chunk (
    CONSTRAINT constraint_165 CHECK ((("time" >= '2017-12-21 00:00:00'::timestamp without time zone) AND ("time" < '2017-12-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_166_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_166_chunk (
    CONSTRAINT constraint_166 CHECK ((("time" >= '2017-12-28 00:00:00'::timestamp without time zone) AND ("time" < '2018-01-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_167_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_167_chunk (
    CONSTRAINT constraint_167 CHECK ((("time" >= '2018-01-04 00:00:00'::timestamp without time zone) AND ("time" < '2018-01-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_168_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_168_chunk (
    CONSTRAINT constraint_168 CHECK ((("time" >= '2018-01-11 00:00:00'::timestamp without time zone) AND ("time" < '2018-01-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_169_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_169_chunk (
    CONSTRAINT constraint_169 CHECK ((("time" >= '2018-01-18 00:00:00'::timestamp without time zone) AND ("time" < '2018-01-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_16_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_16_chunk (
    CONSTRAINT constraint_16 CHECK ((("time" >= '2015-02-12 00:00:00'::timestamp without time zone) AND ("time" < '2015-02-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_170_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_170_chunk (
    CONSTRAINT constraint_170 CHECK ((("time" >= '2018-01-25 00:00:00'::timestamp without time zone) AND ("time" < '2018-02-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_171_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_171_chunk (
    CONSTRAINT constraint_171 CHECK ((("time" >= '2018-02-01 00:00:00'::timestamp without time zone) AND ("time" < '2018-02-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_172_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_172_chunk (
    CONSTRAINT constraint_172 CHECK ((("time" >= '2018-02-08 00:00:00'::timestamp without time zone) AND ("time" < '2018-02-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_173_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_173_chunk (
    CONSTRAINT constraint_173 CHECK ((("time" >= '2018-02-15 00:00:00'::timestamp without time zone) AND ("time" < '2018-02-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_174_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_174_chunk (
    CONSTRAINT constraint_174 CHECK ((("time" >= '2018-02-22 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_175_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_175_chunk (
    CONSTRAINT constraint_175 CHECK ((("time" >= '2018-03-01 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_176_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_176_chunk (
    CONSTRAINT constraint_176 CHECK ((("time" >= '2018-03-08 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_177_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_177_chunk (
    CONSTRAINT constraint_177 CHECK ((("time" >= '2018-03-15 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_178_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_178_chunk (
    CONSTRAINT constraint_178 CHECK ((("time" >= '2018-03-22 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_179_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_179_chunk (
    CONSTRAINT constraint_179 CHECK ((("time" >= '2018-03-29 00:00:00'::timestamp without time zone) AND ("time" < '2018-04-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_17_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_17_chunk (
    CONSTRAINT constraint_17 CHECK ((("time" >= '2015-02-19 00:00:00'::timestamp without time zone) AND ("time" < '2015-02-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_180_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_180_chunk (
    CONSTRAINT constraint_180 CHECK ((("time" >= '2018-04-05 00:00:00'::timestamp without time zone) AND ("time" < '2018-04-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_181_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_181_chunk (
    CONSTRAINT constraint_181 CHECK ((("time" >= '2018-04-12 00:00:00'::timestamp without time zone) AND ("time" < '2018-04-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_182_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_182_chunk (
    CONSTRAINT constraint_182 CHECK ((("time" >= '2018-04-19 00:00:00'::timestamp without time zone) AND ("time" < '2018-04-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_183_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_183_chunk (
    CONSTRAINT constraint_183 CHECK ((("time" >= '2018-04-26 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_184_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_184_chunk (
    CONSTRAINT constraint_184 CHECK ((("time" >= '2018-05-03 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_185_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_185_chunk (
    CONSTRAINT constraint_185 CHECK ((("time" >= '2018-05-10 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_186_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_186_chunk (
    CONSTRAINT constraint_186 CHECK ((("time" >= '2018-05-17 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_187_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_187_chunk (
    CONSTRAINT constraint_187 CHECK ((("time" >= '2018-05-24 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_188_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_188_chunk (
    CONSTRAINT constraint_188 CHECK ((("time" >= '2018-05-31 00:00:00'::timestamp without time zone) AND ("time" < '2018-06-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_189_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_189_chunk (
    CONSTRAINT constraint_189 CHECK ((("time" >= '2018-06-07 00:00:00'::timestamp without time zone) AND ("time" < '2018-06-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_18_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_18_chunk (
    CONSTRAINT constraint_18 CHECK ((("time" >= '2015-02-26 00:00:00'::timestamp without time zone) AND ("time" < '2015-03-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_190_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_190_chunk (
    CONSTRAINT constraint_190 CHECK ((("time" >= '2018-06-14 00:00:00'::timestamp without time zone) AND ("time" < '2018-06-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_191_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_191_chunk (
    CONSTRAINT constraint_191 CHECK ((("time" >= '2018-06-21 00:00:00'::timestamp without time zone) AND ("time" < '2018-06-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_192_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_192_chunk (
    CONSTRAINT constraint_192 CHECK ((("time" >= '2018-06-28 00:00:00'::timestamp without time zone) AND ("time" < '2018-07-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_193_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_193_chunk (
    CONSTRAINT constraint_193 CHECK ((("time" >= '2018-07-05 00:00:00'::timestamp without time zone) AND ("time" < '2018-07-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_194_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_194_chunk (
    CONSTRAINT constraint_194 CHECK ((("time" >= '2018-07-12 00:00:00'::timestamp without time zone) AND ("time" < '2018-07-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_195_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_195_chunk (
    CONSTRAINT constraint_195 CHECK ((("time" >= '2018-07-19 00:00:00'::timestamp without time zone) AND ("time" < '2018-07-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_196_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_196_chunk (
    CONSTRAINT constraint_196 CHECK ((("time" >= '2018-07-26 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_197_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_197_chunk (
    CONSTRAINT constraint_197 CHECK ((("time" >= '2018-08-02 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_198_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_198_chunk (
    CONSTRAINT constraint_198 CHECK ((("time" >= '2018-08-09 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_199_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_199_chunk (
    CONSTRAINT constraint_199 CHECK ((("time" >= '2018-08-16 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_19_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_19_chunk (
    CONSTRAINT constraint_19 CHECK ((("time" >= '2015-03-05 00:00:00'::timestamp without time zone) AND ("time" < '2015-03-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_1_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1_chunk (
    CONSTRAINT constraint_1 CHECK ((("time" >= '2014-10-30 00:00:00'::timestamp without time zone) AND ("time" < '2014-11-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_200_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_200_chunk (
    CONSTRAINT constraint_200 CHECK ((("time" >= '2018-08-23 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_201_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_201_chunk (
    CONSTRAINT constraint_201 CHECK ((("time" >= '2018-08-30 00:00:00'::timestamp without time zone) AND ("time" < '2018-09-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_202_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_202_chunk (
    CONSTRAINT constraint_202 CHECK ((("time" >= '2018-09-06 00:00:00'::timestamp without time zone) AND ("time" < '2018-09-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_203_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_203_chunk (
    CONSTRAINT constraint_203 CHECK ((("time" >= '2018-09-13 00:00:00'::timestamp without time zone) AND ("time" < '2018-09-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_204_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_204_chunk (
    CONSTRAINT constraint_204 CHECK ((("time" >= '2018-09-20 00:00:00'::timestamp without time zone) AND ("time" < '2018-09-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_205_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_205_chunk (
    CONSTRAINT constraint_205 CHECK ((("time" >= '2018-09-27 00:00:00'::timestamp without time zone) AND ("time" < '2018-10-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_206_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_206_chunk (
    CONSTRAINT constraint_206 CHECK ((("time" >= '2018-10-04 00:00:00'::timestamp without time zone) AND ("time" < '2018-10-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_207_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_207_chunk (
    CONSTRAINT constraint_207 CHECK ((("time" >= '2018-10-11 00:00:00'::timestamp without time zone) AND ("time" < '2018-10-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_208_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_208_chunk (
    CONSTRAINT constraint_208 CHECK ((("time" >= '2018-10-18 00:00:00'::timestamp without time zone) AND ("time" < '2018-10-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_209_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_209_chunk (
    CONSTRAINT constraint_209 CHECK ((("time" >= '2018-10-25 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_20_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_20_chunk (
    CONSTRAINT constraint_20 CHECK ((("time" >= '2015-03-12 00:00:00'::timestamp without time zone) AND ("time" < '2015-03-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_210_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_210_chunk (
    CONSTRAINT constraint_210 CHECK ((("time" >= '2018-11-01 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_211_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_211_chunk (
    CONSTRAINT constraint_211 CHECK ((("time" >= '2018-11-08 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_212_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_212_chunk (
    CONSTRAINT constraint_212 CHECK ((("time" >= '2018-11-15 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_213_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_213_chunk (
    CONSTRAINT constraint_213 CHECK ((("time" >= '2018-11-22 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_214_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_214_chunk (
    CONSTRAINT constraint_214 CHECK ((("time" >= '2018-11-29 00:00:00'::timestamp without time zone) AND ("time" < '2018-12-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_215_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_215_chunk (
    CONSTRAINT constraint_215 CHECK ((("time" >= '2018-12-06 00:00:00'::timestamp without time zone) AND ("time" < '2018-12-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_216_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_216_chunk (
    CONSTRAINT constraint_216 CHECK ((("time" >= '2018-12-13 00:00:00'::timestamp without time zone) AND ("time" < '2018-12-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_217_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_217_chunk (
    CONSTRAINT constraint_217 CHECK ((("time" >= '2018-12-20 00:00:00'::timestamp without time zone) AND ("time" < '2018-12-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_218_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_218_chunk (
    CONSTRAINT constraint_218 CHECK ((("time" >= '2018-12-27 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_219_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_219_chunk (
    CONSTRAINT constraint_219 CHECK ((("time" >= '2019-01-03 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_21_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_21_chunk (
    CONSTRAINT constraint_21 CHECK ((("time" >= '2015-03-19 00:00:00'::timestamp without time zone) AND ("time" < '2015-03-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_220_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_220_chunk (
    CONSTRAINT constraint_220 CHECK ((("time" >= '2019-01-10 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_221_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_221_chunk (
    CONSTRAINT constraint_221 CHECK ((("time" >= '2019-01-17 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_222_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_222_chunk (
    CONSTRAINT constraint_222 CHECK ((("time" >= '2019-01-24 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_223_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_223_chunk (
    CONSTRAINT constraint_223 CHECK ((("time" >= '2019-01-31 00:00:00'::timestamp without time zone) AND ("time" < '2019-02-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_224_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_224_chunk (
    CONSTRAINT constraint_224 CHECK ((("time" >= '2019-02-07 00:00:00'::timestamp without time zone) AND ("time" < '2019-02-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_225_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_225_chunk (
    CONSTRAINT constraint_225 CHECK ((("time" >= '2019-02-14 00:00:00'::timestamp without time zone) AND ("time" < '2019-02-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_226_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_226_chunk (
    CONSTRAINT constraint_226 CHECK ((("time" >= '2019-02-21 00:00:00'::timestamp without time zone) AND ("time" < '2019-02-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_227_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_227_chunk (
    CONSTRAINT constraint_227 CHECK ((("time" >= '2019-02-28 00:00:00'::timestamp without time zone) AND ("time" < '2019-03-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_228_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_228_chunk (
    CONSTRAINT constraint_228 CHECK ((("time" >= '2019-03-07 00:00:00'::timestamp without time zone) AND ("time" < '2019-03-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_229_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_229_chunk (
    CONSTRAINT constraint_229 CHECK ((("time" >= '2019-03-14 00:00:00'::timestamp without time zone) AND ("time" < '2019-03-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_22_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_22_chunk (
    CONSTRAINT constraint_22 CHECK ((("time" >= '2015-03-26 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_230_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_230_chunk (
    CONSTRAINT constraint_230 CHECK ((("time" >= '2019-03-21 00:00:00'::timestamp without time zone) AND ("time" < '2019-03-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_231_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_231_chunk (
    CONSTRAINT constraint_231 CHECK ((("time" >= '2019-03-28 00:00:00'::timestamp without time zone) AND ("time" < '2019-04-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_232_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_232_chunk (
    CONSTRAINT constraint_232 CHECK ((("time" >= '2019-04-04 00:00:00'::timestamp without time zone) AND ("time" < '2019-04-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_233_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_233_chunk (
    CONSTRAINT constraint_233 CHECK ((("time" >= '2019-04-11 00:00:00'::timestamp without time zone) AND ("time" < '2019-04-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_234_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_234_chunk (
    CONSTRAINT constraint_234 CHECK ((("time" >= '2019-04-18 00:00:00'::timestamp without time zone) AND ("time" < '2019-04-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_235_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_235_chunk (
    CONSTRAINT constraint_235 CHECK ((("time" >= '2019-04-25 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_236_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_236_chunk (
    CONSTRAINT constraint_236 CHECK ((("time" >= '2019-05-02 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_237_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_237_chunk (
    CONSTRAINT constraint_237 CHECK ((("time" >= '2019-05-09 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_238_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_238_chunk (
    CONSTRAINT constraint_238 CHECK ((("time" >= '2019-05-16 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_239_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_239_chunk (
    CONSTRAINT constraint_239 CHECK ((("time" >= '2019-05-23 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_23_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_23_chunk (
    CONSTRAINT constraint_23 CHECK ((("time" >= '2015-04-02 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_240_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_240_chunk (
    CONSTRAINT constraint_240 CHECK ((("time" >= '2019-05-30 00:00:00'::timestamp without time zone) AND ("time" < '2019-06-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_241_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_241_chunk (
    CONSTRAINT constraint_241 CHECK ((("time" >= '2019-06-06 00:00:00'::timestamp without time zone) AND ("time" < '2019-06-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_242_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_242_chunk (
    CONSTRAINT constraint_242 CHECK ((("time" >= '2019-06-13 00:00:00'::timestamp without time zone) AND ("time" < '2019-06-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_243_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_243_chunk (
    CONSTRAINT constraint_243 CHECK ((("time" >= '2019-06-20 00:00:00'::timestamp without time zone) AND ("time" < '2019-06-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_244_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_244_chunk (
    CONSTRAINT constraint_244 CHECK ((("time" >= '2019-06-27 00:00:00'::timestamp without time zone) AND ("time" < '2019-07-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_245_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_245_chunk (
    CONSTRAINT constraint_245 CHECK ((("time" >= '2019-07-04 00:00:00'::timestamp without time zone) AND ("time" < '2019-07-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_246_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_246_chunk (
    CONSTRAINT constraint_246 CHECK ((("time" >= '2019-07-11 00:00:00'::timestamp without time zone) AND ("time" < '2019-07-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_247_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_247_chunk (
    CONSTRAINT constraint_247 CHECK ((("time" >= '2019-07-18 00:00:00'::timestamp without time zone) AND ("time" < '2019-07-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_248_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_248_chunk (
    CONSTRAINT constraint_248 CHECK ((("time" >= '2019-07-25 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_249_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_249_chunk (
    CONSTRAINT constraint_249 CHECK ((("time" >= '2019-08-01 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_24_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_24_chunk (
    CONSTRAINT constraint_24 CHECK ((("time" >= '2015-04-09 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_250_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_250_chunk (
    CONSTRAINT constraint_250 CHECK ((("time" >= '2019-08-08 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_251_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_251_chunk (
    CONSTRAINT constraint_251 CHECK ((("time" >= '2019-08-15 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_252_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_252_chunk (
    CONSTRAINT constraint_252 CHECK ((("time" >= '2019-08-22 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_253_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_253_chunk (
    CONSTRAINT constraint_253 CHECK ((("time" >= '2019-08-29 00:00:00'::timestamp without time zone) AND ("time" < '2019-09-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_254_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_254_chunk (
    CONSTRAINT constraint_254 CHECK ((("time" >= '2019-09-05 00:00:00'::timestamp without time zone) AND ("time" < '2019-09-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_255_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_255_chunk (
    CONSTRAINT constraint_255 CHECK ((("time" >= '2019-09-12 00:00:00'::timestamp without time zone) AND ("time" < '2019-09-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_256_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_256_chunk (
    CONSTRAINT constraint_256 CHECK ((("time" >= '2019-09-19 00:00:00'::timestamp without time zone) AND ("time" < '2019-09-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_257_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_257_chunk (
    CONSTRAINT constraint_257 CHECK ((("time" >= '2019-09-26 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_258_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_258_chunk (
    CONSTRAINT constraint_258 CHECK ((("time" >= '2019-10-03 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_259_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_259_chunk (
    CONSTRAINT constraint_259 CHECK ((("time" >= '2019-10-10 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_25_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_25_chunk (
    CONSTRAINT constraint_25 CHECK ((("time" >= '2015-04-16 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_260_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_260_chunk (
    CONSTRAINT constraint_260 CHECK ((("time" >= '2019-10-17 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_261_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_261_chunk (
    CONSTRAINT constraint_261 CHECK ((("time" >= '2019-10-24 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_262_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_262_chunk (
    CONSTRAINT constraint_262 CHECK ((("time" >= '2019-10-31 00:00:00'::timestamp without time zone) AND ("time" < '2019-11-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_263_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_263_chunk (
    CONSTRAINT constraint_263 CHECK ((("time" >= '2019-11-07 00:00:00'::timestamp without time zone) AND ("time" < '2019-11-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_264_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_264_chunk (
    CONSTRAINT constraint_264 CHECK ((("time" >= '2019-11-14 00:00:00'::timestamp without time zone) AND ("time" < '2019-11-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_265_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_265_chunk (
    CONSTRAINT constraint_265 CHECK ((("time" >= '2019-11-21 00:00:00'::timestamp without time zone) AND ("time" < '2019-11-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_266_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_266_chunk (
    CONSTRAINT constraint_266 CHECK ((("time" >= '2019-11-28 00:00:00'::timestamp without time zone) AND ("time" < '2019-12-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_267_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_267_chunk (
    CONSTRAINT constraint_267 CHECK ((("time" >= '2019-12-05 00:00:00'::timestamp without time zone) AND ("time" < '2019-12-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_268_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_268_chunk (
    CONSTRAINT constraint_268 CHECK ((("time" >= '2019-12-12 00:00:00'::timestamp without time zone) AND ("time" < '2019-12-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_269_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_269_chunk (
    CONSTRAINT constraint_269 CHECK ((("time" >= '2019-12-19 00:00:00'::timestamp without time zone) AND ("time" < '2019-12-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_26_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_26_chunk (
    CONSTRAINT constraint_26 CHECK ((("time" >= '2015-04-23 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_270_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_270_chunk (
    CONSTRAINT constraint_270 CHECK ((("time" >= '2019-12-26 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_271_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_271_chunk (
    CONSTRAINT constraint_271 CHECK ((("time" >= '2020-01-02 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_272_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_272_chunk (
    CONSTRAINT constraint_272 CHECK ((("time" >= '2020-01-09 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_273_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_273_chunk (
    CONSTRAINT constraint_273 CHECK ((("time" >= '2020-01-16 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_274_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_274_chunk (
    CONSTRAINT constraint_274 CHECK ((("time" >= '2020-01-23 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_275_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_275_chunk (
    CONSTRAINT constraint_275 CHECK ((("time" >= '2020-01-30 00:00:00'::timestamp without time zone) AND ("time" < '2020-02-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_276_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_276_chunk (
    CONSTRAINT constraint_276 CHECK ((("time" >= '2020-02-06 00:00:00'::timestamp without time zone) AND ("time" < '2020-02-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_277_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_277_chunk (
    CONSTRAINT constraint_277 CHECK ((("time" >= '2020-02-13 00:00:00'::timestamp without time zone) AND ("time" < '2020-02-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_278_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_278_chunk (
    CONSTRAINT constraint_278 CHECK ((("time" >= '2020-02-20 00:00:00'::timestamp without time zone) AND ("time" < '2020-02-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_279_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_279_chunk (
    CONSTRAINT constraint_279 CHECK ((("time" >= '2020-02-27 00:00:00'::timestamp without time zone) AND ("time" < '2020-03-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_27_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_27_chunk (
    CONSTRAINT constraint_27 CHECK ((("time" >= '2015-04-30 00:00:00'::timestamp without time zone) AND ("time" < '2015-05-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_280_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_280_chunk (
    CONSTRAINT constraint_280 CHECK ((("time" >= '2020-03-05 00:00:00'::timestamp without time zone) AND ("time" < '2020-03-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_281_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_281_chunk (
    CONSTRAINT constraint_281 CHECK ((("time" >= '2020-03-12 00:00:00'::timestamp without time zone) AND ("time" < '2020-03-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_282_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_282_chunk (
    CONSTRAINT constraint_282 CHECK ((("time" >= '2020-03-19 00:00:00'::timestamp without time zone) AND ("time" < '2020-03-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_283_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_283_chunk (
    CONSTRAINT constraint_283 CHECK ((("time" >= '2020-03-26 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_284_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_284_chunk (
    CONSTRAINT constraint_284 CHECK ((("time" >= '2020-04-02 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_285_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_285_chunk (
    CONSTRAINT constraint_285 CHECK ((("time" >= '2020-04-09 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_286_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_286_chunk (
    CONSTRAINT constraint_286 CHECK ((("time" >= '2020-04-16 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_287_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_287_chunk (
    CONSTRAINT constraint_287 CHECK ((("time" >= '2020-04-23 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_288_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_288_chunk (
    CONSTRAINT constraint_288 CHECK ((("time" >= '2020-04-30 00:00:00'::timestamp without time zone) AND ("time" < '2020-05-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_289_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_289_chunk (
    CONSTRAINT constraint_289 CHECK ((("time" >= '2020-05-07 00:00:00'::timestamp without time zone) AND ("time" < '2020-05-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_28_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_28_chunk (
    CONSTRAINT constraint_28 CHECK ((("time" >= '2015-05-07 00:00:00'::timestamp without time zone) AND ("time" < '2015-05-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_290_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_290_chunk (
    CONSTRAINT constraint_290 CHECK ((("time" >= '2020-05-14 00:00:00'::timestamp without time zone) AND ("time" < '2020-05-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_291_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_291_chunk (
    CONSTRAINT constraint_291 CHECK ((("time" >= '2020-05-21 00:00:00'::timestamp without time zone) AND ("time" < '2020-05-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_292_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_292_chunk (
    CONSTRAINT constraint_292 CHECK ((("time" >= '2020-05-28 00:00:00'::timestamp without time zone) AND ("time" < '2020-06-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_293_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_293_chunk (
    CONSTRAINT constraint_293 CHECK ((("time" >= '2020-06-04 00:00:00'::timestamp without time zone) AND ("time" < '2020-06-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_294_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_294_chunk (
    CONSTRAINT constraint_294 CHECK ((("time" >= '2020-06-11 00:00:00'::timestamp without time zone) AND ("time" < '2020-06-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_295_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_295_chunk (
    CONSTRAINT constraint_295 CHECK ((("time" >= '2020-06-18 00:00:00'::timestamp without time zone) AND ("time" < '2020-06-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_296_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_296_chunk (
    CONSTRAINT constraint_296 CHECK ((("time" >= '2020-06-25 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_297_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_297_chunk (
    CONSTRAINT constraint_297 CHECK ((("time" >= '2020-07-02 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_298_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_298_chunk (
    CONSTRAINT constraint_298 CHECK ((("time" >= '2020-07-09 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_299_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_299_chunk (
    CONSTRAINT constraint_299 CHECK ((("time" >= '2020-07-16 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_29_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_29_chunk (
    CONSTRAINT constraint_29 CHECK ((("time" >= '2015-05-14 00:00:00'::timestamp without time zone) AND ("time" < '2015-05-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_2_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_2_chunk (
    CONSTRAINT constraint_2 CHECK ((("time" >= '2014-11-06 00:00:00'::timestamp without time zone) AND ("time" < '2014-11-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_300_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_300_chunk (
    CONSTRAINT constraint_300 CHECK ((("time" >= '2020-07-23 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_301_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_301_chunk (
    CONSTRAINT constraint_301 CHECK ((("time" >= '2020-07-30 00:00:00'::timestamp without time zone) AND ("time" < '2020-08-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_302_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_302_chunk (
    CONSTRAINT constraint_302 CHECK ((("time" >= '2020-08-06 00:00:00'::timestamp without time zone) AND ("time" < '2020-08-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_303_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_303_chunk (
    CONSTRAINT constraint_303 CHECK ((("time" >= '2020-08-13 00:00:00'::timestamp without time zone) AND ("time" < '2020-08-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_304_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_304_chunk (
    CONSTRAINT constraint_304 CHECK ((("time" >= '2020-08-20 00:00:00'::timestamp without time zone) AND ("time" < '2020-08-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_305_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_305_chunk (
    CONSTRAINT constraint_305 CHECK ((("time" >= '2020-08-27 00:00:00'::timestamp without time zone) AND ("time" < '2020-09-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_306_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_306_chunk (
    CONSTRAINT constraint_306 CHECK ((("time" >= '2020-09-03 00:00:00'::timestamp without time zone) AND ("time" < '2020-09-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_307_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_307_chunk (
    CONSTRAINT constraint_307 CHECK ((("time" >= '2020-09-10 00:00:00'::timestamp without time zone) AND ("time" < '2020-09-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_308_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_308_chunk (
    CONSTRAINT constraint_308 CHECK ((("time" >= '2020-09-17 00:00:00'::timestamp without time zone) AND ("time" < '2020-09-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_309_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_309_chunk (
    CONSTRAINT constraint_309 CHECK ((("time" >= '2020-09-24 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_30_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_30_chunk (
    CONSTRAINT constraint_30 CHECK ((("time" >= '2015-05-21 00:00:00'::timestamp without time zone) AND ("time" < '2015-05-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_310_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_310_chunk (
    CONSTRAINT constraint_310 CHECK ((("time" >= '2020-10-01 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_311_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_311_chunk (
    CONSTRAINT constraint_311 CHECK ((("time" >= '2020-10-08 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_312_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_312_chunk (
    CONSTRAINT constraint_312 CHECK ((("time" >= '2020-10-15 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_313_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_313_chunk (
    CONSTRAINT constraint_313 CHECK ((("time" >= '2020-10-22 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_314_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_314_chunk (
    CONSTRAINT constraint_314 CHECK ((("time" >= '2020-10-29 00:00:00'::timestamp without time zone) AND ("time" < '2020-11-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_315_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_315_chunk (
    CONSTRAINT constraint_315 CHECK ((("time" >= '2020-11-05 00:00:00'::timestamp without time zone) AND ("time" < '2020-11-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_316_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_316_chunk (
    CONSTRAINT constraint_316 CHECK ((("time" >= '2020-11-12 00:00:00'::timestamp without time zone) AND ("time" < '2020-11-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_317_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_317_chunk (
    CONSTRAINT constraint_317 CHECK ((("time" >= '2020-11-19 00:00:00'::timestamp without time zone) AND ("time" < '2020-11-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_318_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_318_chunk (
    CONSTRAINT constraint_318 CHECK ((("time" >= '2020-11-26 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_319_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_319_chunk (
    CONSTRAINT constraint_319 CHECK ((("time" >= '2020-12-03 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_31_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_31_chunk (
    CONSTRAINT constraint_31 CHECK ((("time" >= '2015-05-28 00:00:00'::timestamp without time zone) AND ("time" < '2015-06-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_320_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_320_chunk (
    CONSTRAINT constraint_320 CHECK ((("time" >= '2020-12-10 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_321_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_321_chunk (
    CONSTRAINT constraint_321 CHECK ((("time" >= '2020-12-17 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_322_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_322_chunk (
    CONSTRAINT constraint_322 CHECK ((("time" >= '2020-12-24 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_323_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_323_chunk (
    CONSTRAINT constraint_323 CHECK ((("time" >= '2020-12-31 00:00:00'::timestamp without time zone) AND ("time" < '2021-01-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_324_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_324_chunk (
    CONSTRAINT constraint_324 CHECK ((("time" >= '2021-01-07 00:00:00'::timestamp without time zone) AND ("time" < '2021-01-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_325_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_325_chunk (
    CONSTRAINT constraint_325 CHECK ((("time" >= '2021-01-14 00:00:00'::timestamp without time zone) AND ("time" < '2021-01-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_326_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_326_chunk (
    CONSTRAINT constraint_326 CHECK ((("time" >= '2021-01-21 00:00:00'::timestamp without time zone) AND ("time" < '2021-01-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_327_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_327_chunk (
    CONSTRAINT constraint_327 CHECK ((("time" >= '2021-01-28 00:00:00'::timestamp without time zone) AND ("time" < '2021-02-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_328_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_328_chunk (
    CONSTRAINT constraint_328 CHECK ((("time" >= '2021-02-04 00:00:00'::timestamp without time zone) AND ("time" < '2021-02-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_329_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_329_chunk (
    CONSTRAINT constraint_329 CHECK ((("time" >= '2021-02-11 00:00:00'::timestamp without time zone) AND ("time" < '2021-02-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_32_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_32_chunk (
    CONSTRAINT constraint_32 CHECK ((("time" >= '2015-06-04 00:00:00'::timestamp without time zone) AND ("time" < '2015-06-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_330_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_330_chunk (
    CONSTRAINT constraint_330 CHECK ((("time" >= '2021-02-18 00:00:00'::timestamp without time zone) AND ("time" < '2021-02-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_331_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_331_chunk (
    CONSTRAINT constraint_331 CHECK ((("time" >= '2021-02-25 00:00:00'::timestamp without time zone) AND ("time" < '2021-03-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_332_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_332_chunk (
    CONSTRAINT constraint_332 CHECK ((("time" >= '2021-03-04 00:00:00'::timestamp without time zone) AND ("time" < '2021-03-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_333_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_333_chunk (
    CONSTRAINT constraint_333 CHECK ((("time" >= '2021-03-11 00:00:00'::timestamp without time zone) AND ("time" < '2021-03-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_334_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_334_chunk (
    CONSTRAINT constraint_334 CHECK ((("time" >= '2021-03-18 00:00:00'::timestamp without time zone) AND ("time" < '2021-03-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_335_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_335_chunk (
    CONSTRAINT constraint_335 CHECK ((("time" >= '2021-03-25 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_336_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_336_chunk (
    CONSTRAINT constraint_336 CHECK ((("time" >= '2021-04-01 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_337_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_337_chunk (
    CONSTRAINT constraint_337 CHECK ((("time" >= '2021-04-08 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_338_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_338_chunk (
    CONSTRAINT constraint_338 CHECK ((("time" >= '2021-04-15 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_339_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_339_chunk (
    CONSTRAINT constraint_339 CHECK ((("time" >= '2021-04-22 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_33_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_33_chunk (
    CONSTRAINT constraint_33 CHECK ((("time" >= '2015-06-11 00:00:00'::timestamp without time zone) AND ("time" < '2015-06-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_340_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_340_chunk (
    CONSTRAINT constraint_340 CHECK ((("time" >= '2021-04-29 00:00:00'::timestamp without time zone) AND ("time" < '2021-05-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_341_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_341_chunk (
    CONSTRAINT constraint_341 CHECK ((("time" >= '2021-05-06 00:00:00'::timestamp without time zone) AND ("time" < '2021-05-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_342_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_342_chunk (
    CONSTRAINT constraint_342 CHECK ((("time" >= '2021-05-13 00:00:00'::timestamp without time zone) AND ("time" < '2021-05-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_343_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_343_chunk (
    CONSTRAINT constraint_343 CHECK ((("time" >= '2021-05-20 00:00:00'::timestamp without time zone) AND ("time" < '2021-05-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_344_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_344_chunk (
    CONSTRAINT constraint_344 CHECK ((("time" >= '2021-05-27 00:00:00'::timestamp without time zone) AND ("time" < '2021-06-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_345_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_345_chunk (
    CONSTRAINT constraint_345 CHECK ((("time" >= '2021-06-03 00:00:00'::timestamp without time zone) AND ("time" < '2021-06-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_346_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_346_chunk (
    CONSTRAINT constraint_346 CHECK ((("time" >= '2021-06-10 00:00:00'::timestamp without time zone) AND ("time" < '2021-06-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_347_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_347_chunk (
    CONSTRAINT constraint_347 CHECK ((("time" >= '2021-06-17 00:00:00'::timestamp without time zone) AND ("time" < '2021-06-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_348_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_348_chunk (
    CONSTRAINT constraint_348 CHECK ((("time" >= '2021-06-24 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_349_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_349_chunk (
    CONSTRAINT constraint_349 CHECK ((("time" >= '2021-07-01 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_34_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_34_chunk (
    CONSTRAINT constraint_34 CHECK ((("time" >= '2015-06-18 00:00:00'::timestamp without time zone) AND ("time" < '2015-06-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_350_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_350_chunk (
    CONSTRAINT constraint_350 CHECK ((("time" >= '2021-07-08 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_351_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_351_chunk (
    CONSTRAINT constraint_351 CHECK ((("time" >= '2021-07-15 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_352_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_352_chunk (
    CONSTRAINT constraint_352 CHECK ((("time" >= '2021-07-22 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_353_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_353_chunk (
    CONSTRAINT constraint_353 CHECK ((("time" >= '2021-07-29 00:00:00'::timestamp without time zone) AND ("time" < '2021-08-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_354_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_354_chunk (
    CONSTRAINT constraint_354 CHECK ((("time" >= '2021-08-05 00:00:00'::timestamp without time zone) AND ("time" < '2021-08-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_355_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_355_chunk (
    CONSTRAINT constraint_355 CHECK ((("time" >= '2021-08-12 00:00:00'::timestamp without time zone) AND ("time" < '2021-08-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_356_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_356_chunk (
    CONSTRAINT constraint_356 CHECK ((("time" >= '2021-08-19 00:00:00'::timestamp without time zone) AND ("time" < '2021-08-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_357_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_357_chunk (
    CONSTRAINT constraint_357 CHECK ((("time" >= '2021-08-26 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_358_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_358_chunk (
    CONSTRAINT constraint_358 CHECK ((("time" >= '2021-09-02 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_359_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_359_chunk (
    CONSTRAINT constraint_359 CHECK ((("time" >= '2021-09-09 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_35_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_35_chunk (
    CONSTRAINT constraint_35 CHECK ((("time" >= '2015-06-25 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_360_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_360_chunk (
    CONSTRAINT constraint_360 CHECK ((("time" >= '2021-09-16 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_361_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_361_chunk (
    CONSTRAINT constraint_361 CHECK ((("time" >= '2021-09-23 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_362_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_362_chunk (
    CONSTRAINT constraint_362 CHECK ((("time" >= '2021-09-30 00:00:00'::timestamp without time zone) AND ("time" < '2021-10-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_363_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_363_chunk (
    CONSTRAINT constraint_363 CHECK ((("time" >= '2021-10-07 00:00:00'::timestamp without time zone) AND ("time" < '2021-10-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_364_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_364_chunk (
    CONSTRAINT constraint_364 CHECK ((("time" >= '2021-10-14 00:00:00'::timestamp without time zone) AND ("time" < '2021-10-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_365_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_365_chunk (
    CONSTRAINT constraint_365 CHECK ((("time" >= '2021-10-21 00:00:00'::timestamp without time zone) AND ("time" < '2021-10-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_366_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_366_chunk (
    CONSTRAINT constraint_366 CHECK ((("time" >= '2021-10-28 00:00:00'::timestamp without time zone) AND ("time" < '2021-11-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_367_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_367_chunk (
    CONSTRAINT constraint_367 CHECK ((("time" >= '2021-11-04 00:00:00'::timestamp without time zone) AND ("time" < '2021-11-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_368_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_368_chunk (
    CONSTRAINT constraint_368 CHECK ((("time" >= '2021-11-11 00:00:00'::timestamp without time zone) AND ("time" < '2021-11-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_369_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_369_chunk (
    CONSTRAINT constraint_369 CHECK ((("time" >= '2021-11-18 00:00:00'::timestamp without time zone) AND ("time" < '2021-11-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_36_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_36_chunk (
    CONSTRAINT constraint_36 CHECK ((("time" >= '2015-07-02 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_370_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_370_chunk (
    CONSTRAINT constraint_370 CHECK ((("time" >= '2021-11-25 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_371_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_371_chunk (
    CONSTRAINT constraint_371 CHECK ((("time" >= '2021-12-02 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_372_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_372_chunk (
    CONSTRAINT constraint_372 CHECK ((("time" >= '2021-12-09 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_373_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_373_chunk (
    CONSTRAINT constraint_373 CHECK ((("time" >= '2021-12-16 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_374_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_374_chunk (
    CONSTRAINT constraint_374 CHECK ((("time" >= '2021-12-23 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_375_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_375_chunk (
    CONSTRAINT constraint_375 CHECK ((("time" >= '2021-12-30 00:00:00'::timestamp without time zone) AND ("time" < '2022-01-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_376_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_376_chunk (
    CONSTRAINT constraint_376 CHECK ((("time" >= '2022-01-06 00:00:00'::timestamp without time zone) AND ("time" < '2022-01-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_37_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_37_chunk (
    CONSTRAINT constraint_37 CHECK ((("time" >= '2015-07-09 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_38_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_38_chunk (
    CONSTRAINT constraint_38 CHECK ((("time" >= '2015-07-16 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_39_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_39_chunk (
    CONSTRAINT constraint_39 CHECK ((("time" >= '2015-07-23 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_3_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_3_chunk (
    CONSTRAINT constraint_3 CHECK ((("time" >= '2014-11-13 00:00:00'::timestamp without time zone) AND ("time" < '2014-11-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_40_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_40_chunk (
    CONSTRAINT constraint_40 CHECK ((("time" >= '2015-07-30 00:00:00'::timestamp without time zone) AND ("time" < '2015-08-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_41_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_41_chunk (
    CONSTRAINT constraint_41 CHECK ((("time" >= '2015-08-06 00:00:00'::timestamp without time zone) AND ("time" < '2015-08-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_42_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_42_chunk (
    CONSTRAINT constraint_42 CHECK ((("time" >= '2015-08-13 00:00:00'::timestamp without time zone) AND ("time" < '2015-08-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_43_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_43_chunk (
    CONSTRAINT constraint_43 CHECK ((("time" >= '2015-08-20 00:00:00'::timestamp without time zone) AND ("time" < '2015-08-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_44_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_44_chunk (
    CONSTRAINT constraint_44 CHECK ((("time" >= '2015-08-27 00:00:00'::timestamp without time zone) AND ("time" < '2015-09-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_45_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_45_chunk (
    CONSTRAINT constraint_45 CHECK ((("time" >= '2015-09-03 00:00:00'::timestamp without time zone) AND ("time" < '2015-09-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_46_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_46_chunk (
    CONSTRAINT constraint_46 CHECK ((("time" >= '2015-09-10 00:00:00'::timestamp without time zone) AND ("time" < '2015-09-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_47_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_47_chunk (
    CONSTRAINT constraint_47 CHECK ((("time" >= '2015-09-17 00:00:00'::timestamp without time zone) AND ("time" < '2015-09-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_48_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_48_chunk (
    CONSTRAINT constraint_48 CHECK ((("time" >= '2015-09-24 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_49_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_49_chunk (
    CONSTRAINT constraint_49 CHECK ((("time" >= '2015-10-01 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_4_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_4_chunk (
    CONSTRAINT constraint_4 CHECK ((("time" >= '2014-11-20 00:00:00'::timestamp without time zone) AND ("time" < '2014-11-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_50_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_50_chunk (
    CONSTRAINT constraint_50 CHECK ((("time" >= '2015-10-08 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_51_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_51_chunk (
    CONSTRAINT constraint_51 CHECK ((("time" >= '2015-10-15 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_52_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_52_chunk (
    CONSTRAINT constraint_52 CHECK ((("time" >= '2015-10-22 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_53_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_53_chunk (
    CONSTRAINT constraint_53 CHECK ((("time" >= '2015-10-29 00:00:00'::timestamp without time zone) AND ("time" < '2015-11-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_54_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_54_chunk (
    CONSTRAINT constraint_54 CHECK ((("time" >= '2015-11-05 00:00:00'::timestamp without time zone) AND ("time" < '2015-11-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_55_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_55_chunk (
    CONSTRAINT constraint_55 CHECK ((("time" >= '2015-11-12 00:00:00'::timestamp without time zone) AND ("time" < '2015-11-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_56_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_56_chunk (
    CONSTRAINT constraint_56 CHECK ((("time" >= '2015-11-19 00:00:00'::timestamp without time zone) AND ("time" < '2015-11-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_57_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_57_chunk (
    CONSTRAINT constraint_57 CHECK ((("time" >= '2015-11-26 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_58_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_58_chunk (
    CONSTRAINT constraint_58 CHECK ((("time" >= '2015-12-03 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_59_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_59_chunk (
    CONSTRAINT constraint_59 CHECK ((("time" >= '2015-12-10 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_5_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_5_chunk (
    CONSTRAINT constraint_5 CHECK ((("time" >= '2014-11-27 00:00:00'::timestamp without time zone) AND ("time" < '2014-12-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_60_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_60_chunk (
    CONSTRAINT constraint_60 CHECK ((("time" >= '2015-12-17 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_61_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_61_chunk (
    CONSTRAINT constraint_61 CHECK ((("time" >= '2015-12-24 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_62_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_62_chunk (
    CONSTRAINT constraint_62 CHECK ((("time" >= '2015-12-31 00:00:00'::timestamp without time zone) AND ("time" < '2016-01-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_63_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_63_chunk (
    CONSTRAINT constraint_63 CHECK ((("time" >= '2016-01-07 00:00:00'::timestamp without time zone) AND ("time" < '2016-01-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_64_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_64_chunk (
    CONSTRAINT constraint_64 CHECK ((("time" >= '2016-01-14 00:00:00'::timestamp without time zone) AND ("time" < '2016-01-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_65_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_65_chunk (
    CONSTRAINT constraint_65 CHECK ((("time" >= '2016-01-21 00:00:00'::timestamp without time zone) AND ("time" < '2016-01-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_66_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_66_chunk (
    CONSTRAINT constraint_66 CHECK ((("time" >= '2016-01-28 00:00:00'::timestamp without time zone) AND ("time" < '2016-02-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_67_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_67_chunk (
    CONSTRAINT constraint_67 CHECK ((("time" >= '2016-02-04 00:00:00'::timestamp without time zone) AND ("time" < '2016-02-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_68_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_68_chunk (
    CONSTRAINT constraint_68 CHECK ((("time" >= '2016-02-11 00:00:00'::timestamp without time zone) AND ("time" < '2016-02-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_69_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_69_chunk (
    CONSTRAINT constraint_69 CHECK ((("time" >= '2016-02-18 00:00:00'::timestamp without time zone) AND ("time" < '2016-02-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_6_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_6_chunk (
    CONSTRAINT constraint_6 CHECK ((("time" >= '2014-12-04 00:00:00'::timestamp without time zone) AND ("time" < '2014-12-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_70_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_70_chunk (
    CONSTRAINT constraint_70 CHECK ((("time" >= '2016-02-25 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_71_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_71_chunk (
    CONSTRAINT constraint_71 CHECK ((("time" >= '2016-03-03 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_72_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_72_chunk (
    CONSTRAINT constraint_72 CHECK ((("time" >= '2016-03-10 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_73_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_73_chunk (
    CONSTRAINT constraint_73 CHECK ((("time" >= '2016-03-17 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_74_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_74_chunk (
    CONSTRAINT constraint_74 CHECK ((("time" >= '2016-03-24 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_75_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_75_chunk (
    CONSTRAINT constraint_75 CHECK ((("time" >= '2016-03-31 00:00:00'::timestamp without time zone) AND ("time" < '2016-04-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_76_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_76_chunk (
    CONSTRAINT constraint_76 CHECK ((("time" >= '2016-04-07 00:00:00'::timestamp without time zone) AND ("time" < '2016-04-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_77_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_77_chunk (
    CONSTRAINT constraint_77 CHECK ((("time" >= '2016-04-14 00:00:00'::timestamp without time zone) AND ("time" < '2016-04-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_78_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_78_chunk (
    CONSTRAINT constraint_78 CHECK ((("time" >= '2016-04-21 00:00:00'::timestamp without time zone) AND ("time" < '2016-04-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_79_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_79_chunk (
    CONSTRAINT constraint_79 CHECK ((("time" >= '2016-04-28 00:00:00'::timestamp without time zone) AND ("time" < '2016-05-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_7_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_7_chunk (
    CONSTRAINT constraint_7 CHECK ((("time" >= '2014-12-11 00:00:00'::timestamp without time zone) AND ("time" < '2014-12-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_80_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_80_chunk (
    CONSTRAINT constraint_80 CHECK ((("time" >= '2016-05-05 00:00:00'::timestamp without time zone) AND ("time" < '2016-05-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_81_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_81_chunk (
    CONSTRAINT constraint_81 CHECK ((("time" >= '2016-05-12 00:00:00'::timestamp without time zone) AND ("time" < '2016-05-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_82_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_82_chunk (
    CONSTRAINT constraint_82 CHECK ((("time" >= '2016-05-19 00:00:00'::timestamp without time zone) AND ("time" < '2016-05-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_83_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_83_chunk (
    CONSTRAINT constraint_83 CHECK ((("time" >= '2016-05-26 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_84_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_84_chunk (
    CONSTRAINT constraint_84 CHECK ((("time" >= '2016-06-02 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_85_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_85_chunk (
    CONSTRAINT constraint_85 CHECK ((("time" >= '2016-06-09 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_86_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_86_chunk (
    CONSTRAINT constraint_86 CHECK ((("time" >= '2016-06-16 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_87_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_87_chunk (
    CONSTRAINT constraint_87 CHECK ((("time" >= '2016-06-23 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_88_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_88_chunk (
    CONSTRAINT constraint_88 CHECK ((("time" >= '2016-06-30 00:00:00'::timestamp without time zone) AND ("time" < '2016-07-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_89_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_89_chunk (
    CONSTRAINT constraint_89 CHECK ((("time" >= '2016-07-07 00:00:00'::timestamp without time zone) AND ("time" < '2016-07-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_8_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_8_chunk (
    CONSTRAINT constraint_8 CHECK ((("time" >= '2014-12-18 00:00:00'::timestamp without time zone) AND ("time" < '2014-12-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_90_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_90_chunk (
    CONSTRAINT constraint_90 CHECK ((("time" >= '2016-07-14 00:00:00'::timestamp without time zone) AND ("time" < '2016-07-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_91_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_91_chunk (
    CONSTRAINT constraint_91 CHECK ((("time" >= '2016-07-21 00:00:00'::timestamp without time zone) AND ("time" < '2016-07-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_92_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_92_chunk (
    CONSTRAINT constraint_92 CHECK ((("time" >= '2016-07-28 00:00:00'::timestamp without time zone) AND ("time" < '2016-08-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_93_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_93_chunk (
    CONSTRAINT constraint_93 CHECK ((("time" >= '2016-08-04 00:00:00'::timestamp without time zone) AND ("time" < '2016-08-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_94_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_94_chunk (
    CONSTRAINT constraint_94 CHECK ((("time" >= '2016-08-11 00:00:00'::timestamp without time zone) AND ("time" < '2016-08-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_95_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_95_chunk (
    CONSTRAINT constraint_95 CHECK ((("time" >= '2016-08-18 00:00:00'::timestamp without time zone) AND ("time" < '2016-08-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_96_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_96_chunk (
    CONSTRAINT constraint_96 CHECK ((("time" >= '2016-08-25 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_97_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_97_chunk (
    CONSTRAINT constraint_97 CHECK ((("time" >= '2016-09-01 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_98_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_98_chunk (
    CONSTRAINT constraint_98 CHECK ((("time" >= '2016-09-08 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_99_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_99_chunk (
    CONSTRAINT constraint_99 CHECK ((("time" >= '2016-09-15 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_9_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_9_chunk (
    CONSTRAINT constraint_9 CHECK ((("time" >= '2014-12-25 00:00:00'::timestamp without time zone) AND ("time" < '2015-01-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: entsoe_load; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entsoe_load (
    country character varying NOT NULL,
    value integer NOT NULL,
    "time" timestamp without time zone NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: _hyper_2_377_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_377_chunk (
    CONSTRAINT constraint_377 CHECK ((("time" >= '2014-10-16 00:00:00'::timestamp without time zone) AND ("time" < '2014-10-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_378_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_378_chunk (
    CONSTRAINT constraint_378 CHECK ((("time" >= '2014-10-23 00:00:00'::timestamp without time zone) AND ("time" < '2014-10-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_379_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_379_chunk (
    CONSTRAINT constraint_379 CHECK ((("time" >= '2014-10-30 00:00:00'::timestamp without time zone) AND ("time" < '2014-11-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_380_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_380_chunk (
    CONSTRAINT constraint_380 CHECK ((("time" >= '2014-11-06 00:00:00'::timestamp without time zone) AND ("time" < '2014-11-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_381_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_381_chunk (
    CONSTRAINT constraint_381 CHECK ((("time" >= '2014-11-13 00:00:00'::timestamp without time zone) AND ("time" < '2014-11-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_382_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_382_chunk (
    CONSTRAINT constraint_382 CHECK ((("time" >= '2014-11-20 00:00:00'::timestamp without time zone) AND ("time" < '2014-11-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_383_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_383_chunk (
    CONSTRAINT constraint_383 CHECK ((("time" >= '2014-11-27 00:00:00'::timestamp without time zone) AND ("time" < '2014-12-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_384_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_384_chunk (
    CONSTRAINT constraint_384 CHECK ((("time" >= '2014-12-04 00:00:00'::timestamp without time zone) AND ("time" < '2014-12-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_385_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_385_chunk (
    CONSTRAINT constraint_385 CHECK ((("time" >= '2014-12-11 00:00:00'::timestamp without time zone) AND ("time" < '2014-12-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_386_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_386_chunk (
    CONSTRAINT constraint_386 CHECK ((("time" >= '2014-12-18 00:00:00'::timestamp without time zone) AND ("time" < '2014-12-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_387_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_387_chunk (
    CONSTRAINT constraint_387 CHECK ((("time" >= '2015-01-01 00:00:00'::timestamp without time zone) AND ("time" < '2015-01-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_388_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_388_chunk (
    CONSTRAINT constraint_388 CHECK ((("time" >= '2015-01-08 00:00:00'::timestamp without time zone) AND ("time" < '2015-01-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_389_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_389_chunk (
    CONSTRAINT constraint_389 CHECK ((("time" >= '2015-01-15 00:00:00'::timestamp without time zone) AND ("time" < '2015-01-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_390_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_390_chunk (
    CONSTRAINT constraint_390 CHECK ((("time" >= '2015-01-22 00:00:00'::timestamp without time zone) AND ("time" < '2015-01-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_391_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_391_chunk (
    CONSTRAINT constraint_391 CHECK ((("time" >= '2015-01-29 00:00:00'::timestamp without time zone) AND ("time" < '2015-02-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_392_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_392_chunk (
    CONSTRAINT constraint_392 CHECK ((("time" >= '2015-02-05 00:00:00'::timestamp without time zone) AND ("time" < '2015-02-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_393_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_393_chunk (
    CONSTRAINT constraint_393 CHECK ((("time" >= '2015-02-12 00:00:00'::timestamp without time zone) AND ("time" < '2015-02-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_394_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_394_chunk (
    CONSTRAINT constraint_394 CHECK ((("time" >= '2015-02-19 00:00:00'::timestamp without time zone) AND ("time" < '2015-02-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_395_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_395_chunk (
    CONSTRAINT constraint_395 CHECK ((("time" >= '2015-02-26 00:00:00'::timestamp without time zone) AND ("time" < '2015-03-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_396_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_396_chunk (
    CONSTRAINT constraint_396 CHECK ((("time" >= '2015-03-05 00:00:00'::timestamp without time zone) AND ("time" < '2015-03-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_397_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_397_chunk (
    CONSTRAINT constraint_397 CHECK ((("time" >= '2015-03-12 00:00:00'::timestamp without time zone) AND ("time" < '2015-03-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_398_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_398_chunk (
    CONSTRAINT constraint_398 CHECK ((("time" >= '2015-03-19 00:00:00'::timestamp without time zone) AND ("time" < '2015-03-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_399_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_399_chunk (
    CONSTRAINT constraint_399 CHECK ((("time" >= '2015-03-26 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_400_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_400_chunk (
    CONSTRAINT constraint_400 CHECK ((("time" >= '2015-04-02 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_401_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_401_chunk (
    CONSTRAINT constraint_401 CHECK ((("time" >= '2015-04-09 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_402_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_402_chunk (
    CONSTRAINT constraint_402 CHECK ((("time" >= '2015-04-16 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_403_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_403_chunk (
    CONSTRAINT constraint_403 CHECK ((("time" >= '2015-04-23 00:00:00'::timestamp without time zone) AND ("time" < '2015-04-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_404_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_404_chunk (
    CONSTRAINT constraint_404 CHECK ((("time" >= '2015-04-30 00:00:00'::timestamp without time zone) AND ("time" < '2015-05-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_405_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_405_chunk (
    CONSTRAINT constraint_405 CHECK ((("time" >= '2015-05-07 00:00:00'::timestamp without time zone) AND ("time" < '2015-05-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_406_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_406_chunk (
    CONSTRAINT constraint_406 CHECK ((("time" >= '2015-05-14 00:00:00'::timestamp without time zone) AND ("time" < '2015-05-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_407_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_407_chunk (
    CONSTRAINT constraint_407 CHECK ((("time" >= '2015-05-21 00:00:00'::timestamp without time zone) AND ("time" < '2015-05-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_408_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_408_chunk (
    CONSTRAINT constraint_408 CHECK ((("time" >= '2015-05-28 00:00:00'::timestamp without time zone) AND ("time" < '2015-06-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_409_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_409_chunk (
    CONSTRAINT constraint_409 CHECK ((("time" >= '2015-06-04 00:00:00'::timestamp without time zone) AND ("time" < '2015-06-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_410_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_410_chunk (
    CONSTRAINT constraint_410 CHECK ((("time" >= '2015-06-11 00:00:00'::timestamp without time zone) AND ("time" < '2015-06-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_411_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_411_chunk (
    CONSTRAINT constraint_411 CHECK ((("time" >= '2015-06-18 00:00:00'::timestamp without time zone) AND ("time" < '2015-06-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_412_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_412_chunk (
    CONSTRAINT constraint_412 CHECK ((("time" >= '2015-06-25 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_413_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_413_chunk (
    CONSTRAINT constraint_413 CHECK ((("time" >= '2015-07-02 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_414_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_414_chunk (
    CONSTRAINT constraint_414 CHECK ((("time" >= '2015-07-09 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_415_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_415_chunk (
    CONSTRAINT constraint_415 CHECK ((("time" >= '2015-07-16 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_416_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_416_chunk (
    CONSTRAINT constraint_416 CHECK ((("time" >= '2015-07-23 00:00:00'::timestamp without time zone) AND ("time" < '2015-07-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_417_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_417_chunk (
    CONSTRAINT constraint_417 CHECK ((("time" >= '2015-07-30 00:00:00'::timestamp without time zone) AND ("time" < '2015-08-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_418_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_418_chunk (
    CONSTRAINT constraint_418 CHECK ((("time" >= '2015-08-06 00:00:00'::timestamp without time zone) AND ("time" < '2015-08-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_419_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_419_chunk (
    CONSTRAINT constraint_419 CHECK ((("time" >= '2015-08-13 00:00:00'::timestamp without time zone) AND ("time" < '2015-08-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_420_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_420_chunk (
    CONSTRAINT constraint_420 CHECK ((("time" >= '2015-08-20 00:00:00'::timestamp without time zone) AND ("time" < '2015-08-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_421_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_421_chunk (
    CONSTRAINT constraint_421 CHECK ((("time" >= '2015-08-27 00:00:00'::timestamp without time zone) AND ("time" < '2015-09-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_422_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_422_chunk (
    CONSTRAINT constraint_422 CHECK ((("time" >= '2015-09-03 00:00:00'::timestamp without time zone) AND ("time" < '2015-09-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_423_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_423_chunk (
    CONSTRAINT constraint_423 CHECK ((("time" >= '2015-09-10 00:00:00'::timestamp without time zone) AND ("time" < '2015-09-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_424_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_424_chunk (
    CONSTRAINT constraint_424 CHECK ((("time" >= '2015-09-17 00:00:00'::timestamp without time zone) AND ("time" < '2015-09-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_425_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_425_chunk (
    CONSTRAINT constraint_425 CHECK ((("time" >= '2015-09-24 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_426_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_426_chunk (
    CONSTRAINT constraint_426 CHECK ((("time" >= '2015-10-01 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_427_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_427_chunk (
    CONSTRAINT constraint_427 CHECK ((("time" >= '2015-10-08 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_428_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_428_chunk (
    CONSTRAINT constraint_428 CHECK ((("time" >= '2015-10-15 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_429_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_429_chunk (
    CONSTRAINT constraint_429 CHECK ((("time" >= '2015-10-22 00:00:00'::timestamp without time zone) AND ("time" < '2015-10-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_430_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_430_chunk (
    CONSTRAINT constraint_430 CHECK ((("time" >= '2015-10-29 00:00:00'::timestamp without time zone) AND ("time" < '2015-11-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_431_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_431_chunk (
    CONSTRAINT constraint_431 CHECK ((("time" >= '2015-11-05 00:00:00'::timestamp without time zone) AND ("time" < '2015-11-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_432_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_432_chunk (
    CONSTRAINT constraint_432 CHECK ((("time" >= '2015-11-12 00:00:00'::timestamp without time zone) AND ("time" < '2015-11-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_433_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_433_chunk (
    CONSTRAINT constraint_433 CHECK ((("time" >= '2015-11-19 00:00:00'::timestamp without time zone) AND ("time" < '2015-11-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_434_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_434_chunk (
    CONSTRAINT constraint_434 CHECK ((("time" >= '2015-11-26 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_435_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_435_chunk (
    CONSTRAINT constraint_435 CHECK ((("time" >= '2015-12-03 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_436_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_436_chunk (
    CONSTRAINT constraint_436 CHECK ((("time" >= '2015-12-10 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_437_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_437_chunk (
    CONSTRAINT constraint_437 CHECK ((("time" >= '2015-12-17 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_438_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_438_chunk (
    CONSTRAINT constraint_438 CHECK ((("time" >= '2015-12-24 00:00:00'::timestamp without time zone) AND ("time" < '2015-12-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_439_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_439_chunk (
    CONSTRAINT constraint_439 CHECK ((("time" >= '2015-12-31 00:00:00'::timestamp without time zone) AND ("time" < '2016-01-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_440_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_440_chunk (
    CONSTRAINT constraint_440 CHECK ((("time" >= '2016-01-07 00:00:00'::timestamp without time zone) AND ("time" < '2016-01-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_441_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_441_chunk (
    CONSTRAINT constraint_441 CHECK ((("time" >= '2016-01-14 00:00:00'::timestamp without time zone) AND ("time" < '2016-01-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_442_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_442_chunk (
    CONSTRAINT constraint_442 CHECK ((("time" >= '2016-01-21 00:00:00'::timestamp without time zone) AND ("time" < '2016-01-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_443_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_443_chunk (
    CONSTRAINT constraint_443 CHECK ((("time" >= '2016-01-28 00:00:00'::timestamp without time zone) AND ("time" < '2016-02-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_444_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_444_chunk (
    CONSTRAINT constraint_444 CHECK ((("time" >= '2016-02-04 00:00:00'::timestamp without time zone) AND ("time" < '2016-02-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_445_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_445_chunk (
    CONSTRAINT constraint_445 CHECK ((("time" >= '2016-02-11 00:00:00'::timestamp without time zone) AND ("time" < '2016-02-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_446_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_446_chunk (
    CONSTRAINT constraint_446 CHECK ((("time" >= '2016-02-18 00:00:00'::timestamp without time zone) AND ("time" < '2016-02-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_447_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_447_chunk (
    CONSTRAINT constraint_447 CHECK ((("time" >= '2016-02-25 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_448_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_448_chunk (
    CONSTRAINT constraint_448 CHECK ((("time" >= '2016-03-03 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_449_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_449_chunk (
    CONSTRAINT constraint_449 CHECK ((("time" >= '2016-03-10 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_450_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_450_chunk (
    CONSTRAINT constraint_450 CHECK ((("time" >= '2016-03-17 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_451_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_451_chunk (
    CONSTRAINT constraint_451 CHECK ((("time" >= '2016-03-24 00:00:00'::timestamp without time zone) AND ("time" < '2016-03-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_452_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_452_chunk (
    CONSTRAINT constraint_452 CHECK ((("time" >= '2016-03-31 00:00:00'::timestamp without time zone) AND ("time" < '2016-04-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_453_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_453_chunk (
    CONSTRAINT constraint_453 CHECK ((("time" >= '2016-04-07 00:00:00'::timestamp without time zone) AND ("time" < '2016-04-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_454_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_454_chunk (
    CONSTRAINT constraint_454 CHECK ((("time" >= '2016-04-14 00:00:00'::timestamp without time zone) AND ("time" < '2016-04-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_455_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_455_chunk (
    CONSTRAINT constraint_455 CHECK ((("time" >= '2016-04-21 00:00:00'::timestamp without time zone) AND ("time" < '2016-04-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_456_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_456_chunk (
    CONSTRAINT constraint_456 CHECK ((("time" >= '2016-04-28 00:00:00'::timestamp without time zone) AND ("time" < '2016-05-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_457_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_457_chunk (
    CONSTRAINT constraint_457 CHECK ((("time" >= '2016-05-05 00:00:00'::timestamp without time zone) AND ("time" < '2016-05-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_458_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_458_chunk (
    CONSTRAINT constraint_458 CHECK ((("time" >= '2016-05-12 00:00:00'::timestamp without time zone) AND ("time" < '2016-05-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_459_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_459_chunk (
    CONSTRAINT constraint_459 CHECK ((("time" >= '2016-05-19 00:00:00'::timestamp without time zone) AND ("time" < '2016-05-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_460_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_460_chunk (
    CONSTRAINT constraint_460 CHECK ((("time" >= '2016-05-26 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_461_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_461_chunk (
    CONSTRAINT constraint_461 CHECK ((("time" >= '2016-06-02 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_462_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_462_chunk (
    CONSTRAINT constraint_462 CHECK ((("time" >= '2016-06-09 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_463_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_463_chunk (
    CONSTRAINT constraint_463 CHECK ((("time" >= '2016-06-16 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_464_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_464_chunk (
    CONSTRAINT constraint_464 CHECK ((("time" >= '2016-06-23 00:00:00'::timestamp without time zone) AND ("time" < '2016-06-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_465_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_465_chunk (
    CONSTRAINT constraint_465 CHECK ((("time" >= '2016-06-30 00:00:00'::timestamp without time zone) AND ("time" < '2016-07-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_466_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_466_chunk (
    CONSTRAINT constraint_466 CHECK ((("time" >= '2016-07-07 00:00:00'::timestamp without time zone) AND ("time" < '2016-07-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_467_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_467_chunk (
    CONSTRAINT constraint_467 CHECK ((("time" >= '2016-07-14 00:00:00'::timestamp without time zone) AND ("time" < '2016-07-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_468_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_468_chunk (
    CONSTRAINT constraint_468 CHECK ((("time" >= '2016-07-21 00:00:00'::timestamp without time zone) AND ("time" < '2016-07-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_469_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_469_chunk (
    CONSTRAINT constraint_469 CHECK ((("time" >= '2016-07-28 00:00:00'::timestamp without time zone) AND ("time" < '2016-08-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_470_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_470_chunk (
    CONSTRAINT constraint_470 CHECK ((("time" >= '2016-08-04 00:00:00'::timestamp without time zone) AND ("time" < '2016-08-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_471_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_471_chunk (
    CONSTRAINT constraint_471 CHECK ((("time" >= '2016-08-11 00:00:00'::timestamp without time zone) AND ("time" < '2016-08-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_472_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_472_chunk (
    CONSTRAINT constraint_472 CHECK ((("time" >= '2016-08-18 00:00:00'::timestamp without time zone) AND ("time" < '2016-08-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_473_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_473_chunk (
    CONSTRAINT constraint_473 CHECK ((("time" >= '2016-08-25 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_474_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_474_chunk (
    CONSTRAINT constraint_474 CHECK ((("time" >= '2016-09-01 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_475_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_475_chunk (
    CONSTRAINT constraint_475 CHECK ((("time" >= '2016-09-08 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_476_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_476_chunk (
    CONSTRAINT constraint_476 CHECK ((("time" >= '2016-09-15 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_477_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_477_chunk (
    CONSTRAINT constraint_477 CHECK ((("time" >= '2016-09-22 00:00:00'::timestamp without time zone) AND ("time" < '2016-09-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_478_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_478_chunk (
    CONSTRAINT constraint_478 CHECK ((("time" >= '2016-09-29 00:00:00'::timestamp without time zone) AND ("time" < '2016-10-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_479_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_479_chunk (
    CONSTRAINT constraint_479 CHECK ((("time" >= '2016-10-06 00:00:00'::timestamp without time zone) AND ("time" < '2016-10-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_480_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_480_chunk (
    CONSTRAINT constraint_480 CHECK ((("time" >= '2016-10-13 00:00:00'::timestamp without time zone) AND ("time" < '2016-10-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_481_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_481_chunk (
    CONSTRAINT constraint_481 CHECK ((("time" >= '2016-10-20 00:00:00'::timestamp without time zone) AND ("time" < '2016-10-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_482_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_482_chunk (
    CONSTRAINT constraint_482 CHECK ((("time" >= '2016-10-27 00:00:00'::timestamp without time zone) AND ("time" < '2016-11-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_483_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_483_chunk (
    CONSTRAINT constraint_483 CHECK ((("time" >= '2016-11-03 00:00:00'::timestamp without time zone) AND ("time" < '2016-11-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_484_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_484_chunk (
    CONSTRAINT constraint_484 CHECK ((("time" >= '2016-11-10 00:00:00'::timestamp without time zone) AND ("time" < '2016-11-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_485_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_485_chunk (
    CONSTRAINT constraint_485 CHECK ((("time" >= '2016-11-17 00:00:00'::timestamp without time zone) AND ("time" < '2016-11-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_486_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_486_chunk (
    CONSTRAINT constraint_486 CHECK ((("time" >= '2016-11-24 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_487_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_487_chunk (
    CONSTRAINT constraint_487 CHECK ((("time" >= '2016-12-01 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_488_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_488_chunk (
    CONSTRAINT constraint_488 CHECK ((("time" >= '2016-12-08 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_489_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_489_chunk (
    CONSTRAINT constraint_489 CHECK ((("time" >= '2016-12-15 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_490_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_490_chunk (
    CONSTRAINT constraint_490 CHECK ((("time" >= '2016-12-22 00:00:00'::timestamp without time zone) AND ("time" < '2016-12-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_491_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_491_chunk (
    CONSTRAINT constraint_491 CHECK ((("time" >= '2016-12-29 00:00:00'::timestamp without time zone) AND ("time" < '2017-01-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_492_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_492_chunk (
    CONSTRAINT constraint_492 CHECK ((("time" >= '2017-01-05 00:00:00'::timestamp without time zone) AND ("time" < '2017-01-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_493_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_493_chunk (
    CONSTRAINT constraint_493 CHECK ((("time" >= '2017-01-12 00:00:00'::timestamp without time zone) AND ("time" < '2017-01-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_494_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_494_chunk (
    CONSTRAINT constraint_494 CHECK ((("time" >= '2017-01-19 00:00:00'::timestamp without time zone) AND ("time" < '2017-01-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_495_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_495_chunk (
    CONSTRAINT constraint_495 CHECK ((("time" >= '2017-01-26 00:00:00'::timestamp without time zone) AND ("time" < '2017-02-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_496_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_496_chunk (
    CONSTRAINT constraint_496 CHECK ((("time" >= '2017-02-02 00:00:00'::timestamp without time zone) AND ("time" < '2017-02-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_497_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_497_chunk (
    CONSTRAINT constraint_497 CHECK ((("time" >= '2017-02-09 00:00:00'::timestamp without time zone) AND ("time" < '2017-02-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_498_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_498_chunk (
    CONSTRAINT constraint_498 CHECK ((("time" >= '2017-02-16 00:00:00'::timestamp without time zone) AND ("time" < '2017-02-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_499_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_499_chunk (
    CONSTRAINT constraint_499 CHECK ((("time" >= '2017-02-23 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_500_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_500_chunk (
    CONSTRAINT constraint_500 CHECK ((("time" >= '2017-03-02 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_501_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_501_chunk (
    CONSTRAINT constraint_501 CHECK ((("time" >= '2017-03-09 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_502_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_502_chunk (
    CONSTRAINT constraint_502 CHECK ((("time" >= '2017-03-16 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_503_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_503_chunk (
    CONSTRAINT constraint_503 CHECK ((("time" >= '2017-03-23 00:00:00'::timestamp without time zone) AND ("time" < '2017-03-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_504_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_504_chunk (
    CONSTRAINT constraint_504 CHECK ((("time" >= '2017-03-30 00:00:00'::timestamp without time zone) AND ("time" < '2017-04-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_505_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_505_chunk (
    CONSTRAINT constraint_505 CHECK ((("time" >= '2017-04-06 00:00:00'::timestamp without time zone) AND ("time" < '2017-04-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_506_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_506_chunk (
    CONSTRAINT constraint_506 CHECK ((("time" >= '2017-04-13 00:00:00'::timestamp without time zone) AND ("time" < '2017-04-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_507_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_507_chunk (
    CONSTRAINT constraint_507 CHECK ((("time" >= '2017-04-20 00:00:00'::timestamp without time zone) AND ("time" < '2017-04-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_508_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_508_chunk (
    CONSTRAINT constraint_508 CHECK ((("time" >= '2017-04-27 00:00:00'::timestamp without time zone) AND ("time" < '2017-05-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_509_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_509_chunk (
    CONSTRAINT constraint_509 CHECK ((("time" >= '2017-05-04 00:00:00'::timestamp without time zone) AND ("time" < '2017-05-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_510_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_510_chunk (
    CONSTRAINT constraint_510 CHECK ((("time" >= '2017-05-11 00:00:00'::timestamp without time zone) AND ("time" < '2017-05-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_511_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_511_chunk (
    CONSTRAINT constraint_511 CHECK ((("time" >= '2017-05-18 00:00:00'::timestamp without time zone) AND ("time" < '2017-05-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_512_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_512_chunk (
    CONSTRAINT constraint_512 CHECK ((("time" >= '2017-05-25 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_513_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_513_chunk (
    CONSTRAINT constraint_513 CHECK ((("time" >= '2017-06-01 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_514_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_514_chunk (
    CONSTRAINT constraint_514 CHECK ((("time" >= '2017-06-08 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_515_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_515_chunk (
    CONSTRAINT constraint_515 CHECK ((("time" >= '2017-06-15 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_516_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_516_chunk (
    CONSTRAINT constraint_516 CHECK ((("time" >= '2017-06-22 00:00:00'::timestamp without time zone) AND ("time" < '2017-06-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_517_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_517_chunk (
    CONSTRAINT constraint_517 CHECK ((("time" >= '2017-06-29 00:00:00'::timestamp without time zone) AND ("time" < '2017-07-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_518_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_518_chunk (
    CONSTRAINT constraint_518 CHECK ((("time" >= '2017-07-06 00:00:00'::timestamp without time zone) AND ("time" < '2017-07-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_519_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_519_chunk (
    CONSTRAINT constraint_519 CHECK ((("time" >= '2017-07-13 00:00:00'::timestamp without time zone) AND ("time" < '2017-07-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_520_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_520_chunk (
    CONSTRAINT constraint_520 CHECK ((("time" >= '2017-07-20 00:00:00'::timestamp without time zone) AND ("time" < '2017-07-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_521_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_521_chunk (
    CONSTRAINT constraint_521 CHECK ((("time" >= '2017-07-27 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_522_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_522_chunk (
    CONSTRAINT constraint_522 CHECK ((("time" >= '2017-08-03 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_523_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_523_chunk (
    CONSTRAINT constraint_523 CHECK ((("time" >= '2017-08-10 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_524_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_524_chunk (
    CONSTRAINT constraint_524 CHECK ((("time" >= '2017-08-17 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_525_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_525_chunk (
    CONSTRAINT constraint_525 CHECK ((("time" >= '2017-08-24 00:00:00'::timestamp without time zone) AND ("time" < '2017-08-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_526_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_526_chunk (
    CONSTRAINT constraint_526 CHECK ((("time" >= '2017-08-31 00:00:00'::timestamp without time zone) AND ("time" < '2017-09-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_527_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_527_chunk (
    CONSTRAINT constraint_527 CHECK ((("time" >= '2017-09-07 00:00:00'::timestamp without time zone) AND ("time" < '2017-09-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_528_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_528_chunk (
    CONSTRAINT constraint_528 CHECK ((("time" >= '2017-09-14 00:00:00'::timestamp without time zone) AND ("time" < '2017-09-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_529_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_529_chunk (
    CONSTRAINT constraint_529 CHECK ((("time" >= '2017-09-21 00:00:00'::timestamp without time zone) AND ("time" < '2017-09-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_530_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_530_chunk (
    CONSTRAINT constraint_530 CHECK ((("time" >= '2017-09-28 00:00:00'::timestamp without time zone) AND ("time" < '2017-10-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_531_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_531_chunk (
    CONSTRAINT constraint_531 CHECK ((("time" >= '2017-10-05 00:00:00'::timestamp without time zone) AND ("time" < '2017-10-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_532_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_532_chunk (
    CONSTRAINT constraint_532 CHECK ((("time" >= '2017-10-12 00:00:00'::timestamp without time zone) AND ("time" < '2017-10-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_533_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_533_chunk (
    CONSTRAINT constraint_533 CHECK ((("time" >= '2017-10-19 00:00:00'::timestamp without time zone) AND ("time" < '2017-10-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_534_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_534_chunk (
    CONSTRAINT constraint_534 CHECK ((("time" >= '2017-10-26 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_535_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_535_chunk (
    CONSTRAINT constraint_535 CHECK ((("time" >= '2017-11-02 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_536_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_536_chunk (
    CONSTRAINT constraint_536 CHECK ((("time" >= '2017-11-09 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_537_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_537_chunk (
    CONSTRAINT constraint_537 CHECK ((("time" >= '2017-11-16 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_538_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_538_chunk (
    CONSTRAINT constraint_538 CHECK ((("time" >= '2017-11-23 00:00:00'::timestamp without time zone) AND ("time" < '2017-11-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_539_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_539_chunk (
    CONSTRAINT constraint_539 CHECK ((("time" >= '2017-11-30 00:00:00'::timestamp without time zone) AND ("time" < '2017-12-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_540_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_540_chunk (
    CONSTRAINT constraint_540 CHECK ((("time" >= '2017-12-07 00:00:00'::timestamp without time zone) AND ("time" < '2017-12-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_541_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_541_chunk (
    CONSTRAINT constraint_541 CHECK ((("time" >= '2017-12-14 00:00:00'::timestamp without time zone) AND ("time" < '2017-12-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_542_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_542_chunk (
    CONSTRAINT constraint_542 CHECK ((("time" >= '2017-12-21 00:00:00'::timestamp without time zone) AND ("time" < '2017-12-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_543_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_543_chunk (
    CONSTRAINT constraint_543 CHECK ((("time" >= '2017-12-28 00:00:00'::timestamp without time zone) AND ("time" < '2018-01-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_544_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_544_chunk (
    CONSTRAINT constraint_544 CHECK ((("time" >= '2018-01-04 00:00:00'::timestamp without time zone) AND ("time" < '2018-01-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_545_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_545_chunk (
    CONSTRAINT constraint_545 CHECK ((("time" >= '2018-01-11 00:00:00'::timestamp without time zone) AND ("time" < '2018-01-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_546_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_546_chunk (
    CONSTRAINT constraint_546 CHECK ((("time" >= '2018-01-18 00:00:00'::timestamp without time zone) AND ("time" < '2018-01-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_547_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_547_chunk (
    CONSTRAINT constraint_547 CHECK ((("time" >= '2018-01-25 00:00:00'::timestamp without time zone) AND ("time" < '2018-02-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_548_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_548_chunk (
    CONSTRAINT constraint_548 CHECK ((("time" >= '2018-02-01 00:00:00'::timestamp without time zone) AND ("time" < '2018-02-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_549_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_549_chunk (
    CONSTRAINT constraint_549 CHECK ((("time" >= '2018-02-08 00:00:00'::timestamp without time zone) AND ("time" < '2018-02-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_550_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_550_chunk (
    CONSTRAINT constraint_550 CHECK ((("time" >= '2018-02-15 00:00:00'::timestamp without time zone) AND ("time" < '2018-02-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_551_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_551_chunk (
    CONSTRAINT constraint_551 CHECK ((("time" >= '2018-02-22 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_552_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_552_chunk (
    CONSTRAINT constraint_552 CHECK ((("time" >= '2018-03-01 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_553_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_553_chunk (
    CONSTRAINT constraint_553 CHECK ((("time" >= '2018-03-08 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_554_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_554_chunk (
    CONSTRAINT constraint_554 CHECK ((("time" >= '2018-03-15 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_555_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_555_chunk (
    CONSTRAINT constraint_555 CHECK ((("time" >= '2018-03-22 00:00:00'::timestamp without time zone) AND ("time" < '2018-03-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_556_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_556_chunk (
    CONSTRAINT constraint_556 CHECK ((("time" >= '2018-03-29 00:00:00'::timestamp without time zone) AND ("time" < '2018-04-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_557_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_557_chunk (
    CONSTRAINT constraint_557 CHECK ((("time" >= '2018-04-05 00:00:00'::timestamp without time zone) AND ("time" < '2018-04-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_558_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_558_chunk (
    CONSTRAINT constraint_558 CHECK ((("time" >= '2018-04-12 00:00:00'::timestamp without time zone) AND ("time" < '2018-04-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_559_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_559_chunk (
    CONSTRAINT constraint_559 CHECK ((("time" >= '2018-04-19 00:00:00'::timestamp without time zone) AND ("time" < '2018-04-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_560_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_560_chunk (
    CONSTRAINT constraint_560 CHECK ((("time" >= '2018-04-26 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_561_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_561_chunk (
    CONSTRAINT constraint_561 CHECK ((("time" >= '2018-05-03 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_562_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_562_chunk (
    CONSTRAINT constraint_562 CHECK ((("time" >= '2018-05-10 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_563_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_563_chunk (
    CONSTRAINT constraint_563 CHECK ((("time" >= '2018-05-17 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_564_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_564_chunk (
    CONSTRAINT constraint_564 CHECK ((("time" >= '2018-05-24 00:00:00'::timestamp without time zone) AND ("time" < '2018-05-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_565_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_565_chunk (
    CONSTRAINT constraint_565 CHECK ((("time" >= '2018-05-31 00:00:00'::timestamp without time zone) AND ("time" < '2018-06-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_566_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_566_chunk (
    CONSTRAINT constraint_566 CHECK ((("time" >= '2018-06-07 00:00:00'::timestamp without time zone) AND ("time" < '2018-06-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_567_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_567_chunk (
    CONSTRAINT constraint_567 CHECK ((("time" >= '2018-06-14 00:00:00'::timestamp without time zone) AND ("time" < '2018-06-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_568_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_568_chunk (
    CONSTRAINT constraint_568 CHECK ((("time" >= '2018-06-21 00:00:00'::timestamp without time zone) AND ("time" < '2018-06-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_569_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_569_chunk (
    CONSTRAINT constraint_569 CHECK ((("time" >= '2018-06-28 00:00:00'::timestamp without time zone) AND ("time" < '2018-07-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_570_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_570_chunk (
    CONSTRAINT constraint_570 CHECK ((("time" >= '2018-07-05 00:00:00'::timestamp without time zone) AND ("time" < '2018-07-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_571_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_571_chunk (
    CONSTRAINT constraint_571 CHECK ((("time" >= '2018-07-12 00:00:00'::timestamp without time zone) AND ("time" < '2018-07-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_572_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_572_chunk (
    CONSTRAINT constraint_572 CHECK ((("time" >= '2018-07-19 00:00:00'::timestamp without time zone) AND ("time" < '2018-07-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_573_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_573_chunk (
    CONSTRAINT constraint_573 CHECK ((("time" >= '2018-07-26 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_574_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_574_chunk (
    CONSTRAINT constraint_574 CHECK ((("time" >= '2018-08-02 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_575_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_575_chunk (
    CONSTRAINT constraint_575 CHECK ((("time" >= '2018-08-09 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_576_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_576_chunk (
    CONSTRAINT constraint_576 CHECK ((("time" >= '2018-08-16 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_577_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_577_chunk (
    CONSTRAINT constraint_577 CHECK ((("time" >= '2018-08-23 00:00:00'::timestamp without time zone) AND ("time" < '2018-08-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_578_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_578_chunk (
    CONSTRAINT constraint_578 CHECK ((("time" >= '2018-08-30 00:00:00'::timestamp without time zone) AND ("time" < '2018-09-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_579_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_579_chunk (
    CONSTRAINT constraint_579 CHECK ((("time" >= '2018-09-06 00:00:00'::timestamp without time zone) AND ("time" < '2018-09-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_580_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_580_chunk (
    CONSTRAINT constraint_580 CHECK ((("time" >= '2018-09-13 00:00:00'::timestamp without time zone) AND ("time" < '2018-09-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_581_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_581_chunk (
    CONSTRAINT constraint_581 CHECK ((("time" >= '2018-09-20 00:00:00'::timestamp without time zone) AND ("time" < '2018-09-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_582_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_582_chunk (
    CONSTRAINT constraint_582 CHECK ((("time" >= '2018-09-27 00:00:00'::timestamp without time zone) AND ("time" < '2018-10-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_583_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_583_chunk (
    CONSTRAINT constraint_583 CHECK ((("time" >= '2018-10-04 00:00:00'::timestamp without time zone) AND ("time" < '2018-10-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_584_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_584_chunk (
    CONSTRAINT constraint_584 CHECK ((("time" >= '2018-10-11 00:00:00'::timestamp without time zone) AND ("time" < '2018-10-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_585_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_585_chunk (
    CONSTRAINT constraint_585 CHECK ((("time" >= '2018-10-18 00:00:00'::timestamp without time zone) AND ("time" < '2018-10-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_586_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_586_chunk (
    CONSTRAINT constraint_586 CHECK ((("time" >= '2018-10-25 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_587_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_587_chunk (
    CONSTRAINT constraint_587 CHECK ((("time" >= '2018-11-01 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_588_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_588_chunk (
    CONSTRAINT constraint_588 CHECK ((("time" >= '2018-11-08 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_589_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_589_chunk (
    CONSTRAINT constraint_589 CHECK ((("time" >= '2018-11-15 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_590_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_590_chunk (
    CONSTRAINT constraint_590 CHECK ((("time" >= '2018-11-22 00:00:00'::timestamp without time zone) AND ("time" < '2018-11-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_591_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_591_chunk (
    CONSTRAINT constraint_591 CHECK ((("time" >= '2018-11-29 00:00:00'::timestamp without time zone) AND ("time" < '2018-12-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_592_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_592_chunk (
    CONSTRAINT constraint_592 CHECK ((("time" >= '2018-12-06 00:00:00'::timestamp without time zone) AND ("time" < '2018-12-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_593_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_593_chunk (
    CONSTRAINT constraint_593 CHECK ((("time" >= '2018-12-13 00:00:00'::timestamp without time zone) AND ("time" < '2018-12-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_594_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_594_chunk (
    CONSTRAINT constraint_594 CHECK ((("time" >= '2018-12-20 00:00:00'::timestamp without time zone) AND ("time" < '2018-12-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_595_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_595_chunk (
    CONSTRAINT constraint_595 CHECK ((("time" >= '2018-12-27 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_596_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_596_chunk (
    CONSTRAINT constraint_596 CHECK ((("time" >= '2019-01-03 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_597_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_597_chunk (
    CONSTRAINT constraint_597 CHECK ((("time" >= '2019-01-10 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_598_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_598_chunk (
    CONSTRAINT constraint_598 CHECK ((("time" >= '2019-01-17 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_599_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_599_chunk (
    CONSTRAINT constraint_599 CHECK ((("time" >= '2019-01-24 00:00:00'::timestamp without time zone) AND ("time" < '2019-01-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_600_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_600_chunk (
    CONSTRAINT constraint_600 CHECK ((("time" >= '2019-01-31 00:00:00'::timestamp without time zone) AND ("time" < '2019-02-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_601_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_601_chunk (
    CONSTRAINT constraint_601 CHECK ((("time" >= '2019-02-07 00:00:00'::timestamp without time zone) AND ("time" < '2019-02-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_602_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_602_chunk (
    CONSTRAINT constraint_602 CHECK ((("time" >= '2019-02-14 00:00:00'::timestamp without time zone) AND ("time" < '2019-02-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_603_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_603_chunk (
    CONSTRAINT constraint_603 CHECK ((("time" >= '2019-02-21 00:00:00'::timestamp without time zone) AND ("time" < '2019-02-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_604_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_604_chunk (
    CONSTRAINT constraint_604 CHECK ((("time" >= '2019-02-28 00:00:00'::timestamp without time zone) AND ("time" < '2019-03-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_605_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_605_chunk (
    CONSTRAINT constraint_605 CHECK ((("time" >= '2019-03-07 00:00:00'::timestamp without time zone) AND ("time" < '2019-03-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_606_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_606_chunk (
    CONSTRAINT constraint_606 CHECK ((("time" >= '2019-03-14 00:00:00'::timestamp without time zone) AND ("time" < '2019-03-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_607_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_607_chunk (
    CONSTRAINT constraint_607 CHECK ((("time" >= '2019-03-21 00:00:00'::timestamp without time zone) AND ("time" < '2019-03-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_608_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_608_chunk (
    CONSTRAINT constraint_608 CHECK ((("time" >= '2019-03-28 00:00:00'::timestamp without time zone) AND ("time" < '2019-04-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_609_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_609_chunk (
    CONSTRAINT constraint_609 CHECK ((("time" >= '2019-04-04 00:00:00'::timestamp without time zone) AND ("time" < '2019-04-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_610_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_610_chunk (
    CONSTRAINT constraint_610 CHECK ((("time" >= '2019-04-11 00:00:00'::timestamp without time zone) AND ("time" < '2019-04-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_611_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_611_chunk (
    CONSTRAINT constraint_611 CHECK ((("time" >= '2019-04-18 00:00:00'::timestamp without time zone) AND ("time" < '2019-04-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_612_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_612_chunk (
    CONSTRAINT constraint_612 CHECK ((("time" >= '2019-04-25 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_613_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_613_chunk (
    CONSTRAINT constraint_613 CHECK ((("time" >= '2019-05-02 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_614_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_614_chunk (
    CONSTRAINT constraint_614 CHECK ((("time" >= '2019-05-09 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_615_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_615_chunk (
    CONSTRAINT constraint_615 CHECK ((("time" >= '2019-05-16 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_616_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_616_chunk (
    CONSTRAINT constraint_616 CHECK ((("time" >= '2019-05-23 00:00:00'::timestamp without time zone) AND ("time" < '2019-05-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_617_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_617_chunk (
    CONSTRAINT constraint_617 CHECK ((("time" >= '2019-05-30 00:00:00'::timestamp without time zone) AND ("time" < '2019-06-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_618_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_618_chunk (
    CONSTRAINT constraint_618 CHECK ((("time" >= '2019-06-06 00:00:00'::timestamp without time zone) AND ("time" < '2019-06-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_619_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_619_chunk (
    CONSTRAINT constraint_619 CHECK ((("time" >= '2019-06-13 00:00:00'::timestamp without time zone) AND ("time" < '2019-06-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_620_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_620_chunk (
    CONSTRAINT constraint_620 CHECK ((("time" >= '2019-06-20 00:00:00'::timestamp without time zone) AND ("time" < '2019-06-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_621_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_621_chunk (
    CONSTRAINT constraint_621 CHECK ((("time" >= '2019-06-27 00:00:00'::timestamp without time zone) AND ("time" < '2019-07-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_622_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_622_chunk (
    CONSTRAINT constraint_622 CHECK ((("time" >= '2019-07-04 00:00:00'::timestamp without time zone) AND ("time" < '2019-07-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_623_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_623_chunk (
    CONSTRAINT constraint_623 CHECK ((("time" >= '2019-07-11 00:00:00'::timestamp without time zone) AND ("time" < '2019-07-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_624_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_624_chunk (
    CONSTRAINT constraint_624 CHECK ((("time" >= '2019-07-18 00:00:00'::timestamp without time zone) AND ("time" < '2019-07-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_625_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_625_chunk (
    CONSTRAINT constraint_625 CHECK ((("time" >= '2019-07-25 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_626_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_626_chunk (
    CONSTRAINT constraint_626 CHECK ((("time" >= '2019-08-01 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_627_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_627_chunk (
    CONSTRAINT constraint_627 CHECK ((("time" >= '2019-08-08 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_628_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_628_chunk (
    CONSTRAINT constraint_628 CHECK ((("time" >= '2019-08-15 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_629_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_629_chunk (
    CONSTRAINT constraint_629 CHECK ((("time" >= '2019-08-22 00:00:00'::timestamp without time zone) AND ("time" < '2019-08-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_630_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_630_chunk (
    CONSTRAINT constraint_630 CHECK ((("time" >= '2019-08-29 00:00:00'::timestamp without time zone) AND ("time" < '2019-09-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_631_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_631_chunk (
    CONSTRAINT constraint_631 CHECK ((("time" >= '2019-09-05 00:00:00'::timestamp without time zone) AND ("time" < '2019-09-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_632_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_632_chunk (
    CONSTRAINT constraint_632 CHECK ((("time" >= '2019-09-12 00:00:00'::timestamp without time zone) AND ("time" < '2019-09-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_633_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_633_chunk (
    CONSTRAINT constraint_633 CHECK ((("time" >= '2019-09-19 00:00:00'::timestamp without time zone) AND ("time" < '2019-09-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_634_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_634_chunk (
    CONSTRAINT constraint_634 CHECK ((("time" >= '2019-09-26 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_635_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_635_chunk (
    CONSTRAINT constraint_635 CHECK ((("time" >= '2019-10-03 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_636_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_636_chunk (
    CONSTRAINT constraint_636 CHECK ((("time" >= '2019-10-10 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_637_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_637_chunk (
    CONSTRAINT constraint_637 CHECK ((("time" >= '2019-10-17 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_638_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_638_chunk (
    CONSTRAINT constraint_638 CHECK ((("time" >= '2019-10-24 00:00:00'::timestamp without time zone) AND ("time" < '2019-10-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_639_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_639_chunk (
    CONSTRAINT constraint_639 CHECK ((("time" >= '2019-10-31 00:00:00'::timestamp without time zone) AND ("time" < '2019-11-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_640_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_640_chunk (
    CONSTRAINT constraint_640 CHECK ((("time" >= '2019-11-07 00:00:00'::timestamp without time zone) AND ("time" < '2019-11-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_641_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_641_chunk (
    CONSTRAINT constraint_641 CHECK ((("time" >= '2019-11-14 00:00:00'::timestamp without time zone) AND ("time" < '2019-11-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_642_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_642_chunk (
    CONSTRAINT constraint_642 CHECK ((("time" >= '2019-11-21 00:00:00'::timestamp without time zone) AND ("time" < '2019-11-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_643_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_643_chunk (
    CONSTRAINT constraint_643 CHECK ((("time" >= '2019-11-28 00:00:00'::timestamp without time zone) AND ("time" < '2019-12-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_644_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_644_chunk (
    CONSTRAINT constraint_644 CHECK ((("time" >= '2019-12-05 00:00:00'::timestamp without time zone) AND ("time" < '2019-12-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_645_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_645_chunk (
    CONSTRAINT constraint_645 CHECK ((("time" >= '2019-12-12 00:00:00'::timestamp without time zone) AND ("time" < '2019-12-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_646_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_646_chunk (
    CONSTRAINT constraint_646 CHECK ((("time" >= '2019-12-19 00:00:00'::timestamp without time zone) AND ("time" < '2019-12-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_647_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_647_chunk (
    CONSTRAINT constraint_647 CHECK ((("time" >= '2019-12-26 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_648_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_648_chunk (
    CONSTRAINT constraint_648 CHECK ((("time" >= '2020-01-02 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_649_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_649_chunk (
    CONSTRAINT constraint_649 CHECK ((("time" >= '2020-01-09 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_650_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_650_chunk (
    CONSTRAINT constraint_650 CHECK ((("time" >= '2020-01-16 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_651_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_651_chunk (
    CONSTRAINT constraint_651 CHECK ((("time" >= '2020-01-23 00:00:00'::timestamp without time zone) AND ("time" < '2020-01-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_652_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_652_chunk (
    CONSTRAINT constraint_652 CHECK ((("time" >= '2020-01-30 00:00:00'::timestamp without time zone) AND ("time" < '2020-02-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_653_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_653_chunk (
    CONSTRAINT constraint_653 CHECK ((("time" >= '2020-02-06 00:00:00'::timestamp without time zone) AND ("time" < '2020-02-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_654_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_654_chunk (
    CONSTRAINT constraint_654 CHECK ((("time" >= '2020-02-13 00:00:00'::timestamp without time zone) AND ("time" < '2020-02-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_655_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_655_chunk (
    CONSTRAINT constraint_655 CHECK ((("time" >= '2020-02-20 00:00:00'::timestamp without time zone) AND ("time" < '2020-02-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_656_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_656_chunk (
    CONSTRAINT constraint_656 CHECK ((("time" >= '2020-02-27 00:00:00'::timestamp without time zone) AND ("time" < '2020-03-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_657_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_657_chunk (
    CONSTRAINT constraint_657 CHECK ((("time" >= '2020-03-05 00:00:00'::timestamp without time zone) AND ("time" < '2020-03-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_658_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_658_chunk (
    CONSTRAINT constraint_658 CHECK ((("time" >= '2020-03-12 00:00:00'::timestamp without time zone) AND ("time" < '2020-03-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_659_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_659_chunk (
    CONSTRAINT constraint_659 CHECK ((("time" >= '2020-03-19 00:00:00'::timestamp without time zone) AND ("time" < '2020-03-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_660_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_660_chunk (
    CONSTRAINT constraint_660 CHECK ((("time" >= '2020-03-26 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_661_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_661_chunk (
    CONSTRAINT constraint_661 CHECK ((("time" >= '2020-04-02 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_662_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_662_chunk (
    CONSTRAINT constraint_662 CHECK ((("time" >= '2020-04-09 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_663_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_663_chunk (
    CONSTRAINT constraint_663 CHECK ((("time" >= '2020-04-16 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_664_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_664_chunk (
    CONSTRAINT constraint_664 CHECK ((("time" >= '2020-04-23 00:00:00'::timestamp without time zone) AND ("time" < '2020-04-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_665_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_665_chunk (
    CONSTRAINT constraint_665 CHECK ((("time" >= '2020-04-30 00:00:00'::timestamp without time zone) AND ("time" < '2020-05-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_666_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_666_chunk (
    CONSTRAINT constraint_666 CHECK ((("time" >= '2020-05-07 00:00:00'::timestamp without time zone) AND ("time" < '2020-05-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_667_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_667_chunk (
    CONSTRAINT constraint_667 CHECK ((("time" >= '2020-05-14 00:00:00'::timestamp without time zone) AND ("time" < '2020-05-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_668_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_668_chunk (
    CONSTRAINT constraint_668 CHECK ((("time" >= '2020-05-21 00:00:00'::timestamp without time zone) AND ("time" < '2020-05-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_669_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_669_chunk (
    CONSTRAINT constraint_669 CHECK ((("time" >= '2020-05-28 00:00:00'::timestamp without time zone) AND ("time" < '2020-06-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_670_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_670_chunk (
    CONSTRAINT constraint_670 CHECK ((("time" >= '2020-06-04 00:00:00'::timestamp without time zone) AND ("time" < '2020-06-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_671_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_671_chunk (
    CONSTRAINT constraint_671 CHECK ((("time" >= '2020-06-11 00:00:00'::timestamp without time zone) AND ("time" < '2020-06-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_672_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_672_chunk (
    CONSTRAINT constraint_672 CHECK ((("time" >= '2020-06-18 00:00:00'::timestamp without time zone) AND ("time" < '2020-06-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_673_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_673_chunk (
    CONSTRAINT constraint_673 CHECK ((("time" >= '2020-06-25 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_674_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_674_chunk (
    CONSTRAINT constraint_674 CHECK ((("time" >= '2020-07-02 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_675_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_675_chunk (
    CONSTRAINT constraint_675 CHECK ((("time" >= '2020-07-09 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_676_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_676_chunk (
    CONSTRAINT constraint_676 CHECK ((("time" >= '2020-07-16 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_677_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_677_chunk (
    CONSTRAINT constraint_677 CHECK ((("time" >= '2020-07-23 00:00:00'::timestamp without time zone) AND ("time" < '2020-07-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_678_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_678_chunk (
    CONSTRAINT constraint_678 CHECK ((("time" >= '2020-07-30 00:00:00'::timestamp without time zone) AND ("time" < '2020-08-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_679_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_679_chunk (
    CONSTRAINT constraint_679 CHECK ((("time" >= '2020-08-06 00:00:00'::timestamp without time zone) AND ("time" < '2020-08-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_680_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_680_chunk (
    CONSTRAINT constraint_680 CHECK ((("time" >= '2020-08-13 00:00:00'::timestamp without time zone) AND ("time" < '2020-08-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_681_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_681_chunk (
    CONSTRAINT constraint_681 CHECK ((("time" >= '2020-08-20 00:00:00'::timestamp without time zone) AND ("time" < '2020-08-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_682_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_682_chunk (
    CONSTRAINT constraint_682 CHECK ((("time" >= '2020-08-27 00:00:00'::timestamp without time zone) AND ("time" < '2020-09-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_683_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_683_chunk (
    CONSTRAINT constraint_683 CHECK ((("time" >= '2020-09-03 00:00:00'::timestamp without time zone) AND ("time" < '2020-09-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_684_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_684_chunk (
    CONSTRAINT constraint_684 CHECK ((("time" >= '2020-09-10 00:00:00'::timestamp without time zone) AND ("time" < '2020-09-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_685_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_685_chunk (
    CONSTRAINT constraint_685 CHECK ((("time" >= '2020-09-17 00:00:00'::timestamp without time zone) AND ("time" < '2020-09-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_686_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_686_chunk (
    CONSTRAINT constraint_686 CHECK ((("time" >= '2020-09-24 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_687_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_687_chunk (
    CONSTRAINT constraint_687 CHECK ((("time" >= '2020-10-01 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_688_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_688_chunk (
    CONSTRAINT constraint_688 CHECK ((("time" >= '2020-10-08 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_689_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_689_chunk (
    CONSTRAINT constraint_689 CHECK ((("time" >= '2020-10-15 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_690_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_690_chunk (
    CONSTRAINT constraint_690 CHECK ((("time" >= '2020-10-22 00:00:00'::timestamp without time zone) AND ("time" < '2020-10-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_691_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_691_chunk (
    CONSTRAINT constraint_691 CHECK ((("time" >= '2020-10-29 00:00:00'::timestamp without time zone) AND ("time" < '2020-11-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_692_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_692_chunk (
    CONSTRAINT constraint_692 CHECK ((("time" >= '2020-11-05 00:00:00'::timestamp without time zone) AND ("time" < '2020-11-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_693_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_693_chunk (
    CONSTRAINT constraint_693 CHECK ((("time" >= '2020-11-12 00:00:00'::timestamp without time zone) AND ("time" < '2020-11-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_694_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_694_chunk (
    CONSTRAINT constraint_694 CHECK ((("time" >= '2020-11-19 00:00:00'::timestamp without time zone) AND ("time" < '2020-11-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_695_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_695_chunk (
    CONSTRAINT constraint_695 CHECK ((("time" >= '2020-11-26 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_696_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_696_chunk (
    CONSTRAINT constraint_696 CHECK ((("time" >= '2020-12-03 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_697_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_697_chunk (
    CONSTRAINT constraint_697 CHECK ((("time" >= '2020-12-10 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_698_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_698_chunk (
    CONSTRAINT constraint_698 CHECK ((("time" >= '2020-12-17 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_699_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_699_chunk (
    CONSTRAINT constraint_699 CHECK ((("time" >= '2020-12-24 00:00:00'::timestamp without time zone) AND ("time" < '2020-12-31 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_700_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_700_chunk (
    CONSTRAINT constraint_700 CHECK ((("time" >= '2020-12-31 00:00:00'::timestamp without time zone) AND ("time" < '2021-01-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_701_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_701_chunk (
    CONSTRAINT constraint_701 CHECK ((("time" >= '2021-01-07 00:00:00'::timestamp without time zone) AND ("time" < '2021-01-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_702_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_702_chunk (
    CONSTRAINT constraint_702 CHECK ((("time" >= '2021-01-14 00:00:00'::timestamp without time zone) AND ("time" < '2021-01-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_703_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_703_chunk (
    CONSTRAINT constraint_703 CHECK ((("time" >= '2021-01-21 00:00:00'::timestamp without time zone) AND ("time" < '2021-01-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_704_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_704_chunk (
    CONSTRAINT constraint_704 CHECK ((("time" >= '2021-01-28 00:00:00'::timestamp without time zone) AND ("time" < '2021-02-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_705_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_705_chunk (
    CONSTRAINT constraint_705 CHECK ((("time" >= '2021-02-04 00:00:00'::timestamp without time zone) AND ("time" < '2021-02-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_706_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_706_chunk (
    CONSTRAINT constraint_706 CHECK ((("time" >= '2021-02-11 00:00:00'::timestamp without time zone) AND ("time" < '2021-02-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_707_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_707_chunk (
    CONSTRAINT constraint_707 CHECK ((("time" >= '2021-02-18 00:00:00'::timestamp without time zone) AND ("time" < '2021-02-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_708_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_708_chunk (
    CONSTRAINT constraint_708 CHECK ((("time" >= '2021-02-25 00:00:00'::timestamp without time zone) AND ("time" < '2021-03-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_709_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_709_chunk (
    CONSTRAINT constraint_709 CHECK ((("time" >= '2021-03-04 00:00:00'::timestamp without time zone) AND ("time" < '2021-03-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_710_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_710_chunk (
    CONSTRAINT constraint_710 CHECK ((("time" >= '2021-03-11 00:00:00'::timestamp without time zone) AND ("time" < '2021-03-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_711_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_711_chunk (
    CONSTRAINT constraint_711 CHECK ((("time" >= '2021-03-18 00:00:00'::timestamp without time zone) AND ("time" < '2021-03-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_712_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_712_chunk (
    CONSTRAINT constraint_712 CHECK ((("time" >= '2021-03-25 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_713_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_713_chunk (
    CONSTRAINT constraint_713 CHECK ((("time" >= '2021-04-01 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_714_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_714_chunk (
    CONSTRAINT constraint_714 CHECK ((("time" >= '2021-04-08 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_715_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_715_chunk (
    CONSTRAINT constraint_715 CHECK ((("time" >= '2021-04-15 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_716_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_716_chunk (
    CONSTRAINT constraint_716 CHECK ((("time" >= '2021-04-22 00:00:00'::timestamp without time zone) AND ("time" < '2021-04-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_717_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_717_chunk (
    CONSTRAINT constraint_717 CHECK ((("time" >= '2021-04-29 00:00:00'::timestamp without time zone) AND ("time" < '2021-05-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_718_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_718_chunk (
    CONSTRAINT constraint_718 CHECK ((("time" >= '2021-05-06 00:00:00'::timestamp without time zone) AND ("time" < '2021-05-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_719_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_719_chunk (
    CONSTRAINT constraint_719 CHECK ((("time" >= '2021-05-13 00:00:00'::timestamp without time zone) AND ("time" < '2021-05-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_720_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_720_chunk (
    CONSTRAINT constraint_720 CHECK ((("time" >= '2021-05-20 00:00:00'::timestamp without time zone) AND ("time" < '2021-05-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_721_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_721_chunk (
    CONSTRAINT constraint_721 CHECK ((("time" >= '2021-05-27 00:00:00'::timestamp without time zone) AND ("time" < '2021-06-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_722_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_722_chunk (
    CONSTRAINT constraint_722 CHECK ((("time" >= '2021-06-03 00:00:00'::timestamp without time zone) AND ("time" < '2021-06-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_723_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_723_chunk (
    CONSTRAINT constraint_723 CHECK ((("time" >= '2021-06-10 00:00:00'::timestamp without time zone) AND ("time" < '2021-06-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_724_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_724_chunk (
    CONSTRAINT constraint_724 CHECK ((("time" >= '2021-06-17 00:00:00'::timestamp without time zone) AND ("time" < '2021-06-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_725_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_725_chunk (
    CONSTRAINT constraint_725 CHECK ((("time" >= '2021-06-24 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-01 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_726_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_726_chunk (
    CONSTRAINT constraint_726 CHECK ((("time" >= '2021-07-01 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-08 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_727_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_727_chunk (
    CONSTRAINT constraint_727 CHECK ((("time" >= '2021-07-08 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-15 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_728_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_728_chunk (
    CONSTRAINT constraint_728 CHECK ((("time" >= '2021-07-15 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-22 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_729_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_729_chunk (
    CONSTRAINT constraint_729 CHECK ((("time" >= '2021-07-22 00:00:00'::timestamp without time zone) AND ("time" < '2021-07-29 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_730_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_730_chunk (
    CONSTRAINT constraint_730 CHECK ((("time" >= '2021-07-29 00:00:00'::timestamp without time zone) AND ("time" < '2021-08-05 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_731_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_731_chunk (
    CONSTRAINT constraint_731 CHECK ((("time" >= '2021-08-05 00:00:00'::timestamp without time zone) AND ("time" < '2021-08-12 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_732_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_732_chunk (
    CONSTRAINT constraint_732 CHECK ((("time" >= '2021-08-12 00:00:00'::timestamp without time zone) AND ("time" < '2021-08-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_733_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_733_chunk (
    CONSTRAINT constraint_733 CHECK ((("time" >= '2021-08-19 00:00:00'::timestamp without time zone) AND ("time" < '2021-08-26 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_734_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_734_chunk (
    CONSTRAINT constraint_734 CHECK ((("time" >= '2021-08-26 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_735_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_735_chunk (
    CONSTRAINT constraint_735 CHECK ((("time" >= '2021-09-02 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_736_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_736_chunk (
    CONSTRAINT constraint_736 CHECK ((("time" >= '2021-09-09 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_737_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_737_chunk (
    CONSTRAINT constraint_737 CHECK ((("time" >= '2021-09-16 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_738_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_738_chunk (
    CONSTRAINT constraint_738 CHECK ((("time" >= '2021-09-23 00:00:00'::timestamp without time zone) AND ("time" < '2021-09-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_739_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_739_chunk (
    CONSTRAINT constraint_739 CHECK ((("time" >= '2021-09-30 00:00:00'::timestamp without time zone) AND ("time" < '2021-10-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_740_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_740_chunk (
    CONSTRAINT constraint_740 CHECK ((("time" >= '2021-10-07 00:00:00'::timestamp without time zone) AND ("time" < '2021-10-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_741_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_741_chunk (
    CONSTRAINT constraint_741 CHECK ((("time" >= '2021-10-14 00:00:00'::timestamp without time zone) AND ("time" < '2021-10-21 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_742_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_742_chunk (
    CONSTRAINT constraint_742 CHECK ((("time" >= '2021-10-21 00:00:00'::timestamp without time zone) AND ("time" < '2021-10-28 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_743_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_743_chunk (
    CONSTRAINT constraint_743 CHECK ((("time" >= '2021-10-28 00:00:00'::timestamp without time zone) AND ("time" < '2021-11-04 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_744_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_744_chunk (
    CONSTRAINT constraint_744 CHECK ((("time" >= '2021-11-04 00:00:00'::timestamp without time zone) AND ("time" < '2021-11-11 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_745_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_745_chunk (
    CONSTRAINT constraint_745 CHECK ((("time" >= '2021-11-11 00:00:00'::timestamp without time zone) AND ("time" < '2021-11-18 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_746_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_746_chunk (
    CONSTRAINT constraint_746 CHECK ((("time" >= '2021-11-18 00:00:00'::timestamp without time zone) AND ("time" < '2021-11-25 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_747_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_747_chunk (
    CONSTRAINT constraint_747 CHECK ((("time" >= '2021-11-25 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-02 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_748_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_748_chunk (
    CONSTRAINT constraint_748 CHECK ((("time" >= '2021-12-02 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-09 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_749_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_749_chunk (
    CONSTRAINT constraint_749 CHECK ((("time" >= '2021-12-09 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-16 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_750_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_750_chunk (
    CONSTRAINT constraint_750 CHECK ((("time" >= '2021-12-16 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-23 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_751_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_751_chunk (
    CONSTRAINT constraint_751 CHECK ((("time" >= '2021-12-23 00:00:00'::timestamp without time zone) AND ("time" < '2021-12-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


--
-- Name: _hyper_2_752_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_752_chunk (
    CONSTRAINT constraint_752 CHECK ((("time" >= '2021-12-30 00:00:00'::timestamp without time zone) AND ("time" < '2022-01-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_load);


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

CREATE INDEX _hyper_1_100_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_100_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_100_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_100_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_101_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_101_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_101_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_101_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_101_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_102_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_102_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_102_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_102_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_102_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_103_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_103_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_103_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_103_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_103_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_104_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_104_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_104_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_104_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_104_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_105_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_105_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_105_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_105_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_105_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_106_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_106_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_106_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_106_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_106_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_107_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_107_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_107_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_107_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_107_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_108_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_108_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_108_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_108_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_108_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_109_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_109_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_109_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_109_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_109_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_10_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_10_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_10_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_10_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_10_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_110_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_110_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_110_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_110_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_110_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_111_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_111_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_111_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_111_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_111_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_112_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_112_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_112_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_112_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_112_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_113_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_113_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_113_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_113_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_113_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_114_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_114_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_114_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_114_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_114_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_115_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_115_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_115_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_115_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_115_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_116_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_116_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_116_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_116_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_116_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_117_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_117_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_117_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_117_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_117_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_118_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_118_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_118_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_118_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_118_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_119_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_119_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_119_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_119_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_119_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_11_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_11_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_11_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_11_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_11_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_120_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_120_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_120_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_120_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_120_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_121_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_121_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_121_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_121_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_121_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_122_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_122_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_122_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_122_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_122_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_123_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_123_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_123_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_123_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_123_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_124_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_124_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_124_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_124_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_124_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_125_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_125_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_125_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_125_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_125_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_126_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_126_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_126_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_126_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_126_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_127_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_127_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_127_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_127_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_127_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_128_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_128_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_128_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_128_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_128_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_129_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_129_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_129_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_129_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_129_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_12_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_12_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_12_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_12_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_12_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_130_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_130_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_130_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_130_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_130_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_131_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_131_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_131_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_131_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_131_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_132_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_132_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_132_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_132_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_132_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_133_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_133_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_133_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_133_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_133_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_134_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_134_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_134_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_134_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_134_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_135_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_135_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_135_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_135_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_135_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_136_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_136_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_136_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_136_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_136_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_137_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_137_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_137_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_137_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_137_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_138_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_138_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_138_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_138_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_138_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_139_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_139_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_139_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_139_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_139_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_13_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_13_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_13_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_13_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_13_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_140_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_140_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_140_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_140_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_140_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_141_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_141_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_141_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_141_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_141_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_142_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_142_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_142_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_142_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_142_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_143_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_143_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_143_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_143_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_143_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_144_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_144_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_144_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_144_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_144_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_145_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_145_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_145_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_145_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_145_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_146_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_146_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_146_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_146_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_146_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_147_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_147_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_147_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_147_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_147_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_148_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_148_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_148_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_148_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_148_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_149_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_149_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_149_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_149_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_149_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_14_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_14_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_14_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_14_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_14_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_150_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_150_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_150_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_150_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_150_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_151_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_151_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_151_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_151_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_151_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_152_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_152_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_152_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_152_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_152_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_153_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_153_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_153_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_153_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_153_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_154_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_154_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_154_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_154_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_154_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_155_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_155_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_155_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_155_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_155_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_156_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_156_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_156_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_156_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_156_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_157_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_157_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_157_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_157_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_157_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_158_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_158_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_158_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_158_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_158_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_159_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_159_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_159_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_159_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_159_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_15_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_15_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_15_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_15_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_15_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_160_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_160_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_160_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_160_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_160_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_161_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_161_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_161_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_161_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_161_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_162_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_162_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_162_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_162_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_162_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_163_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_163_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_163_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_163_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_163_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_164_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_164_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_164_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_164_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_164_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_165_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_165_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_165_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_165_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_165_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_166_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_166_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_166_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_166_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_166_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_167_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_167_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_167_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_167_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_167_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_168_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_168_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_168_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_168_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_168_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_169_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_169_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_169_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_169_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_169_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_16_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_16_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_16_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_16_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_16_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_170_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_170_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_170_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_170_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_170_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_171_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_171_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_171_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_171_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_171_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_172_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_172_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_172_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_172_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_172_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_173_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_173_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_173_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_173_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_173_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_174_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_174_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_174_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_174_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_174_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_175_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_175_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_175_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_175_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_175_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_176_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_176_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_176_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_176_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_176_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_177_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_177_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_177_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_177_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_177_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_178_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_178_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_178_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_178_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_178_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_179_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_179_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_179_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_179_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_179_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_17_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_17_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_17_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_17_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_17_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_180_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_180_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_180_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_180_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_180_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_181_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_181_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_181_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_181_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_181_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_182_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_182_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_182_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_182_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_182_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_183_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_183_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_183_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_183_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_183_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_184_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_184_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_184_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_184_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_184_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_185_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_185_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_185_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_185_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_185_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_186_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_186_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_186_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_186_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_186_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_187_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_187_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_187_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_187_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_187_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_188_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_188_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_188_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_188_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_188_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_189_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_189_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_189_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_189_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_189_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_18_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_18_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_18_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_18_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_18_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_190_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_190_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_190_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_190_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_190_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_191_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_191_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_191_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_191_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_191_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_192_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_192_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_192_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_192_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_192_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_193_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_193_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_193_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_193_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_193_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_194_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_194_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_194_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_194_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_194_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_195_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_195_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_195_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_195_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_195_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_196_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_196_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_196_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_196_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_196_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_197_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_197_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_197_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_197_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_197_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_198_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_198_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_198_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_198_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_198_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_199_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_199_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_199_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_199_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_199_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_19_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_19_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_19_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_19_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_19_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_1_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_1_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_1_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_1_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_200_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_200_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_200_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_200_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_200_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_201_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_201_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_201_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_201_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_201_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_202_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_202_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_202_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_202_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_202_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_203_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_203_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_203_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_203_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_203_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_204_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_204_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_204_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_204_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_204_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_205_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_205_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_205_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_205_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_205_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_206_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_206_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_206_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_206_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_206_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_207_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_207_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_207_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_207_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_207_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_208_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_208_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_208_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_208_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_208_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_209_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_209_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_209_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_209_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_209_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_20_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_20_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_20_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_20_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_20_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_210_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_210_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_210_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_210_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_210_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_211_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_211_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_211_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_211_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_211_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_212_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_212_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_212_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_212_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_212_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_213_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_213_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_213_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_213_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_213_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_214_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_214_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_214_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_214_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_214_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_215_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_215_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_215_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_215_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_215_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_216_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_216_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_216_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_216_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_216_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_217_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_217_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_217_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_217_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_217_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_218_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_218_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_218_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_218_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_218_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_219_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_219_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_219_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_219_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_219_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_21_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_21_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_21_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_21_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_21_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_220_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_220_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_220_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_220_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_220_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_221_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_221_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_221_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_221_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_221_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_222_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_222_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_222_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_222_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_222_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_223_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_223_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_223_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_223_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_223_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_224_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_224_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_224_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_224_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_224_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_225_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_225_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_225_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_225_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_225_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_226_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_226_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_226_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_226_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_226_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_227_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_227_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_227_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_227_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_227_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_228_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_228_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_228_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_228_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_228_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_229_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_229_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_229_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_229_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_229_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_22_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_22_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_22_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_22_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_22_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_230_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_230_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_230_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_230_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_230_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_231_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_231_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_231_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_231_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_231_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_232_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_232_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_232_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_232_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_232_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_233_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_233_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_233_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_233_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_233_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_234_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_234_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_234_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_234_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_234_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_235_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_235_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_235_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_235_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_235_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_236_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_236_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_236_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_236_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_236_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_237_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_237_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_237_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_237_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_237_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_238_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_238_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_238_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_238_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_238_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_239_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_239_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_239_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_239_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_239_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_23_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_23_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_23_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_23_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_23_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_240_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_240_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_240_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_240_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_240_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_241_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_241_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_241_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_241_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_241_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_242_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_242_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_242_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_242_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_242_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_243_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_243_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_243_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_243_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_243_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_244_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_244_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_244_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_244_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_244_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_245_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_245_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_245_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_245_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_245_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_246_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_246_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_246_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_246_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_246_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_247_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_247_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_247_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_247_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_247_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_248_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_248_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_248_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_248_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_248_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_249_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_249_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_249_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_249_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_249_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_24_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_24_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_24_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_24_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_24_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_250_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_250_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_250_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_250_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_250_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_251_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_251_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_251_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_251_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_251_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_252_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_252_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_252_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_252_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_252_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_253_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_253_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_253_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_253_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_253_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_254_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_254_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_254_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_254_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_254_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_255_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_255_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_255_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_255_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_255_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_256_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_256_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_256_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_256_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_256_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_257_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_257_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_257_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_257_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_257_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_258_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_258_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_258_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_258_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_258_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_259_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_259_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_259_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_259_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_259_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_25_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_25_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_25_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_25_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_25_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_260_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_260_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_260_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_260_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_260_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_261_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_261_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_261_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_261_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_261_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_262_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_262_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_262_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_262_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_262_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_263_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_263_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_263_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_263_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_263_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_264_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_264_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_264_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_264_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_264_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_265_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_265_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_265_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_265_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_265_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_266_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_266_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_266_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_266_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_266_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_267_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_267_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_267_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_267_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_267_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_268_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_268_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_268_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_268_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_268_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_269_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_269_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_269_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_269_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_269_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_26_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_26_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_26_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_26_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_26_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_270_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_270_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_270_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_270_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_270_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_271_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_271_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_271_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_271_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_271_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_272_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_272_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_272_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_272_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_272_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_273_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_273_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_273_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_273_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_273_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_274_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_274_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_274_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_274_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_274_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_275_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_275_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_275_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_275_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_275_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_276_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_276_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_276_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_276_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_276_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_277_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_277_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_277_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_277_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_277_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_278_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_278_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_278_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_278_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_278_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_279_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_279_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_279_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_279_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_279_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_27_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_27_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_27_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_27_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_27_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_280_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_280_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_280_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_280_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_280_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_281_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_281_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_281_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_281_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_281_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_282_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_282_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_282_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_282_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_282_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_283_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_283_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_283_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_283_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_283_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_284_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_284_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_284_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_284_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_284_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_285_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_285_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_285_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_285_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_285_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_286_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_286_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_286_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_286_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_286_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_287_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_287_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_287_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_287_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_287_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_288_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_288_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_288_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_288_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_288_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_289_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_289_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_289_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_289_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_289_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_28_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_28_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_28_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_28_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_28_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_290_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_290_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_290_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_290_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_290_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_291_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_291_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_291_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_291_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_291_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_292_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_292_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_292_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_292_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_292_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_293_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_293_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_293_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_293_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_293_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_294_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_294_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_294_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_294_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_294_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_295_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_295_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_295_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_295_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_295_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_296_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_296_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_296_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_296_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_296_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_297_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_297_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_297_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_297_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_297_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_298_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_298_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_298_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_298_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_298_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_299_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_299_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_299_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_299_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_299_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_29_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_29_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_29_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_29_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_29_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_2_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_2_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_2_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_2_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_2_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_300_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_300_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_300_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_300_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_300_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_301_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_301_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_301_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_301_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_301_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_302_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_302_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_302_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_302_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_302_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_303_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_303_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_303_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_303_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_303_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_304_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_304_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_304_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_304_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_304_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_305_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_305_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_305_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_305_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_305_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_306_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_306_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_306_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_306_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_306_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_307_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_307_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_307_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_307_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_307_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_308_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_308_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_308_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_308_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_308_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_309_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_309_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_309_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_309_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_309_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_30_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_30_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_30_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_30_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_30_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_310_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_310_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_310_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_310_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_310_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_311_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_311_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_311_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_311_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_311_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_312_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_312_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_312_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_312_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_312_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_313_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_313_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_313_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_313_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_313_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_314_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_314_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_314_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_314_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_314_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_315_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_315_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_315_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_315_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_315_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_316_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_316_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_316_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_316_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_316_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_317_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_317_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_317_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_317_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_317_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_318_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_318_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_318_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_318_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_318_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_319_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_319_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_319_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_319_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_319_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_31_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_31_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_31_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_31_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_31_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_320_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_320_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_320_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_320_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_320_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_321_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_321_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_321_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_321_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_321_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_322_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_322_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_322_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_322_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_322_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_323_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_323_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_323_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_323_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_323_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_324_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_324_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_324_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_324_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_324_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_325_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_325_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_325_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_325_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_325_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_326_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_326_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_326_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_326_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_326_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_327_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_327_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_327_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_327_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_327_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_328_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_328_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_328_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_328_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_328_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_329_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_329_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_329_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_329_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_329_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_32_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_32_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_32_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_32_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_32_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_330_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_330_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_330_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_330_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_330_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_331_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_331_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_331_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_331_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_331_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_332_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_332_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_332_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_332_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_332_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_333_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_333_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_333_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_333_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_333_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_334_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_334_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_334_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_334_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_334_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_335_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_335_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_335_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_335_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_335_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_336_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_336_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_336_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_336_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_336_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_337_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_337_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_337_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_337_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_337_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_338_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_338_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_338_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_338_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_338_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_339_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_339_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_339_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_339_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_339_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_33_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_33_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_33_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_33_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_33_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_340_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_340_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_340_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_340_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_340_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_341_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_341_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_341_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_341_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_341_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_342_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_342_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_342_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_342_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_342_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_343_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_343_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_343_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_343_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_343_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_344_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_344_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_344_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_344_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_344_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_345_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_345_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_345_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_345_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_345_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_346_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_346_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_346_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_346_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_346_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_347_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_347_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_347_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_347_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_347_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_348_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_348_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_348_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_348_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_348_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_349_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_349_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_349_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_349_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_349_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_34_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_34_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_34_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_34_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_34_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_350_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_350_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_350_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_350_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_350_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_351_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_351_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_351_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_351_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_351_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_352_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_352_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_352_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_352_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_352_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_353_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_353_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_353_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_353_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_353_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_354_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_354_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_354_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_354_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_354_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_355_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_355_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_355_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_355_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_355_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_356_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_356_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_356_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_356_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_356_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_357_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_357_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_357_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_357_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_357_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_358_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_358_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_358_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_358_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_358_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_359_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_359_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_359_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_359_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_359_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_35_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_35_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_35_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_35_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_35_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_360_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_360_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_360_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_360_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_360_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_361_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_361_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_361_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_361_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_361_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_362_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_362_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_362_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_362_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_362_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_363_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_363_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_363_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_363_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_363_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_364_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_364_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_364_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_364_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_364_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_365_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_365_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_365_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_365_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_365_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_366_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_366_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_366_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_366_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_366_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_367_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_367_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_367_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_367_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_367_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_368_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_368_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_368_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_368_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_368_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_369_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_369_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_369_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_369_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_369_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_36_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_36_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_36_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_36_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_36_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_370_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_370_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_370_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_370_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_370_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_371_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_371_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_371_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_371_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_371_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_372_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_372_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_372_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_372_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_372_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_373_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_373_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_373_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_373_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_373_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_374_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_374_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_374_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_374_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_374_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_375_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_375_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_375_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_375_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_375_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_376_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_376_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_376_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_376_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_376_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_37_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_37_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_37_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_37_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_37_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_38_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_38_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_38_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_38_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_38_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_39_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_39_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_39_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_39_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_39_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_3_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_3_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_3_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_3_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_3_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_40_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_40_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_40_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_40_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_40_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_41_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_41_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_41_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_41_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_41_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_42_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_42_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_42_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_42_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_42_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_43_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_43_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_43_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_43_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_43_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_44_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_44_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_44_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_44_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_44_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_45_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_45_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_45_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_45_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_45_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_46_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_46_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_46_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_46_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_46_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_47_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_47_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_47_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_47_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_47_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_48_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_48_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_48_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_48_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_48_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_49_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_49_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_49_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_49_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_49_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_4_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_4_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_4_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_4_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_4_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_50_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_50_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_50_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_50_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_50_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_51_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_51_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_51_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_51_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_51_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_52_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_52_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_52_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_52_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_52_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_53_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_53_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_53_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_53_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_53_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_54_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_54_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_54_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_54_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_54_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_55_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_55_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_55_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_55_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_55_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_56_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_56_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_56_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_56_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_56_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_57_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_57_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_57_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_57_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_57_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_58_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_58_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_58_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_58_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_58_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_59_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_59_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_59_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_59_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_59_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_5_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_5_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_5_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_5_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_5_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_60_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_60_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_60_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_60_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_60_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_61_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_61_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_61_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_61_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_61_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_62_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_62_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_62_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_62_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_62_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_63_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_63_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_63_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_63_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_63_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_64_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_64_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_64_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_64_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_64_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_65_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_65_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_65_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_65_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_65_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_66_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_66_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_66_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_66_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_66_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_67_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_67_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_67_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_67_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_67_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_68_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_68_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_68_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_68_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_68_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_69_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_69_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_69_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_69_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_69_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_6_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_6_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_6_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_6_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_6_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_70_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_70_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_70_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_70_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_70_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_71_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_71_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_71_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_71_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_71_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_72_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_72_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_72_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_72_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_72_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_73_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_73_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_73_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_73_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_73_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_74_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_74_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_74_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_74_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_74_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_75_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_75_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_75_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_75_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_75_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_76_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_76_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_76_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_76_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_76_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_77_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_77_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_77_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_77_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_77_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_78_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_78_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_78_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_78_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_78_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_79_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_79_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_79_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_79_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_79_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_7_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_7_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_7_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_7_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_7_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_80_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_80_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_80_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_80_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_80_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_81_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_81_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_81_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_81_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_81_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_82_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_82_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_82_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_82_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_82_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_83_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_83_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_83_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_83_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_83_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_84_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_84_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_84_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_84_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_84_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_85_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_85_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_85_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_85_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_85_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_86_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_86_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_86_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_86_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_86_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_87_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_87_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_87_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_87_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_87_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_88_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_88_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_88_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_88_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_88_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_89_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_89_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_89_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_89_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_89_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_8_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_8_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_8_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_8_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_8_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_90_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_90_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_90_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_90_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_90_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_91_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_91_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_91_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_91_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_91_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_92_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_92_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_92_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_92_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_92_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_93_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_93_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_93_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_93_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_93_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_94_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_94_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_94_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_94_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_94_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_95_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_95_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_95_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_95_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_95_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_96_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_96_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_96_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_96_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_96_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_97_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_97_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_97_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_97_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_97_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_98_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_98_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_98_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_98_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_98_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_99_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_99_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_99_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_99_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_99_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_1_9_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_9_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_9_chunk USING btree ("time" DESC);


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

CREATE UNIQUE INDEX _hyper_1_9_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_9_chunk USING btree ("time", country, production_type, process_type);


--
-- Name: _hyper_2_377_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_377_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_377_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_377_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_377_chunk_unique ON _timescaledb_internal._hyper_2_377_chunk USING btree ("time", country);


--
-- Name: _hyper_2_378_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_378_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_378_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_378_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_378_chunk_unique ON _timescaledb_internal._hyper_2_378_chunk USING btree ("time", country);


--
-- Name: _hyper_2_379_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_379_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_379_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_379_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_379_chunk_unique ON _timescaledb_internal._hyper_2_379_chunk USING btree ("time", country);


--
-- Name: _hyper_2_380_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_380_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_380_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_380_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_380_chunk_unique ON _timescaledb_internal._hyper_2_380_chunk USING btree ("time", country);


--
-- Name: _hyper_2_381_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_381_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_381_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_381_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_381_chunk_unique ON _timescaledb_internal._hyper_2_381_chunk USING btree ("time", country);


--
-- Name: _hyper_2_382_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_382_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_382_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_382_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_382_chunk_unique ON _timescaledb_internal._hyper_2_382_chunk USING btree ("time", country);


--
-- Name: _hyper_2_383_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_383_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_383_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_383_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_383_chunk_unique ON _timescaledb_internal._hyper_2_383_chunk USING btree ("time", country);


--
-- Name: _hyper_2_384_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_384_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_384_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_384_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_384_chunk_unique ON _timescaledb_internal._hyper_2_384_chunk USING btree ("time", country);


--
-- Name: _hyper_2_385_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_385_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_385_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_385_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_385_chunk_unique ON _timescaledb_internal._hyper_2_385_chunk USING btree ("time", country);


--
-- Name: _hyper_2_386_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_386_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_386_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_386_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_386_chunk_unique ON _timescaledb_internal._hyper_2_386_chunk USING btree ("time", country);


--
-- Name: _hyper_2_387_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_387_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_387_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_387_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_387_chunk_unique ON _timescaledb_internal._hyper_2_387_chunk USING btree ("time", country);


--
-- Name: _hyper_2_388_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_388_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_388_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_388_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_388_chunk_unique ON _timescaledb_internal._hyper_2_388_chunk USING btree ("time", country);


--
-- Name: _hyper_2_389_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_389_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_389_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_389_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_389_chunk_unique ON _timescaledb_internal._hyper_2_389_chunk USING btree ("time", country);


--
-- Name: _hyper_2_390_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_390_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_390_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_390_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_390_chunk_unique ON _timescaledb_internal._hyper_2_390_chunk USING btree ("time", country);


--
-- Name: _hyper_2_391_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_391_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_391_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_391_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_391_chunk_unique ON _timescaledb_internal._hyper_2_391_chunk USING btree ("time", country);


--
-- Name: _hyper_2_392_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_392_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_392_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_392_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_392_chunk_unique ON _timescaledb_internal._hyper_2_392_chunk USING btree ("time", country);


--
-- Name: _hyper_2_393_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_393_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_393_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_393_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_393_chunk_unique ON _timescaledb_internal._hyper_2_393_chunk USING btree ("time", country);


--
-- Name: _hyper_2_394_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_394_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_394_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_394_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_394_chunk_unique ON _timescaledb_internal._hyper_2_394_chunk USING btree ("time", country);


--
-- Name: _hyper_2_395_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_395_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_395_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_395_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_395_chunk_unique ON _timescaledb_internal._hyper_2_395_chunk USING btree ("time", country);


--
-- Name: _hyper_2_396_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_396_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_396_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_396_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_396_chunk_unique ON _timescaledb_internal._hyper_2_396_chunk USING btree ("time", country);


--
-- Name: _hyper_2_397_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_397_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_397_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_397_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_397_chunk_unique ON _timescaledb_internal._hyper_2_397_chunk USING btree ("time", country);


--
-- Name: _hyper_2_398_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_398_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_398_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_398_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_398_chunk_unique ON _timescaledb_internal._hyper_2_398_chunk USING btree ("time", country);


--
-- Name: _hyper_2_399_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_399_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_399_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_399_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_399_chunk_unique ON _timescaledb_internal._hyper_2_399_chunk USING btree ("time", country);


--
-- Name: _hyper_2_400_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_400_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_400_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_400_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_400_chunk_unique ON _timescaledb_internal._hyper_2_400_chunk USING btree ("time", country);


--
-- Name: _hyper_2_401_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_401_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_401_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_401_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_401_chunk_unique ON _timescaledb_internal._hyper_2_401_chunk USING btree ("time", country);


--
-- Name: _hyper_2_402_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_402_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_402_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_402_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_402_chunk_unique ON _timescaledb_internal._hyper_2_402_chunk USING btree ("time", country);


--
-- Name: _hyper_2_403_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_403_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_403_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_403_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_403_chunk_unique ON _timescaledb_internal._hyper_2_403_chunk USING btree ("time", country);


--
-- Name: _hyper_2_404_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_404_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_404_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_404_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_404_chunk_unique ON _timescaledb_internal._hyper_2_404_chunk USING btree ("time", country);


--
-- Name: _hyper_2_405_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_405_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_405_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_405_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_405_chunk_unique ON _timescaledb_internal._hyper_2_405_chunk USING btree ("time", country);


--
-- Name: _hyper_2_406_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_406_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_406_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_406_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_406_chunk_unique ON _timescaledb_internal._hyper_2_406_chunk USING btree ("time", country);


--
-- Name: _hyper_2_407_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_407_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_407_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_407_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_407_chunk_unique ON _timescaledb_internal._hyper_2_407_chunk USING btree ("time", country);


--
-- Name: _hyper_2_408_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_408_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_408_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_408_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_408_chunk_unique ON _timescaledb_internal._hyper_2_408_chunk USING btree ("time", country);


--
-- Name: _hyper_2_409_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_409_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_409_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_409_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_409_chunk_unique ON _timescaledb_internal._hyper_2_409_chunk USING btree ("time", country);


--
-- Name: _hyper_2_410_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_410_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_410_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_410_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_410_chunk_unique ON _timescaledb_internal._hyper_2_410_chunk USING btree ("time", country);


--
-- Name: _hyper_2_411_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_411_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_411_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_411_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_411_chunk_unique ON _timescaledb_internal._hyper_2_411_chunk USING btree ("time", country);


--
-- Name: _hyper_2_412_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_412_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_412_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_412_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_412_chunk_unique ON _timescaledb_internal._hyper_2_412_chunk USING btree ("time", country);


--
-- Name: _hyper_2_413_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_413_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_413_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_413_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_413_chunk_unique ON _timescaledb_internal._hyper_2_413_chunk USING btree ("time", country);


--
-- Name: _hyper_2_414_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_414_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_414_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_414_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_414_chunk_unique ON _timescaledb_internal._hyper_2_414_chunk USING btree ("time", country);


--
-- Name: _hyper_2_415_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_415_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_415_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_415_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_415_chunk_unique ON _timescaledb_internal._hyper_2_415_chunk USING btree ("time", country);


--
-- Name: _hyper_2_416_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_416_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_416_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_416_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_416_chunk_unique ON _timescaledb_internal._hyper_2_416_chunk USING btree ("time", country);


--
-- Name: _hyper_2_417_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_417_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_417_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_417_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_417_chunk_unique ON _timescaledb_internal._hyper_2_417_chunk USING btree ("time", country);


--
-- Name: _hyper_2_418_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_418_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_418_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_418_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_418_chunk_unique ON _timescaledb_internal._hyper_2_418_chunk USING btree ("time", country);


--
-- Name: _hyper_2_419_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_419_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_419_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_419_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_419_chunk_unique ON _timescaledb_internal._hyper_2_419_chunk USING btree ("time", country);


--
-- Name: _hyper_2_420_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_420_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_420_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_420_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_420_chunk_unique ON _timescaledb_internal._hyper_2_420_chunk USING btree ("time", country);


--
-- Name: _hyper_2_421_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_421_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_421_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_421_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_421_chunk_unique ON _timescaledb_internal._hyper_2_421_chunk USING btree ("time", country);


--
-- Name: _hyper_2_422_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_422_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_422_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_422_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_422_chunk_unique ON _timescaledb_internal._hyper_2_422_chunk USING btree ("time", country);


--
-- Name: _hyper_2_423_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_423_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_423_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_423_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_423_chunk_unique ON _timescaledb_internal._hyper_2_423_chunk USING btree ("time", country);


--
-- Name: _hyper_2_424_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_424_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_424_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_424_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_424_chunk_unique ON _timescaledb_internal._hyper_2_424_chunk USING btree ("time", country);


--
-- Name: _hyper_2_425_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_425_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_425_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_425_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_425_chunk_unique ON _timescaledb_internal._hyper_2_425_chunk USING btree ("time", country);


--
-- Name: _hyper_2_426_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_426_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_426_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_426_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_426_chunk_unique ON _timescaledb_internal._hyper_2_426_chunk USING btree ("time", country);


--
-- Name: _hyper_2_427_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_427_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_427_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_427_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_427_chunk_unique ON _timescaledb_internal._hyper_2_427_chunk USING btree ("time", country);


--
-- Name: _hyper_2_428_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_428_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_428_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_428_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_428_chunk_unique ON _timescaledb_internal._hyper_2_428_chunk USING btree ("time", country);


--
-- Name: _hyper_2_429_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_429_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_429_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_429_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_429_chunk_unique ON _timescaledb_internal._hyper_2_429_chunk USING btree ("time", country);


--
-- Name: _hyper_2_430_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_430_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_430_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_430_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_430_chunk_unique ON _timescaledb_internal._hyper_2_430_chunk USING btree ("time", country);


--
-- Name: _hyper_2_431_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_431_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_431_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_431_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_431_chunk_unique ON _timescaledb_internal._hyper_2_431_chunk USING btree ("time", country);


--
-- Name: _hyper_2_432_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_432_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_432_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_432_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_432_chunk_unique ON _timescaledb_internal._hyper_2_432_chunk USING btree ("time", country);


--
-- Name: _hyper_2_433_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_433_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_433_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_433_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_433_chunk_unique ON _timescaledb_internal._hyper_2_433_chunk USING btree ("time", country);


--
-- Name: _hyper_2_434_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_434_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_434_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_434_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_434_chunk_unique ON _timescaledb_internal._hyper_2_434_chunk USING btree ("time", country);


--
-- Name: _hyper_2_435_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_435_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_435_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_435_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_435_chunk_unique ON _timescaledb_internal._hyper_2_435_chunk USING btree ("time", country);


--
-- Name: _hyper_2_436_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_436_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_436_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_436_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_436_chunk_unique ON _timescaledb_internal._hyper_2_436_chunk USING btree ("time", country);


--
-- Name: _hyper_2_437_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_437_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_437_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_437_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_437_chunk_unique ON _timescaledb_internal._hyper_2_437_chunk USING btree ("time", country);


--
-- Name: _hyper_2_438_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_438_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_438_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_438_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_438_chunk_unique ON _timescaledb_internal._hyper_2_438_chunk USING btree ("time", country);


--
-- Name: _hyper_2_439_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_439_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_439_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_439_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_439_chunk_unique ON _timescaledb_internal._hyper_2_439_chunk USING btree ("time", country);


--
-- Name: _hyper_2_440_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_440_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_440_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_440_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_440_chunk_unique ON _timescaledb_internal._hyper_2_440_chunk USING btree ("time", country);


--
-- Name: _hyper_2_441_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_441_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_441_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_441_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_441_chunk_unique ON _timescaledb_internal._hyper_2_441_chunk USING btree ("time", country);


--
-- Name: _hyper_2_442_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_442_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_442_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_442_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_442_chunk_unique ON _timescaledb_internal._hyper_2_442_chunk USING btree ("time", country);


--
-- Name: _hyper_2_443_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_443_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_443_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_443_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_443_chunk_unique ON _timescaledb_internal._hyper_2_443_chunk USING btree ("time", country);


--
-- Name: _hyper_2_444_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_444_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_444_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_444_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_444_chunk_unique ON _timescaledb_internal._hyper_2_444_chunk USING btree ("time", country);


--
-- Name: _hyper_2_445_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_445_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_445_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_445_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_445_chunk_unique ON _timescaledb_internal._hyper_2_445_chunk USING btree ("time", country);


--
-- Name: _hyper_2_446_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_446_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_446_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_446_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_446_chunk_unique ON _timescaledb_internal._hyper_2_446_chunk USING btree ("time", country);


--
-- Name: _hyper_2_447_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_447_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_447_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_447_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_447_chunk_unique ON _timescaledb_internal._hyper_2_447_chunk USING btree ("time", country);


--
-- Name: _hyper_2_448_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_448_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_448_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_448_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_448_chunk_unique ON _timescaledb_internal._hyper_2_448_chunk USING btree ("time", country);


--
-- Name: _hyper_2_449_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_449_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_449_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_449_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_449_chunk_unique ON _timescaledb_internal._hyper_2_449_chunk USING btree ("time", country);


--
-- Name: _hyper_2_450_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_450_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_450_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_450_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_450_chunk_unique ON _timescaledb_internal._hyper_2_450_chunk USING btree ("time", country);


--
-- Name: _hyper_2_451_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_451_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_451_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_451_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_451_chunk_unique ON _timescaledb_internal._hyper_2_451_chunk USING btree ("time", country);


--
-- Name: _hyper_2_452_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_452_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_452_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_452_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_452_chunk_unique ON _timescaledb_internal._hyper_2_452_chunk USING btree ("time", country);


--
-- Name: _hyper_2_453_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_453_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_453_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_453_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_453_chunk_unique ON _timescaledb_internal._hyper_2_453_chunk USING btree ("time", country);


--
-- Name: _hyper_2_454_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_454_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_454_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_454_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_454_chunk_unique ON _timescaledb_internal._hyper_2_454_chunk USING btree ("time", country);


--
-- Name: _hyper_2_455_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_455_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_455_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_455_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_455_chunk_unique ON _timescaledb_internal._hyper_2_455_chunk USING btree ("time", country);


--
-- Name: _hyper_2_456_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_456_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_456_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_456_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_456_chunk_unique ON _timescaledb_internal._hyper_2_456_chunk USING btree ("time", country);


--
-- Name: _hyper_2_457_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_457_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_457_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_457_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_457_chunk_unique ON _timescaledb_internal._hyper_2_457_chunk USING btree ("time", country);


--
-- Name: _hyper_2_458_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_458_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_458_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_458_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_458_chunk_unique ON _timescaledb_internal._hyper_2_458_chunk USING btree ("time", country);


--
-- Name: _hyper_2_459_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_459_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_459_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_459_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_459_chunk_unique ON _timescaledb_internal._hyper_2_459_chunk USING btree ("time", country);


--
-- Name: _hyper_2_460_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_460_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_460_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_460_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_460_chunk_unique ON _timescaledb_internal._hyper_2_460_chunk USING btree ("time", country);


--
-- Name: _hyper_2_461_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_461_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_461_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_461_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_461_chunk_unique ON _timescaledb_internal._hyper_2_461_chunk USING btree ("time", country);


--
-- Name: _hyper_2_462_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_462_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_462_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_462_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_462_chunk_unique ON _timescaledb_internal._hyper_2_462_chunk USING btree ("time", country);


--
-- Name: _hyper_2_463_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_463_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_463_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_463_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_463_chunk_unique ON _timescaledb_internal._hyper_2_463_chunk USING btree ("time", country);


--
-- Name: _hyper_2_464_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_464_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_464_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_464_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_464_chunk_unique ON _timescaledb_internal._hyper_2_464_chunk USING btree ("time", country);


--
-- Name: _hyper_2_465_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_465_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_465_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_465_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_465_chunk_unique ON _timescaledb_internal._hyper_2_465_chunk USING btree ("time", country);


--
-- Name: _hyper_2_466_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_466_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_466_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_466_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_466_chunk_unique ON _timescaledb_internal._hyper_2_466_chunk USING btree ("time", country);


--
-- Name: _hyper_2_467_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_467_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_467_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_467_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_467_chunk_unique ON _timescaledb_internal._hyper_2_467_chunk USING btree ("time", country);


--
-- Name: _hyper_2_468_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_468_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_468_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_468_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_468_chunk_unique ON _timescaledb_internal._hyper_2_468_chunk USING btree ("time", country);


--
-- Name: _hyper_2_469_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_469_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_469_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_469_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_469_chunk_unique ON _timescaledb_internal._hyper_2_469_chunk USING btree ("time", country);


--
-- Name: _hyper_2_470_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_470_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_470_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_470_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_470_chunk_unique ON _timescaledb_internal._hyper_2_470_chunk USING btree ("time", country);


--
-- Name: _hyper_2_471_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_471_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_471_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_471_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_471_chunk_unique ON _timescaledb_internal._hyper_2_471_chunk USING btree ("time", country);


--
-- Name: _hyper_2_472_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_472_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_472_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_472_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_472_chunk_unique ON _timescaledb_internal._hyper_2_472_chunk USING btree ("time", country);


--
-- Name: _hyper_2_473_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_473_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_473_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_473_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_473_chunk_unique ON _timescaledb_internal._hyper_2_473_chunk USING btree ("time", country);


--
-- Name: _hyper_2_474_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_474_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_474_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_474_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_474_chunk_unique ON _timescaledb_internal._hyper_2_474_chunk USING btree ("time", country);


--
-- Name: _hyper_2_475_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_475_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_475_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_475_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_475_chunk_unique ON _timescaledb_internal._hyper_2_475_chunk USING btree ("time", country);


--
-- Name: _hyper_2_476_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_476_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_476_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_476_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_476_chunk_unique ON _timescaledb_internal._hyper_2_476_chunk USING btree ("time", country);


--
-- Name: _hyper_2_477_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_477_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_477_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_477_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_477_chunk_unique ON _timescaledb_internal._hyper_2_477_chunk USING btree ("time", country);


--
-- Name: _hyper_2_478_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_478_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_478_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_478_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_478_chunk_unique ON _timescaledb_internal._hyper_2_478_chunk USING btree ("time", country);


--
-- Name: _hyper_2_479_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_479_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_479_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_479_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_479_chunk_unique ON _timescaledb_internal._hyper_2_479_chunk USING btree ("time", country);


--
-- Name: _hyper_2_480_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_480_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_480_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_480_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_480_chunk_unique ON _timescaledb_internal._hyper_2_480_chunk USING btree ("time", country);


--
-- Name: _hyper_2_481_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_481_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_481_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_481_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_481_chunk_unique ON _timescaledb_internal._hyper_2_481_chunk USING btree ("time", country);


--
-- Name: _hyper_2_482_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_482_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_482_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_482_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_482_chunk_unique ON _timescaledb_internal._hyper_2_482_chunk USING btree ("time", country);


--
-- Name: _hyper_2_483_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_483_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_483_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_483_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_483_chunk_unique ON _timescaledb_internal._hyper_2_483_chunk USING btree ("time", country);


--
-- Name: _hyper_2_484_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_484_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_484_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_484_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_484_chunk_unique ON _timescaledb_internal._hyper_2_484_chunk USING btree ("time", country);


--
-- Name: _hyper_2_485_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_485_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_485_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_485_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_485_chunk_unique ON _timescaledb_internal._hyper_2_485_chunk USING btree ("time", country);


--
-- Name: _hyper_2_486_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_486_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_486_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_486_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_486_chunk_unique ON _timescaledb_internal._hyper_2_486_chunk USING btree ("time", country);


--
-- Name: _hyper_2_487_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_487_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_487_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_487_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_487_chunk_unique ON _timescaledb_internal._hyper_2_487_chunk USING btree ("time", country);


--
-- Name: _hyper_2_488_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_488_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_488_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_488_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_488_chunk_unique ON _timescaledb_internal._hyper_2_488_chunk USING btree ("time", country);


--
-- Name: _hyper_2_489_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_489_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_489_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_489_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_489_chunk_unique ON _timescaledb_internal._hyper_2_489_chunk USING btree ("time", country);


--
-- Name: _hyper_2_490_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_490_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_490_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_490_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_490_chunk_unique ON _timescaledb_internal._hyper_2_490_chunk USING btree ("time", country);


--
-- Name: _hyper_2_491_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_491_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_491_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_491_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_491_chunk_unique ON _timescaledb_internal._hyper_2_491_chunk USING btree ("time", country);


--
-- Name: _hyper_2_492_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_492_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_492_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_492_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_492_chunk_unique ON _timescaledb_internal._hyper_2_492_chunk USING btree ("time", country);


--
-- Name: _hyper_2_493_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_493_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_493_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_493_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_493_chunk_unique ON _timescaledb_internal._hyper_2_493_chunk USING btree ("time", country);


--
-- Name: _hyper_2_494_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_494_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_494_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_494_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_494_chunk_unique ON _timescaledb_internal._hyper_2_494_chunk USING btree ("time", country);


--
-- Name: _hyper_2_495_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_495_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_495_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_495_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_495_chunk_unique ON _timescaledb_internal._hyper_2_495_chunk USING btree ("time", country);


--
-- Name: _hyper_2_496_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_496_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_496_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_496_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_496_chunk_unique ON _timescaledb_internal._hyper_2_496_chunk USING btree ("time", country);


--
-- Name: _hyper_2_497_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_497_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_497_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_497_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_497_chunk_unique ON _timescaledb_internal._hyper_2_497_chunk USING btree ("time", country);


--
-- Name: _hyper_2_498_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_498_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_498_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_498_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_498_chunk_unique ON _timescaledb_internal._hyper_2_498_chunk USING btree ("time", country);


--
-- Name: _hyper_2_499_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_499_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_499_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_499_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_499_chunk_unique ON _timescaledb_internal._hyper_2_499_chunk USING btree ("time", country);


--
-- Name: _hyper_2_500_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_500_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_500_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_500_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_500_chunk_unique ON _timescaledb_internal._hyper_2_500_chunk USING btree ("time", country);


--
-- Name: _hyper_2_501_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_501_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_501_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_501_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_501_chunk_unique ON _timescaledb_internal._hyper_2_501_chunk USING btree ("time", country);


--
-- Name: _hyper_2_502_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_502_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_502_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_502_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_502_chunk_unique ON _timescaledb_internal._hyper_2_502_chunk USING btree ("time", country);


--
-- Name: _hyper_2_503_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_503_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_503_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_503_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_503_chunk_unique ON _timescaledb_internal._hyper_2_503_chunk USING btree ("time", country);


--
-- Name: _hyper_2_504_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_504_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_504_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_504_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_504_chunk_unique ON _timescaledb_internal._hyper_2_504_chunk USING btree ("time", country);


--
-- Name: _hyper_2_505_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_505_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_505_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_505_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_505_chunk_unique ON _timescaledb_internal._hyper_2_505_chunk USING btree ("time", country);


--
-- Name: _hyper_2_506_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_506_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_506_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_506_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_506_chunk_unique ON _timescaledb_internal._hyper_2_506_chunk USING btree ("time", country);


--
-- Name: _hyper_2_507_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_507_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_507_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_507_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_507_chunk_unique ON _timescaledb_internal._hyper_2_507_chunk USING btree ("time", country);


--
-- Name: _hyper_2_508_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_508_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_508_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_508_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_508_chunk_unique ON _timescaledb_internal._hyper_2_508_chunk USING btree ("time", country);


--
-- Name: _hyper_2_509_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_509_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_509_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_509_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_509_chunk_unique ON _timescaledb_internal._hyper_2_509_chunk USING btree ("time", country);


--
-- Name: _hyper_2_510_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_510_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_510_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_510_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_510_chunk_unique ON _timescaledb_internal._hyper_2_510_chunk USING btree ("time", country);


--
-- Name: _hyper_2_511_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_511_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_511_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_511_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_511_chunk_unique ON _timescaledb_internal._hyper_2_511_chunk USING btree ("time", country);


--
-- Name: _hyper_2_512_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_512_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_512_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_512_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_512_chunk_unique ON _timescaledb_internal._hyper_2_512_chunk USING btree ("time", country);


--
-- Name: _hyper_2_513_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_513_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_513_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_513_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_513_chunk_unique ON _timescaledb_internal._hyper_2_513_chunk USING btree ("time", country);


--
-- Name: _hyper_2_514_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_514_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_514_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_514_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_514_chunk_unique ON _timescaledb_internal._hyper_2_514_chunk USING btree ("time", country);


--
-- Name: _hyper_2_515_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_515_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_515_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_515_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_515_chunk_unique ON _timescaledb_internal._hyper_2_515_chunk USING btree ("time", country);


--
-- Name: _hyper_2_516_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_516_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_516_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_516_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_516_chunk_unique ON _timescaledb_internal._hyper_2_516_chunk USING btree ("time", country);


--
-- Name: _hyper_2_517_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_517_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_517_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_517_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_517_chunk_unique ON _timescaledb_internal._hyper_2_517_chunk USING btree ("time", country);


--
-- Name: _hyper_2_518_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_518_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_518_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_518_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_518_chunk_unique ON _timescaledb_internal._hyper_2_518_chunk USING btree ("time", country);


--
-- Name: _hyper_2_519_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_519_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_519_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_519_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_519_chunk_unique ON _timescaledb_internal._hyper_2_519_chunk USING btree ("time", country);


--
-- Name: _hyper_2_520_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_520_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_520_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_520_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_520_chunk_unique ON _timescaledb_internal._hyper_2_520_chunk USING btree ("time", country);


--
-- Name: _hyper_2_521_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_521_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_521_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_521_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_521_chunk_unique ON _timescaledb_internal._hyper_2_521_chunk USING btree ("time", country);


--
-- Name: _hyper_2_522_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_522_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_522_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_522_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_522_chunk_unique ON _timescaledb_internal._hyper_2_522_chunk USING btree ("time", country);


--
-- Name: _hyper_2_523_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_523_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_523_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_523_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_523_chunk_unique ON _timescaledb_internal._hyper_2_523_chunk USING btree ("time", country);


--
-- Name: _hyper_2_524_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_524_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_524_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_524_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_524_chunk_unique ON _timescaledb_internal._hyper_2_524_chunk USING btree ("time", country);


--
-- Name: _hyper_2_525_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_525_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_525_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_525_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_525_chunk_unique ON _timescaledb_internal._hyper_2_525_chunk USING btree ("time", country);


--
-- Name: _hyper_2_526_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_526_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_526_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_526_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_526_chunk_unique ON _timescaledb_internal._hyper_2_526_chunk USING btree ("time", country);


--
-- Name: _hyper_2_527_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_527_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_527_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_527_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_527_chunk_unique ON _timescaledb_internal._hyper_2_527_chunk USING btree ("time", country);


--
-- Name: _hyper_2_528_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_528_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_528_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_528_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_528_chunk_unique ON _timescaledb_internal._hyper_2_528_chunk USING btree ("time", country);


--
-- Name: _hyper_2_529_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_529_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_529_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_529_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_529_chunk_unique ON _timescaledb_internal._hyper_2_529_chunk USING btree ("time", country);


--
-- Name: _hyper_2_530_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_530_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_530_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_530_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_530_chunk_unique ON _timescaledb_internal._hyper_2_530_chunk USING btree ("time", country);


--
-- Name: _hyper_2_531_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_531_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_531_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_531_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_531_chunk_unique ON _timescaledb_internal._hyper_2_531_chunk USING btree ("time", country);


--
-- Name: _hyper_2_532_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_532_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_532_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_532_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_532_chunk_unique ON _timescaledb_internal._hyper_2_532_chunk USING btree ("time", country);


--
-- Name: _hyper_2_533_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_533_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_533_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_533_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_533_chunk_unique ON _timescaledb_internal._hyper_2_533_chunk USING btree ("time", country);


--
-- Name: _hyper_2_534_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_534_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_534_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_534_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_534_chunk_unique ON _timescaledb_internal._hyper_2_534_chunk USING btree ("time", country);


--
-- Name: _hyper_2_535_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_535_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_535_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_535_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_535_chunk_unique ON _timescaledb_internal._hyper_2_535_chunk USING btree ("time", country);


--
-- Name: _hyper_2_536_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_536_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_536_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_536_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_536_chunk_unique ON _timescaledb_internal._hyper_2_536_chunk USING btree ("time", country);


--
-- Name: _hyper_2_537_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_537_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_537_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_537_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_537_chunk_unique ON _timescaledb_internal._hyper_2_537_chunk USING btree ("time", country);


--
-- Name: _hyper_2_538_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_538_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_538_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_538_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_538_chunk_unique ON _timescaledb_internal._hyper_2_538_chunk USING btree ("time", country);


--
-- Name: _hyper_2_539_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_539_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_539_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_539_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_539_chunk_unique ON _timescaledb_internal._hyper_2_539_chunk USING btree ("time", country);


--
-- Name: _hyper_2_540_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_540_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_540_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_540_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_540_chunk_unique ON _timescaledb_internal._hyper_2_540_chunk USING btree ("time", country);


--
-- Name: _hyper_2_541_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_541_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_541_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_541_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_541_chunk_unique ON _timescaledb_internal._hyper_2_541_chunk USING btree ("time", country);


--
-- Name: _hyper_2_542_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_542_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_542_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_542_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_542_chunk_unique ON _timescaledb_internal._hyper_2_542_chunk USING btree ("time", country);


--
-- Name: _hyper_2_543_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_543_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_543_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_543_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_543_chunk_unique ON _timescaledb_internal._hyper_2_543_chunk USING btree ("time", country);


--
-- Name: _hyper_2_544_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_544_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_544_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_544_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_544_chunk_unique ON _timescaledb_internal._hyper_2_544_chunk USING btree ("time", country);


--
-- Name: _hyper_2_545_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_545_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_545_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_545_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_545_chunk_unique ON _timescaledb_internal._hyper_2_545_chunk USING btree ("time", country);


--
-- Name: _hyper_2_546_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_546_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_546_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_546_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_546_chunk_unique ON _timescaledb_internal._hyper_2_546_chunk USING btree ("time", country);


--
-- Name: _hyper_2_547_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_547_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_547_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_547_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_547_chunk_unique ON _timescaledb_internal._hyper_2_547_chunk USING btree ("time", country);


--
-- Name: _hyper_2_548_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_548_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_548_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_548_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_548_chunk_unique ON _timescaledb_internal._hyper_2_548_chunk USING btree ("time", country);


--
-- Name: _hyper_2_549_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_549_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_549_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_549_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_549_chunk_unique ON _timescaledb_internal._hyper_2_549_chunk USING btree ("time", country);


--
-- Name: _hyper_2_550_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_550_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_550_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_550_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_550_chunk_unique ON _timescaledb_internal._hyper_2_550_chunk USING btree ("time", country);


--
-- Name: _hyper_2_551_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_551_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_551_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_551_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_551_chunk_unique ON _timescaledb_internal._hyper_2_551_chunk USING btree ("time", country);


--
-- Name: _hyper_2_552_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_552_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_552_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_552_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_552_chunk_unique ON _timescaledb_internal._hyper_2_552_chunk USING btree ("time", country);


--
-- Name: _hyper_2_553_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_553_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_553_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_553_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_553_chunk_unique ON _timescaledb_internal._hyper_2_553_chunk USING btree ("time", country);


--
-- Name: _hyper_2_554_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_554_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_554_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_554_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_554_chunk_unique ON _timescaledb_internal._hyper_2_554_chunk USING btree ("time", country);


--
-- Name: _hyper_2_555_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_555_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_555_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_555_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_555_chunk_unique ON _timescaledb_internal._hyper_2_555_chunk USING btree ("time", country);


--
-- Name: _hyper_2_556_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_556_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_556_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_556_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_556_chunk_unique ON _timescaledb_internal._hyper_2_556_chunk USING btree ("time", country);


--
-- Name: _hyper_2_557_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_557_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_557_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_557_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_557_chunk_unique ON _timescaledb_internal._hyper_2_557_chunk USING btree ("time", country);


--
-- Name: _hyper_2_558_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_558_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_558_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_558_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_558_chunk_unique ON _timescaledb_internal._hyper_2_558_chunk USING btree ("time", country);


--
-- Name: _hyper_2_559_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_559_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_559_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_559_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_559_chunk_unique ON _timescaledb_internal._hyper_2_559_chunk USING btree ("time", country);


--
-- Name: _hyper_2_560_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_560_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_560_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_560_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_560_chunk_unique ON _timescaledb_internal._hyper_2_560_chunk USING btree ("time", country);


--
-- Name: _hyper_2_561_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_561_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_561_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_561_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_561_chunk_unique ON _timescaledb_internal._hyper_2_561_chunk USING btree ("time", country);


--
-- Name: _hyper_2_562_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_562_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_562_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_562_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_562_chunk_unique ON _timescaledb_internal._hyper_2_562_chunk USING btree ("time", country);


--
-- Name: _hyper_2_563_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_563_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_563_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_563_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_563_chunk_unique ON _timescaledb_internal._hyper_2_563_chunk USING btree ("time", country);


--
-- Name: _hyper_2_564_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_564_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_564_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_564_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_564_chunk_unique ON _timescaledb_internal._hyper_2_564_chunk USING btree ("time", country);


--
-- Name: _hyper_2_565_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_565_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_565_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_565_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_565_chunk_unique ON _timescaledb_internal._hyper_2_565_chunk USING btree ("time", country);


--
-- Name: _hyper_2_566_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_566_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_566_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_566_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_566_chunk_unique ON _timescaledb_internal._hyper_2_566_chunk USING btree ("time", country);


--
-- Name: _hyper_2_567_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_567_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_567_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_567_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_567_chunk_unique ON _timescaledb_internal._hyper_2_567_chunk USING btree ("time", country);


--
-- Name: _hyper_2_568_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_568_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_568_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_568_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_568_chunk_unique ON _timescaledb_internal._hyper_2_568_chunk USING btree ("time", country);


--
-- Name: _hyper_2_569_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_569_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_569_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_569_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_569_chunk_unique ON _timescaledb_internal._hyper_2_569_chunk USING btree ("time", country);


--
-- Name: _hyper_2_570_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_570_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_570_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_570_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_570_chunk_unique ON _timescaledb_internal._hyper_2_570_chunk USING btree ("time", country);


--
-- Name: _hyper_2_571_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_571_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_571_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_571_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_571_chunk_unique ON _timescaledb_internal._hyper_2_571_chunk USING btree ("time", country);


--
-- Name: _hyper_2_572_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_572_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_572_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_572_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_572_chunk_unique ON _timescaledb_internal._hyper_2_572_chunk USING btree ("time", country);


--
-- Name: _hyper_2_573_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_573_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_573_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_573_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_573_chunk_unique ON _timescaledb_internal._hyper_2_573_chunk USING btree ("time", country);


--
-- Name: _hyper_2_574_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_574_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_574_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_574_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_574_chunk_unique ON _timescaledb_internal._hyper_2_574_chunk USING btree ("time", country);


--
-- Name: _hyper_2_575_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_575_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_575_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_575_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_575_chunk_unique ON _timescaledb_internal._hyper_2_575_chunk USING btree ("time", country);


--
-- Name: _hyper_2_576_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_576_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_576_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_576_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_576_chunk_unique ON _timescaledb_internal._hyper_2_576_chunk USING btree ("time", country);


--
-- Name: _hyper_2_577_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_577_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_577_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_577_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_577_chunk_unique ON _timescaledb_internal._hyper_2_577_chunk USING btree ("time", country);


--
-- Name: _hyper_2_578_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_578_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_578_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_578_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_578_chunk_unique ON _timescaledb_internal._hyper_2_578_chunk USING btree ("time", country);


--
-- Name: _hyper_2_579_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_579_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_579_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_579_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_579_chunk_unique ON _timescaledb_internal._hyper_2_579_chunk USING btree ("time", country);


--
-- Name: _hyper_2_580_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_580_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_580_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_580_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_580_chunk_unique ON _timescaledb_internal._hyper_2_580_chunk USING btree ("time", country);


--
-- Name: _hyper_2_581_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_581_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_581_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_581_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_581_chunk_unique ON _timescaledb_internal._hyper_2_581_chunk USING btree ("time", country);


--
-- Name: _hyper_2_582_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_582_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_582_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_582_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_582_chunk_unique ON _timescaledb_internal._hyper_2_582_chunk USING btree ("time", country);


--
-- Name: _hyper_2_583_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_583_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_583_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_583_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_583_chunk_unique ON _timescaledb_internal._hyper_2_583_chunk USING btree ("time", country);


--
-- Name: _hyper_2_584_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_584_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_584_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_584_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_584_chunk_unique ON _timescaledb_internal._hyper_2_584_chunk USING btree ("time", country);


--
-- Name: _hyper_2_585_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_585_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_585_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_585_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_585_chunk_unique ON _timescaledb_internal._hyper_2_585_chunk USING btree ("time", country);


--
-- Name: _hyper_2_586_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_586_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_586_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_586_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_586_chunk_unique ON _timescaledb_internal._hyper_2_586_chunk USING btree ("time", country);


--
-- Name: _hyper_2_587_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_587_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_587_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_587_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_587_chunk_unique ON _timescaledb_internal._hyper_2_587_chunk USING btree ("time", country);


--
-- Name: _hyper_2_588_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_588_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_588_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_588_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_588_chunk_unique ON _timescaledb_internal._hyper_2_588_chunk USING btree ("time", country);


--
-- Name: _hyper_2_589_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_589_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_589_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_589_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_589_chunk_unique ON _timescaledb_internal._hyper_2_589_chunk USING btree ("time", country);


--
-- Name: _hyper_2_590_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_590_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_590_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_590_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_590_chunk_unique ON _timescaledb_internal._hyper_2_590_chunk USING btree ("time", country);


--
-- Name: _hyper_2_591_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_591_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_591_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_591_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_591_chunk_unique ON _timescaledb_internal._hyper_2_591_chunk USING btree ("time", country);


--
-- Name: _hyper_2_592_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_592_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_592_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_592_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_592_chunk_unique ON _timescaledb_internal._hyper_2_592_chunk USING btree ("time", country);


--
-- Name: _hyper_2_593_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_593_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_593_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_593_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_593_chunk_unique ON _timescaledb_internal._hyper_2_593_chunk USING btree ("time", country);


--
-- Name: _hyper_2_594_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_594_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_594_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_594_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_594_chunk_unique ON _timescaledb_internal._hyper_2_594_chunk USING btree ("time", country);


--
-- Name: _hyper_2_595_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_595_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_595_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_595_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_595_chunk_unique ON _timescaledb_internal._hyper_2_595_chunk USING btree ("time", country);


--
-- Name: _hyper_2_596_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_596_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_596_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_596_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_596_chunk_unique ON _timescaledb_internal._hyper_2_596_chunk USING btree ("time", country);


--
-- Name: _hyper_2_597_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_597_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_597_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_597_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_597_chunk_unique ON _timescaledb_internal._hyper_2_597_chunk USING btree ("time", country);


--
-- Name: _hyper_2_598_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_598_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_598_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_598_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_598_chunk_unique ON _timescaledb_internal._hyper_2_598_chunk USING btree ("time", country);


--
-- Name: _hyper_2_599_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_599_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_599_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_599_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_599_chunk_unique ON _timescaledb_internal._hyper_2_599_chunk USING btree ("time", country);


--
-- Name: _hyper_2_600_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_600_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_600_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_600_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_600_chunk_unique ON _timescaledb_internal._hyper_2_600_chunk USING btree ("time", country);


--
-- Name: _hyper_2_601_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_601_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_601_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_601_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_601_chunk_unique ON _timescaledb_internal._hyper_2_601_chunk USING btree ("time", country);


--
-- Name: _hyper_2_602_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_602_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_602_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_602_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_602_chunk_unique ON _timescaledb_internal._hyper_2_602_chunk USING btree ("time", country);


--
-- Name: _hyper_2_603_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_603_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_603_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_603_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_603_chunk_unique ON _timescaledb_internal._hyper_2_603_chunk USING btree ("time", country);


--
-- Name: _hyper_2_604_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_604_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_604_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_604_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_604_chunk_unique ON _timescaledb_internal._hyper_2_604_chunk USING btree ("time", country);


--
-- Name: _hyper_2_605_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_605_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_605_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_605_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_605_chunk_unique ON _timescaledb_internal._hyper_2_605_chunk USING btree ("time", country);


--
-- Name: _hyper_2_606_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_606_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_606_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_606_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_606_chunk_unique ON _timescaledb_internal._hyper_2_606_chunk USING btree ("time", country);


--
-- Name: _hyper_2_607_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_607_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_607_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_607_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_607_chunk_unique ON _timescaledb_internal._hyper_2_607_chunk USING btree ("time", country);


--
-- Name: _hyper_2_608_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_608_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_608_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_608_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_608_chunk_unique ON _timescaledb_internal._hyper_2_608_chunk USING btree ("time", country);


--
-- Name: _hyper_2_609_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_609_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_609_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_609_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_609_chunk_unique ON _timescaledb_internal._hyper_2_609_chunk USING btree ("time", country);


--
-- Name: _hyper_2_610_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_610_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_610_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_610_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_610_chunk_unique ON _timescaledb_internal._hyper_2_610_chunk USING btree ("time", country);


--
-- Name: _hyper_2_611_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_611_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_611_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_611_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_611_chunk_unique ON _timescaledb_internal._hyper_2_611_chunk USING btree ("time", country);


--
-- Name: _hyper_2_612_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_612_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_612_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_612_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_612_chunk_unique ON _timescaledb_internal._hyper_2_612_chunk USING btree ("time", country);


--
-- Name: _hyper_2_613_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_613_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_613_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_613_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_613_chunk_unique ON _timescaledb_internal._hyper_2_613_chunk USING btree ("time", country);


--
-- Name: _hyper_2_614_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_614_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_614_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_614_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_614_chunk_unique ON _timescaledb_internal._hyper_2_614_chunk USING btree ("time", country);


--
-- Name: _hyper_2_615_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_615_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_615_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_615_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_615_chunk_unique ON _timescaledb_internal._hyper_2_615_chunk USING btree ("time", country);


--
-- Name: _hyper_2_616_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_616_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_616_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_616_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_616_chunk_unique ON _timescaledb_internal._hyper_2_616_chunk USING btree ("time", country);


--
-- Name: _hyper_2_617_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_617_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_617_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_617_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_617_chunk_unique ON _timescaledb_internal._hyper_2_617_chunk USING btree ("time", country);


--
-- Name: _hyper_2_618_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_618_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_618_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_618_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_618_chunk_unique ON _timescaledb_internal._hyper_2_618_chunk USING btree ("time", country);


--
-- Name: _hyper_2_619_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_619_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_619_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_619_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_619_chunk_unique ON _timescaledb_internal._hyper_2_619_chunk USING btree ("time", country);


--
-- Name: _hyper_2_620_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_620_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_620_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_620_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_620_chunk_unique ON _timescaledb_internal._hyper_2_620_chunk USING btree ("time", country);


--
-- Name: _hyper_2_621_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_621_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_621_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_621_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_621_chunk_unique ON _timescaledb_internal._hyper_2_621_chunk USING btree ("time", country);


--
-- Name: _hyper_2_622_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_622_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_622_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_622_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_622_chunk_unique ON _timescaledb_internal._hyper_2_622_chunk USING btree ("time", country);


--
-- Name: _hyper_2_623_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_623_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_623_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_623_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_623_chunk_unique ON _timescaledb_internal._hyper_2_623_chunk USING btree ("time", country);


--
-- Name: _hyper_2_624_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_624_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_624_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_624_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_624_chunk_unique ON _timescaledb_internal._hyper_2_624_chunk USING btree ("time", country);


--
-- Name: _hyper_2_625_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_625_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_625_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_625_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_625_chunk_unique ON _timescaledb_internal._hyper_2_625_chunk USING btree ("time", country);


--
-- Name: _hyper_2_626_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_626_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_626_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_626_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_626_chunk_unique ON _timescaledb_internal._hyper_2_626_chunk USING btree ("time", country);


--
-- Name: _hyper_2_627_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_627_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_627_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_627_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_627_chunk_unique ON _timescaledb_internal._hyper_2_627_chunk USING btree ("time", country);


--
-- Name: _hyper_2_628_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_628_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_628_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_628_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_628_chunk_unique ON _timescaledb_internal._hyper_2_628_chunk USING btree ("time", country);


--
-- Name: _hyper_2_629_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_629_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_629_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_629_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_629_chunk_unique ON _timescaledb_internal._hyper_2_629_chunk USING btree ("time", country);


--
-- Name: _hyper_2_630_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_630_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_630_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_630_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_630_chunk_unique ON _timescaledb_internal._hyper_2_630_chunk USING btree ("time", country);


--
-- Name: _hyper_2_631_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_631_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_631_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_631_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_631_chunk_unique ON _timescaledb_internal._hyper_2_631_chunk USING btree ("time", country);


--
-- Name: _hyper_2_632_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_632_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_632_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_632_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_632_chunk_unique ON _timescaledb_internal._hyper_2_632_chunk USING btree ("time", country);


--
-- Name: _hyper_2_633_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_633_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_633_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_633_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_633_chunk_unique ON _timescaledb_internal._hyper_2_633_chunk USING btree ("time", country);


--
-- Name: _hyper_2_634_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_634_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_634_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_634_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_634_chunk_unique ON _timescaledb_internal._hyper_2_634_chunk USING btree ("time", country);


--
-- Name: _hyper_2_635_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_635_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_635_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_635_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_635_chunk_unique ON _timescaledb_internal._hyper_2_635_chunk USING btree ("time", country);


--
-- Name: _hyper_2_636_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_636_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_636_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_636_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_636_chunk_unique ON _timescaledb_internal._hyper_2_636_chunk USING btree ("time", country);


--
-- Name: _hyper_2_637_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_637_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_637_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_637_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_637_chunk_unique ON _timescaledb_internal._hyper_2_637_chunk USING btree ("time", country);


--
-- Name: _hyper_2_638_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_638_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_638_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_638_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_638_chunk_unique ON _timescaledb_internal._hyper_2_638_chunk USING btree ("time", country);


--
-- Name: _hyper_2_639_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_639_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_639_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_639_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_639_chunk_unique ON _timescaledb_internal._hyper_2_639_chunk USING btree ("time", country);


--
-- Name: _hyper_2_640_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_640_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_640_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_640_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_640_chunk_unique ON _timescaledb_internal._hyper_2_640_chunk USING btree ("time", country);


--
-- Name: _hyper_2_641_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_641_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_641_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_641_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_641_chunk_unique ON _timescaledb_internal._hyper_2_641_chunk USING btree ("time", country);


--
-- Name: _hyper_2_642_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_642_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_642_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_642_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_642_chunk_unique ON _timescaledb_internal._hyper_2_642_chunk USING btree ("time", country);


--
-- Name: _hyper_2_643_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_643_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_643_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_643_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_643_chunk_unique ON _timescaledb_internal._hyper_2_643_chunk USING btree ("time", country);


--
-- Name: _hyper_2_644_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_644_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_644_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_644_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_644_chunk_unique ON _timescaledb_internal._hyper_2_644_chunk USING btree ("time", country);


--
-- Name: _hyper_2_645_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_645_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_645_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_645_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_645_chunk_unique ON _timescaledb_internal._hyper_2_645_chunk USING btree ("time", country);


--
-- Name: _hyper_2_646_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_646_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_646_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_646_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_646_chunk_unique ON _timescaledb_internal._hyper_2_646_chunk USING btree ("time", country);


--
-- Name: _hyper_2_647_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_647_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_647_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_647_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_647_chunk_unique ON _timescaledb_internal._hyper_2_647_chunk USING btree ("time", country);


--
-- Name: _hyper_2_648_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_648_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_648_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_648_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_648_chunk_unique ON _timescaledb_internal._hyper_2_648_chunk USING btree ("time", country);


--
-- Name: _hyper_2_649_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_649_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_649_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_649_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_649_chunk_unique ON _timescaledb_internal._hyper_2_649_chunk USING btree ("time", country);


--
-- Name: _hyper_2_650_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_650_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_650_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_650_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_650_chunk_unique ON _timescaledb_internal._hyper_2_650_chunk USING btree ("time", country);


--
-- Name: _hyper_2_651_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_651_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_651_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_651_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_651_chunk_unique ON _timescaledb_internal._hyper_2_651_chunk USING btree ("time", country);


--
-- Name: _hyper_2_652_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_652_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_652_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_652_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_652_chunk_unique ON _timescaledb_internal._hyper_2_652_chunk USING btree ("time", country);


--
-- Name: _hyper_2_653_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_653_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_653_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_653_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_653_chunk_unique ON _timescaledb_internal._hyper_2_653_chunk USING btree ("time", country);


--
-- Name: _hyper_2_654_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_654_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_654_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_654_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_654_chunk_unique ON _timescaledb_internal._hyper_2_654_chunk USING btree ("time", country);


--
-- Name: _hyper_2_655_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_655_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_655_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_655_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_655_chunk_unique ON _timescaledb_internal._hyper_2_655_chunk USING btree ("time", country);


--
-- Name: _hyper_2_656_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_656_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_656_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_656_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_656_chunk_unique ON _timescaledb_internal._hyper_2_656_chunk USING btree ("time", country);


--
-- Name: _hyper_2_657_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_657_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_657_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_657_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_657_chunk_unique ON _timescaledb_internal._hyper_2_657_chunk USING btree ("time", country);


--
-- Name: _hyper_2_658_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_658_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_658_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_658_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_658_chunk_unique ON _timescaledb_internal._hyper_2_658_chunk USING btree ("time", country);


--
-- Name: _hyper_2_659_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_659_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_659_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_659_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_659_chunk_unique ON _timescaledb_internal._hyper_2_659_chunk USING btree ("time", country);


--
-- Name: _hyper_2_660_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_660_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_660_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_660_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_660_chunk_unique ON _timescaledb_internal._hyper_2_660_chunk USING btree ("time", country);


--
-- Name: _hyper_2_661_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_661_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_661_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_661_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_661_chunk_unique ON _timescaledb_internal._hyper_2_661_chunk USING btree ("time", country);


--
-- Name: _hyper_2_662_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_662_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_662_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_662_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_662_chunk_unique ON _timescaledb_internal._hyper_2_662_chunk USING btree ("time", country);


--
-- Name: _hyper_2_663_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_663_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_663_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_663_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_663_chunk_unique ON _timescaledb_internal._hyper_2_663_chunk USING btree ("time", country);


--
-- Name: _hyper_2_664_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_664_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_664_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_664_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_664_chunk_unique ON _timescaledb_internal._hyper_2_664_chunk USING btree ("time", country);


--
-- Name: _hyper_2_665_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_665_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_665_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_665_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_665_chunk_unique ON _timescaledb_internal._hyper_2_665_chunk USING btree ("time", country);


--
-- Name: _hyper_2_666_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_666_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_666_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_666_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_666_chunk_unique ON _timescaledb_internal._hyper_2_666_chunk USING btree ("time", country);


--
-- Name: _hyper_2_667_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_667_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_667_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_667_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_667_chunk_unique ON _timescaledb_internal._hyper_2_667_chunk USING btree ("time", country);


--
-- Name: _hyper_2_668_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_668_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_668_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_668_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_668_chunk_unique ON _timescaledb_internal._hyper_2_668_chunk USING btree ("time", country);


--
-- Name: _hyper_2_669_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_669_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_669_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_669_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_669_chunk_unique ON _timescaledb_internal._hyper_2_669_chunk USING btree ("time", country);


--
-- Name: _hyper_2_670_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_670_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_670_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_670_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_670_chunk_unique ON _timescaledb_internal._hyper_2_670_chunk USING btree ("time", country);


--
-- Name: _hyper_2_671_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_671_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_671_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_671_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_671_chunk_unique ON _timescaledb_internal._hyper_2_671_chunk USING btree ("time", country);


--
-- Name: _hyper_2_672_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_672_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_672_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_672_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_672_chunk_unique ON _timescaledb_internal._hyper_2_672_chunk USING btree ("time", country);


--
-- Name: _hyper_2_673_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_673_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_673_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_673_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_673_chunk_unique ON _timescaledb_internal._hyper_2_673_chunk USING btree ("time", country);


--
-- Name: _hyper_2_674_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_674_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_674_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_674_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_674_chunk_unique ON _timescaledb_internal._hyper_2_674_chunk USING btree ("time", country);


--
-- Name: _hyper_2_675_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_675_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_675_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_675_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_675_chunk_unique ON _timescaledb_internal._hyper_2_675_chunk USING btree ("time", country);


--
-- Name: _hyper_2_676_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_676_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_676_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_676_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_676_chunk_unique ON _timescaledb_internal._hyper_2_676_chunk USING btree ("time", country);


--
-- Name: _hyper_2_677_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_677_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_677_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_677_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_677_chunk_unique ON _timescaledb_internal._hyper_2_677_chunk USING btree ("time", country);


--
-- Name: _hyper_2_678_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_678_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_678_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_678_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_678_chunk_unique ON _timescaledb_internal._hyper_2_678_chunk USING btree ("time", country);


--
-- Name: _hyper_2_679_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_679_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_679_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_679_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_679_chunk_unique ON _timescaledb_internal._hyper_2_679_chunk USING btree ("time", country);


--
-- Name: _hyper_2_680_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_680_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_680_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_680_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_680_chunk_unique ON _timescaledb_internal._hyper_2_680_chunk USING btree ("time", country);


--
-- Name: _hyper_2_681_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_681_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_681_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_681_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_681_chunk_unique ON _timescaledb_internal._hyper_2_681_chunk USING btree ("time", country);


--
-- Name: _hyper_2_682_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_682_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_682_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_682_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_682_chunk_unique ON _timescaledb_internal._hyper_2_682_chunk USING btree ("time", country);


--
-- Name: _hyper_2_683_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_683_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_683_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_683_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_683_chunk_unique ON _timescaledb_internal._hyper_2_683_chunk USING btree ("time", country);


--
-- Name: _hyper_2_684_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_684_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_684_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_684_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_684_chunk_unique ON _timescaledb_internal._hyper_2_684_chunk USING btree ("time", country);


--
-- Name: _hyper_2_685_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_685_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_685_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_685_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_685_chunk_unique ON _timescaledb_internal._hyper_2_685_chunk USING btree ("time", country);


--
-- Name: _hyper_2_686_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_686_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_686_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_686_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_686_chunk_unique ON _timescaledb_internal._hyper_2_686_chunk USING btree ("time", country);


--
-- Name: _hyper_2_687_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_687_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_687_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_687_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_687_chunk_unique ON _timescaledb_internal._hyper_2_687_chunk USING btree ("time", country);


--
-- Name: _hyper_2_688_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_688_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_688_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_688_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_688_chunk_unique ON _timescaledb_internal._hyper_2_688_chunk USING btree ("time", country);


--
-- Name: _hyper_2_689_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_689_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_689_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_689_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_689_chunk_unique ON _timescaledb_internal._hyper_2_689_chunk USING btree ("time", country);


--
-- Name: _hyper_2_690_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_690_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_690_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_690_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_690_chunk_unique ON _timescaledb_internal._hyper_2_690_chunk USING btree ("time", country);


--
-- Name: _hyper_2_691_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_691_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_691_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_691_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_691_chunk_unique ON _timescaledb_internal._hyper_2_691_chunk USING btree ("time", country);


--
-- Name: _hyper_2_692_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_692_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_692_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_692_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_692_chunk_unique ON _timescaledb_internal._hyper_2_692_chunk USING btree ("time", country);


--
-- Name: _hyper_2_693_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_693_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_693_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_693_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_693_chunk_unique ON _timescaledb_internal._hyper_2_693_chunk USING btree ("time", country);


--
-- Name: _hyper_2_694_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_694_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_694_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_694_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_694_chunk_unique ON _timescaledb_internal._hyper_2_694_chunk USING btree ("time", country);


--
-- Name: _hyper_2_695_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_695_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_695_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_695_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_695_chunk_unique ON _timescaledb_internal._hyper_2_695_chunk USING btree ("time", country);


--
-- Name: _hyper_2_696_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_696_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_696_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_696_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_696_chunk_unique ON _timescaledb_internal._hyper_2_696_chunk USING btree ("time", country);


--
-- Name: _hyper_2_697_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_697_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_697_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_697_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_697_chunk_unique ON _timescaledb_internal._hyper_2_697_chunk USING btree ("time", country);


--
-- Name: _hyper_2_698_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_698_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_698_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_698_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_698_chunk_unique ON _timescaledb_internal._hyper_2_698_chunk USING btree ("time", country);


--
-- Name: _hyper_2_699_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_699_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_699_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_699_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_699_chunk_unique ON _timescaledb_internal._hyper_2_699_chunk USING btree ("time", country);


--
-- Name: _hyper_2_700_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_700_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_700_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_700_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_700_chunk_unique ON _timescaledb_internal._hyper_2_700_chunk USING btree ("time", country);


--
-- Name: _hyper_2_701_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_701_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_701_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_701_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_701_chunk_unique ON _timescaledb_internal._hyper_2_701_chunk USING btree ("time", country);


--
-- Name: _hyper_2_702_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_702_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_702_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_702_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_702_chunk_unique ON _timescaledb_internal._hyper_2_702_chunk USING btree ("time", country);


--
-- Name: _hyper_2_703_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_703_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_703_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_703_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_703_chunk_unique ON _timescaledb_internal._hyper_2_703_chunk USING btree ("time", country);


--
-- Name: _hyper_2_704_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_704_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_704_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_704_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_704_chunk_unique ON _timescaledb_internal._hyper_2_704_chunk USING btree ("time", country);


--
-- Name: _hyper_2_705_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_705_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_705_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_705_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_705_chunk_unique ON _timescaledb_internal._hyper_2_705_chunk USING btree ("time", country);


--
-- Name: _hyper_2_706_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_706_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_706_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_706_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_706_chunk_unique ON _timescaledb_internal._hyper_2_706_chunk USING btree ("time", country);


--
-- Name: _hyper_2_707_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_707_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_707_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_707_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_707_chunk_unique ON _timescaledb_internal._hyper_2_707_chunk USING btree ("time", country);


--
-- Name: _hyper_2_708_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_708_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_708_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_708_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_708_chunk_unique ON _timescaledb_internal._hyper_2_708_chunk USING btree ("time", country);


--
-- Name: _hyper_2_709_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_709_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_709_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_709_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_709_chunk_unique ON _timescaledb_internal._hyper_2_709_chunk USING btree ("time", country);


--
-- Name: _hyper_2_710_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_710_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_710_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_710_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_710_chunk_unique ON _timescaledb_internal._hyper_2_710_chunk USING btree ("time", country);


--
-- Name: _hyper_2_711_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_711_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_711_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_711_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_711_chunk_unique ON _timescaledb_internal._hyper_2_711_chunk USING btree ("time", country);


--
-- Name: _hyper_2_712_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_712_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_712_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_712_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_712_chunk_unique ON _timescaledb_internal._hyper_2_712_chunk USING btree ("time", country);


--
-- Name: _hyper_2_713_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_713_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_713_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_713_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_713_chunk_unique ON _timescaledb_internal._hyper_2_713_chunk USING btree ("time", country);


--
-- Name: _hyper_2_714_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_714_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_714_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_714_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_714_chunk_unique ON _timescaledb_internal._hyper_2_714_chunk USING btree ("time", country);


--
-- Name: _hyper_2_715_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_715_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_715_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_715_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_715_chunk_unique ON _timescaledb_internal._hyper_2_715_chunk USING btree ("time", country);


--
-- Name: _hyper_2_716_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_716_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_716_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_716_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_716_chunk_unique ON _timescaledb_internal._hyper_2_716_chunk USING btree ("time", country);


--
-- Name: _hyper_2_717_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_717_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_717_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_717_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_717_chunk_unique ON _timescaledb_internal._hyper_2_717_chunk USING btree ("time", country);


--
-- Name: _hyper_2_718_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_718_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_718_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_718_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_718_chunk_unique ON _timescaledb_internal._hyper_2_718_chunk USING btree ("time", country);


--
-- Name: _hyper_2_719_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_719_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_719_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_719_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_719_chunk_unique ON _timescaledb_internal._hyper_2_719_chunk USING btree ("time", country);


--
-- Name: _hyper_2_720_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_720_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_720_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_720_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_720_chunk_unique ON _timescaledb_internal._hyper_2_720_chunk USING btree ("time", country);


--
-- Name: _hyper_2_721_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_721_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_721_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_721_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_721_chunk_unique ON _timescaledb_internal._hyper_2_721_chunk USING btree ("time", country);


--
-- Name: _hyper_2_722_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_722_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_722_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_722_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_722_chunk_unique ON _timescaledb_internal._hyper_2_722_chunk USING btree ("time", country);


--
-- Name: _hyper_2_723_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_723_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_723_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_723_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_723_chunk_unique ON _timescaledb_internal._hyper_2_723_chunk USING btree ("time", country);


--
-- Name: _hyper_2_724_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_724_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_724_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_724_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_724_chunk_unique ON _timescaledb_internal._hyper_2_724_chunk USING btree ("time", country);


--
-- Name: _hyper_2_725_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_725_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_725_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_725_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_725_chunk_unique ON _timescaledb_internal._hyper_2_725_chunk USING btree ("time", country);


--
-- Name: _hyper_2_726_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_726_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_726_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_726_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_726_chunk_unique ON _timescaledb_internal._hyper_2_726_chunk USING btree ("time", country);


--
-- Name: _hyper_2_727_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_727_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_727_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_727_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_727_chunk_unique ON _timescaledb_internal._hyper_2_727_chunk USING btree ("time", country);


--
-- Name: _hyper_2_728_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_728_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_728_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_728_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_728_chunk_unique ON _timescaledb_internal._hyper_2_728_chunk USING btree ("time", country);


--
-- Name: _hyper_2_729_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_729_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_729_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_729_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_729_chunk_unique ON _timescaledb_internal._hyper_2_729_chunk USING btree ("time", country);


--
-- Name: _hyper_2_730_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_730_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_730_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_730_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_730_chunk_unique ON _timescaledb_internal._hyper_2_730_chunk USING btree ("time", country);


--
-- Name: _hyper_2_731_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_731_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_731_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_731_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_731_chunk_unique ON _timescaledb_internal._hyper_2_731_chunk USING btree ("time", country);


--
-- Name: _hyper_2_732_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_732_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_732_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_732_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_732_chunk_unique ON _timescaledb_internal._hyper_2_732_chunk USING btree ("time", country);


--
-- Name: _hyper_2_733_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_733_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_733_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_733_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_733_chunk_unique ON _timescaledb_internal._hyper_2_733_chunk USING btree ("time", country);


--
-- Name: _hyper_2_734_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_734_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_734_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_734_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_734_chunk_unique ON _timescaledb_internal._hyper_2_734_chunk USING btree ("time", country);


--
-- Name: _hyper_2_735_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_735_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_735_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_735_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_735_chunk_unique ON _timescaledb_internal._hyper_2_735_chunk USING btree ("time", country);


--
-- Name: _hyper_2_736_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_736_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_736_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_736_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_736_chunk_unique ON _timescaledb_internal._hyper_2_736_chunk USING btree ("time", country);


--
-- Name: _hyper_2_737_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_737_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_737_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_737_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_737_chunk_unique ON _timescaledb_internal._hyper_2_737_chunk USING btree ("time", country);


--
-- Name: _hyper_2_738_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_738_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_738_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_738_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_738_chunk_unique ON _timescaledb_internal._hyper_2_738_chunk USING btree ("time", country);


--
-- Name: _hyper_2_739_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_739_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_739_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_739_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_739_chunk_unique ON _timescaledb_internal._hyper_2_739_chunk USING btree ("time", country);


--
-- Name: _hyper_2_740_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_740_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_740_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_740_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_740_chunk_unique ON _timescaledb_internal._hyper_2_740_chunk USING btree ("time", country);


--
-- Name: _hyper_2_741_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_741_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_741_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_741_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_741_chunk_unique ON _timescaledb_internal._hyper_2_741_chunk USING btree ("time", country);


--
-- Name: _hyper_2_742_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_742_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_742_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_742_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_742_chunk_unique ON _timescaledb_internal._hyper_2_742_chunk USING btree ("time", country);


--
-- Name: _hyper_2_743_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_743_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_743_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_743_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_743_chunk_unique ON _timescaledb_internal._hyper_2_743_chunk USING btree ("time", country);


--
-- Name: _hyper_2_744_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_744_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_744_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_744_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_744_chunk_unique ON _timescaledb_internal._hyper_2_744_chunk USING btree ("time", country);


--
-- Name: _hyper_2_745_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_745_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_745_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_745_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_745_chunk_unique ON _timescaledb_internal._hyper_2_745_chunk USING btree ("time", country);


--
-- Name: _hyper_2_746_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_746_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_746_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_746_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_746_chunk_unique ON _timescaledb_internal._hyper_2_746_chunk USING btree ("time", country);


--
-- Name: _hyper_2_747_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_747_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_747_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_747_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_747_chunk_unique ON _timescaledb_internal._hyper_2_747_chunk USING btree ("time", country);


--
-- Name: _hyper_2_748_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_748_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_748_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_748_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_748_chunk_unique ON _timescaledb_internal._hyper_2_748_chunk USING btree ("time", country);


--
-- Name: _hyper_2_749_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_749_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_749_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_749_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_749_chunk_unique ON _timescaledb_internal._hyper_2_749_chunk USING btree ("time", country);


--
-- Name: _hyper_2_750_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_750_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_750_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_750_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_750_chunk_unique ON _timescaledb_internal._hyper_2_750_chunk USING btree ("time", country);


--
-- Name: _hyper_2_751_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_751_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_751_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_751_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_751_chunk_unique ON _timescaledb_internal._hyper_2_751_chunk USING btree ("time", country);


--
-- Name: _hyper_2_752_chunk_entsoe_load_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_752_chunk_entsoe_load_time_idx ON _timescaledb_internal._hyper_2_752_chunk USING btree ("time" DESC);


--
-- Name: _hyper_2_752_chunk_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_2_752_chunk_unique ON _timescaledb_internal._hyper_2_752_chunk USING btree ("time", country);


--
-- Name: entsoe_generation_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entsoe_generation_created_at_idx ON public.entsoe_generation USING btree ("time" DESC);


--
-- Name: entsoe_load_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entsoe_load_time_idx ON public.entsoe_load USING btree ("time" DESC);


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

CREATE UNIQUE INDEX intermittency_unique ON public.entsoe_generation USING btree ("time", country, production_type, process_type);


--
-- Name: unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "unique" ON public.entsoe_load USING btree ("time", country);


--
-- Name: entsoe_generation ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.entsoe_generation FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: entsoe_load ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.entsoe_load FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('0'),
('1'),
('2'),
('3'),
('4'),
('5'),
('6');


