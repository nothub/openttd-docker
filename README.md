## openttd-docker

[docker hub](https://hub.docker.com/r/n0thub/openttd)

---

### Configuration

#### Custom config

A custom configuration can be loaded by mounting the file to: `/data/openttd.cfg`

Available options are listed in the official [wiki](https://wiki.openttd.org/en/Archive/Manual/Settings/Openttd.cfg) and [github](https://github.com/OpenTTD/OpenTTD/blob/master/src/settings_type.h).

#### Load latest autosave

If the environment variable LOAD_AUTOSAVE is set, the latest autosave present in `/data/save/autosave/` will be loaded.

#### Load template save

A template save file can be loaded by mounting the file to: `/data/save/template.sav`

The file will be ignored if LOAD_AUTOSAVE is set and an autosave file is present in `/data/save/autosave/`.

#### Custom user or group id

A custom user or group id can be defined by setting the environment variable `PUID` or `PGID`, e.g. `PUID=2000` or `PGID=3000`.

---

### Online content

To download online content in a running container, use the `content` command:

```
content update
content state ITL Houses
content select 54540301
content download
```

For online content to be loaded from persistent storage, make sure the content file is:

Present in the mounted volume, e.g.

`54540301-ITL_Houses-2.1.tar`:`/data/content_download/newgrf/54540301-ITL_Houses-2.1.tar`

And configured in the `/data/openttd.cfg` config file, e.g.

```
[newgrf]
54540301|F7CDD4F730E4F3EE87100CE42E5070AE|itl_houses-2.1/itl_houses.grf = 0 0 0
```

---

### Examples

<details><summary>Defaults</summary>

**docker run**

```bash
docker run --interactive --tty --rm \
  -p "3979:3979/tcp"                \
  -p "3979:3979/udp"                \
  n0thub/openttd:latest
```

**docker compose**

```yaml
version: '3'
services:
  openttd:
    image: n0thub/openttd:latest
    ports:
      - "3979:3979/tcp"
      - "3979:3979/udp"
```

---

</details>

<details><summary>Custom config</summary>

**docker run**

```bash
docker run --interactive --tty --rm         \
  -p "3979:3979/tcp"                        \
  -p "3979:3979/udp"                        \
  -v "${PWD}/example.cfg:/data/openttd.cfg" \
  n0thub/openttd:latest
```

**docker compose**

```yaml
version: '3'
services:
  openttd:
    image: n0thub/openttd:latest
    ports:
      - "3979:3979/tcp"
      - "3979:3979/udp"
    volumes:
      - ./example.cfg:/data/openttd.cfg
```

---

</details>

<details><summary>Persistent storage mount</summary>

**docker run**

```bash
docker run --interactive --tty --rm \
  -p "3979:3979/tcp"                \
  -p "3979:3979/udp"                \
  -v "${PWD}/data/:/data/"          \
  n0thub/openttd:latest
```

**docker compose**

```yaml
version: '3'
services:
  openttd:
    image: n0thub/openttd:latest
    ports:
      - "3979:3979/tcp"
      - "3979:3979/udp"
    volumes:
      - ./data/:/data/
```

---

</details>

<details><summary>Load latest autosave</summary>

**docker run**

```bash
docker run --interactive --tty --rm \
  -p "3979:3979/tcp"                \
  -p "3979:3979/udp"                \
  -v "${PWD}/data/:/data/"          \
  -e LOAD_AUTOSAVE="true"           \
  n0thub/openttd:latest
```

**docker compose**

```yaml
version: '3'
services:
  openttd:
    image: n0thub/openttd:latest
    ports:
      - "3979:3979/tcp"
      - "3979:3979/udp"
    volumes:
      - ./data/:/data/
    environment:
      - LOAD_AUTOSAVE="true"
```

---

</details>

<details><summary>Load template save</summary>

**docker run**

```bash
docker run --interactive --tty --rm                \
  -p "3979:3979/tcp"                               \
  -p "3979:3979/udp"                               \
  -v "${PWD}/template.sav:/data/save/template.sav" \
  n0thub/openttd:latest
```

**docker compose**

```yaml
version: '3'
services:
  openttd:
    image: n0thub/openttd:latest
    ports:
      - "3979:3979/tcp"
      - "3979:3979/udp"
    volumes:
      - ./template.sav:/data/save/template.sav
```

---

</details>

<details><summary>Custom user or group id</summary>

**docker run**

```bash
docker run --interactive --tty --rm \
  -p "3979:3979/tcp"                \
  -p "3979:3979/udp"                \
  -v "${PWD}/data/:/data/"          \
  -e PUID=2000                      \
  -e PGID=3000                      \
  n0thub/openttd:latest
```

**docker compose**

```yaml
version: '3'
services:
  openttd:
    image: n0thub/openttd:latest
    ports:
      - "3979:3979/tcp"
      - "3979:3979/udp"
    volumes:
      - ./data/:/data/
    environment:
      - PUID=2000
      - PGID=3000
```

---

</details>

<details><summary>Combined options</summary>

**docker run**

```bash
docker run --interactive --tty --rm                \
  -p "3979:3979/tcp"                               \
  -p "3979:3979/udp"                               \
  -v "${PWD}/data/:/data/"                         \
  -v "${PWD}/example.cfg:/data/openttd.cfg"        \
  -v "${PWD}/template.sav:/data/save/template.sav" \
  -e PUID=2000                                     \
  -e PGID=3000                                     \
  -e LOAD_AUTOSAVE="true"                          \
  n0thub/openttd:latest
```

**docker compose**

```yaml
version: '3'
services:
  openttd:
    image: n0thub/openttd:latest
    ports:
      - "3979:3979/tcp"
      - "3979:3979/udp"
    volumes:
      - ./data/:/data/
      - ./example.cfg:/data/openttd.cfg
      - ./template.sav:/data/save/template.sav
    environment:
      - PUID=2000
      - PGID=3000
      - LOAD_AUTOSAVE="true"
```

---

</details>

### Arguments

Arguments will be relayed to the OpenTTD process if supplied to the container:

```bash
docker run --rm n0thub/openttd:latest --help
```
