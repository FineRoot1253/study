--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.1

-- Started on 2022-04-13 17:53:18 KST

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
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3313 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16384)
-- Name: member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member (
    id bigint NOT NULL,
    name character varying
);


ALTER TABLE public.member OWNER TO postgres;

--
-- TOC entry 3307 (class 0 OID 16384)
-- Dependencies: 209
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member (id, name) FROM stdin;
2	kim
1	oh-hong-hong
\.


--
-- TOC entry 3167 (class 2606 OID 16390)
-- Name: member member_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pk PRIMARY KEY (id);


-- Completed on 2022-04-13 17:53:18 KST

--
-- PostgreSQL database dump complete
--

