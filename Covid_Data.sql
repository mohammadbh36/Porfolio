SELECT *
From coviddeaths
WHERE continent is not null
ORDER BY 3,4;

-- Select data that i will be working with
SELECT location, date1, total_cases, new_cases, total_deaths, population
FROM coviddeaths
WHERE continent is not null
ORDER BY 1,2;

--Looking at the total cases vs total deaths to knw the percentage of deaths from the infected
SELECT location, date1, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PercentPopulationInfected
FROM coviddeaths
WHERE location like '%States%' and continent is not null
ORDER BY 1,2;

-- looking at total cases vs population
SELECT location, date1, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM coviddeaths
WHERE location like '%States%' and continent is not null
ORDER BY 1,2;

-- looking at countries with highest infection rate compared to population 
SELECT location, population, max(total_cases) AS MaxinfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM coviddeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected desc;

-- Showing the countries with the highest death count per population
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM coviddeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc;

-- Showing death count by continent
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM coviddeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc;

--Global Numbers by date
SELECT date1, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent is not null
GROUP BY date1
ORDER BY 1,2;

--Global Numbers 
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent is not null
--GROUP BY date1
ORDER BY 1,2;

SELECT death.continent, death.location, death.date1, vacc.new_vaccinations, SUM(vacc.new_vaccinations) OVER (PARTITION BY death.location)
FROM coviddeaths death
JOIN covidvaccinations vacc
    ON death.location = vacc.location
    and death.date1 = vacc.date1
WHERE death.continent is not null
ORDER BY 2,3;

-- CREATING view to store data for later visualizations 
CREATE View PercentPopulationVaccinated AS 
SELECT death.continent, death.location, death.date1, death.population, vacc.new_vaccinations, SUM(vacc.new_vaccinations) OVER (PARTITION BY death.location 
ORDER BY death.location, death.date1) AS RollingPeopleVaccinated
FROM coviddeaths death
JOIN covidvaccinations vacc
    ON death.location = vacc.location
    and death.date1 = vacc.date1
WHERE death.continent is not null;

SELECT * FROM percentpopulationvaccinated;















