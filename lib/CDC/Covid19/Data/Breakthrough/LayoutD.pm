package CDC::Covid19::Data::Breakthrough::LayoutD 0.001 {
    use utf8;
    use v5.28;
    use strict;
    use warnings;

    use feature 'signatures';
    no warnings 'experimental::signatures';

    use constant date => sprintf(
        'substring-after(normalize-space(string(//h2[contains(normalize-space(text()), "%s")])), "%s")',
        'Hospitalized or fatal COVID-19 vaccine breakthrough cases reported to CDC as of ',
        'as of',
    );

    use constant date_updated => '/html/head/meta[@property="cdc:last_updated"]';

    use constant deaths => '//th[@id="deaths"]';

    use constant hospitalized => '//th[@id="hospitalized"]';

    use constant non_covid19_deaths => '//td[@headers="asymptomatic deaths"][1]';

    use constant non_covid19_hospitalized => '//td[@headers="asymptomatic hospitalized"][1]';

    use constant vaccinated => sprintf(
        q{
            substring-before(
                substring-after(
                    normalize-space(string(//a[starts-with(normalize-space(text()), "%s")])),
                "%s"),
            "%s")
        },
        'more than ',
        'more than ',
        ' million people',
    );

    use constant public_sources => '//div[@id="acc-panel-1"]//a[@class="tp-link-policy"]';

    use constant discriminator => '//table[@class="table table-bordered"]';

    __PACKAGE__;
}
__END__
