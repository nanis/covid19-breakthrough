package CDC::Covid19::Data::Breakthrough::LayoutB 0.001 {
    use utf8;
    use v5.28;
    use strict;
    use warnings;

    use feature 'signatures';
    no warnings 'experimental::signatures';

    use constant date => '//div[starts-with(normalize-space(text()), "As of")]';

    use constant date_updated => '/html/head/meta[@property="article:modified_time"]';

    # Example for the following expressions:
    # > *167 (34%) of the 498 hospitalizations were reported as asymptomatic or not related to COVID-19.
    # > †11 (13%) of the 88 fatal cases were reported as asymptomatic or not related to COVID-19

    use constant deaths => sprintf(
        # We want to extract the '88' between 'of the' and 'fatal cases' in the example above
        q{
            substring-before(
                substring-after(
                    substring-after(
                        normalize-space(string(//div[contains(normalize-space(text()), "%s")])),
                    "%s"),
                "%s"),
            "%s")
        },
        'were reported as asymptomatic or not related to COVID-19',
        '†',
        'of the ',
        ' fatal cases',
    );

    use constant hospitalized => sprintf(
        'substring-after(substring-before(normalize-space(string(//div[starts-with(text(), "%s")])), "%s"), "%s")',
        '*',
        'hospitalizations were reported',
        'of the',
    );

    use constant non_covid19_deaths => sprintf(
        # We want to extract the '11' between the dagger and the opening parenthesis in the example above
        q{
            substring-before(
                substring-after(
                    normalize-space(string(//div[contains(normalize-space(text()), "%s")])),
                "%s"),
            "%s")
        },
        'were reported as asymptomatic or not related to COVID-19',
        '†',
        ' (',
    );


    use constant non_covid19_hospitalized => sprintf(
        'substring-after(substring-before(normalize-space(string(//div[starts-with(text(), "%s")])), "%s"), "%s")',
        '*',
        '(',
        '*',
    );

    use constant vaccinated => 'string(//a[contains(normalize-space(text()), "More than")])';

    use constant public_sources => '/doesnotexist';

    use constant discriminator => sprintf(
        '//h2[starts-with(normalize-space(text()), "%s")]',
        'COVID-19 vaccine breakthrough infections reported to CDC as of',
    );

    __PACKAGE__;
}
__END__
