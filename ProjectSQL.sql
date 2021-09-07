Select *
From PortfolioProject..CovidDeaths
order by 3,4

Select *
From PortfolioProject..CovidVaccinations
order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population	
From PortfolioProject..CovidDeaths
order by 1,2




--  Total Cases vs Total Deaths
--  Death Percentage of a covid positive person in India

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage	
From PortfolioProject..CovidDeaths
Where location like '%India%'
order by 1,2



-- Total Cases vs Total Population
-- Shows what percentage of population got covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected	
From PortfolioProject..CovidDeaths
Where location like '%India%'
order by 1,2

--Countries with highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected	
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Group by location, population
order by PercentPopulationInfected desc

--Countries with highest Death Count per Population

Select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Where continent is not null
Group by location
order by TotalDeathCount desc


--Break down by Continent

Select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Where continent is null
Group by location
order by TotalDeathCount desc


--Global Numbers


Select date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage	
From PortfolioProject..CovidDeaths
Where continent is not null
--Where location like '%India%'
Group by date
order by 1,2


--Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int))
OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by  2,3