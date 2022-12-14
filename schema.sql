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