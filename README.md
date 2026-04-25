# Docker - Minecraft | All the Mods 10 (Archlight Fork)

Форк [kryptonhydrit/docker-minecraft-all-the-mods-10](https://github.com/kryptonhydrit/docker-minecraft-all-the-mods-10) с заменой стандартного NeoForge на [GezzyDax/Arclight](https://github.com/GezzyDax/Arclight) — гибрид NeoForge + Bukkit/Spigot API (плагины + моды одновременно).

- [About](#about)
- [Getting started](#getting-started)
- [Environment variables](#environment-variables)
- [Update Arclight version](#update-arclight-version)
- [FAQ](#faq)
- [Sources](#sources)

## About

На первом запуске контейнер:
1. Скачает и распакует ATM10 Server Files v6.6
2. Установит NeoForge через стандартный установщик пака
3. Скачает Arclight JAR из [Releases](https://github.com/GezzyDax/Arclight/releases) и запустит сервер

**Версии:**
- All the Mods 10: `6.6`
- Arclight: `1.0.2-SNAPSHOT` (Feudal Kings)
- NeoForge: `21.1.228`
- Minecraft: `1.21.1`

## Getting started

### Требования
- Docker + Docker Compose

### Вариант 1: готовый образ из GitHub Registry (рекомендуется)

```bash
# Скачать и запустить одной командой
docker run -d \
  -e EULA=true \
  -e MAX_RAM=8G \
  -e MIN_RAM=8G \
  -v ./data:/data \
  -p 25565:25565 \
  --name atm10-archlight \
  --restart unless-stopped \
  ghcr.io/gezzydax/docker-minecraft-all-the-mods-10:latest
```

Или с `docker-compose.yml` — создай файл:

```yaml
services:
  atm10:
    image: ghcr.io/gezzydax/docker-minecraft-all-the-mods-10:latest
    container_name: atm10-archlight
    stdin_open: true
    tty: true
    restart: unless-stopped
    ports:
      - "25565:25565"
    volumes:
      - ./data:/data
    environment:
      EULA: "true"
      MAX_RAM: "8G"
      MIN_RAM: "8G"
```

```bash
docker compose up -d
docker compose logs -f
```

### Вариант 2: собрать из исходников (для разработки/изменений)

```bash
# 1. Клонировать репозиторий
git clone https://github.com/GezzyDax/docker-minecraft-all-the-mods-10.git
cd docker-minecraft-all-the-mods-10

# 2. Собрать образ и запустить
sudo docker compose up --build -d

# 3. Смотреть логи
sudo docker compose logs -f
```

Первый запуск занимает **10–15 минут** — скачиваются и устанавливаются пак и NeoForge.

### Остановка и перезапуск

```bash
# Остановить
sudo docker compose down

# Перезапустить
sudo docker compose down && sudo docker compose up -d
```

### Обновление образа (после изменений в репо)

```bash
git pull
sudo docker compose up --build -d
```

## Environment variables

Переменные задаются в `docker-compose.yml`:

| Переменная | По умолчанию | Описание |
|---|---|---|
| `EULA` | `true` | Принятие лицензии Minecraft EULA |
| `MAX_RAM` | `8G` | Максимальная оперативная память |
| `MIN_RAM` | `8G` | Минимальная оперативная память |
| `MOTD` | `All the Mods 10 - Archlight` | Описание сервера |
| `DIFFICULTY` | `easy` | Сложность (`peaceful`, `easy`, `normal`, `hard`) |
| `MAX_PLAYERS` | `20` | Максимум игроков |
| `ONLINE_MODE` | `true` | Проверка лицензии (`false` — для пиратки) |
| `VIEW_DISTANCE` | `10` | Дальность прорисовки |
| `SIMULATION_DISTANCE` | `10` | Дальность симуляции |
| `SPAWN_PROTECTION` | `0` | Радиус защиты спавна |

Дополнительно (раскомментировать в `docker-compose.yml`):
- `OPS_LIST` — список операторов через запятую
- `ALLOW_LIST` / `WHITE_LIST` / `ENFORCE_WHITELIST` — белый список
- `ENABLE_RCON` / `RCON_PASSWORD` / `RCON_PORT` — RCON

## Update Arclight version

Версия Arclight/NeoForge меняется в репо [GezzyDax/Arclight](https://github.com/GezzyDax/Arclight):

1. Поменяй `neoforge = 'X.X.X'` в `gradle/libs.versions.toml`
2. Запушь в ветку `FeudalKings` → GitHub Actions автоматически собирает новый JAR и создаёт релиз с тегом `neoforgeX.X.X-X.X.X`
3. Обнови `_ARCHLIGHT_URL` и `_ARCHLIGHT_JAR` в `servermanager.sh` на новый релиз
4. Удали старый JAR из `data/` если уже запускался:
   ```bash
   rm data/arclight-neoforge-*.jar
   ```
5. Пересобери и перезапусти:
   ```bash
   sudo docker compose up --build -d
   ```

## FAQ

### Данные сервера где хранятся?

В папке `./data/` рядом с `docker-compose.yml`. Это bind mount — файлы доступны напрямую с хоста.

### Как зайти в консоль сервера?

```bash
sudo docker attach atm10-archlight
```
Выйти без остановки: `Ctrl+P`, затем `Ctrl+Q`.

### Бэкап

Достаточно скопировать папку `data/`:
```bash
cp -r data/ backup-$(date +%Y%m%d)/
```

> [!CAUTION]
> Не обновляй сервер без бэкапа папки `data/`

## Sources

- Этот форк: https://github.com/GezzyDax/docker-minecraft-all-the-mods-10
- Оригинал: https://github.com/kryptonhydrit/docker-minecraft-all-the-mods-10
- Arclight (форк): https://github.com/GezzyDax/Arclight
- All the Mods 10: https://www.curseforge.com/minecraft/modpacks/all-the-mods-10


