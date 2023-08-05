SELECT *
FROM Portfolio..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 3, 4

--SELECT *
--FROM Portfolio..CovidVaccinations$
--ORDER BY 3, 4


SELECT DISTINCT Location, date, total_cases, new_cases, total_deaths, population
From Portfolio..CovidDeaths$
ORDER BY 1, 2

--Looking at Total Cases vs Total Deaths

SELECT Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS 'Death Percentage'
From Portfolio..CovidDeaths$
WHERE Location like '%brazil%'
ORDER BY 1, 2

--Total Cases vs Population

SELECT Location, date, total_cases, population, (total_cases/population)*100 AS 'Infection Percentage'
From Portfolio..CovidDeaths$
WHERE location like '%Brazil%'
ORDER BY 1, 2

--Looking at countries vs population with highest infection percentage

SELECT Location, population, MAX(total_cases) AS 'Highest Infection Country', MAX((total_cases/population))*100 AS 'Location Percentage'
From Portfolio..CovidDeaths$
--WHERE Location like '%brazil%'
GROUP BY Location, population
ORDER BY [Location Percentage] DESC

--Countries  With Highest death Count per Population

SELECT Location, MAX(CAST(total_deaths AS int)) AS 'Total Deaths '
From Portfolio..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY [Total Deaths ] DESC

--Continents

--Showing Continents With The Highest Death Count

SELECT continent, MAX(CAST(total_deaths AS int)) AS 'Total Deaths Per Continent'
FROM Portfolio..CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY [total_deaths]

--Global Numbers

SELECT SUM(new_cases) AS 'Total Cases', SUM(CAST(new_deaths AS int)) AS 'Total Deaths', SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS 'Global	Infection'
FROM Portfolio..CovidDeaths$
WHERE continent is not null
--GROUP BY date
ORDER BY 1, 2

--Looking at total number of vaccinated people

WITH PopvsVAC (continent, location, date, population, new_vaccinations, TotalVaccinatedPeople)
AS
(
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CAST(VAC.new_vaccinations AS int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date ) AS TotalVaccinatedPeople
--,(TotalVaccinatedPeople/population)*100
FROM Portfolio..CovidDeaths$ AS DEA
JOIN Portfolio..CovidVaccinations$ AS VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL 
)
SELECT *, (TotalVaccinatedPeople/population)*100 AS PercentOfVacciantedPeople
FROM PopvsVAC


--Temp Table

DROP TABLE IF EXIST #VaccinatedPeoplePercent 

CREATE TABLE #VaccinatedPeoplePercent
(continent nvarchar(50),
location nvarchar(50),
date datetime,
population numeric,
new_vaccinations numeric,
TotalVaccinatedPeople numeric)

INSERT INTO #VaccinatedPeoplePercent
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CAST(VAC.new_vaccinations AS int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date ) AS TotalVaccinatedPeople
--,(TotalVaccinatedPeople/population)*100
FROM Portfolio..CovidDeaths$ AS DEA
JOIN Portfolio..CovidVaccinations$ AS VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL 
ORDER BY 2,3

SELECT *, (TotalVaccinatedPeople/population)*100
FROM #VaccinatedPeoplePercent

--Creating View For Data Visualization

CREATE VIEW VaccinatedPeoplePercent AS
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CAST(VAC.new_vaccinations AS int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date ) AS TotalVaccinatedPeople
--,(TotalVaccinatedPeople/population)*100
FROM Portfolio..CovidDeaths$ AS DEA
JOIN Portfolio..CovidVaccinations$ AS VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL 

CREATE VIEW TotalDeaths AS
SELECT Location, MAX(CAST(total_deaths AS int)) AS 'Total Deaths '
From Portfolio..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY Location

CREATE VIEW HighestCountriesDeaths AS
SELECT Location, MAX(CAST(total_deaths AS int)) AS 'Total Deaths'
From Portfolio..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY Location

CREATE VIEW ContinentsDeathCounts AS
SELECT continent, MAX(CAST(total_deaths AS int)) AS 'Total Deaths Per Continent'
FROM Portfolio..CovidDeaths$
WHERE continent is not null
GROUP BY continent
