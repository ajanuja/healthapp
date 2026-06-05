--
-- PostgreSQL database dump
--

\restrict nzPfRoCNrhtHz5L24sOeoTdPwbfwl4Oo1kxyeV88xjsoFc5miPJ3fneDfHYN7KE

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: gender_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender_type AS ENUM (
    'MALE',
    'FEMALE',
    'OTHER'
);


ALTER TYPE public.gender_type OWNER TO postgres;

--
-- Name: medicine_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.medicine_status AS ENUM (
    'TAKEN',
    'SKIPPED',
    'SNOOZED',
    'MISSED'
);


ALTER TYPE public.medicine_status OWNER TO postgres;

--
-- Name: symptom_severity; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.symptom_severity AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH'
);


ALTER TYPE public.symptom_severity OWNER TO postgres;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'PATIENT',
    'CAREGIVER',
    'DOCTOR'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- Name: vital_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.vital_type AS ENUM (
    'BLOOD_SUGAR',
    'BLOOD_PRESSURE',
    'WEIGHT'
);


ALTER TYPE public.vital_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    doctor_id uuid NOT NULL,
    patient_id uuid NOT NULL,
    appointment_date date NOT NULL,
    appointment_time time without time zone NOT NULL,
    notes text,
    status character varying(20) DEFAULT 'SCHEDULED'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- Name: caregiver_patient_links; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caregiver_patient_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    caregiver_id uuid NOT NULL,
    patient_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.caregiver_patient_links OWNER TO postgres;

--
-- Name: caregiver_patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caregiver_patients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    caregiver_id uuid NOT NULL,
    patient_id uuid NOT NULL,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.caregiver_patients OWNER TO postgres;

--
-- Name: doctor_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_notes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    doctor_id uuid NOT NULL,
    patient_id uuid NOT NULL,
    note text NOT NULL,
    follow_up_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.doctor_notes OWNER TO postgres;

--
-- Name: doctor_patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_patients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    doctor_id uuid NOT NULL,
    patient_id uuid NOT NULL,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.doctor_patients OWNER TO postgres;

--
-- Name: medicine_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicine_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    medicine_id uuid NOT NULL,
    patient_id uuid NOT NULL,
    status public.medicine_status NOT NULL,
    taken_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    note text
);


ALTER TABLE public.medicine_logs OWNER TO postgres;

--
-- Name: medicines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicines (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    medicine_name character varying(150) NOT NULL,
    dosage character varying(100) NOT NULL,
    frequency character varying(100) NOT NULL,
    reminder_time time without time zone NOT NULL,
    start_date date,
    end_date date,
    instructions text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.medicines OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: patient_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    condition_type character varying(100) NOT NULL,
    emergency_contact character varying(20),
    doctor_name character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.patient_profiles OWNER TO postgres;

--
-- Name: symptom_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.symptom_notes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    symptom text NOT NULL,
    severity public.symptom_severity NOT NULL,
    note text,
    recorded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.symptom_notes OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    role public.user_role NOT NULL,
    gender public.gender_type,
    age integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: vitals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vitals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    vital_type public.vital_type NOT NULL,
    value character varying(50) NOT NULL,
    recorded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    note text
);


ALTER TABLE public.vitals OWNER TO postgres;

--
-- Name: weekly_summaries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weekly_summaries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    summary_text text NOT NULL,
    adherence_percentage numeric(5,2),
    missed_doses_count integer DEFAULT 0,
    generated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.weekly_summaries OWNER TO postgres;

--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (id, doctor_id, patient_id, appointment_date, appointment_time, notes, status, created_at) FROM stdin;
380bd1e4-0782-4f6e-8ddc-57667c7479a1	04702959-bc2a-404a-9b75-d1d3a2b2bb1c	ad40f9e8-636a-4d50-9863-c917bda724b3	2026-06-09	11:30:00	check in	SCHEDULED	2026-06-03 13:21:56.674
\.


--
-- Data for Name: caregiver_patient_links; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caregiver_patient_links (id, caregiver_id, patient_id, created_at) FROM stdin;
\.


--
-- Data for Name: caregiver_patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caregiver_patients (id, caregiver_id, patient_id, assigned_at) FROM stdin;
6f2b21a4-8260-40be-9177-c6cd6965ebf1	83125301-675f-4979-9ad3-9f1ca03196b7	428e4a6f-d875-4d1c-a545-6915f5491dcd	2026-05-27 12:39:02.343891
\.


--
-- Data for Name: doctor_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor_notes (id, doctor_id, patient_id, note, follow_up_date, created_at) FROM stdin;
7eeb8909-d518-48f4-988b-43ed7e3e69e4	04702959-bc2a-404a-9b75-d1d3a2b2bb1c	428e4a6f-d875-4d1c-a545-6915f5491dcd	good 	2026-06-10	2026-06-04 07:34:44.557
cef46864-c65f-41ac-bb8b-fb2fea808ab3	04702959-bc2a-404a-9b75-d1d3a2b2bb1c	ad40f9e8-636a-4d50-9863-c917bda724b3	Patient has fever and cough	2026-06-10	2026-06-04 17:57:25.36196
\.


--
-- Data for Name: doctor_patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor_patients (id, doctor_id, patient_id, assigned_at) FROM stdin;
7df8c63c-ce6a-409c-bd4e-decc54472a19	04702959-bc2a-404a-9b75-d1d3a2b2bb1c	428e4a6f-d875-4d1c-a545-6915f5491dcd	2026-05-27 12:20:58.841967
780c723d-9cff-4789-b51b-be5f17b20cb9	04702959-bc2a-404a-9b75-d1d3a2b2bb1c	ad40f9e8-636a-4d50-9863-c917bda724b3	2026-06-02 12:56:58.159
\.


--
-- Data for Name: medicine_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicine_logs (id, medicine_id, patient_id, status, taken_at, note) FROM stdin;
0325298b-a626-4d1a-9f7b-5663d8a1f156	b05b1a60-feff-4fd5-a6c5-624384d802f5	428e4a6f-d875-4d1c-a545-6915f5491dcd	TAKEN	2026-05-23 07:09:50.09	Taken after breakfast
54799e9e-b83b-4184-8931-c181c0f8ff7a	6798e203-e244-4081-943d-467525be687d	428e4a6f-d875-4d1c-a545-6915f5491dcd	MISSED	2026-05-27 06:22:14.722	Automatically marked missed
a443ce5a-fbcb-4dfd-8817-14f62193b737	b1c79120-7044-438c-9ccc-a82d787e8cd0	428e4a6f-d875-4d1c-a545-6915f5491dcd	MISSED	2026-05-28 06:04:00.087	Automatically marked missed
dcff572a-0851-46ab-ad0c-8acaf3feec02	6798e203-e244-4081-943d-467525be687d	428e4a6f-d875-4d1c-a545-6915f5491dcd	MISSED	2026-05-28 06:22:00.082	Automatically marked missed
30b0ede9-97f1-410a-aaad-a5cf21c6cb5e	0f847061-51fd-4161-ad4c-df71d1789725	ad40f9e8-636a-4d50-9863-c917bda724b3	TAKEN	2026-06-01 11:55:29.03	\N
16a2b695-0c98-427a-8844-136cccb04e81	1d068fe3-a398-4d12-b1cc-5aea129f4ac6	ad40f9e8-636a-4d50-9863-c917bda724b3	TAKEN	2026-06-01 11:56:29.49	\N
54163970-1e3b-4dd5-b235-75ec5125fa1e	0f847061-51fd-4161-ad4c-df71d1789725	ad40f9e8-636a-4d50-9863-c917bda724b3	TAKEN	2026-06-01 11:59:25.428	\N
7c4ef39e-2c5f-4553-a0ea-b6e4a32ac749	0f847061-51fd-4161-ad4c-df71d1789725	ad40f9e8-636a-4d50-9863-c917bda724b3	TAKEN	2026-06-01 11:59:30.64	\N
02a2dfd3-9b93-4730-866c-9adc793677dc	0f847061-51fd-4161-ad4c-df71d1789725	ad40f9e8-636a-4d50-9863-c917bda724b3	TAKEN	2026-06-02 05:39:17.492	\N
73a43bf4-ab30-47cd-82e0-a8dd56d9b956	b05b1a60-feff-4fd5-a6c5-624384d802f5	428e4a6f-d875-4d1c-a545-6915f5491dcd	MISSED	2026-06-02 05:42:00.08	Automatically marked missed
318b24f7-1c92-4f8c-8580-d8c7918aa7e4	b1c79120-7044-438c-9ccc-a82d787e8cd0	428e4a6f-d875-4d1c-a545-6915f5491dcd	MISSED	2026-06-02 06:04:00.082	Automatically marked missed
29a61a11-7298-4040-8b8f-2536c338b07a	6798e203-e244-4081-943d-467525be687d	428e4a6f-d875-4d1c-a545-6915f5491dcd	MISSED	2026-06-02 06:22:00.345	Automatically marked missed
07a8603f-6c5c-4b09-916b-aa313b34dfea	1d068fe3-a398-4d12-b1cc-5aea129f4ac6	ad40f9e8-636a-4d50-9863-c917bda724b3	MISSED	2026-06-02 07:29:00.337	Automatically marked missed
7f268b03-2e2e-41bf-ae45-6b43d1d7cd10	1d068fe3-a398-4d12-b1cc-5aea129f4ac6	ad40f9e8-636a-4d50-9863-c917bda724b3	MISSED	2026-06-03 07:29:00.066	Automatically marked missed
e1abdf3a-58de-497d-9bce-e591e52b84c4	6a9318f8-d70e-4aa4-8386-f1d63bb9502e	428e4a6f-d875-4d1c-a545-6915f5491dcd	MISSED	2026-06-04 07:05:00.068	Automatically marked missed
7a722866-1ad7-4702-bcd3-0cd64be14ac2	1d068fe3-a398-4d12-b1cc-5aea129f4ac6	ad40f9e8-636a-4d50-9863-c917bda724b3	MISSED	2026-06-04 07:29:00.067	Automatically marked missed
\.


--
-- Data for Name: medicines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicines (id, patient_id, medicine_name, dosage, frequency, reminder_time, start_date, end_date, instructions, created_at) FROM stdin;
b05b1a60-feff-4fd5-a6c5-624384d802f5	428e4a6f-d875-4d1c-a545-6915f5491dcd	Metformin	500mg	Twice Daily	11:12:00	2026-05-21	2026-06-21	After food	2026-05-21 12:26:00.144
b1c79120-7044-438c-9ccc-a82d787e8cd0	428e4a6f-d875-4d1c-a545-6915f5491dcd	Paracetamol	500mg	Once Daily	11:34:00	2026-05-27	2026-06-03	After food	2026-05-27 11:33:00.540173
6798e203-e244-4081-943d-467525be687d	428e4a6f-d875-4d1c-a545-6915f5491dcd	Pan 40	200mg	Once Daily	11:52:00	2026-05-27	2026-05-29	Before food	2026-05-27 11:37:15.987418
0f847061-51fd-4161-ad4c-df71d1789725	ad40f9e8-636a-4d50-9863-c917bda724b3	h	g	i	05:38:00	2026-05-28	2026-06-28	hj	2026-06-01 10:43:58.939
1d068fe3-a398-4d12-b1cc-5aea129f4ac6	ad40f9e8-636a-4d50-9863-c917bda724b3	u	y	h	12:59:00	2026-06-01	2026-06-30	jk	2026-06-01 11:00:11.665
6a9318f8-d70e-4aa4-8386-f1d63bb9502e	428e4a6f-d875-4d1c-a545-6915f5491dcd	hj	vh	4	12:35:00	2026-06-02	2026-06-29	test	2026-06-03 07:06:33.648
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, title, message, is_read, created_at) FROM stdin;
3ab75f26-48c5-4407-9178-2dbd2528d6fe	428e4a6f-d875-4d1c-a545-6915f5491dcd	Medicine Missed	You missed your Pan 40 dose.	f	2026-05-27 06:22:14.745
d1dbfbd1-3f20-4d04-8abd-919afa367ae6	428e4a6f-d875-4d1c-a545-6915f5491dcd	Medicine Missed	You missed your Paracetamol dose.	f	2026-05-28 06:04:00.116
5f5dd9e2-036e-46b6-92e0-0fa5042d7e23	428e4a6f-d875-4d1c-a545-6915f5491dcd	Medicine Missed	You missed your Pan 40 dose.	f	2026-05-28 06:22:00.092
af4ddde2-4c02-40c0-9150-1575b5f0eb12	428e4a6f-d875-4d1c-a545-6915f5491dcd	Medicine Missed	You missed your Metformin dose.	f	2026-06-02 05:42:00.086
c663a7ea-a37d-4fe1-9a3c-ed9f9de09b10	428e4a6f-d875-4d1c-a545-6915f5491dcd	Medicine Missed	You missed your Paracetamol dose.	f	2026-06-02 06:04:00.103
204740ad-fb83-4ab9-8f8e-b72c2d66f9cf	428e4a6f-d875-4d1c-a545-6915f5491dcd	Medicine Missed	You missed your Pan 40 dose.	f	2026-06-02 06:22:00.363
a1c357a1-607a-4a7f-a7c9-d548e797e1d1	ad40f9e8-636a-4d50-9863-c917bda724b3	Medicine Missed	You missed your u dose.	t	2026-06-02 07:29:00.372
ac0e31ee-6169-4151-b603-ef6a0903702b	ad40f9e8-636a-4d50-9863-c917bda724b3	Medicine Missed	You missed your u dose.	f	2026-06-03 07:29:00.081
d7c12f1a-4bb6-4bb2-a29a-66566a8b2084	428e4a6f-d875-4d1c-a545-6915f5491dcd	Medicine Missed	You missed your hj dose.	f	2026-06-04 07:05:00.101
4796bdef-fcee-40c6-a6c6-a482f0b3f9bf	ad40f9e8-636a-4d50-9863-c917bda724b3	Medicine Missed	You missed your u dose.	f	2026-06-04 07:29:00.082
\.


--
-- Data for Name: patient_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_profiles (id, user_id, condition_type, emergency_contact, doctor_name, created_at) FROM stdin;
3e4a2ab4-dd8a-43d5-8d15-dfe2e6cace7a	428e4a6f-d875-4d1c-a545-6915f5491dcd	Diabetes	9999999999	Dr. Mehta	2026-05-21 11:47:06.964
\.


--
-- Data for Name: symptom_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.symptom_notes (id, patient_id, symptom, severity, note, recorded_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, full_name, email, password_hash, role, gender, age, created_at, updated_at) FROM stdin;
428e4a6f-d875-4d1c-a545-6915f5491dcd	Rahul Sharma	rahul@example.com	$2b$10$59LDDW/sSJtx66V9M3wcvenYPlv913igz.hX4697qBkD6jTRHHfqm	PATIENT	\N	\N	2026-05-13 11:00:37.238	2026-05-13 11:00:37.238
04702959-bc2a-404a-9b75-d1d3a2b2bb1c	Dr Sharma	doctor@example.com	$2b$10$quiHerYQix3aqVk037BIIOQRuk/Hj0q.9h1SB5scWCJUC3Nf7Nsge	DOCTOR	\N	\N	2026-05-27 06:49:44.558	2026-05-27 06:49:44.558
83125301-675f-4979-9ad3-9f1ca03196b7	Deepti	deeps@example.com	$2b$10$asKt50ODoBk5STSgwDxK/evSaf3cAdcegzrF0rwEku06wlwO0sH8y	CAREGIVER	\N	\N	2026-05-27 07:06:58.659	2026-05-27 07:06:58.659
ad40f9e8-636a-4d50-9863-c917bda724b3	shamu	shamu@yahoo.com	$2b$10$4avoDhX/Kg7NGyp8oz545.rGZM7mUO4ovGpLAqxxkx1e1X7Ixy1iO	PATIENT	\N	\N	2026-05-27 11:20:51.064	2026-05-27 11:20:51.064
\.


--
-- Data for Name: vitals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vitals (id, patient_id, vital_type, value, recorded_at, note) FROM stdin;
a2a0c8e1-f57e-49f4-8c81-a334b1d92c68	ad40f9e8-636a-4d50-9863-c917bda724b3	BLOOD_PRESSURE	120/80	2026-05-23 07:19:24.194	Morning reading and evening 
5426bffd-2dee-4939-9292-75f78c00087a	ad40f9e8-636a-4d50-9863-c917bda724b3	WEIGHT	80	2026-06-02 07:53:11.477	today 
fc732e43-3134-4bb4-b84d-ec14594e5ea5	ad40f9e8-636a-4d50-9863-c917bda724b3	BLOOD_SUGAR	500	2026-06-02 07:52:53.551	hj
\.


--
-- Data for Name: weekly_summaries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weekly_summaries (id, patient_id, summary_text, adherence_percentage, missed_doses_count, generated_at) FROM stdin;
\.


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: caregiver_patient_links caregiver_patient_links_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver_patient_links
    ADD CONSTRAINT caregiver_patient_links_pkey PRIMARY KEY (id);


--
-- Name: caregiver_patients caregiver_patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver_patients
    ADD CONSTRAINT caregiver_patients_pkey PRIMARY KEY (id);


--
-- Name: doctor_notes doctor_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_notes
    ADD CONSTRAINT doctor_notes_pkey PRIMARY KEY (id);


--
-- Name: doctor_patients doctor_patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_patients
    ADD CONSTRAINT doctor_patients_pkey PRIMARY KEY (id);


--
-- Name: medicine_logs medicine_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine_logs
    ADD CONSTRAINT medicine_logs_pkey PRIMARY KEY (id);


--
-- Name: medicines medicines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicines_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: patient_profiles patient_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_profiles
    ADD CONSTRAINT patient_profiles_pkey PRIMARY KEY (id);


--
-- Name: patient_profiles patient_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_profiles
    ADD CONSTRAINT patient_profiles_user_id_key UNIQUE (user_id);


--
-- Name: symptom_notes symptom_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symptom_notes
    ADD CONSTRAINT symptom_notes_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vitals vitals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vitals
    ADD CONSTRAINT vitals_pkey PRIMARY KEY (id);


--
-- Name: weekly_summaries weekly_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weekly_summaries
    ADD CONSTRAINT weekly_summaries_pkey PRIMARY KEY (id);


--
-- Name: caregiver_patient_links caregiver_patient_links_caregiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver_patient_links
    ADD CONSTRAINT caregiver_patient_links_caregiver_id_fkey FOREIGN KEY (caregiver_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: caregiver_patient_links caregiver_patient_links_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver_patient_links
    ADD CONSTRAINT caregiver_patient_links_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: doctor_notes doctor_notes_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_notes
    ADD CONSTRAINT doctor_notes_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: doctor_notes doctor_notes_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_notes
    ADD CONSTRAINT doctor_notes_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: appointments fk_appointment_doctor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: appointments fk_appointment_patient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: caregiver_patients fk_caregiver; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver_patients
    ADD CONSTRAINT fk_caregiver FOREIGN KEY (caregiver_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: doctor_patients fk_doctor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_patients
    ADD CONSTRAINT fk_doctor FOREIGN KEY (doctor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: caregiver_patients fk_patient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver_patients
    ADD CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: doctor_patients fk_patient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_patients
    ADD CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: medicine_logs medicine_logs_medicine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine_logs
    ADD CONSTRAINT medicine_logs_medicine_id_fkey FOREIGN KEY (medicine_id) REFERENCES public.medicines(id) ON DELETE CASCADE;


--
-- Name: medicine_logs medicine_logs_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine_logs
    ADD CONSTRAINT medicine_logs_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: medicines medicines_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicines_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: patient_profiles patient_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_profiles
    ADD CONSTRAINT patient_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: symptom_notes symptom_notes_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symptom_notes
    ADD CONSTRAINT symptom_notes_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: vitals vitals_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vitals
    ADD CONSTRAINT vitals_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: weekly_summaries weekly_summaries_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weekly_summaries
    ADD CONSTRAINT weekly_summaries_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict nzPfRoCNrhtHz5L24sOeoTdPwbfwl4Oo1kxyeV88xjsoFc5miPJ3fneDfHYN7KE

