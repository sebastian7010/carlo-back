--
-- PostgreSQL database dump
--

\restrict fGHqIsBmOZfR8iNOqtm9yjMDA8PHmRP8jTMCOOccLN8mOLPMpEZ7s6izxle2LVd

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Conversation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Conversation" (
    id text NOT NULL,
    "userId" text NOT NULL,
    title text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Message" (
    id text NOT NULL,
    "conversationId" text NOT NULL,
    role text NOT NULL,
    content text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Miracle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Miracle" (
    id text NOT NULL,
    "saintId" text NOT NULL,
    title text NOT NULL,
    type text,
    date text,
    location text,
    witnesses text,
    approved boolean DEFAULT false NOT NULL,
    details text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: MiracleTranslation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."MiracleTranslation" (
    id text NOT NULL,
    "miracleId" text NOT NULL,
    lang text NOT NULL,
    title text,
    type text,
    date text,
    location text,
    witnesses text,
    details text
);


--
-- Name: Prayer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Prayer" (
    id text NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    category text,
    approved boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    occasion text,
    "saintName" text
);


--
-- Name: PrayerTranslation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PrayerTranslation" (
    id text NOT NULL,
    "prayerId" text NOT NULL,
    lang text NOT NULL,
    title text,
    content text,
    category text,
    "saintName" text,
    occasion text
);


--
-- Name: Saint; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Saint" (
    id text NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    country text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    biography text,
    "feastDay" text,
    "imageUrl" text,
    title text,
    continent text,
    lat double precision,
    lng double precision
);


--
-- Name: SaintTranslation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SaintTranslation" (
    id text NOT NULL,
    "saintId" text NOT NULL,
    lang text NOT NULL,
    name text,
    title text,
    biography text
);


--
-- Name: User; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."User" (
    id text NOT NULL,
    email text NOT NULL,
    "passwordHash" text NOT NULL,
    name text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Data for Name: Conversation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Conversation" (id, "userId", title, "createdAt", "updatedAt") FROM stdin;
cmjz5ahk00001olh8x3zwoxil	cmjz4iafg0000ol8gdepjyvf5	Mi primer chat	2026-01-04 03:01:18.046	2026-01-04 03:01:18.046
a12e2e3e-d9a7-4305-85b9-fe25444f858e	cmjz6i6cq0000ol9kfaltqtbv	Nueva conversación	2026-01-04 03:36:37.643	2026-01-04 03:36:37.643
044b7a64-e72c-41ee-bfd4-401b0eb69214	cmjz714lc0000ol7snfljtxvy	Nueva conversación	2026-01-04 03:50:07.807	2026-01-04 03:50:07.807
cmjz4iafg0000ol8gdepjyvf5	cmjz4iafg0000ol8gdepjyvf5	Nueva conversación	2026-01-04 03:56:07.022	2026-01-04 03:56:07.028
cmjz76t3g0002ol7sc2icf3ji	cmjz4iafg0000ol8gdepjyvf5	Chat desde bash	2026-01-04 03:54:25.613	2026-01-04 03:57:29.439
e53b4c43-d6c0-4235-8032-846adbf32d7e	cmjz83q3l0007ol7sm3l46yyg	Cuéntame un milagro…	2026-01-04 04:20:06.9	2026-01-04 20:12:34.055
cmk068qql000dolz0xm1tbrpr	cmjz4iafg0000ol8gdepjyvf5	Chat creado ahora	2026-01-04 20:15:42.43	2026-01-04 20:15:42.43
\.


--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Message" (id, "conversationId", role, content, "createdAt") FROM stdin;
cmjz62nh70003olh8dltvrfvz	cmjz5ahk00001olh8x3zwoxil	user	hola desde DB	2026-01-04 03:23:12.092
cmjz78zch0004ol7snwftv92n	cmjz4iafg0000ol8gdepjyvf5	user	hola desde bash	2026-01-04 03:56:07.026
cmjz7aqxp0006ol7skuymh9uh	cmjz76t3g0002ol7sc2icf3ji	user	hola desde bash	2026-01-04 03:57:29.437
cmk06464b0001olz0ywaxgone	e53b4c43-d6c0-4235-8032-846adbf32d7e	user	Salmo del día	2026-01-04 20:12:09.084
cmk06484d0003olz0aa1d84kr	e53b4c43-d6c0-4235-8032-846adbf32d7e	user	Salmo del día	2026-01-04 20:12:11.677
cmk0648500005olz0ncbteyom	e53b4c43-d6c0-4235-8032-846adbf32d7e	assistant	Hoy, el Salmo 119:105 es una hermosa elección: "Lámpara es a mis pies tu palabra, y luz para mi camino". Este versículo nos recuerda la guía y la claridad que nos ofrece la Palabra de Dios en nuestras vidas.\n\nSi deseas, puedo ofrecerte una oración para que la reces. Recuerda que esta es solo una orientación general y no sustituye la guía de un sacerdote o director espiritual. ¿Te gustaría que orara por algo en particular?	2026-01-04 20:12:11.7
cmk064lrw0007olz0u6i3kr8w	e53b4c43-d6c0-4235-8032-846adbf32d7e	user	Cuéntame un milagro	2026-01-04 20:12:29.372
cmk064pcq0009olz0y3cuggfs	e53b4c43-d6c0-4235-8032-846adbf32d7e	user	Cuéntame un milagro	2026-01-04 20:12:34.01
cmk064pds000bolz09tjzimt6	e53b4c43-d6c0-4235-8032-846adbf32d7e	assistant	Un milagro muy conocido en la tradición católica es el de la multiplicación de los panes y los peces. Jesús, al ver a una multitud hambrienta, tomó cinco panes y dos peces que un niño ofreció, y los bendijo. Luego, los distribuyó entre la multitud, y milagrosamente, todos comieron y hubo sobras. Este milagro no solo muestra el poder de Jesús, sino también su compasión y el valor de compartir. \n\nRecuerda que siempre es importante buscar la guía de un sacerdote o director espiritual para profundizar en estos temas.	2026-01-04 20:12:34.048
\.


--
-- Data for Name: Miracle; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Miracle" (id, "saintId", title, type, date, location, witnesses, approved, details, "createdAt", "updatedAt") FROM stdin;
cmjxqfvxy0002olnk0kkx9nfe	cmjxpju2f0000olnkeayalmoi	niño brasil	curacion	10/12/2020	brasil	su mamá	f	curo a un niño en brasil	2026-01-03 03:17:49.552	2026-01-03 03:17:49.552
\.


--
-- Data for Name: MiracleTranslation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."MiracleTranslation" (id, "miracleId", lang, title, type, date, location, witnesses, details) FROM stdin;
\.


--
-- Data for Name: Prayer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Prayer" (id, title, content, category, approved, "createdAt", "updatedAt", occasion, "saintName") FROM stdin;
cmjxrwpzn0000olrseugy03f1	codigo	ojala funcione el codigo	codigo	t	2026-01-03 03:58:54.61	2026-01-03 03:58:54.61	\N	\N
\.


--
-- Data for Name: PrayerTranslation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PrayerTranslation" (id, "prayerId", lang, title, content, category, "saintName", occasion) FROM stdin;
\.


--
-- Data for Name: Saint; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Saint" (id, slug, name, country, "createdAt", "updatedAt", biography, "feastDay", "imageUrl", title, continent, lat, lng) FROM stdin;
cmjxpju2f0000olnkeayalmoi	carlo-maria-antonio-acutis	Carlo María Antonio Acutis	Italia	2026-01-03 02:52:54.135	2026-01-03 02:52:54.135	Carlo Acutis nació un 3 de Mayo de 1991 en Londer Reino Unido, en una familia acomodada pero desde muy pequeño mostró una sensibilidad espiritual fuera de lo comun. Aunque sus padres no eran muy practicantes al inicio, \nCarlo los fue acercando a la fe con su ejemplo, fue criado en .\n\nDesed niño tuvo una devoción profunda a la Eucaristia , a la Virgen María y a el Ángel de la Guarda  a los 7 años, tras hacer su primera comunión Carlo decía: \n"Estar siempre unido a Jesús: ese es mi plan de vida".\nFue un joven adolecente normal:\n\njugaba videojuegos \nle gustaba el fútbol \namaba la informatica \nescychaba música \nvestia jeans y tenis \n\n-Fechas importantes\nNacio un 3 de Mayo de 1991 en Londres, Reino unido \nHizo su primera comunión a los 7 años \nFallecio unn 12 de Octubre de 2006 (a los 15 años)	12/12	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSe7rnEz4qVXWlBdqb2jju4cPrXCo_GzCSk0w&s	Santo	Europa	43.06961445810709	12.61435149860022
cmk0b9syr0000olfw7onybv3m	amable	amable	colombia	2026-01-04 22:36:30.049	2026-01-04 22:36:30.049	amable amable amable amable amable amable amable amable	12/12	https://files.worldwildlife.org/wwfcmsprod/images/HERO_Penguins_Antarctica/hero_full/29o7jhrgam_Medium_WW267491.jpg	amable	america	1	1
\.


--
-- Data for Name: SaintTranslation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."SaintTranslation" (id, "saintId", lang, name, title, biography) FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."User" (id, email, "passwordHash", name, "createdAt", "updatedAt") FROM stdin;
cmjz4iafg0000ol8gdepjyvf5	test@a.com	$2b$10$EZQAgCdrSZzl3oIWgTfhOu88j1YcXFV9bAinMQb/a7v93Wj6s6sSa	Test	2026-01-04 02:39:22.444	2026-01-04 02:39:22.444
cmjz551g40001ol8gicespa89	testa@gmail.com	$2b$10$QH0oP2idRN5dPAg0dRhNWel0T9sR4lKa.64qLjg0Vu5UTImYgJ/Ji	mellon	2026-01-04 02:57:03.893	2026-01-04 02:57:03.893
cmjz6i6cq0000ol9kfaltqtbv	apolo@gmail.com	$2b$10$oGZ.s2qF7ykHCVRtie6uXenWX/3wIDzjgIEKxeDhZDB9qlRa0fQFW	apolo	2026-01-04 03:35:16.395	2026-01-04 03:35:16.395
cmjz714lc0000ol7snfljtxvy	san@gmail.com	$2b$10$6emFG.xVIkhg.42CP.lmpO6aZjGJO5eHtmY59uvlUiqgpUQke7Usq	san	2026-01-04 03:50:00.576	2026-01-04 03:50:00.576
cmjz83q3l0007ol7sm3l46yyg	son@gmail.com	$2b$10$hnLy5Kve.pjIeoD5EFoJDOfxKB/XSnlPMj228XcdaHkNKbqroVSUW	son	2026-01-04 04:20:01.377	2026-01-04 04:20:01.377
cmjz8xvz00000oll4xi4k6jfu	sol@gamil.com	$2b$10$eqKX.ZXOy0brmlDDzN8p0uj7Fn7/X1i4kUEjg6MxNzZAWZoxnHtGm	sol	2026-01-04 04:43:28.668	2026-01-04 04:43:28.668
cmjz8y7zq0001oll4307pnxl1	sot@gamil.com	$2b$10$uMikLEo00rlEasAamaekHuhHDa.ey5I33CGzXj8nscLPb.7o9OdBu	sot	2026-01-04 04:43:44.246	2026-01-04 04:43:44.246
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
2b9f737f-c1c2-4f17-8b5c-29fc22e96710	b25bfcda8669d01317b1bf9aabfba3a534c92156605c13fbc32653dfb51d726b	2025-12-30 21:22:00.601009-05	20251216214935_init	\N	\N	2025-12-30 21:22:00.586042-05	1
15f7a9d7-7217-4e97-a239-db132e604ad7	ac54a296a6ac860c61e397b7f7726c8ef7103014c9c1e5a291dc77d025b09140	2025-12-30 21:22:00.607606-05	20251218201511_add_saint_fields	\N	\N	2025-12-30 21:22:00.602189-05	1
16a8e5c3-5486-4cf9-ab9c-1b617f61864d	962067fcbd267453483c962971a99463486de50718f47cc0fb0c1a1a02dad500	2025-12-30 21:22:00.622578-05	20251219035149_add_miracles	\N	\N	2025-12-30 21:22:00.608543-05	1
182c8d6a-c819-448f-b7b5-bbd5044bd882	681f0d542bb614550cc05bffe2f2fc27da1a8823c1ac2aaff5d73b01cc75783a	2025-12-30 21:22:00.634779-05	20251220083904_add_prayers	\N	\N	2025-12-30 21:22:00.624237-05	1
72e2fa76-e542-424c-b284-762cf548285f	6b78dbbd033360f0ea127d89bf5ce0c656c5d6807808330aaea017149cc35dd8	2025-12-30 21:22:00.640968-05	20251220114509_add_prayer_saint_occasion	\N	\N	2025-12-30 21:22:00.635916-05	1
47e699f4-5968-471a-8690-f197e945e337	c695d63743557aa4e1af7edb1a25666daecd9d391ed86c97867dcf1de199c7be	2025-12-30 21:22:00.646096-05	20251222105648_add_saint_location	\N	\N	2025-12-30 21:22:00.642522-05	1
83e0e616-faa6-454c-8704-025acae01b23	0ad425b6731cffed4932dc005e5c0d5ffb7143f41f8417dc20c9a3443afa7e48	2025-12-30 21:22:00.694978-05	20251223093007_add_translations_tables	\N	\N	2025-12-30 21:22:00.646897-05	1
\.


--
-- Name: Conversation Conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_pkey" PRIMARY KEY (id);


--
-- Name: Message Message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_pkey" PRIMARY KEY (id);


--
-- Name: MiracleTranslation MiracleTranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MiracleTranslation"
    ADD CONSTRAINT "MiracleTranslation_pkey" PRIMARY KEY (id);


--
-- Name: Miracle Miracle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Miracle"
    ADD CONSTRAINT "Miracle_pkey" PRIMARY KEY (id);


--
-- Name: PrayerTranslation PrayerTranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PrayerTranslation"
    ADD CONSTRAINT "PrayerTranslation_pkey" PRIMARY KEY (id);


--
-- Name: Prayer Prayer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Prayer"
    ADD CONSTRAINT "Prayer_pkey" PRIMARY KEY (id);


--
-- Name: SaintTranslation SaintTranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SaintTranslation"
    ADD CONSTRAINT "SaintTranslation_pkey" PRIMARY KEY (id);


--
-- Name: Saint Saint_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Saint"
    ADD CONSTRAINT "Saint_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Message_conversationId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Message_conversationId_idx" ON public."Message" USING btree ("conversationId");


--
-- Name: MiracleTranslation_lang_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "MiracleTranslation_lang_idx" ON public."MiracleTranslation" USING btree (lang);


--
-- Name: MiracleTranslation_miracleId_lang_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "MiracleTranslation_miracleId_lang_key" ON public."MiracleTranslation" USING btree ("miracleId", lang);


--
-- Name: Miracle_saintId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Miracle_saintId_idx" ON public."Miracle" USING btree ("saintId");


--
-- Name: PrayerTranslation_lang_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "PrayerTranslation_lang_idx" ON public."PrayerTranslation" USING btree (lang);


--
-- Name: PrayerTranslation_prayerId_lang_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "PrayerTranslation_prayerId_lang_key" ON public."PrayerTranslation" USING btree ("prayerId", lang);


--
-- Name: SaintTranslation_lang_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "SaintTranslation_lang_idx" ON public."SaintTranslation" USING btree (lang);


--
-- Name: SaintTranslation_saintId_lang_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "SaintTranslation_saintId_lang_key" ON public."SaintTranslation" USING btree ("saintId", lang);


--
-- Name: Saint_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Saint_slug_key" ON public."Saint" USING btree (slug);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: Conversation Conversation_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_conversationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES public."Conversation"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MiracleTranslation MiracleTranslation_miracleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MiracleTranslation"
    ADD CONSTRAINT "MiracleTranslation_miracleId_fkey" FOREIGN KEY ("miracleId") REFERENCES public."Miracle"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Miracle Miracle_saintId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Miracle"
    ADD CONSTRAINT "Miracle_saintId_fkey" FOREIGN KEY ("saintId") REFERENCES public."Saint"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PrayerTranslation PrayerTranslation_prayerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PrayerTranslation"
    ADD CONSTRAINT "PrayerTranslation_prayerId_fkey" FOREIGN KEY ("prayerId") REFERENCES public."Prayer"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SaintTranslation SaintTranslation_saintId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SaintTranslation"
    ADD CONSTRAINT "SaintTranslation_saintId_fkey" FOREIGN KEY ("saintId") REFERENCES public."Saint"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict fGHqIsBmOZfR8iNOqtm9yjMDA8PHmRP8jTMCOOccLN8mOLPMpEZ7s6izxle2LVd

