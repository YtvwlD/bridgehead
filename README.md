# Bridgehead

This repository contains all information and tools to deploy a bridgehead. If you have any questions about deploying a bridgehead, please [contact us](mailto:verbis-support@dkfz-heidelberg.de).


TOC

1. [About](#about)
    - [Projects](#projects)
        - [GBA/BBMRI-ERIC](#gbabbmri-eric)
        - [DKTK/C4](#dktkc4)
        - [NNGM](#nngm)
    - [Bridgehead Components](#bridgehead-components)
        - [Blaze Server](#blaze-serverhttpsgithubcomsamplyblaze)   
1. [Requirements](#requirements)
    - [Hardware](#hardware)
    - [System](#system-requirements)
2. [Getting Started](#getting-started)
    - [DKTK](#dktkc4)
    - [C4](#c4)
    - [GBA/BBMRI-ERIC](#gbabbmri-eric)
3. [Configuration](#configuration)
4. [Managing your Bridgehead](#managing-your-bridgehead)
    - [Systemd](#on-a-server)
    - [Without Systemd](#on-developers-machine)
4. [Pitfalls](#pitfalls)
5. [Migration-guide](#migration-guide)
7. [License](#license)


## About

TODO: Insert comprehensive feature list of the bridgehead? Why would anyone install it?

### Projects

#### GBA/BBMRI-ERIC

The **Sample Locator** is a tool that allows researchers to make searches for samples over a large number of geographically distributed biobanks. Each biobank runs a so-called **Bridgehead** at its site, which makes it visible to the Sample Locator.  The Bridgehead is designed to give a high degree of protection to patient data. Additionally, a tool called the [Negotiator][negotiator] puts you in complete control over which samples and which data are delivered to which researcher.

You will most likely want to make your biobanks visible via the [publicly accessible Sample Locator][sl], but the possibility also exists to install your own Sample Locator for your site or organization, see the GitHub pages for [the server][sl-server-src] and [the GUI][sl-ui-src].

The Bridgehead has two primary components:
* The **Blaze Store**. This is a highly responsive FHIR data store, which you will need to fill with your data via an ETL chain.
* The **Connector**. This is the communication portal to the Sample Locator, with specially designed features that make it possible to run it behind a corporate firewall without making any compromises on security.

#### CCP(DKTK/C4)

TODO:

#### NNGM

TODO:

### Bridgehead Components

#### [Blaze Server](https://github.com/samply/blaze)

This holds the actual data being searched. This store must be filled by you, generally by running an ETL on your locally stored data to turn it into the standardized FHIR format that we require.

#### [Connector]

TODO:



## Requirements

### Hardware

For running your bridgehead we recommend the follwing Hardware:

- 4 CPU cores
- At least 8 GB Ram
- 100GB Hard Drive, SSD recommended


### System Requirements

Before starting the installation process, please ensure that following software is available on your system:

//Remove
#### [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

To check that you have a working git installation, please run
``` shell
cd ~/;
git clone https://github.com/octocat/Hello-World.git;
cat ~/Hello-World/README;
rm -rf Hello-World;
```
If you see the output "Hello World!" your installation should be working.


//Just install docker-compose und docker with version
#### [Docker](https://docs.docker.com/get-docker/)

To check your docker installation, you can try to execute dockers "Hello World" Image. The command is:
``` shell
docker run --rm --name hello-world hello-world;
```
Docker will now download the "hello-world" docker image and try to execute it. After the download you should see a message starting with "Hello from Docker!".

> NOTE: If the download of the image fails (e.g with "connection timed out" message), ensure that you have correctly set the proxy for the docker daemon. Refer to ["Docker Daemon Proxy Configuration" in the "Pitfalls" section](#docker-daemon-proxy-configuration)

You should also check, that the version of docker installed by you is newer than "1.20". To check this, just run 

``` shell
docker --version
```

#### [Docker Compose](https://docs.docker.com/compose/cli-command/#installing-compose-v2)

To check your docker-compose installation, please run the following command. It uses the "hello-world" image from the previous section:
``` shell
docker-compose -f - up <<EOF
version: "3.9"
services:
  hello-world:
    image: hello-world
EOF
```
After executing the command, you should again see the message starting with "Hello from Docker!".

You should also ensure, that the version of docker-compose installed by you is newer than "2.XX". To check this, just run 

``` shell
docker-compose --version
```

#### [systemd](https://systemd.io/)

You shouldn't need to install it yourself. If systemd is not available on your system you should get another system.
To check if systemd is available on your system, please execute

``` shell
systemctl --version
```

---

## Getting Started

If your system passed all checks from ["Requirements" section], you are now ready to download the bridgehead.

First, clone the repository to the directory "/srv/docker/bridgehead":

``` shell
sudo mkdir -p /srv/docker/;
sudo git clone https://github.com/samply/bridgehead.git /srv/docker/bridgehead;
```

When using the systemd services we you need to create a bridgehead user for security reasons. This should be done after clone the repository. Since not all linux distros support ```adduser```, we provide a action for the systemcall ```useradd```.

//

``` shell
adduser --no-create-home --disabled-login --ingroup docker --gecos "" bridgehead
```

``` shell
useradd -M -g docker -N -s /sbin/nologin bridgehead
chown bridgehead /srv/docker/bridgehead/ -R
```


Next, you need to configure a set of variables, specific for your site with not so high security concerns. You can visit the configuration template at [GitHub](https://github.com/samply/bridgehead-config). You can download the repositories contents and add them to the "bridgehead-config" directory.

``` shell
sudo git clone https://github.com/samply/bridgehead-config.git /etc/bridgehead;
```
> NOTE: If you are part of the CCP-IT we will provide you another link for the configuration.

You should now be able to run a bridgehead instance. To check if everything works, execute the following:
``` shell
/srv/docker/bridgehead/bridgehead start <project>
```

You should now be able to access the landing page on your system, e.g "https://<your-host>/" 

To shutdown the bridgehead just run.
``` shell
/srv/docker/bridgehead/bridgehead stop <project>
```

We recommend to run first with the start and stop script and if aviable run the systemd service, which also enables automatic updates and more.

### Systemd service

For a server, we highly recommend that you install the system units for managing the bridgehead, provided by us. You can do this by executing the [bridgehead](./bridgehead) script:
``` shell
sudo /srv/docker/bridgehead/bridgehead install <project>
```

Finally, you need to configure your sites secrets. These are places as configuration for each bridgeheads system unit. Refer to the section for your specific project:

For Every Project you need to set the proxy this way, if you have a proxy.

``` conf
[Service]
Environment=http_proxy=
Environment=https_proxy=
```

### CCP(DKTK/C4)

You can create the site specific configuration with: 

``` shell
sudo systemctl edit bridgehead@ccp.service;
sudo systemctl edit bridgehead-update@ccp.service;

```

This will open your default editor allowing you to edit the docker system units configuration. Insert the following lines in the editor and define your machines secrets. You share some of the ID-Management secrets with the central patientlist (Mainz) and controlnumbergenerator (Frankfurt). Refer to the ["Configuration" section](#configuration) for this.

``` conf
[Service]
Environment=http_proxy=
Environment=https_proxy=
```

To make the configuration effective, you need to tell systemd to reload the configuration and restart the docker service:

``` shell
sudo systemctl daemon-reload;
sudo systemctl bridgehead@ccp.service;
```

### DKTK/C4

You can create the site specific configuration with: 

``` shell
sudo systemctl edit bridgehead@c4.service;
```

This will open your default editor allowing you to edit the docker system units configuration. Insert the following lines in the editor and define your machines secrets. You share some of the ID-Management secrets with the central patientlist (Mainz) and controlnumbergenerator (Frankfurt). Refer to the ["Configuration" section](#configuration) for this.

``` conf
[Service]
Environment=http_proxy=
Environment=https_proxy=
Environment=HOSTIP=
Environment=HOST=
Environment=HTTP_PROXY_USER=
Environment=HTTP_PROXY_PASSWORD=
Environment=HTTPS_PROXY_USER=
Environment=HTTPS_PROXY_PASSWORD=
Environment=CONNECTOR_POSTGRES_PASS=
Environment=ML_DB_PASS=
Environment=MAGICPL_API_KEY=
Environment=MAGICPL_MAINZELLISTE_API_KEY=
Environment=MAGICPL_API_KEY_CONNECTOR=
Environment=MAGICPL_MAINZELLISTE_CENTRAL_API_KEY=
Environment=MAGICPL_CENTRAL_API_KEY=
Environment=MAGICPL_OIDC_CLIENT_ID=
Environment=MAGICPL_OIDC_CLIENT_SECRET=
```

To make the configuration effective, you need to tell systemd to reload the configuration and restart the docker service:

``` shell
sudo systemctl daemon-reload;
sudo systemctl bridgehead@c4.service;
```
### GBA/BBMRI-ERIC

You can create the site specific configuration with: 

``` shell
sudo systemctl edit bridgehead@gbn.service;
```

This will open your default editor allowing you to edit the docker system units configuration. Insert the following lines in the editor and define your machines secrets.

``` conf
[Service]
Environment=HOSTIP=
Environment=HOST=
Environment=HTTP_PROXY_USER=
Environment=HTTP_PROXY_PASSWORD=
Environment=HTTPS_PROXY_USER=
Environment=HTTPS_PROXY_PASSWORD=
Environment=CONNECTOR_POSTGRES_PASS=
```

To make the configuration effective, you need to tell systemd to reload the configuration and restart the docker service:

``` shell
sudo systemctl daemon-reload;
sudo systemctl bridgehead@gbn.service;
```

### Developers

Because some developers machines doesn't support system units (e.g Windows Subsystem for Linux), we provide a dev environment [configuration script](./lib/init-test-environment.sh).
It is not recommended to use this script in production!

## Configuration

### Basic Auth

For Data protection we use basic authenfication for some services. To access those services you need a username and password combination. If you start the bridgehead with them, those services are not accesbile. We provide a script which set the needed config for you, just run the script and follow the instructions.

``` shell
add_user.sh <project>
```

If you are not using the systemd service, you need to export it yourself with 

``` shell
docker run --rm -it httpd:latest htpasswd -nb <username> <password>
```

The result needs to be set in your current console with:

``` shell
export bc_auth_user=<output>
```

Cation: you need to escape occrring dollar signs.

### HTTPS Access

We advise to use https for all service of your bridgehead. HTTPS is enabled on default. For starting the bridghead you need a ssl certificate. You can either create it yourself or get a signed one. You need to drop the certificates in /certs.

The bridgehead create one autotmatic on the first start. However it will be unsigned and we recomend to get a signed one.


### Locally Managed Secrets

This section describes the secrets you need to configure locally through the configuration

| Name                                 | Recommended Value                                                                                 | Description |  
|--------------------------------------|---------------------------------------------------------------------------------------------------| ----------- |  
| HTTP_PROXY_USER                      |                                                                                                   | Your local http proxy user |
| HOSTIP                               | Compute with: `docker run --rm --add-host=host.docker.internal:host-gateway ubuntu cat /etc/hosts | grep 'host.docker.internal' | awk '{print $1}'` | The ip from which docker containers can reach your host system. |
| HOST                                 | Compute with: `hostname`                                                                          |The hostname from which all components will eventually be available|
| HTTP_PROXY_PASSWORD                  |                                                                                                   |Your local http proxy user's password|
| HTTPS_PROXY_USER                     |                                                                                                   |Your local https proxy user|
| HTTPS_PROXY_PASSWORD                 || Your local https proxy user's password                                                            |
| CONNECTOR_POSTGRES_PASS              | Random String                                                                                     |The password for your project specific connector.|
| STORE_POSTGRES_PASS                  | Random String                                                                                     |The password for your local datamanagements database (only relevant in c4)|
| ML_DB_PASS                           | Random String                                                                                     |The password for your local patientlist database|
| MAGICPL_API_KEY                      | Random String                                                                                     |The apiKey used by the local datamanagement to create pseudonymes.|
| MAGICPL_MAINZELLISTE_API_KEY         | Random String                                                                                     |The apiKey used by the local id-manager to communicate with the local patientlist|
| MAGICPL_API_KEY_CONNECTOR            | Random String                                                                                     |The apiKey used by the connector to communicate with the local patientlist|
| MAGICPL_MAINZELLISTE_CENTRAL_API_KEY | You need to ask the central patientlists admin for this.                                          |The apiKey for your machine to communicate with the central patientlist|
| MAGICPL_CENTRAL_API_KEY              | You need to ask the central controlnumbergenerator admin for this.                                |The apiKey for your machine to communicate with the central controlnumbergenerator|
| MAGICPL_OIDC_CLIENT_ID               || The client id used for your machine, to connect with the central authentication service           |
| MAGICPL_OIDC_CLIENT_SECRET           || The client secret used for your machine, to connect with the central authentication service       |

### Cooperatively Managed Secrets

> TODO: Describe secrets from site-config 

## Managing your Bridgehead

> TODO: Rewrite this section (restart, stop, uninstall, manual updates)

### On a Server

#### Start

This will start a not running bridgehead system unit:
``` shell
sudo systemctl start bridgehead@<dktk/c4/gbn>
```

#### Stop

This will stop a running bridgehead system unit:
``` shell
sudo systemctl stop bridgehead@<dktk/c4/gbn>
```

#### Update

This will update bridgehead system unit:
``` shell
sudo systemctl start bridgehead-update@<dktk/c4/gbn>
```

#### Remove the Bridgehead System Units

If, for some reason you want to remove the installed bridgehead units, we added a command to [bridgehead](./bridgehead):
``` shell
sudo /srv/docker/bridgehead/bridgehead uninstall <project>
```

### On Developers Machine

For developers, we provide additional scripts for starting and stopping the specif bridgehead:

#### Start or stop

This command starts a specified bridgehead. Choose between "dktk", "c4" and "gbn".
``` shell
/srv/docker/bridgehead/bridgehead start <dktk/c4/gbn>
```

#### Stop

This command stops a specified bridgehead. Choose between "dktk", "c4" and "gbn".
``` shell
/srv/docker/bridgehead/bridgehead stop <dktk/c4/gbn>
```

#### Update

This shell script updates the configuration for all bridgeheads installed on your system.
``` shell
/srv/docker/bridgehead/bridgehead update
```
> NOTE: If you want to regularly update your developing instance, you can create a CRON job that executes this script.

## Migration Guide

> TODO: How to transfer from windows/gbn

## Pitfalls

### [Git Proxy Configuration](https://gist.github.com/evantoli/f8c23a37eb3558ab8765)

Unlike most other tools, git doesn't use the default proxy variables "http_proxy" and "https_proxy". To make git use a proxy, you will need to adjust the global git configuration:

``` shell
sudo git config --global http.proxy http://<your-proxy-host>:<your-proxy-port>;
sudo git config --global https.proxy http://<your-proxy-host>:<your-proxy-port>;
```
> NOTE: Some proxies may require user and password authentication. You can adjust the settings like this: "http://<your-proxy-user>:<your-proxy-user-password>@<your-proxy-host>:<your-proxy-port>".
> NOTE: It is also possible that a proxy requires https protocol, so you can replace this to.

You can check that the updated configuration with

``` shell
sudo git config --global --list;
```

### Docker Daemon Proxy Configuration

Docker has a background daemon, responsible for downloading images and starting them. To configure the proxy for this daemon, use the systemctl command:

``` shell
sudo systemctl edit docker
```

This will open your default editor allowing you to edit the docker system units configuration. Insert the following lines in the editor, replace <your-proxy-host> and <your-proxy-port> with the corresponding values for your machine and save the file:
``` conf
[Service]
Environment=HTTP_PROXY=http://<your-proxy-host>:<your-proxy-port>
Environment=HTTPS_PROXY=http://<your-proxy-host>:<your-proxy-port>
Environment=FTP_PROXY=http://<your-proxy-host>:<your-proxy-port>
```
> NOTE: Some proxies may require user and password authentication. You can adjust the settings like this: "http://<your-proxy-user>:<your-proxy-user-password>@<your-proxy-host>:<your-proxy-port>".
> NOTE: It is also possible that a proxy requires https protocol, so you can replace this to.

The file should now be at the location "/etc/systemd/system/docker.service.d/override.conf". You can proof check with
``` shell
cat /etc/systemd/system/docker.service.d/override.conf;
```

To make the configuration effective, you need to tell systemd to reload the configuration and restart the docker service:

``` shell
sudo systemctl daemon-reload;
sudo systemctl restart docker;
```

## After the Installtion

After starting your bridgehead, visit the landing page under the hostname. If you singed your own ssl certificate, there is probable an error message. However, you can accept it as exception. 

On this page, there are all important links to each component, central and local. 

### Connector Administration

The Connector administration panel allows you to set many of the parameters regulating your Bridgehead. Most especially, it is the place where you can register your site with the Sample Locator. To access this page, proceed as follows:

* Open the Connector page: https://<hostname>/<project>-connector/
* In the "Local components" box, click the "Samply Share" button.
* A new page will be opened, where you will need to log in using the administrator credentials (admin/adminpass by default).
* After log in, you will be taken to the administration dashboard, allowing you to configure the Connector.
* If this is the first time you have logged in as an administrator, you are strongly recommended to set a more secure password! You can use the "Users" button on the dashboard to do this.

### GBA/BBMRI-ERIC

#### Register with a Directory

The [Directory][directory] is a BBMRI project that aims to catalog all biobanks in Europe and beyond. Each biobank is given its own unique ID and the Directory maintains counts of the number of donors and the number of samples held at each biobank. You are strongly encouraged to register with the Directory, because this opens the door to further services, such as the [Negotiator][negotiator].

Generally, you should register with the BBMRI national node for the country where your biobank is based. You can find a list of contacts for the national nodes [here](http://www.bbmri-eric.eu/national-nodes/). If your country is not in this list, or you have any questions, please contact the [BBMRI helpdesk](mailto:directory@helpdesk.bbmri-eric.eu). If your biobank is for COVID samples, you can also take advantage of an accelerated registration process [here](https://docs.google.com/forms/d/e/1FAIpQLSdIFfxADikGUf1GA0M16J0HQfc2NHJ55M_E47TXahju5BlFIQ).

Your national node will give you detailed instructions for registering, but for your information, here are the basic steps:

* Log in to the Directory for your country.
* Add your biobank and enter its details, including contact information for a person involved in running the biobank.
* You will need to create at least one collection.
* Note the biobank ID and the collection ID that you have created - these will be needed when you register with the Locator (see below).

#### Register with a Locator

* Go to the registration page http://localhost:8082/admin/broker_list.xhtml.
* To register with a Locator, enter the following values in the three fields under "Join new Searchbroker":
  * "Address": Depends on which Locator you want to register with:
    * `https://locator.bbmri-eric.eu/broker/`: BBMRI Locator production service (European).
    * `http://147.251.124.125:8088/broker/`: BBMRI Locator test service (European).
    * `https://samplelocator.bbmri.de/broker/`: GBA Sample Locator production service (German).
    * `https://samplelocator.test.bbmri.de/broker/`: GBA Sample Locator test service (German).
  * "Your email address": this is the email to which the registration token will be returned.
  * "Automatic reply": Set this to be `Total Size`
* Click "Join" to start the registration process.
* You should now have a list containing exactly one broker. You will notice that the "Status" box is empty.
* Send an email to `feedback@germanbiobanknode.de` and let us know which of our Sample Locators you would like to register to. Please include the biobank ID and the collection ID from your Directory registration, if you have these available.
* We will send you a registration token per email.
* You will then re-open the Connector and enter the token into the "Status" box.
* You should send us an email to let us know that you have done this.
* We will then complete the registration process
* We will email you to let you know that your biobank is now visible in the Sample Locator.

If you are a Sample Locator administrator, you will need to understand the [registration process](./SampleLocatorRegistration.md). Normal bridgehead admins do not need to worry about this.


## License

Copyright 2019 - 2022 The Samply Community

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
