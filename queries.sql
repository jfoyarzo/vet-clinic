/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered=true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered=true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;
UPDATE animals SET species='undefined';
ROLLBACK;

BEGIN;
UPDATE animals SET species='unspecified';
ROLLBACK;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon%';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;

BEGIN;
TRUNCATE TABLE animals;
ROLLBACK;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, AVG(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

SELECT name, full_name as owner
FROM animals A 
JOIN owners O ON A.owner_id = O.id
WHERE full_name = 'Melody Pond';

SELECT A.name, S.name as species
FROM animals A 
JOIN species S ON A.species_id = S.id
WHERE species_id = 1;

SELECT full_name, A.name as pet
FROM owners O
LEFT JOIN animals A ON O.id = A.owner_id;

SELECT COUNT(*), S.name
FROM animals A
JOIN species S ON A.species_id = S.id
GROUP BY S.name;

SELECT A.name, O.full_name as owner, S.name as species
FROM animals A
JOIN owners O ON A.species_id = S.id
WHERE O.full_name = 'Jennifer Orwell' AND S.id = 2;

SELECT A.name, O.full_name as owner, A.escape_attempts
FROM animals A
JOIN owners O ON A.owner_id = O.id
WHERE O.full_name = 'Dean Winchester' AND A.escape_attempts = 0;

SELECT COUNT(*) as number_of_pets, O.full_name 
FROM animals A 
JOIN owners O ON A.owner_id = O.id 
GROUP BY O.full_name
ORDER BY number_of_pets DESC
LIMIT 1;