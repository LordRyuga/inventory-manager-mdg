# --- Build Stage ---
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy all files and publish
COPY . ./
RUN dotnet publish -c Release -o /out

# --- Runtime Stage ---
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /out .

EXPOSE 80

ENTRYPOINT ["dotnet", "ProductAPI.dll"]
