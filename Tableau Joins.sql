/*

Queries used for Tableau Project 

*/



-- total deaths and death percentage

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Covid Deaths]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2




-- total population by location

select location, max(population) as population_count from [Covid Deaths]
where continent is not null
group by location 



-- total population
WITH Pop AS (
    SELECT location, MAX(population) AS population_count 
    FROM [Covid Deaths]
    WHERE continent IS NOT NULL
    GROUP BY location
)
SELECT SUM(population_count) AS total_population
FROM Pop;


--Total Vaccinations

WITH Pop AS (
    SELECT location, MAX(population) AS population_count, MAX(convert(bigint, new_vaccinations)) AS vaccinations_count
    FROM [Sheet2$]
    WHERE continent IS not NULL and new_vaccinations is not null
	GROUP BY location
)
SELECT SUM(vaccinations_count) AS TOTAL_VACCINATIONS 
FROM Pop



-- World Vaccination Percentage


WITH Pop AS (
    SELECT location, MAX(population) AS population_count, MAX(convert(bigint, new_vaccinations)) AS vaccinations_count
    FROM [Sheet2$]
    WHERE continent IS not NULL
    GROUP BY location
)
SELECT SUM(population_count) AS total_population, SUM(vaccinations_count) AS total_vaccinations, (SUM(vaccinations_count) / SUM(population_count))*100 as total_vaccinationPercentage
FROM Pop


-- VACCINE COUNT by continent

SELECT continent, MAX(CONVERT(bigint, new_vaccinations)) AS VACCINECOUNTS
FROM [Covid Vaccinations]
WHERE continent is not null
GROUP BY continent
ORDER BY VACCINECOUNTS DESC;


-- Percentagepeoplevaccinated by continent


WITH Pop AS (
    SELECT continent, MAX(population) AS population_count, MAX(convert(bigint, new_vaccinations)) AS vaccinations_count
    FROM [Sheet2$]
    WHERE continent IS NOT NULL
    GROUP BY continent
)
SELECT continent, population_count, vaccinations_count, (vaccinations_count/population_count)*100 AS peoplevaccinated_percentage
FROM Pop
order by 4 desc;

-- OR

WITH Pop AS (
    SELECT location, MAX(population) AS population_count, MAX(convert(bigint, new_vaccinations)) AS vaccinations_count
    FROM [Sheet2$]
    WHERE continent IS NULL and location not in ('World', 'European Union', 'International', 'High-income countries','Upper-middle-income countries','Lower-middle-income countries','Low-income countries','European Union (27)')
    GROUP BY location
)
SELECT location, population_count, vaccinations_count, (vaccinations_count/population_count)*100 AS peoplevaccinated_percentage
FROM Pop
order by 4 desc;


 
 -- percent people vaccinated by country

 WITH Pop AS (
    SELECT location, MAX(population) AS population_count, MAX(convert(bigint, new_vaccinations)) AS vaccinations_count
    FROM [Sheet2$]
    WHERE continent IS not NULL and new_vaccinations is not null
	GROUP BY location
)
SELECT location, population_count, vaccinations_count, (vaccinations_count/population_count)*100 AS peoplevaccinated_percentage
FROM Pop
order by 4 desc;





-- Deathcount by continent


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Covid Deaths]
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High-income countries','Upper-middle-income countries','Lower-middle-income countries','Low-income countries','European Union (27)')
Group by location
order by TotalDeathCount desc

--OR

Select continent, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Covid Deaths]
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc




-- Infection counts by location

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Deaths]
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- PercentPeopleInfected by date


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Deaths]
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc




-- Total(cases,deaths and deathpercentage) 


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Covid Deaths]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2




-- Rolling People Vaccinated Percentage by date

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Covid Deaths] dea
Join [Covid Vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


-- Percent People Infected by Date

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Deaths]
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


--Vaccination Count by date

SELECT DEA.date, DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations
FROM [Covid Deaths] DEA
JOIN [Covid Vaccinations] VAC
 ON DEA.date = VAC.date
 AND DEA.location = VAC.location
WHERE DEA.continent is not null AND VAC.new_vaccinations is not null
ORDER BY 1, 3;



