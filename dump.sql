--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: desport; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA desport;


ALTER SCHEMA desport OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: codes; Type: TABLE; Schema: desport; Owner: postgres
--

CREATE TABLE desport.codes (
    idcode bigint NOT NULL,
    code bigint NOT NULL,
    email text NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires timestamp with time zone DEFAULT (CURRENT_TIMESTAMP + '00:25:00'::interval) NOT NULL
);


ALTER TABLE desport.codes OWNER TO postgres;

--
-- Name: codes_idcode_seq; Type: SEQUENCE; Schema: desport; Owner: postgres
--

CREATE SEQUENCE desport.codes_idcode_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE desport.codes_idcode_seq OWNER TO postgres;

--
-- Name: codes_idcode_seq; Type: SEQUENCE OWNED BY; Schema: desport; Owner: postgres
--

ALTER SEQUENCE desport.codes_idcode_seq OWNED BY desport.codes.idcode;


--
-- Name: users; Type: TABLE; Schema: desport; Owner: postgres
--

CREATE TABLE desport.users (
    iduser bigint NOT NULL,
    name text NOT NULL,
    username character varying(50) NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    is_active boolean NOT NULL
);


ALTER TABLE desport.users OWNER TO postgres;

--
-- Name: users_iduser_seq; Type: SEQUENCE; Schema: desport; Owner: postgres
--

CREATE SEQUENCE desport.users_iduser_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE desport.users_iduser_seq OWNER TO postgres;

--
-- Name: users_iduser_seq; Type: SEQUENCE OWNED BY; Schema: desport; Owner: postgres
--

ALTER SEQUENCE desport.users_iduser_seq OWNED BY desport.users.iduser;


--
-- Name: codes idcode; Type: DEFAULT; Schema: desport; Owner: postgres
--

ALTER TABLE ONLY desport.codes ALTER COLUMN idcode SET DEFAULT nextval('desport.codes_idcode_seq'::regclass);


--
-- Name: users iduser; Type: DEFAULT; Schema: desport; Owner: postgres
--

ALTER TABLE ONLY desport.users ALTER COLUMN iduser SET DEFAULT nextval('desport.users_iduser_seq'::regclass);


--
-- Data for Name: codes; Type: TABLE DATA; Schema: desport; Owner: postgres
--

COPY desport.codes (idcode, code, email, created, expires) FROM stdin;
3       37182547        eduardo.c.01@hotmail.com        2024-10-21 14:09:22.039-03      2024-10-21 14:34:22.039-03
4       83961536        duducom95@gmail.com     2024-10-24 19:40:42.219-03      2024-10-24 20:05:42.219-03
5       68394421        duducom195@gmail.com    2024-10-24 20:17:45.67-03       2024-10-24 20:42:45.67-03
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: desport; Owner: postgres
--

COPY desport.users (iduser, name, username, email, password, is_active) FROM stdin;
5       Eduardo Cardoso Agostinetti     rjnhxf  eduardo.c.01@hotmail.com        $2b$10$NxPr5wXUSB61/EGoSM//..rQv7fZOMUjXA/Q32e6/hv04ToI1gGIm  t
6       Eduardo Cardoso Agostinetti     rjnhxg  duducom95@gmail.com     $2b$10$Ruk.u38URTXjKRlzs4cV5.0.9E2KuygVvAwOn3.h8KlZ6tveCxIOO  t
7       Teste   teste   duducom195@gmail.com    $2b$10$dYUhK80VVZ/ECkDG7fdnz.FZ5qew0T8qoY/L1z7JjCQw4jVW9Zq1.  t
\.


--
-- Name: codes_idcode_seq; Type: SEQUENCE SET; Schema: desport; Owner: postgres
--

SELECT pg_catalog.setval('desport.codes_idcode_seq', 5, true);


--
-- Name: users_iduser_seq; Type: SEQUENCE SET; Schema: desport; Owner: postgres
--

SELECT pg_catalog.setval('desport.users_iduser_seq', 7, true);


--
-- Name: codes codes_pkey; Type: CONSTRAINT; Schema: desport; Owner: postgres
--

ALTER TABLE ONLY desport.codes
    ADD CONSTRAINT codes_pkey PRIMARY KEY (idcode);


--
-- Name: users unique_username; Type: CONSTRAINT; Schema: desport; Owner: postgres
--

ALTER TABLE ONLY desport.users
    ADD CONSTRAINT unique_username UNIQUE (username);


--
-- Name: users users_email; Type: CONSTRAINT; Schema: desport; Owner: postgres
--

ALTER TABLE ONLY desport.users
    ADD CONSTRAINT users_email UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: desport; Owner: postgres
--

ALTER TABLE ONLY desport.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (iduser);


--
-- PostgreSQL database dump complete
--