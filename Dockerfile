FROM mcr.microsoft.com/dotnet/aspnet:2.1 AS base
WORKDIR /app
EXPOSE 80
ENV SYNCFUSION_LICENSE_KEY=""
ENV SPELLCHECK_DICTIONARY_PATH=""
ENV SPELLCHECK_JSON_FILENAME=""
ENV SPELLCHECK_CACHE_COUNT=""
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build

WORKDIR /source
COPY ["src/ej2-webservice/ej2-webservice.csproj", "./ej2-webservice/ej2-webservice.csproj"]
COPY ["src/ej2-webservice/NuGet.Config", "./ej2-webservice/"]
RUN dotnet restore "./ej2-webservice/ej2-webservice.csproj"
COPY . .
WORKDIR "/source/src"
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ej2-webservice.dll"]