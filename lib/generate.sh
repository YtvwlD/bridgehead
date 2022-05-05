#!/bin/bash

if [ ! -d ./landing ]
then 
  mkdir landing
fi

CENTRAL_SERVICES="          <tr>
            <td>CCP-IT</td>
            <td><a href=\"https://monitor.vmitro.de/icingaweb2/dashboard\">Monitoring Service</td>
          </tr>"

LOCAL_SERVICES="          <tr>
            <td>Bridgehead</td>
            <td>Reverse Proxy <a href=\"https://${HOST}:8080/\">Traefik</a></td>
          </tr>"

if [ "$project" = "ccp" ]
then
    CENTRAL_SERVICES+="          <tr>
            <td>CCP-IT</td>
            <td><a href=\"https://patientlist.ccp-it.dktk.dkfz.de\">Zentrale Patientenliste</td>
          </tr>
          <tr>
            <td>CCP-IT</td>
            <td><a href=\"https://decentralsearch.ccp-it.dktk.dkfz.de\">Dezentrale Suche</td>
          </tr>
          <tr>
            <td>CCP-IT</td>
            <td><a href=\"https://centralsearch.ccp-it.dktk.dkfz.de\">Zentrale Suche</td>
          </tr>
          <tr>
            <td>CCP-IT</td>
            <td><a href=\"https://deployment.ccp-it.dktk.dkfz.de\">Deployment-Server</td>
          </tr>
          <tr>
            <td>CCP-IT</td>
            <td><a href=\"https://dktk-kne.kgu.de\">Zentraler Kontrollnummernerzeuger</td>
          </tr>
          "
fi

if [ "$project" = "ccp" ]
then 
    LOCAL_SERVICES+="         <tr>
            <td>DKTK</td>
            <td><a href=\"https://${HOST}/cpp-localdatamanagement/fhir/\">Blaze</a></td>
          </tr>
          "
fi

cat > ./landing/index.html <<EOL
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="">
  <title>Bridgehead Overview</title>
  <!-- Bootstrap core CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
    crossorigin="anonymous"></script>

</head>

<body class="d-flex flex-column min-vh-100">

  <nav class="navbar navbar-light" style="background-color: #aad7f6;">
    <h2 class="pb-2 border-bottom">Bridgehead ${site_name}</h2>
  </nav>
  <div class="container px-4 py-5" id="featured-3">
    <div>
      <h2>Components</h2>
      <h3>Central</h3>
      <table class="table">
        <thead class="thead-dark">
          <tr>
            <th style="width: 50%">Group</th>
            <th style="width: 50%">Service</th>
          </tr>
        </thead>
        <tbody>
          ${CENTRAL_SERVICES}
        </tbody>
      </table>
    </div>

    <div>
      <h3>Local</h3>
      <table class="table">
        <thead class="thead-dark">
          <tr>
            <th style="width: 50%">Project</th>
            <th style="width: 50%">Services</th>
          </tr>
        </thead>
        <tbody>
          ${LOCAL_SERVICES}
        </tbody>
      </table>
    </div>
    <footer class="footer mt-auto py-3">
     <a href="https://dktk.dkfz.de/"><img src="https://www.oncoray.de/fileadmin/files/bilder_gruppen/DKTK/Logo_DKTK_neu_2016.jpg" style="max-width: 30%; height: auto;"></a> DKTK 2022<span style="float: right;"><a href="https://github.com/samply/bridgehead"><button type="button" class="btn btn-primary">Documentaion</button></a></span>
    </footer>
</body>

</html>
EOL