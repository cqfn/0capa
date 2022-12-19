<img src="https://github.com/cqfn/0capa/blob/master/public/logo-256.png" width="64px"/>

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
 * Postgres client for Ruby
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
* **TOM-Chat-bot**, and lately, the chat-bot is the component which is in charge on posting issues to the repos and keep track of the actions taken.

Once the app has been deploy and setting up process is completed, the rest is to start running the components of TOM.

* **TOM-Radar**
> 1. http://your-server-ip/api/radar/v1/start-radar?source=[source_vcs]
> 2. http://your-server-ip/api/radar/v1/stop-radar?source=[source_vcs]

E.G
> https://mydomain.com/api/radar/v1/start-radar?source=github

* **TOM-Advisor**
> 1. http://your-server-ip/api/advisor/v1/start-advisor?model=[prediction_model]
> 2. http://your-server-ip/api/advisor/v1/stop-advisor?model=[prediction_model]

E.G
> https://mydomain.com/api/advisor/v1/start-advisor?model=kmeans

// Chat-bot daemon is currently not supported.

* **TOM-Chat-bot**
> 1. http://your-server-ip/api/chatbot/v1/start-chatbot?source=[source_vcs]
> 2. http://your-server-ip/api/chatbot/v1/stop-chatbot?source=[source_vcs]

E.G
> https://mydomain.com/api/chatbot/v1/start-chatbot?source=github

\
Note: it's important to say that every component has endpoints to start and stop its own activity.

___


## Working with TOM
### Add more patterns and rules

$$ Rule => {P_i, C_j}, where P - pattern, C - capa$$

Run query from an open file to add patterns and rules;
```
INSERT INTO public.patterns (id, title, body, "window", threshold, consensus_pattern, created_at, updated_at)
VALUES (
      DEFAULT, 
      '<<CAPA NAME>>', 
      '<<CAPA BODY>>', 
      14, 
      0.3919,
      '{93.0,
          2.0,
          2.0,
          2.0,
          4.0,
          4.0,
          6.0,
          4.0,
          14.0,
          20.0,
          11.0,
          11.0,
          19.0,
          19.0
      }', '2022-12-19 17:01:22.000000',
              '2022-12-19 17:01:25.000000');
```

A stored procedure is a set of SQL statements with an assigned name. You can execute stored procedures in PostgreSQL, Microsoft SQL Server, Oracle, and MySQL.
<img width="1186" alt="Screenshot 2022-12-19 at 23 52 10" src="https://user-images.githubusercontent.com/38398999/208521714-1d116c5e-ef60-4262-a017-0d80ddb87715.png">

### Switch mode

The Chatbot Daemon Service can spam projects with suggested `CAPAS` in two supported modes: `Random` (that is random suggestion from a predefined set of rules and patterns) and `ML` (that is suggestins based on project metrics collected by Radar Daemon Service and predefined `consensus patterns`). 
The identified `CAPAS` will be generated through the information that we can obtain through the github [APIs](https://docs.github.com/en/rest/reference), so below The stages of the analysis process are presented. 

### How can i switch mode?

All commands you give to 0capa should start with @0capa-beta and be followed by a text, which includes a mnemo of a command. For example, in order to check the status of 0capa in current conversation (ticket), you can post a comment:

```
@0capa-beta what is the current status?
```
The mnemo of the command here is status. All the rest is ignored. You can achieve exactly the same by just posting:
```
@0capa-beta status
```
Here is a full list of all commands, in alphabetic order.
#### Hello
Sort of a "ping". Post `@0capa-beta hello` and expect an immediate answer from Rultor (well, within 60 seconds). If you don't get an answer, there is something wrong with Rultor. Feel free to post a bug to our issue tracker.

#### Status
Checks the status of currently running analyze in project. Just post `@0capa-beta status` and see what 0capa says, like detailed information about mode;

#### Switch mode
By default 0capa proceed project metrics and generate `CAPAs` in `Random` mode. But if you consider it significant you can switch mode(that was described above) simply post `@0capa-beta switch ML mode` and vise-versa.

## How to Contribute

Fork repository, make changes, send us a [pull request](https://www.yegor256.com/2014/04/15/github-guidelines.html).
We will review your changes and apply them to the `master` branch shortly,
provided they don't violate our quality standards. 
