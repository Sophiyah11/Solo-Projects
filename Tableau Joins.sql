/*

Queries used for Tableau Project

*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Covid Deaths]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2




--total population by location

select location, max(population) as population_count from [Covid Deaths]
where continent is not null
group by location 



--- Total population
WITH Pop AS (
    SELECT location, MAX(population) AS population_count 
    FROM [Covid Deaths]
    WHERE continent IS NOT NULL
    GROUP BY location
)
SELECT SUM(population_count) AS total_population
FROM Pop;


--peoplevaccinated by continent

WITH Pop AS (
    SELECT continent, MAX(population) AS population_count, MAX(convert(bigint, new_vaccinations)) AS vaccinations_count
    FROM [Sheet2$]
    WHERE continent IS NOT NULL
    GROUP BY continent
)
SELECT continent, population_count, vaccinations_count, (vaccinations_count/population_count)*100 AS peoplevaccinated_percentage
FROM Pop
order by 4 desc;


WITH Pop AS (
    SELECT location, MAX(population) AS population_count, MAX(convert(bigint, new_vaccinations)) AS vaccinations_count
    FROM [Sheet2$]
    WHERE continent IS NULL and location not in ('World', 'European Union', 'International', 'High-income countries','Upper-middle-income countries','Lower-middle-income countries','Low-income countries','European Union (27)')
    GROUP BY location
)
SELECT location, population_count, vaccinations_count, (vaccinations_count/population_count)*100 AS peoplevaccinated_percentage
FROM Pop
order by 3 desc;
 
 --percent people vaccinated by country

 WITH Pop AS (
    SELECT location, MAX(population) AS population_count, MAX(convert(bigint, new_vaccinations)) AS vaccinations_count
    FROM [Sheet2$]
    WHERE continent IS not NULL and new_vaccinations is not null
	GROUP BY location
)
SELECT location, population_count, vaccinations_count, (vaccinations_count/population_count)*100 AS peoplevaccinated_percentage
FROM Pop
order by 4 desc;




-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

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


--2b

Select location, SUM(cast(new_vaccinations as bigint)) as TotalVaccinationCount
From [Sheet2$]
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High-income countries','Upper-middle-income countries','Lower-middle-income countries','Low-income countries','European Union (27)')
Group by location
order by TotalVaccinationCount desc




-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Deaths]
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Deaths]
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc












-- Queries I originally had, but excluded some because it created too long of video
-- Here only in case you want to check them out


-- 1.

Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Covid Deaths] dea
Join [Covid Vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3




-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Covid Deaths]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Covid Deaths]
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 4.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Deaths]
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From [Covid Deaths]
--Where location like '%states%'
where continent is not null 
order by 1,2


-- 6. 


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






-- 7. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Deaths]
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


--8

SELECT DEA.date, DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations
FROM [Covid Deaths] DEA
JOIN [Covid Vaccinations] VAC
 ON DEA.date = VAC.date
 AND DEA.location = VAC.location
WHERE DEA.continent is not null AND VAC.new_vaccinations is not null
ORDER BY 1, 3;



--9 VACCINE COUNT

SELECT continent, MAX(CONVERT(bigint, new_vaccinations)) AS VACCINECOUNTS
FROM [Covid Vaccinations]
WHERE continent is not null
GROUP BY continent
ORDER BY VACCINECOUNTS DESC;