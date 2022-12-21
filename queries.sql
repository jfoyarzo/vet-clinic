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

SELECT date_of_visit, A.name
FROM visits
JOIN animals A ON pet_id = A.id
WHERE vet_id = 1
ORDER BY date_of_visit DESC
LIMIT 1;

SELECT COUNT(pet_id)
FROM visits
WHERE vet_id = 3;

SELECT vet_id, V.name, S.name as specialization
FROM specializations
RIGHT JOIN vets V ON vet_id = V.id
LEFT JOIN species S ON species_id = S.id;

SELECT vet_id, A.name as pacient, date_of_visit
FROM visits
JOIN animals A ON pet_id = A.id
WHERE vet_id = 3 AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

SELECT COUNT(pet_id) as number_of_visits, A.name
FROM visits
JOIN animals A ON pet_id = A.id
GROUP BY A.name
ORDER BY number_of_visits DESC
LIMIT 1;

SELECT V.name as vet, date_of_visit, A.name as pacient
FROM visits
JOIN vets V ON vet_id = V.id
JOIN animals A ON pet_id = A.id
ORDER BY date_of_visit ASC
LIMIT 1;

SELECT A.name as pacient, V.name as vet, date_of_visit
FROM visits
JOIN animals A ON pet_id = A.id
JOIN vets V ON vet_id = V.id
ORDER BY date_of_visit DESC
LIMIT 1;

SELECT COUNT(*) as number_of_visits
FROM visits
JOIN specializations S ON visits.vet_id = S.vet_id
JOIN animals A ON visits.pet_id = A.id
WHERE A.species_id != S.species_id;

SELECT COUNT(*) as number_of_visits, S.name as species
FROM visits
JOIN animals A ON visits.pet_id = A.id
JOIN species S ON A.species_id = S.id
WHERE visits.vet_id = 2
GROUP BY S.name
ORDER BY number_of_visits DESC
LIMIT 1;
-- Performance audit starts here
explain analyze SELECT COUNT(*) FROM visits where pet_id = 4;

explain analyze SELECT COUNT(*) FROM visits where pet_id = 2;

explain analyze SELECT COUNT(*) FROM owners where email='owner_18327@mail.com';
