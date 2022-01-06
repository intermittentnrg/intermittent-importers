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
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: _hyper_1_1_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1_chunk (
    CONSTRAINT constraint_1 CHECK (((created_at >= '2021-12-23 00:00:00'::timestamp without time zone) AND (created_at < '2021-12-30 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_2_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_2_chunk (
    CONSTRAINT constraint_2 CHECK (((created_at >= '2021-12-30 00:00:00'::timestamp without time zone) AND (created_at < '2022-01-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_3_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_3_chunk (
    CONSTRAINT constraint_3 CHECK (((created_at >= '2020-12-31 00:00:00'::timestamp without time zone) AND (created_at < '2021-01-07 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_4_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_4_chunk (
    CONSTRAINT constraint_4 CHECK (((created_at >= '2021-01-07 00:00:00'::timestamp without time zone) AND (created_at < '2021-01-14 00:00:00'::timestamp without time zone)))
)
INHERITS (public.entsoe_generation);


--
-- Name: _hyper_1_5_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_5_chunk (
    CONSTRAINT constraint_5 CHECK (((created_at >= '2021-01-14 00:00:00'::timestamp without time zone) AND (created_at < '2021-01-21 00:00:00'::timestamp without time zone)))
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
-- Name: _hyper_1_1_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_1_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_1_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_1_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_1_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_2_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_2_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_2_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_2_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_2_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_2_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_3_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_3_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_3_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_3_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_3_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_3_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_4_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_4_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_4_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_4_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_4_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_4_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: _hyper_1_5_chunk_entsoe_generation_created_at_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_5_chunk_entsoe_generation_created_at_idx ON _timescaledb_internal._hyper_1_5_chunk USING btree (created_at DESC);


--
-- Name: _hyper_1_5_chunk_intermittency_unique; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE UNIQUE INDEX _hyper_1_5_chunk_intermittency_unique ON _timescaledb_internal._hyper_1_5_chunk USING btree (created_at, country, production_type, process_type);


--
-- Name: entsoe_generation_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entsoe_generation_created_at_idx ON public.entsoe_generation USING btree (created_at DESC);


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
('2');


