<img src="/logo.svg" width="64px"/>

[![Hits-of-Code](https://hitsofcode.com/github/xavzelada/tom?branch=master)](https://hitsofcode.com/github/xavzelada/tom/view?branch=master)


**TOM** (stands for Theoretically Objective Measurements
of Software Development Projects) is a set of services that are in charge of helping developers or teams in the process of identifying anomilies within their software development process, and providing a list of preventive or corrective actions (aka **CAPAS**) that positively impact the process. and in this way to improve the quality of the final product and its development process.

In order to get help from TOM, it is as simple as adding our bot([@0capa](https://github.com/0capa)) to the list of collaborators in your repository, and with this our bot will automatically take care of obtaining different metrics from your repository, in order to suggest actions to take into account to that in your future updates the identified anomalies are not repeated.



## How it Works?

For now, the identified `anomalies` and `CAPAS` will be generated through the information that we can obtain through the github [APIs](https://docs.github.com/en/rest/reference), so below The stages of the analysis process are presented.

* **Data collection:** as mentioned above, the github API provides a lot of interesting data about the activity of the repositories, so TOM periodically takes care of scanning those repositories that have requested its help.

* **Data analysis:** since TOM has the history of the metrics collected from each repository individually, a component based on ML is in charge of processing this data in order to identify a list of possible anomalies, on which the list of LAYERS that best suit the particular case.

* **Feedback:** once TOM has generated the list of CAPAs for your repository, a bot will create an issue within your repository, indicating each of the anomalies that were identified and the actions to take in consideration.

After you have been solved the issue, you can tag our bot ([@0capa](https://github.com/0capa)) on your closing comment, so TOM will run once again its analysis to verify that there are not more work to be done.

## Software requirements
 * Postgres 12+
 * Ruby 2.6.8
 * Posgres client for Ruby
 * Docker

## Installation using Docker
Tom is divided into 3 diferent services (radar, ML Advisor and chatbot), please follow this step for each of them.

```
  - Step 1: Clone this repository on your local machine
  - Step 2: Navigate to the service to be install 
  - Step 3: On the Dockerfile, modify it to set the database URI and password
  - Step 4: Build the docker imagen (e.g.: docker build . -t tom-radar)
  - Step 5: Create the docker container based on the image created previously (e.g.: docker run --name tom-radar -p 3000:3000 -d tom-radar)
  - Step 6: Log into the docker container to run the database migraions
    - Run rake db:setup to initialize the database (only in the first instalation)
     -Run rake db:migrate to create the tom database structure
```

## Setting up TOM Radar
Once the services are properly deployed and the database has been created, the next step is to add the parameters for each Version control system(VCS) that you might like to integrate to TOM, for this purpose follow the these steps on the database

```
  - Step 1: Setup a new record on the table tom_settings, which requires all the endpoids to be used to extract the metrics from your VCS, (e.g.: repo_info_url, refers to the endpoint to fetch the most general information about an specific repository ),
  - Step 2: Add the list of tokens to be use, due the fact that some VCS have limitations to fetch data from their systems a queue of tokens is required to increase the limit of request, this configuration should be added on the table tom_tokens_queue. 
```

## How to Contribute

Fork repository, make changes, send us a [pull request](https://www.yegor256.com/2014/04/15/github-guidelines.html).
We will review your changes and apply them to the `master` branch shortly,
provided they don't violate our quality standards. 



