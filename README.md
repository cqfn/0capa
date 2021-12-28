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

## How to install your own bot
```
This guide in process, will be released in a future update
```

## How to Contribute

Fork repository, make changes, send us a [pull request](https://www.yegor256.com/2014/04/15/github-guidelines.html).
We will review your changes and apply them to the `master` branch shortly,
provided they don't violate our quality standards. 

You will need Ruby 2.6+ and postgres 12+.