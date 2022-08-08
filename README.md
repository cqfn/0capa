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
```
  - Step 1: Clone this repository on your local machine
  - Step 2: On the Dockerfile, set the database URI (#DATABASE_URL) and password (#DATABASE_PASSWORD)
  - Step 3: Build the docker imagen (e.g.: docker build . -t tom-agent)
  - Step 4: Create the docker container based on the image created previously (e.g.: docker run --name tom-agent -p 3000:3000 -d tom-agent)
  - Step 6: Log into the docker container to run the database migraions
    - Run rake db:setup to initialize the database (only in the first instalation)
     -Run rake db:migrate to create the tom database structure
```

## Setting up TOM 
Once the services are properly deployed and the database has been created, the next step is to add the parameters for each Version control system(VCS) that you might like to integrate to TOM, for this purpose follow the these steps on the database

```
  - Step 1: On the table **tom_settings**, look at the record which correspond to the VCS to be configured, for example "github", 
  - Step 2: On that record, you will need to set the api secrect, which means the Personal Token generated from user who will be the "colaborator" on ever yproject
  - Step 3: And as a last step, due the fact that some VCS have limitations on the number of daily request to fetch data from their systems, we have added a list of tokens (tom_tokens_queues). 
```

## Starting TOM
At the moment **TOM** is composed by 3 different components, which are
* **TOM-Radar**, is the responsible to collect the data from the different VCS.
* **TOM-Advisor**, is the component aimed to analyze the data collected previously by the *Radar* to find some possible anomalies and produce a set of possible actions to fix it or to avoid it in the future.
* **TOM-Chatbot**, and lately, the chatbot is the component which is in charge on posting issues to the repos and keep track of the actions taken.

Once the app has been deploy and setting up process is completed, the rest is to start running the components of TOM.

* **TOM-Radar**
> 1. http://your-server-ip/api/radar/v1/start-radar?source=[source_vcs]
> 1. http://your-server-ip/api/radar/v1/stop-radar?source=[source_vcs]

E.G
> https://mydomain.com/api/radar/v1/start-radar?source=github

* **TOM-Advisor**
> 1. http://your-server-ip/api/advisor/v1/start-advisor?model=[prediction_model]
> 1. http://your-server-ip/api/advisor/v1/stop-advisor?model=[prediction_model]

E.G
> https://mydomain.com/api/radar/v1/start-advisor?model=kmeans
* **TOM-Chatbot**
> 1. http://your-server-ip/api/radar/v1/start-chatbot?source=[source_vcs]
> 1. http://your-server-ip/api/radar/v1/stop-chatbot?source=[source_vcs]

E.G
> https://mydomain.com/api/radar/v1/start-chatbot?source=github

\
Note: it's important to say that every component has endpoints to start and stop its own activity.

___


## How to Contribute

Fork repository, make changes, send us a [pull request](https://www.yegor256.com/2014/04/15/github-guidelines.html).
We will review your changes and apply them to the `master` branch shortly,
provided they don't violate our quality standards. 
