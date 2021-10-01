#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
COPY dist /app
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["LearningDocker.csproj", "."]
RUN dotnet restore "./LearningDocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "LearningDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "LearningDocker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "LearningDocker.dll"]