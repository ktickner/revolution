--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: event_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_logs (
    id integer NOT NULL,
    user_id integer,
    event_id integer,
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT event_logs_description_check CHECK ((length(description) > 0))
);


--
-- Name: event_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_logs_id_seq OWNED BY event_logs.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    creator_id integer,
    location_id integer,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    over_eighteen boolean DEFAULT false NOT NULL,
    private boolean DEFAULT false NOT NULL,
    cancelled boolean DEFAULT false NOT NULL,
    start_datetime timestamp with time zone NOT NULL,
    end_datetime timestamp with time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT events_check CHECK ((end_datetime > start_datetime)),
    CONSTRAINT events_description_check CHECK ((length(description) > 0)),
    CONSTRAINT events_name_check CHECK ((length((name)::text) > 0))
);


--
-- Name: events_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_genres (
    event_id integer NOT NULL,
    genre_name character varying(50) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: events_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_images (
    event_id integer,
    image_id integer,
    feature_image boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE images (
    id integer NOT NULL,
    creator_id integer,
    path character varying(255) NOT NULL,
    removed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT images_path_check CHECK ((length((path)::text) > 0))
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lat numeric(10,8) NOT NULL,
    lng numeric(11,8) NOT NULL
);


--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_profiles (
    user_id integer NOT NULL,
    location_id integer,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    birth_date timestamp without time zone NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT user_profiles_birth_date_check CHECK ((birth_date > '1900-01-01 00:00:01'::timestamp without time zone)),
    CONSTRAINT user_profiles_first_name_check CHECK ((length((first_name)::text) > 0)),
    CONSTRAINT user_profiles_last_name_check CHECK ((length((last_name)::text) > 0))
);


--
-- Name: feed_events; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW feed_events AS
 SELECT e.id AS event_id,
    e.name AS event_name,
    e.creator_id,
    e.description AS event_description,
    e.over_eighteen,
    e.private,
    e.start_datetime AS event_start,
    e.end_datetime AS event_end,
    i.path AS feature_image_path,
    l.lat AS event_lat,
    l.lng AS event_lng,
    up.first_name AS creator_first_name,
    up.last_name AS creator_last_name
   FROM ((((events e
     LEFT JOIN events_images ei ON (((e.id = ei.event_id) AND (ei.feature_image = true))))
     LEFT JOIN images i ON (((ei.image_id = i.id) AND (i.removed = false))))
     LEFT JOIN locations l ON ((e.location_id = l.id)))
     LEFT JOIN user_profiles up ON ((e.creator_id = up.user_id)))
  WHERE (e.start_datetime > now());


--
-- Name: friend_connections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friend_connections (
    user_id integer NOT NULL,
    friend_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genres (
    name character varying(50) NOT NULL,
    creator_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT genres_name_check CHECK ((length((name)::text) > 0))
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE images_id_seq OWNED BY images.id;


--
-- Name: location_components; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE location_components (
    id integer NOT NULL,
    location_id integer,
    component_type character varying(50) NOT NULL,
    value character varying(100) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT location_components_component_type_check CHECK (((length((component_type)::text) > 0) AND (length((component_type)::text) < 51))),
    CONSTRAINT location_components_value_check CHECK (((length((value)::text) > 0) AND (length((value)::text) < 101)))
);


--
-- Name: location_components_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE location_components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE location_components_id_seq OWNED BY location_components.id;


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: user_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_logs (
    id integer NOT NULL,
    user_id integer,
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT user_logs_description_check CHECK ((length(description) > 0))
);


--
-- Name: user_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_logs_id_seq OWNED BY user_logs.id;


--
-- Name: user_profile_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_profile_images (
    user_id integer NOT NULL,
    image_id integer NOT NULL,
    current_profile_image boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_removed_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_removed_events (
    user_id integer NOT NULL,
    event_id integer NOT NULL,
    removed boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_genres (
    user_id integer NOT NULL,
    genre_name character varying(50) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_logs ALTER COLUMN id SET DEFAULT nextval('event_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY images ALTER COLUMN id SET DEFAULT nextval('images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY location_components ALTER COLUMN id SET DEFAULT nextval('location_components_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_logs ALTER COLUMN id SET DEFAULT nextval('user_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: event_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_genres
    ADD CONSTRAINT event_genres_pkey PRIMARY KEY (event_id, genre_name);


--
-- Name: event_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_logs
    ADD CONSTRAINT event_logs_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: friend_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friend_connections
    ADD CONSTRAINT friend_connections_pkey PRIMARY KEY (user_id, friend_id);


--
-- Name: genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (name);


--
-- Name: images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: location_components_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location_components
    ADD CONSTRAINT location_components_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: user_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_genres
    ADD CONSTRAINT user_genres_pkey PRIMARY KEY (user_id, genre_name);


--
-- Name: user_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_logs
    ADD CONSTRAINT user_logs_pkey PRIMARY KEY (id);


--
-- Name: user_profile_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_profile_images
    ADD CONSTRAINT user_profile_images_pkey PRIMARY KEY (user_id, image_id);


--
-- Name: user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id);


--
-- Name: user_removed_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_removed_events
    ADD CONSTRAINT user_removed_events_pkey PRIMARY KEY (user_id, event_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_locations_on_lat_and_lng; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_locations_on_lat_and_lng ON locations USING btree (lat, lng);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: event_genres_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events_genres
    ADD CONSTRAINT event_genres_event_id_fkey FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE RESTRICT;


--
-- Name: event_genres_genre_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events_genres
    ADD CONSTRAINT event_genres_genre_name_fkey FOREIGN KEY (genre_name) REFERENCES genres(name) ON DELETE RESTRICT;


--
-- Name: event_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_logs
    ADD CONSTRAINT event_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE RESTRICT;


--
-- Name: event_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_logs
    ADD CONSTRAINT event_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: events_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: events_images_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events_images
    ADD CONSTRAINT events_images_event_id_fkey FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE RESTRICT;


--
-- Name: events_images_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events_images
    ADD CONSTRAINT events_images_image_id_fkey FOREIGN KEY (image_id) REFERENCES images(id) ON DELETE RESTRICT;


--
-- Name: events_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_location_id_fkey FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE RESTRICT;


--
-- Name: friend_connections_friend_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY friend_connections
    ADD CONSTRAINT friend_connections_friend_id_fkey FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: friend_connections_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY friend_connections
    ADD CONSTRAINT friend_connections_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: genres_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: images_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: location_components_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY location_components
    ADD CONSTRAINT location_components_location_id_fkey FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE RESTRICT;


--
-- Name: user_genres_genre_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_genres
    ADD CONSTRAINT user_genres_genre_name_fkey FOREIGN KEY (genre_name) REFERENCES genres(name) ON DELETE RESTRICT;


--
-- Name: user_genres_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_genres
    ADD CONSTRAINT user_genres_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: user_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_logs
    ADD CONSTRAINT user_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: user_profile_images_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profile_images
    ADD CONSTRAINT user_profile_images_image_id_fkey FOREIGN KEY (image_id) REFERENCES images(id) ON DELETE RESTRICT;


--
-- Name: user_profile_images_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profile_images
    ADD CONSTRAINT user_profile_images_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: user_profiles_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT user_profiles_location_id_fkey FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE RESTRICT;


--
-- Name: user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- Name: user_removed_events_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_removed_events
    ADD CONSTRAINT user_removed_events_event_id_fkey FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE RESTRICT;


--
-- Name: user_removed_events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_removed_events
    ADD CONSTRAINT user_removed_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20160226002715');

INSERT INTO schema_migrations (version) VALUES ('20160226055536');

INSERT INTO schema_migrations (version) VALUES ('20160226060137');

INSERT INTO schema_migrations (version) VALUES ('20160229045318');

INSERT INTO schema_migrations (version) VALUES ('20160229050233');

INSERT INTO schema_migrations (version) VALUES ('20160229054658');

INSERT INTO schema_migrations (version) VALUES ('20160301041810');

INSERT INTO schema_migrations (version) VALUES ('20160301041840');

INSERT INTO schema_migrations (version) VALUES ('20160301054505');

INSERT INTO schema_migrations (version) VALUES ('20160301063915');

INSERT INTO schema_migrations (version) VALUES ('20160301224209');

INSERT INTO schema_migrations (version) VALUES ('20160302014811');

INSERT INTO schema_migrations (version) VALUES ('20160302035109');

INSERT INTO schema_migrations (version) VALUES ('20160310043830');

INSERT INTO schema_migrations (version) VALUES ('20160405053346');

INSERT INTO schema_migrations (version) VALUES ('20160420021434');

