#!bin/sh

PROJECT_NAME="$1"
PROJECT_PATH="$2"

# Save current folder

# Create project directory
echo "Creating project directory..."
mkdir -p "$PROJECT_PATH/$PROJECT_NAME"
cd "$PROJECT_PATH/$PROJECT_NAME"

# Create api project
echo "Creating api project..."
API_Project="$PROJECT_NAME.API"
dotnet new webapi -o "$API_Project"

# Create domain project
echo "Creating domain project..."
Domain_Project="$PROJECT_NAME.Domain"
dotnet new classlib -o "$Domain_Project"

# Create application project
echo "Creating application project..."
Application_Project="$PROJECT_NAME.Application"
dotnet new classlib -o "$Application_Project"

# Create infrastructure project
echo "Creating infrastructure project..."
Infrastructure_Project="$PROJECT_NAME.Infrastructure"
dotnet new classlib -o "$Infrastructure_Project"

# Create solution
echo "Creating solution..."
Solution="$PROJECT_NAME"
dotnet new sln -n "$Solution"

# Add projects to solution
echo "Adding projects to solution..."
dotnet sln "$Solution.sln" add "$API_Project/$API_Project.csproj"
dotnet sln "$Solution.sln" add "$Domain_Project/$Domain_Project.csproj"
dotnet sln "$Solution.sln" add "$Application_Project/$Application_Project.csproj"
dotnet sln "$Solution.sln" add "$Infrastructure_Project/$Infrastructure_Project.csproj"

# Add Api references
echo "Adding API references..."
dotnet add "$API_Project/$API_Project.csproj" reference "$Domain_Project/$Domain_Project.csproj"
dotnet add "$API_Project/$API_Project.csproj" reference "$Application_Project/$Application_Project.csproj"
dotnet add "$API_Project/$API_Project.csproj" reference "$Infrastructure_Project/$Infrastructure_Project.csproj"

# Add Application references
echo "Adding Application references..."
dotnet add "$Application_Project/$Application_Project.csproj" reference "$Domain_Project/$Domain_Project.csproj"

# Add Infrastructure references
echo "Adding Infrastructure references..."
dotnet add "$Infrastructure_Project/$Infrastructure_Project.csproj" reference "$Domain_Project/$Domain_Project.csproj"

# Add Ilse Packages references
echo "Adding Ilse packages references..."
dotnet add "$API_Project/$API_Project.csproj" package Ilse.MinimalApi
dotnet add "$API_Project/$API_Project.csproj" package Ilse.CorrelationId
dotnet add "$API_Project/$API_Project.csproj" package Ilse.TenantContext
dotnet add "$API_Project/$API_Project.csproj" package Ilse.Repository
dotnet add "$Application_Project/$Application_Project.csproj" package Ilse.Cqrs
dotnet add "$Domain_Project/$Domain_Project.csproj" package Ilse.Cqrs
dotnet add "$Domain_Project/$Domain_Project.csproj" package Ilse.Repository

# Add third party packages references
echo "Adding third party packages references..."
dotnet add "$API_Project/$API_Project.csproj" package Microsoft.AspNetCore.Authentication.JwtBearer
dotnet add "$API_Project/$API_Project.csproj" package FluentValidation.DependencyInjectionExtensions
dotnet add "$API_Project/$API_Project.csproj" package NLog.Web.AspNetCore
dotnet add "$API_Project/$API_Project.csproj" package NLog.DiagnosticSource
dotnet add "$API_Project/$API_Project.csproj" package Npgsql.EntityFrameworkCore.PostgreSQL
dotnet add "$Infrastructure_Project/$Infrastructure_Project.csproj" package Microsoft.EntityFrameworkCore

# Back to original folder
popd