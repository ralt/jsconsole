CREATE TABLE session (
       id serial PRIMARY KEY,
       slug varchar(50) UNIQUE NOT NULL
);

CREATE TABLE line (
       sid integer references session(id),
       line text NOT NULL
);
