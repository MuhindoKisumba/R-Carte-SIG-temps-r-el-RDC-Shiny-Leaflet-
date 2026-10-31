-- Extension géospatiale
CREATE EXTENSION IF NOT EXISTS postgis;

-- Table SIG
CREATE TABLE IF NOT EXISTS cas_epidemio (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP,
    region TEXT,
    lat FLOAT,
    lon FLOAT,
    cas INT,
    deces INT,
    gueris INT,
    geom GEOGRAPHY(Point, 4326)
);

-- Index spatial
CREATE INDEX idx_geom ON cas_epidemio USING GIST (geom);
