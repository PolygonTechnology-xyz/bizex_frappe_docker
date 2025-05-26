# Prerequisite

## Github => Personal Access Token
Github Personal Access Token (PAT) is needed for using private repository while building image. Token creation step is given below:

1. Go to github => settings => Developer Settings => Fine-grained tokens
2. Click on "Generate new token"
3. Please provide proper "Resource owner", select option "Only select repositories" for selecting specified repositories.
4. For "Repository permissions" make "Contents" type as "Read and Write" and "Metadata" type as "Read only"
5. After providing all information generate the token and copy the token text carefully and store it in a secret place.

**Note:** Be sure to approve it from organization authority

## Docker Hub login
Make sure docker is logged in with Docker Hub on both local and server. This is needed to push and pull private image.

# Frappe Image Building and Pushing

1. Git clone `git@github.com:PolygonTechnology-xyz/bizex_frappe_docker.git`. Make sure you are in the `main` branch.
2. Outside of cloned git repo create a file named `apps.json`
3. In `apps.json` add following text:
```json
[
    {   // Public Repo
        "url": "https://github.com/frappe/erpnext",
        "branch": "version-15"
    },
    {   // Public Repo
        "url": "https://github.com/frappe/hrms",
        "branch": "version-15"
    },
    {   // Private Repo
        "url": "https://{PAT}@github.com/PolygonTechnology-xyz/<specific_repo>.git",
        "branch": "<specific_repo_branch>"
    }
]
```
4. Convert this `apps.json` to a base64 string and store it under a variable:
```bash
export APPS_JSON_BASE64=$(base64 -w 0 apps.json)
```
5. To check proper base64 conversion run:
```bash
echo "$APPS_JSON_BASE64" | base64 --decode > apps_decoded.json
```
6. Run the following command to build the image:
```bash
docker build --no-cache \
    --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
    --build-arg=FRAPPE_BRANCH=version-15 \
    --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
    --tag=<docker_hub_username>/<image_name>:<tag_name> \
    --file=images/layered/Containerfile .
```
7. After proper build push the image to Docker Hub:
```bash
docker push <docker_hub_username>/<image_name>:<tag_name>
```
> **Note:** Ensure Docker is logged in to Docker Hub

8. After proper push check Docker Hub

# Image Testing on Local

1. Inside cloned frappe docker repository open `.env` file and change following variables:
```
IMAGE_NAME=<image_name>
SITE_NAME=<site_name>
ADMIN_PASSWORD=admin
MYSQL_ROOT_PASSWORD=admin
INSTALL_APPS=erpnext hrms <custom_app>
CONTAINER_NAME=frappe_backend
FRONTEND_PORT=<specific_port>
```
> **Note:** `<image_name>` should be the image that was just built.

2. Run following command to run image:
```bash
make up
```
3. Wait for container setup. Check status with:
```bash
docker compose -f pwd.yml logs -f create-site
```
4. Browse: `http://localhost:<specific_port>/app`

**Note:**
- Before deployment always run `make down` for targeted application. Be sure to change `.env` with proper values before.
- To destroy all volumes and containers: `make destroy` (Use with caution).

# Image Deployment on Server

1. Login to polygon_server:
```bash
ssh polygon_server
```
2. Navigate to working directory:
```bash
cd /home/polygon/projects/erpnext
```
3. Clone frappe docker repository on server if not cloned. Ensure it’s on `main` branch.
4. Follow "Image Testing on Local" steps 1–3.
5. Browse: `http://<server_ip>:<specific_port>/app`

**Note:** Don’t run `make destroy` on server

# Polygon SSH Server Login Configuration

- Download `polygon_server_key` from Google Drive or from Pasha Bhai
- Place it under `/home/abir/.ssh`
- Configure `~/.ssh/config` file:
```
Host polygon_server
HostName 192.168.27.4
User polygon
Port 22
IdentityFile ~/.ssh/polygon_server_key
```
- Check login with:
```bash
ssh polygon_server
```

# Running App on Server if Down

1. Login to server:
```bash
ssh polygon_server
```
2. Navigate to frappe docker directory:
```bash
cd /home/polygon/projects/erpnext/frappe_docker
```
3. Run:
```bash
make up
```

# Important Links

- [Frappe Docker](https://github.com/frappe/frappe_docker)
- [Google Drive File](https://drive.google.com/file/d/1QvKPUOBXS0I-S_adX_k6uBT3YOGJV-ob/view?usp=drive_link)