--
-- PostgreSQL database dump
--

\restrict YadcGjRkTgXReZEJZ2gCqmenS3QH7NHHtgDfu0FwcY4lgtbm9DykjI9LlleJjv8

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2026-03-16 17:41:56

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
-- TOC entry 864 (class 1247 OID 33330)
-- Name: recruitment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.recruitment_status AS ENUM (
    'OPEN',
    'IN_PROGRESS',
    'COMPLETED'
);


ALTER TYPE public.recruitment_status OWNER TO postgres;

--
-- TOC entry 861 (class 1247 OID 33316)
-- Name: task_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.task_status AS ENUM (
    'NEW',
    'IN_PROGRESS',
    'ASSIGNED',
    'RECRUITMENT_PENDING',
    'CANCELLED',
    'CLOSED'
);


ALTER TYPE public.task_status OWNER TO postgres;

--
-- TOC entry 858 (class 1247 OID 33308)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'STORE_MANAGER',
    'OFFICE_MANAGER',
    'HR_SPECIALIST'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 33470)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 33422)
-- Name: recruitment_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recruitment_requests (
    id integer NOT NULL,
    task_id integer NOT NULL,
    hr_specialist_id integer,
    status public.recruitment_status DEFAULT 'OPEN'::public.recruitment_status,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamp without time zone
);


ALTER TABLE public.recruitment_requests OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 33421)
-- Name: recruitment_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recruitment_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recruitment_requests_id_seq OWNER TO postgres;

--
-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 225
-- Name: recruitment_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recruitment_requests_id_seq OWNED BY public.recruitment_requests.id;


--
-- TOC entry 222 (class 1259 OID 33382)
-- Name: specialists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specialists (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    specialization character varying(100),
    experience_years integer DEFAULT 0,
    has_active_contract boolean DEFAULT true,
    phone character varying(20),
    email character varying(100),
    added_by_hr_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.specialists OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 33381)
-- Name: specialists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specialists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.specialists_id_seq OWNER TO postgres;

--
-- TOC entry 4900 (class 0 OID 0)
-- Dependencies: 221
-- Name: specialists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specialists_id_seq OWNED BY public.specialists.id;


--
-- TOC entry 224 (class 1259 OID 33397)
-- Name: task_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_assignments (
    id integer NOT NULL,
    task_id integer NOT NULL,
    specialist_id integer NOT NULL,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    assigned_by integer
);


ALTER TABLE public.task_assignments OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 33396)
-- Name: task_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_assignments_id_seq OWNER TO postgres;

--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 223
-- Name: task_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_assignments_id_seq OWNED BY public.task_assignments.id;


--
-- TOC entry 228 (class 1259 OID 33443)
-- Name: task_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_history (
    id integer NOT NULL,
    task_id integer NOT NULL,
    user_id integer,
    action_description text NOT NULL,
    old_status public.task_status,
    new_status public.task_status,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.task_history OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 33442)
-- Name: task_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_history_id_seq OWNER TO postgres;

--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 227
-- Name: task_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_history_id_seq OWNED BY public.task_history.id;


--
-- TOC entry 220 (class 1259 OID 33354)
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    store_manager_id integer NOT NULL,
    office_manager_id integer,
    title character varying(255) NOT NULL,
    description text,
    start_date date NOT NULL,
    end_date date NOT NULL,
    requirements text,
    status public.task_status DEFAULT 'NEW'::public.task_status,
    cancellation_reason text,
    closed_by integer,
    closed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_dates CHECK ((end_date >= start_date))
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 33353)
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasks_id_seq OWNER TO postgres;

--
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 219
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- TOC entry 218 (class 1259 OID 33338)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    birth_date date,
    phone character varying(20),
    role public.user_role NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 33337)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4690 (class 2604 OID 33425)
-- Name: recruitment_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_requests ALTER COLUMN id SET DEFAULT nextval('public.recruitment_requests_id_seq'::regclass);


--
-- TOC entry 4684 (class 2604 OID 33385)
-- Name: specialists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialists ALTER COLUMN id SET DEFAULT nextval('public.specialists_id_seq'::regclass);


--
-- TOC entry 4688 (class 2604 OID 33400)
-- Name: task_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_assignments ALTER COLUMN id SET DEFAULT nextval('public.task_assignments_id_seq'::regclass);


--
-- TOC entry 4693 (class 2604 OID 33446)
-- Name: task_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_history ALTER COLUMN id SET DEFAULT nextval('public.task_history_id_seq'::regclass);


--
-- TOC entry 4680 (class 2604 OID 33357)
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- TOC entry 4676 (class 2604 OID 33341)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4891 (class 0 OID 33422)
-- Dependencies: 226
-- Data for Name: recruitment_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.recruitment_requests (id, task_id, hr_specialist_id, status, created_at, completed_at) VALUES (1, 2, 1, 'IN_PROGRESS', '2026-03-16 17:34:59.123326', NULL);
INSERT INTO public.recruitment_requests (id, task_id, hr_specialist_id, status, created_at, completed_at) VALUES (2, 1, 1, 'COMPLETED', '2026-03-16 17:34:59.123326', '2024-01-14 15:00:00');


--
-- TOC entry 4887 (class 0 OID 33382)
-- Dependencies: 222
-- Data for Name: specialists; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (1, 'Андрей', 'Морозов', 'Мерчандайзер', 3, true, '+7-901-111-11-11', 'morozov.a@specialist.ru', 1, '2026-03-16 17:34:59.123326');
INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (2, 'Наталья', 'Лебедева', 'Грузчик', 2, true, '+7-901-222-22-22', 'lebedeva.n@specialist.ru', 1, '2026-03-16 17:34:59.123326');
INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (3, 'Сергей', 'Павлов', 'Уборщик', 5, true, '+7-901-333-33-33', 'pavlov.s@specialist.ru', 2, '2026-03-16 17:34:59.123326');
INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (4, 'Екатерина', 'Виноградова', 'Промоутер', 1, true, '+7-901-444-44-44', 'vinogradova.e@specialist.ru', 1, '2026-03-16 17:34:59.123326');
INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (5, 'Михаил', 'Зайцев', 'Мерчандайзер', 4, true, '+7-901-555-55-55', 'zaycev.m@specialist.ru', 2, '2026-03-16 17:34:59.123326');
INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (6, 'Анна', 'Соколова', 'Кассир', 6, true, '+7-901-666-66-66', 'sokolova.a@specialist.ru', 1, '2026-03-16 17:34:59.123326');
INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (7, 'Виктор', 'Кузнецов', 'Грузчик', 3, false, '+7-901-777-77-77', 'kuznetsov.v@specialist.ru', 2, '2026-03-16 17:34:59.123326');
INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (8, 'Ольга', 'Попова', 'Уборщик', 2, true, '+7-901-888-88-88', 'popova.o@specialist.ru', 1, '2026-03-16 17:34:59.123326');
INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (9, 'Денис', 'Федоров', 'Промоутер', 1, true, '+7-901-999-99-99', 'fedorov.d@specialist.ru', 2, '2026-03-16 17:34:59.123326');
INSERT INTO public.specialists (id, first_name, last_name, specialization, experience_years, has_active_contract, phone, email, added_by_hr_id, created_at) VALUES (10, 'Татьяна', 'Орлова', 'Мерчандайзер', 5, true, '+7-902-111-11-11', 'orlova.t@specialist.ru', 1, '2026-03-16 17:34:59.123326');


--
-- TOC entry 4889 (class 0 OID 33397)
-- Dependencies: 224
-- Data for Name: task_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.task_assignments (id, task_id, specialist_id, assigned_at, assigned_by) VALUES (1, 1, 1, '2026-03-16 17:34:59.123326', 1);
INSERT INTO public.task_assignments (id, task_id, specialist_id, assigned_at, assigned_by) VALUES (2, 1, 5, '2026-03-16 17:34:59.123326', 1);
INSERT INTO public.task_assignments (id, task_id, specialist_id, assigned_at, assigned_by) VALUES (3, 1, 10, '2026-03-16 17:34:59.123326', 1);
INSERT INTO public.task_assignments (id, task_id, specialist_id, assigned_at, assigned_by) VALUES (4, 3, 2, '2026-03-16 17:34:59.123326', 2);
INSERT INTO public.task_assignments (id, task_id, specialist_id, assigned_at, assigned_by) VALUES (5, 3, 8, '2026-03-16 17:34:59.123326', 2);
INSERT INTO public.task_assignments (id, task_id, specialist_id, assigned_at, assigned_by) VALUES (6, 6, 6, '2026-03-16 17:34:59.123326', 2);
INSERT INTO public.task_assignments (id, task_id, specialist_id, assigned_at, assigned_by) VALUES (7, 6, 3, '2026-03-16 17:34:59.123326', 2);


--
-- TOC entry 4893 (class 0 OID 33443)
-- Dependencies: 228
-- Data for Name: task_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (1, 1, 1, 'Задание создано управляющим магазина', NULL, 'NEW', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (2, 1, 1, 'Задание отправлено в центральный офис', 'NEW', 'IN_PROGRESS', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (3, 1, 1, 'Создана заявка на подбор персонала', 'IN_PROGRESS', 'RECRUITMENT_PENDING', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (4, 1, 1, 'Специалисты найдены и назначены', 'RECRUITMENT_PENDING', 'ASSIGNED', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (5, 1, 1, 'Задание выполнено и закрыто', 'ASSIGNED', 'CLOSED', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (6, 2, 1, 'Задание создано управляющим магази', NULL, 'NEW', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (7, 2, 1, 'Задание отправлено в центральный офис', 'NEW', 'IN_PROGRESS', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (8, 2, 1, 'Требуется подбор персонала, создана заявка HR', 'IN_PROGRESS', 'RECRUITMENT_PENDING', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (9, 3, 2, 'Задание создано управляющим магази', NULL, 'NEW', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (10, 3, 2, 'Задание отправлено в центральный офис', 'NEW', 'IN_PROGRESS', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (11, 3, 2, 'Специалисты назначены на задание', 'IN_PROGRESS', 'ASSIGNED', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (12, 4, 2, 'Задание создано управляющим магази', NULL, 'NEW', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (13, 4, 2, 'Задание отправлено в центральный офис', 'NEW', 'IN_PROGRESS', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (14, 4, 2, 'Задание отменено по причине изменения планов', 'IN_PROGRESS', 'CANCELLED', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (15, 5, 3, 'Задание создано управляющим магази', NULL, 'NEW', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (16, 6, 3, 'Задание создано управляющим магази', NULL, 'NEW', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (17, 6, 3, 'Задание отправлено в центральный офис', 'NEW', 'IN_PROGRESS', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (18, 7, 1, 'Задание создано управляющим магази', NULL, 'NEW', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (19, 7, 1, 'Задание отправлено в центральный офис', 'NEW', 'IN_PROGRESS', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (20, 7, 2, 'Специалисты назначены на задание', 'IN_PROGRESS', 'ASSIGNED', '2026-03-16 17:34:59.123326');
INSERT INTO public.task_history (id, task_id, user_id, action_description, old_status, new_status, changed_at) VALUES (21, 7, 2, 'Задание выполнено и закрыто', 'ASSIGNED', 'CLOSED', '2026-03-16 17:34:59.123326');


--
-- TOC entry 4885 (class 0 OID 33354)
-- Dependencies: 220
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tasks (id, store_manager_id, office_manager_id, title, description, start_date, end_date, requirements, status, cancellation_reason, closed_by, closed_at, created_at, updated_at) VALUES (1, 1, 1, 'Выкладка товара', 'Необходимо выложить новую коллекцию осенней одежды в торговом зале', '2024-01-15', '2024-01-17', 'Опыт работы мерчандайзером от 2 лет, внимательность к деталям', 'CLOSED', NULL, 1, '2024-01-17 18:00:00', '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.tasks (id, store_manager_id, office_manager_id, title, description, start_date, end_date, requirements, status, cancellation_reason, closed_by, closed_at, created_at, updated_at) VALUES (2, 1, 1, 'Генеральная уборка', 'Полная уборка склада после инвентаризации', '2024-01-20', '2024-01-21', 'Физическая выносливость, наличие спецодежды', 'RECRUITMENT_PENDING', NULL, NULL, NULL, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.tasks (id, store_manager_id, office_manager_id, title, description, start_date, end_date, requirements, status, cancellation_reason, closed_by, closed_at, created_at, updated_at) VALUES (3, 2, 2, 'Разгрузка товара', 'Разгрузка фур с товаром в ночное время', '2024-01-22', '2024-01-22', 'Опыт работы грузчиком, возможность работы в ночную смену', 'ASSIGNED', NULL, NULL, NULL, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.tasks (id, store_manager_id, office_manager_id, title, description, start_date, end_date, requirements, status, cancellation_reason, closed_by, closed_at, created_at, updated_at) VALUES (4, 2, NULL, 'Промо-акция', 'Раздача листовок у входа в магазин', '2024-01-25', '2024-01-26', 'Коммуникабельность, презентабельный внешний вид', 'CANCELLED', 'Активность перенесена на следующий месяц', NULL, NULL, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.tasks (id, store_manager_id, office_manager_id, title, description, start_date, end_date, requirements, status, cancellation_reason, closed_by, closed_at, created_at, updated_at) VALUES (5, 3, NULL, 'Монтаж торгового оборудования', 'Установка новых стеллажей в зоне электроники', '2024-02-01', '2024-02-03', 'Опыт монтажных работ, наличие инструментов', 'NEW', NULL, NULL, NULL, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.tasks (id, store_manager_id, office_manager_id, title, description, start_date, end_date, requirements, status, cancellation_reason, closed_by, closed_at, created_at, updated_at) VALUES (6, 3, 2, 'Инвентаризация', 'Полная инвентаризация товарных остатков', '2024-02-05', '2024-02-07', 'Внимательность, опыт работы с ТСД', 'IN_PROGRESS', NULL, NULL, NULL, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.tasks (id, store_manager_id, office_manager_id, title, description, start_date, end_date, requirements, status, cancellation_reason, closed_by, closed_at, created_at, updated_at) VALUES (7, 1, 2, 'Навеска ценников', 'Замена ценников на всю товарную матрицу', '2024-01-10', '2024-01-12', 'Аккуратность, скорость работы', 'CLOSED', NULL, 2, '2024-01-12 20:00:00', '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');


--
-- TOC entry 4883 (class 0 OID 33338)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, birth_date, phone, role, is_active, created_at, updated_at) VALUES (1, 'store_mgr_1', 'ivanov.p@shop1.company.ru', '$2b$12$hash123', 'Пётр', 'Иванов', '1985-03-15', '+7-900-111-11-11', 'STORE_MANAGER', true, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, birth_date, phone, role, is_active, created_at, updated_at) VALUES (2, 'store_mgr_2', 'petrova.m@shop2.company.ru', '$2b$12$hash456', 'Мария', 'Петрова', '1990-07-22', '+7-900-222-22-22', 'STORE_MANAGER', true, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, birth_date, phone, role, is_active, created_at, updated_at) VALUES (3, 'store_mgr_3', 'sidorov.a@shop3.company.ru', '$2b$12$hash789', 'Алексей', 'Сидоров', '1988-11-30', '+7-900-333-33-33', 'STORE_MANAGER', true, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, birth_date, phone, role, is_active, created_at, updated_at) VALUES (4, 'office_mgr_1', 'volkova.e@office.company.ru', '$2b$12$hash101', 'Елена', 'Волкова', '1987-05-10', '+7-900-444-44-44', 'OFFICE_MANAGER', true, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, birth_date, phone, role, is_active, created_at, updated_at) VALUES (5, 'office_mgr_2', 'kozlov.d@office.company.ru', '$2b$12$hash102', 'Дмитрий', 'Козлов', '1983-09-18', '+7-900-555-55-55', 'OFFICE_MANAGER', true, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, birth_date, phone, role, is_active, created_at, updated_at) VALUES (6, 'hr_1', 'smirnova.o@hr.company.ru', '$2b$12$hash201', 'Ольга', 'Смирнова', '1991-02-25', '+7-900-666-66-66', 'HR_SPECIALIST', true, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');
INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, birth_date, phone, role, is_active, created_at, updated_at) VALUES (7, 'hr_2', 'novikov.i@hr.company.ru', '$2b$12$hash202', 'Игорь', 'Новиков', '1989-12-05', '+7-900-777-77-77', 'HR_SPECIALIST', true, '2026-03-16 17:34:59.123326', '2026-03-16 17:34:59.123326');


--
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 225
-- Name: recruitment_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recruitment_requests_id_seq', 2, true);


--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 221
-- Name: specialists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specialists_id_seq', 10, true);


--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 223
-- Name: task_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_assignments_id_seq', 7, true);


--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 227
-- Name: task_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_history_id_seq', 21, true);


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 219
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_id_seq', 7, true);


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- TOC entry 4718 (class 2606 OID 33429)
-- Name: recruitment_requests recruitment_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_requests
    ADD CONSTRAINT recruitment_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 4720 (class 2606 OID 33431)
-- Name: recruitment_requests recruitment_requests_task_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_requests
    ADD CONSTRAINT recruitment_requests_task_id_key UNIQUE (task_id);


--
-- TOC entry 4710 (class 2606 OID 33390)
-- Name: specialists specialists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialists
    ADD CONSTRAINT specialists_pkey PRIMARY KEY (id);


--
-- TOC entry 4713 (class 2606 OID 33403)
-- Name: task_assignments task_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 4715 (class 2606 OID 33405)
-- Name: task_assignments task_assignments_task_id_specialist_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_task_id_specialist_id_key UNIQUE (task_id, specialist_id);


--
-- TOC entry 4723 (class 2606 OID 33451)
-- Name: task_history task_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4706 (class 2606 OID 33365)
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 4697 (class 2606 OID 33352)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4699 (class 2606 OID 33348)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4701 (class 2606 OID 33350)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4716 (class 1259 OID 33467)
-- Name: idx_recruitment_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recruitment_status ON public.recruitment_requests USING btree (status);


--
-- TOC entry 4707 (class 1259 OID 33465)
-- Name: idx_specialists_contract; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_specialists_contract ON public.specialists USING btree (has_active_contract);


--
-- TOC entry 4708 (class 1259 OID 33466)
-- Name: idx_specialists_spec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_specialists_spec ON public.specialists USING btree (specialization);


--
-- TOC entry 4711 (class 1259 OID 33468)
-- Name: idx_task_assignments_task; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_assignments_task ON public.task_assignments USING btree (task_id);


--
-- TOC entry 4721 (class 1259 OID 33469)
-- Name: idx_task_history_task; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_history_task ON public.task_history USING btree (task_id);


--
-- TOC entry 4702 (class 1259 OID 33463)
-- Name: idx_tasks_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_dates ON public.tasks USING btree (start_date, end_date);


--
-- TOC entry 4703 (class 1259 OID 33462)
-- Name: idx_tasks_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_status ON public.tasks USING btree (status);


--
-- TOC entry 4704 (class 1259 OID 33464)
-- Name: idx_tasks_store_manager; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_store_manager ON public.tasks USING btree (store_manager_id);


--
-- TOC entry 4736 (class 2620 OID 33472)
-- Name: tasks update_tasks_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4735 (class 2620 OID 33471)
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4731 (class 2606 OID 33437)
-- Name: recruitment_requests recruitment_requests_hr_specialist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_requests
    ADD CONSTRAINT recruitment_requests_hr_specialist_id_fkey FOREIGN KEY (hr_specialist_id) REFERENCES public.users(id);


--
-- TOC entry 4732 (class 2606 OID 33432)
-- Name: recruitment_requests recruitment_requests_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_requests
    ADD CONSTRAINT recruitment_requests_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 4727 (class 2606 OID 33391)
-- Name: specialists specialists_added_by_hr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialists
    ADD CONSTRAINT specialists_added_by_hr_id_fkey FOREIGN KEY (added_by_hr_id) REFERENCES public.users(id);


--
-- TOC entry 4728 (class 2606 OID 33416)
-- Name: task_assignments task_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- TOC entry 4729 (class 2606 OID 33411)
-- Name: task_assignments task_assignments_specialist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_specialist_id_fkey FOREIGN KEY (specialist_id) REFERENCES public.specialists(id);


--
-- TOC entry 4730 (class 2606 OID 33406)
-- Name: task_assignments task_assignments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 4733 (class 2606 OID 33452)
-- Name: task_history task_history_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- TOC entry 4734 (class 2606 OID 33457)
-- Name: task_history task_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4724 (class 2606 OID 33376)
-- Name: tasks tasks_closed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_closed_by_fkey FOREIGN KEY (closed_by) REFERENCES public.users(id);


--
-- TOC entry 4725 (class 2606 OID 33371)
-- Name: tasks tasks_office_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_office_manager_id_fkey FOREIGN KEY (office_manager_id) REFERENCES public.users(id);


--
-- TOC entry 4726 (class 2606 OID 33366)
-- Name: tasks tasks_store_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_store_manager_id_fkey FOREIGN KEY (store_manager_id) REFERENCES public.users(id);


-- Completed on 2026-03-16 17:41:56

--
-- PostgreSQL database dump complete
--

\unrestrict YadcGjRkTgXReZEJZ2gCqmenS3QH7NHHtgDfu0FwcY4lgtbm9DykjI9LlleJjv8

