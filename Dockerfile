FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /src
COPY ["jrtechdockervs2019/jrtechdockervs2019.csproj", "jrtechdockervs2019/"]
RUN dotnet restore "jrtechdockervs2019/jrtechdockervs2019.csproj"
COPY . .
WORKDIR "/src/jrtechdockervs2019"
RUN dotnet build "jrtechdockervs2019.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "jrtechdockervs2019.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "jrtechdockervs2019.dll"]