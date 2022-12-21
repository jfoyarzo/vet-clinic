/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

CREATE TABLE animals(
    id int,
    name varchar(30),
    date_of_birth date,
    escape_attempts int,
    neutered boolean,
    weight_kg float
    );

ALTER TABLE animals ADD species varchar(30);

CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(50),
    age INT,
    PRIMARY KEY (id)
    );

CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(30),
    PRIMARY KEY (id)
    );

ALTER TABLE animals
ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY 
(START WITH 11);
ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals
ADD CONSTRAINT fk_species_id
FOREIGN KEY (species_id) REFERENCES species(id);
ALTER TABLE animals ADD owner_id INT;
ALTER TABLE animals
ADD CONSTRAINT fk_owner_id
FOREIGN KEY (owner_id) REFERENCES owners(id);

CREATE TABLE vets (
 id INT GENERATED ALWAYS AS IDENTITY,
 name VARCHAR(50),
 age INT,
 date_of_graduation DATE,
 PRIMARY KEY (id)
);

CREATE TABLE specializations (
 species_id INT,
 vet_id INT,
 FOREIGN KEY (species_id) REFERENCES species (id),
 FOREIGN KEY (vet_id) REFERENCES vets (id),
 PRIMARY KEY (species_id, vet_id)
);

CREATE TABLE visits (
 pet_id INT,
 vet_id INT,
 date_of_visit DATE,
 FOREIGN KEY (pet_id) REFERENCES animals (id),
 FOREIGN KEY (vet_id) REFERENCES vets (id),
 PRIMARY KEY (pet_id, vet_id, date_of_visit)
);

-- Performance Aduit starts here

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);


-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (pet_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';

CREATE INDEX ON owners(email);
CREATE INDEX vet_index ON visits(vet_id);
CREATE INDEX animal_index ON visits(pet_id);
