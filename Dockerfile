# Start from the SDK image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY super-service/src/*.csproj ./super-service/src/
RUN dotnet restore ./super-service/src/SuperService.csproj

# Copy everything else and build
COPY super-service/. ./super-service/

# Remove duplicate assembly attributes files
RUN find . -name "*.AssemblyInfo.cs" -type f -delete

# Publish the application
RUN dotnet publish ./super-service/src/SuperService.csproj -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "SuperService.dll"]

