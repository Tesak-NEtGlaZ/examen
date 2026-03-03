--
-- PostgreSQL database dump
--

\restrict wJR5vn0xxqEtsJ463xinZ958MqImZRAZCiTTUpx0BoJPpAbOpJv4nwawNgCs69z

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-03-03 10:53:24

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 17457)
-- Name: aircrafts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aircrafts (
    aircraft_id integer NOT NULL,
    model character varying(100) NOT NULL,
    registration_number character varying(20) NOT NULL,
    capacity integer NOT NULL,
    manufacture_year integer,
    status character varying(20) DEFAULT 'active'::character varying,
    CONSTRAINT aircrafts_capacity_check CHECK ((capacity > 0)),
    CONSTRAINT aircrafts_manufacture_year_check CHECK (((manufacture_year >= 1900) AND ((manufacture_year)::numeric <= EXTRACT(year FROM CURRENT_DATE)))),
    CONSTRAINT aircrafts_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'maintenance'::character varying, 'retired'::character varying])::text[])))
);


ALTER TABLE public.aircrafts OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17456)
-- Name: aircrafts_aircraft_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.aircrafts_aircraft_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aircrafts_aircraft_id_seq OWNER TO postgres;

--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 221
-- Name: aircrafts_aircraft_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.aircrafts_aircraft_id_seq OWNED BY public.aircrafts.aircraft_id;


--
-- TOC entry 224 (class 1259 OID 17474)
-- Name: flights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flights (
    flight_id integer NOT NULL,
    flight_number character varying(10) NOT NULL,
    aircraft_id integer NOT NULL,
    departure_city character varying(50) NOT NULL,
    arrival_city character varying(50) NOT NULL,
    departure_date date NOT NULL,
    departure_time time without time zone NOT NULL,
    arrival_date date NOT NULL,
    arrival_time time without time zone NOT NULL,
    ticket_price numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'scheduled'::character varying,
    available_seats integer NOT NULL,
    CONSTRAINT flights_available_seats_check CHECK ((available_seats > 0)),
    CONSTRAINT flights_status_check CHECK (((status)::text = ANY ((ARRAY['scheduled'::character varying, 'delayed'::character varying, 'cancelled'::character varying, 'departed'::character varying, 'arrived'::character varying])::text[]))),
    CONSTRAINT flights_ticket_price_check CHECK ((ticket_price > (0)::numeric))
);


ALTER TABLE public.flights OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17473)
-- Name: flights_flight_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flights_flight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flights_flight_id_seq OWNER TO postgres;

--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 223
-- Name: flights_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flights_flight_id_seq OWNED BY public.flights.flight_id;


--
-- TOC entry 230 (class 1259 OID 17551)
-- Name: login_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_history (
    history_id integer NOT NULL,
    user_id integer NOT NULL,
    login_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ip_address character varying(45),
    result character varying(20),
    CONSTRAINT login_history_result_check CHECK (((result)::text = ANY ((ARRAY['success'::character varying, 'failed'::character varying])::text[])))
);


ALTER TABLE public.login_history OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17550)
-- Name: login_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_history_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_history_history_id_seq OWNER TO postgres;

--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 229
-- Name: login_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_history_history_id_seq OWNED BY public.login_history.history_id;


--
-- TOC entry 226 (class 1259 OID 17503)
-- Name: passengers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passengers (
    passenger_id integer NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    middle_name character varying(50),
    passport_number character varying(20) NOT NULL,
    phone character varying(20),
    email character varying(100),
    registration_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.passengers OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17502)
-- Name: passengers_passenger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passengers_passenger_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passengers_passenger_id_seq OWNER TO postgres;

--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 225
-- Name: passengers_passenger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passengers_passenger_id_seq OWNED BY public.passengers.passenger_id;


--
-- TOC entry 228 (class 1259 OID 17517)
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets (
    ticket_id integer NOT NULL,
    flight_id integer NOT NULL,
    passenger_id integer NOT NULL,
    user_id integer NOT NULL,
    seat_number character varying(5) NOT NULL,
    price numeric(10,2) NOT NULL,
    booking_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'booked'::character varying,
    CONSTRAINT tickets_price_check CHECK ((price > (0)::numeric)),
    CONSTRAINT tickets_status_check CHECK (((status)::text = ANY ((ARRAY['booked'::character varying, 'refunded'::character varying, 'exchanged'::character varying, 'used'::character varying])::text[])))
);


ALTER TABLE public.tickets OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17516)
-- Name: tickets_ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tickets_ticket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tickets_ticket_id_seq OWNER TO postgres;

--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 227
-- Name: tickets_ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tickets_ticket_id_seq OWNED BY public.tickets.ticket_id;


--
-- TOC entry 220 (class 1259 OID 17440)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    registration_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_login timestamp without time zone,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'operator'::character varying])::text[]))),
    CONSTRAINT users_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'blocked'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17439)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4884 (class 2604 OID 17460)
-- Name: aircrafts aircraft_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircrafts ALTER COLUMN aircraft_id SET DEFAULT nextval('public.aircrafts_aircraft_id_seq'::regclass);


--
-- TOC entry 4886 (class 2604 OID 17477)
-- Name: flights flight_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights ALTER COLUMN flight_id SET DEFAULT nextval('public.flights_flight_id_seq'::regclass);


--
-- TOC entry 4893 (class 2604 OID 17554)
-- Name: login_history history_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history ALTER COLUMN history_id SET DEFAULT nextval('public.login_history_history_id_seq'::regclass);


--
-- TOC entry 4888 (class 2604 OID 17506)
-- Name: passengers passenger_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passengers ALTER COLUMN passenger_id SET DEFAULT nextval('public.passengers_passenger_id_seq'::regclass);


--
-- TOC entry 4890 (class 2604 OID 17520)
-- Name: tickets ticket_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets ALTER COLUMN ticket_id SET DEFAULT nextval('public.tickets_ticket_id_seq'::regclass);


--
-- TOC entry 4881 (class 2604 OID 17443)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 5083 (class 0 OID 17457)
-- Dependencies: 222
-- Data for Name: aircrafts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aircrafts (aircraft_id, model, registration_number, capacity, manufacture_year, status) FROM stdin;
1	Boeing 737-800	RA-12345	189	2015	active
2	Airbus A320	RA-67890	180	2018	active
3	Boeing 777-300	RA-54321	350	2020	active
\.


--
-- TOC entry 5085 (class 0 OID 17474)
-- Dependencies: 224
-- Data for Name: flights; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flights (flight_id, flight_number, aircraft_id, departure_city, arrival_city, departure_date, departure_time, arrival_date, arrival_time, ticket_price, status, available_seats) FROM stdin;
1	SU-100	1	Москва (SVO)	Нью-Йорк (JFK)	2025-03-15	10:00:00	2025-03-15	22:00:00	25000.00	scheduled	189
2	SU-101	1	Нью-Йорк (JFK)	Москва (SVO)	2025-03-16	12:00:00	2025-03-17	06:00:00	27000.00	scheduled	189
3	S7-250	2	Москва (DME)	Санкт-Петербург (LED)	2025-03-16	14:30:00	2025-03-16	16:00:00	8000.00	scheduled	180
\.


--
-- TOC entry 5091 (class 0 OID 17551)
-- Dependencies: 230
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_history (history_id, user_id, login_date, ip_address, result) FROM stdin;
\.


--
-- TOC entry 5087 (class 0 OID 17503)
-- Dependencies: 226
-- Data for Name: passengers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passengers (passenger_id, last_name, first_name, middle_name, passport_number, phone, email, registration_date) FROM stdin;
1	Иванов	Иван	Иванович	1234 567890	+7-916-111-22-33	ivan@mail.ru	2026-03-03
2	Петрова	Мария	Сергеевна	0987 654321	+7-926-222-33-44	maria@gmail.com	2026-03-03
3	Сидоров	Алексей	Петрович	4567 890123	+7-903-333-44-55	alex@yandex.ru	2026-03-03
\.


--
-- TOC entry 5089 (class 0 OID 17517)
-- Dependencies: 228
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets (ticket_id, flight_id, passenger_id, user_id, seat_number, price, booking_date, status) FROM stdin;
1	1	1	1	15A	25000.00	2026-03-03 10:50:55.438359	booked
2	1	2	2	15B	25000.00	2026-03-03 10:50:55.438359	booked
3	2	3	1	1A	27000.00	2026-03-03 10:50:55.438359	booked
\.


--
-- TOC entry 5081 (class 0 OID 17440)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, password_hash, role, status, registration_date, last_login) FROM stdin;
1	admin	admin123	admin	active	2026-03-03 10:50:55.438359	\N
2	operator1	oper123	operator	active	2026-03-03 10:50:55.438359	\N
3	operator2	oper456	operator	blocked	2026-03-03 10:50:55.438359	\N
\.


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 221
-- Name: aircrafts_aircraft_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aircrafts_aircraft_id_seq', 3, true);


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 223
-- Name: flights_flight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flights_flight_id_seq', 3, true);


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 229
-- Name: login_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_history_history_id_seq', 1, false);


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 225
-- Name: passengers_passenger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passengers_passenger_id_seq', 3, true);


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 227
-- Name: tickets_ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tickets_ticket_id_seq', 3, true);


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 3, true);


--
-- TOC entry 4911 (class 2606 OID 17470)
-- Name: aircrafts aircrafts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircrafts
    ADD CONSTRAINT aircrafts_pkey PRIMARY KEY (aircraft_id);


--
-- TOC entry 4913 (class 2606 OID 17472)
-- Name: aircrafts aircrafts_registration_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircrafts
    ADD CONSTRAINT aircrafts_registration_number_key UNIQUE (registration_number);


--
-- TOC entry 4915 (class 2606 OID 17496)
-- Name: flights flights_flight_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_flight_number_key UNIQUE (flight_number);


--
-- TOC entry 4917 (class 2606 OID 17494)
-- Name: flights flights_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (flight_id);


--
-- TOC entry 4927 (class 2606 OID 17560)
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (history_id);


--
-- TOC entry 4919 (class 2606 OID 17515)
-- Name: passengers passengers_passport_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_passport_number_key UNIQUE (passport_number);


--
-- TOC entry 4921 (class 2606 OID 17513)
-- Name: passengers passengers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_pkey PRIMARY KEY (passenger_id);


--
-- TOC entry 4923 (class 2606 OID 17534)
-- Name: tickets tickets_flight_id_seat_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_flight_id_seat_number_key UNIQUE (flight_id, seat_number);


--
-- TOC entry 4925 (class 2606 OID 17532)
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (ticket_id);


--
-- TOC entry 4907 (class 2606 OID 17453)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4909 (class 2606 OID 17455)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4928 (class 2606 OID 17497)
-- Name: flights flights_aircraft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_aircraft_id_fkey FOREIGN KEY (aircraft_id) REFERENCES public.aircrafts(aircraft_id) ON DELETE RESTRICT;


--
-- TOC entry 4932 (class 2606 OID 17561)
-- Name: login_history login_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4929 (class 2606 OID 17535)
-- Name: tickets tickets_flight_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flights(flight_id) ON DELETE CASCADE;


--
-- TOC entry 4930 (class 2606 OID 17540)
-- Name: tickets tickets_passenger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_passenger_id_fkey FOREIGN KEY (passenger_id) REFERENCES public.passengers(passenger_id) ON DELETE CASCADE;


--
-- TOC entry 4931 (class 2606 OID 17545)
-- Name: tickets tickets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


-- Completed on 2026-03-03 10:53:25

--
-- PostgreSQL database dump complete
--

\unrestrict wJR5vn0xxqEtsJ463xinZ958MqImZRAZCiTTUpx0BoJPpAbOpJv4nwawNgCs69z

