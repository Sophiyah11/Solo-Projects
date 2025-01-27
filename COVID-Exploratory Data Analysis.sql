/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

USE [Portfolio Projects]


SELECT *
FROM [Covid Deaths]
where continent is not null
ORDER BY 3, 4;

SELECT *
FROM [Covid Vaccinations]
where continent is not null
ORDER BY 3, 4;


-- SELECTION OF DATA TO BE USED

SELECT location, date, population, new_cases, total_cases, total_deaths
FROM [Covid Deaths]
WHERE continent is not null
ORDER BY 1,2;


-- Total Cases vs Total Deaths
-- SHOWS THE LIKELIHOOD OF DYING IF COVID +VE IN YOUR COUNTRY

SELECT location, date, total_cases, total_deaths, (CONVERT(float, total_deaths)/NULLIF(CONVERT(float, total_cases), 0))*100 AS Deathpercentage
FROM [Covid Deaths]
WHERE continent is not null
AND location LIKE '%Nigeria%'
ORDER BY 1,2;

-- TOTAL CASES VS POPULATION
-- SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID

SELECT location, date, population, total_cases, (total_cases/population)*100 AS PositiveCasespercentage
FROM [Covid Deaths]
--WHERE location LIKE '%Nigeria%'
WHERE continent is not null
ORDER BY 1,2;


--COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULation

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentagePopulationInfected
FROM [Covid Deaths]
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC;


-- SHOWING COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION 

SELECT location, population, MAX(total_deaths) AS HighestDEATHCount, MAX(total_deaths/population)*100 AS PercentagePopulationDEATHS
FROM [Covid Deaths]
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentagePopulationDEATHS DESC;


-- HIGHEST DEATH COUNT BY LOCATION

SELECT location, MAX(total_deaths) AS DEATHCOUNTS
FROM [Covid Deaths]
WHERE continent is not null
GROUP BY location
ORDER BY DEATHCOUNTS DESC;


-- HIGHEST VACCINE COUNTS BY LOCATION

SELECT location, MAX(CONVERT(bigint, new_vaccinations)) AS VACCINECOUNTS
FROM [Covid Vaccinations]
WHERE continent is not null
GROUP BY location
ORDER BY VACCINECOUNTS DESC;



-- CONTINENTS WITH THE HIGHEST DEATH COUNTS PER POPULATION

SELECT continent, MAX(total_deaths) AS DEATHCOUNTS
FROM [Covid Deaths]
WHERE continent is not null
GROUP BY continent
ORDER BY DEATHCOUNTS DESC;


-- CONTINENTS WITH THE HIGHEST VACCINATIONS PER POPULATION

SELECT continent, MAX(CONVERT(bigint, new_vaccinations)) AS VACCINECOUNTS
FROM [Covid Vaccinations]
WHERE continent is not null
GROUP BY continent
ORDER BY VACCINECOUNTS DESC;


-- GLOBAL NUMBERS

SELECT date, SUM(new_cases), SUM(new_deaths)
FROM [Covid Deaths]
WHERE continent is not NULL
GROUP BY date
ORDER BY 1,2;


-- GLOBAL NUMBERS PER POPULATION

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(population) as World_population, SUM(new_deaths)/SUM(new_Cases)*100 as GlobalDeathPercentage, 
SUM(total_cases)/SUM(population)*100 as GlobalcasesPercentage
FROM [Covid Deaths]
WHERE continent is not null 

--ORDER by 1,2



-- GLOBAL DEATH PERCENTAGE BY DATE

SELECT date, SUM(new_cases) as Globalnewcases, SUM(new_deaths) as Globalnewdeaths, 
SUM(CONVERT(float, new_deaths))/SUM(NULLIF(CONVERT(float, new_cases), 0))*100 AS GlobalDeathPercentage
FROM [Covid Deaths]
WHERE continent is not NULL
GROUP BY date
ORDER BY 1,2;



-- JOIN BOTH TABLES
SELECT *
FROM [Covid Deaths] DEA
JOIN [Covid Vaccinations] VAC
 ON DEA.date = VAC.date
 AND DEA.location = VAC.location


 -- POPULATION VS VACCINATION

SELECT DEA.date, DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations
FROM [Covid Deaths] DEA
JOIN [Covid Vaccinations] VAC
 ON DEA.date = VAC.date
 AND DEA.location = VAC.location
WHERE DEA.continent is not null AND VAC.new_vaccinations is not null
ORDER BY 1, 3;


-- TOTAL VACCINATION BY LOCATION
-- SHOWS THE COUNT OF POPULATION THAT HAS RECEIVED AT-LEAST ONE COVID VACCINE

SELECT DEA.date, DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations,
SUM(CONVERT(bigint, VAC.new_vaccinations)) OVER (PARTITION BY VAC.location ORDER BY DEA.date)
AS RollingPeopleVaccination
FROM [Covid Deaths] DEA
JOIN [Covid Vaccinations] VAC
 ON DEA.date = VAC.date
 AND DEA.location = VAC.location
WHERE DEA.continent is not null AND VAC.new_vaccinations is not null 
--ORDER BY 1, 2;


-- USING CTE

WITH PopVsVac (date, continent, location, population, new_vaccinations, RollingPeopleVaccination)
AS
(
SELECT DEA.date, DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations,
SUM(CONVERT(bigint, VAC.new_vaccinations)) OVER (PARTITION BY VAC.location ORDER BY DEA.date)
AS RollingPeopleVaccination
FROM [Covid Deaths] DEA
JOIN [Covid Vaccinations] VAC
 ON DEA.date = VAC.date
 AND DEA.location = VAC.location
WHERE DEA.continent is not null AND VAC.new_vaccinations is not null
-- ORDER BY 1, 2
)
SELECT *, (RollingPeopleVaccination/population)*100
FROM PopVsVac


--TEMP TABLE

CREATE TABLE #PercentagePopulationvaccinated
(
Date datetime,
Continent nvarchar(255),
Location nvarchar(255),
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccination numeric
)

INSERT into #PercentagePopulationvaccinated
SELECT DEA.date, DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations,
SUM(CONVERT(bigint, VAC.new_vaccinations)) OVER (PARTITION BY VAC.location ORDER BY DEA.date)
AS RollingPeopleVaccination
FROM [Covid Deaths] DEA
JOIN [Covid Vaccinations] VAC
 ON DEA.date = VAC.date
 AND DEA.location = VAC.location
WHERE DEA.continent is not null AND VAC.new_vaccinations is not null
-- ORDER BY 1, 2

SELECT *, (RollingPeopleVaccination/population)*100
FROM #PercentagePopulationvaccinated


-- or YOU WANNA CHANGE THINGS AROUND A BIT(MAKING ALTERATION)

DROP TABLE IF exists #PercentagePopulationvaccinated
CREATE TABLE #PercentagePopulationvaccinated
(
Date datetime,
Continent nvarchar(255),
Location nvarchar(255),
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccination numeric
)

INSERT into #PercentagePopulationvaccinated
SELECT DEA.date, DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations,
SUM(CONVERT(bigint, VAC.new_vaccinations)) OVER (PARTITION BY VAC.location ORDER BY DEA.date)
AS RollingPeopleVaccination
FROM [Covid Deaths] DEA
JOIN [Covid Vaccinations] VAC
 ON DEA.date = VAC.date
 AND DEA.location = VAC.location
--WHERE DEA.continent is not null AND VAC.new_vaccinations is not null
-- ORDER BY 1, 2

SELECT *, (RollingPeopleVaccination/population)*100
FROM #PercentagePopulationvaccinated


--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION

CREATE View PercentagePopulationvaccinated as
SELECT DEA.date, DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations,
SUM(CONVERT(bigint, VAC.new_vaccinations)) OVER (PARTITION BY VAC.location ORDER BY DEA.date)
AS RollingPeopleVaccination
FROM [Covid Deaths] DEA
JOIN [Covid Vaccinations] VAC
 ON DEA.date = VAC.date
 AND DEA.location = VAC.location
WHERE DEA.continent is not null AND VAC.new_vaccinations is not null
--ORDER BY 1, 2

SELECT * FROM PercentagePopulationvaccinated 


CREATE View PercentPopulationInfected as
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentagePopulationInfected
FROM [Covid Deaths]
GROUP BY location, population
-- ORDER BY PercentagePopulationInfected DESC;


CREATE View PercentPopulationDeath as
SELECT location, population, MAX(total_deaths) AS HighestDEATHCount, MAX(total_deaths/population)*100 AS PercentagePopulationDEATHS
FROM [Covid Deaths]
WHERE continent is not null
GROUP BY location, population
--ORDER BY PercentagePopulationDEATHS DESC;

