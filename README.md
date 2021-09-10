# Breakthrough hospitalizations and deaths from COVID-19

Tools to extract and store official information on breakthrough hospitalizations anddeaths due to COVID-19 among the fully vaccinated population.

## IMPORTANT DISCLAIMER

***While these tools are for working with data published by official sources (currently only CDC), none of the work is endorsed by those organizations. I use organization names in modules/libraries so as an indicator of the source of data. Any opinion, commentary, inference etc expressed in the code and/or documentation is based on my personal perspective, does not imply endorsement by any organization or any current, past, or future employers/clients etc.***

## Extract and store CDC data on breakthrough hospitalizations and deaths from Covid-19

Currently, this is the only implementation.

The CDC provides some information on the number of hospitalizations and deaths from Covid-19 among those fully vaccinated against Covid-19 in the U.S. They do this by updating the contents of the [COVID-19 Vaccine Breakthrough Case Investigation and Reporting](https://www.cdc.gov/vaccines/covid-19/health-departments/breakthrough-cases.html) page instead of providing a proper time series in a proper data exchange file format.

I am interested specifically in this time series. Irregular snapshots of this page are currently [archived on archive.today](https://archive.is/https://www.cdc.gov/vaccines/covid-19/health-departments/breakthrough-cases.html). I downloaded those snapshots and manually created a couple of spreadsheets by copying and pasting numbers. That is error-prone so I decided to automate it.

Due to both changes introduced by the CDC to the layout of the page and the vagaries of dealing with archived snapshots, the code currently has to deal with four different types of pages with subtle differences in locating the information of interest. Thanks to the excellent [HTML::TreeBuilder::XPath](https://metacpan.org/pod/HTML::TreeBuilder::XPath) module, the code to extract the information was mostly straightforward.

Originally, this information was to be published every Friday for the period up to the previous Monday [as stated by the CDC](https://archive.ph/hAK1h):

> As CDC and state health departments shift to focus only on investigating vaccine breakthrough cases that result in hospitalization or death, those data will be regularly updated and posted every Friday.

The CDC skipped the update on the Friday immediately prior to the [approval of the Pfizer vaccine (Comirnaty)](https://www.fda.gov/news-events/press-announcements/fda-approves-first-covid-19-vaccine). The update on August 20th was delayed to August 23 and was released after the vaccine approval was announced. Since then, updates have been released on Mondays to reflect information up to the preceding Monday.

As of September 10, 2021, [CDC continue to state](https://www.cdc.gov/vaccines/covid-19/health-departments/breakthrough-cases.html):

> Ultimately, CDC will use the [National Notifiable Diseases Surveillance System (NNDSS)](https://archive.ph/o/hAK1h/https://wwwn.cdc.gov/nndss/) to identify vaccine breakthrough cases.

I am not sure why this has not been implemented over the five months since mid-April this year. I hope that when it is implemented, the CDC provide more detailed information regarding breakthrough cases, hospitalizations, and deaths as a time series.

Note the CDC caution on selection bias in the data:

> It is important to note that reported vaccine breakthrough cases will represent an undercount. This surveillance system is passive and relies on voluntary reporting from state health departments which may not be complete.  Also, not all real-world breakthrough cases will be identified because of lack of testing. This is particularly true in instances of asymptomatic or mild illness.

It is important to note that most asymptotic or mild cases of COVID19 infection are unlikely to make it into official statistics either.

## INSTALLATION

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install

## SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc command.

    perldoc CDC::Covid19::Data::Breakthrough

## LICENSE AND COPYRIGHT

This software is Copyright © 2021 by A. Sinan Unur.

This is free software, licensed under:

  [The Apache License version 2.0](LICENSE)
