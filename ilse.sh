#!bin/sh

PROJECT_NAME="$1"
PROJECT_PATH="$2"

# Save current folder

# Create project directory
mkdir -p "$PROJECT_PATH/$PROJECT_NAME"
cd "$PROJECT_PATH/$PROJECT_NAME"

# Create api project
API_Project="$PROJECT_NAME.API"
dotnet new webapi -o "$API_Project"

# Create domain project
Domain_Project="$PROJECT_NAME.Domain"
dotnet new classlib -o "$Domain_Project"

# Create application project
Application_Project="$PROJECT_NAME.Application"
dotnet new classlib -o "$Application_Project"

# Create infrastructure project
Infrastructure_Project="$PROJECT_NAME.Infrastructure"
dotnet new classlib -o "$Infrastructure_Project"

# Create solution
Solution="$PROJECT_NAME"
dotnet new sln -n "$Solution"

# Add projects to solution
dotnet sln "$Solution.sln" add "$API_Project/$API_Project.csproj"
dotnet sln "$Solution.sln" add "$Domain_Project/$Domain_Project.csproj"
dotnet sln "$Solution.sln" add "$Application_Project/$Application_Project.csproj"
dotnet sln "$Solution.sln" add "$Infrastructure_Project/$Infrastructure_Project.csproj"

# Add Api references
dotnet add "$API_Project/$API_Project.csproj" reference "$Domain_Project/$Domain_Project.csproj"
dotnet add "$API_Project/$API_Project.csproj" reference "$Application_Project/$Application_Project.csproj"
dotnet add "$API_Project/$API_Project.csproj" reference "$Infrastructure_Project/$Infrastructure_Project.csproj"

# Add Application references
dotnet add "$Application_Project/$Application_Project.csproj" reference "$Domain_Project/$Domain_Project.csproj"

# Add Infrastructure references
dotnet add "$Infrastructure_Project/$Infrastructure_Project.csproj" reference "$Domain_Project/$Domain_Project.csproj"

# Add Ilse Packages references
dotnet add "$API_Project/$API_Project.csproj" package Ilse.MinimalApi
dotnet add "$API_Project/$API_Project.csproj" package Ilse.CorrelationId
dotnet add "$API_Project/$API_Project.csproj" package Ilse.TenantContext
dotnet add "$API_Project/$API_Project.csproj" package Ilse.BaseContext
dotnet add "$API_Project/$API_Project.csproj" package Ilse.ServicesAbstractions
dotnet add "$Domain_Project/$Domain_Project.csproj" package Ilse.Cqrs


# Back to original folder
popd