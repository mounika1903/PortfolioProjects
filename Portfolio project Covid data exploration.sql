SELECT * FROM [portfolio project]..covidDeaths
where continent is  not null
ORDER BY 3,4;

--SELECT * FROM [portfolio project]..COVIDVaccination
--ORDER BY 3,4

--select Data that we are going to be using


select location,date,total_cases,new_cases,total_deaths,population from  
[portfolio project]..covidDeaths
where continent is  not null
ORDER BY 1,2

--Looking at Total cases vs Total Deaths
--shows likelihood of dying if you contract covid in your country
select location,date,total_cases,total_deaths,(total_deaths*1.00/total_cases)*100 as Deathprecentage
from [portfolio project]..covidDeaths
where continent is  not null
and location like '%states%'
order by 1,2

--Looking at Total cases vs population
--shows what precentage of people got covid

select location,date, population,total_cases,(total_cases*1.00/population)*100 as Deathprecentage
from [portfolio project]..covidDeaths
--where location like '%states%'
where continent is  not null
order by 1,2

--Looking at Countries with Highest Infection Rate compared to population

select location, population, Max(total_cases)as HighestInfecioncount,max((total_cases*1.00/population))*100 as percentpopulatInfected
from [portfolio project]..covidDeaths
where continent is  not null
group by location,population
order by percentpopulatInfected desc

--showing countries with Highest Death count per Population

--	LET'S BREAK THINGS DOWN BY CONTINENT	

--showing continents with highest death count per population

select continent, max(cast(total_deaths as int)) as TotalDeathcount
from [portfolio project]..covidDeaths
--where location like '%states%
where continent is  not null
group by continent
order by TotalDeathcount desc



--GLOBAL NUMBERS

select date, SUM(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(new_deaths)/sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathprecentage
from [portfolio project]..covidDeaths
--where location like '%states%'
where continent is  not null
--group by date
order by 1,2

--Looking at Total population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as rollingPeopleVaccinated
From [portfolio project]..covidDeaths dea
Join [portfolio project]..covidVaccination vac
	On dea.location = vac.location  
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

--USE CTE

with popvsvac(continet,location,date,population, new_vaccinations,rollingPeopleVaccinated)
as 
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as rollingPeopleVaccinated
From [portfolio project]..covidDeaths dea
Join [portfolio project]..covidVaccination vac
	On dea.location = vac.location  
	and dea.date = vac.date
where dea.continent is not null 

)
select *,(rollingPeopleVaccinated/population)*100
from popvsvac
order by 2,3

