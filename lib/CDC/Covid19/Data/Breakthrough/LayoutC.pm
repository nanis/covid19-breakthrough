package CDC::Covid19::Data::Breakthrough::LayoutC 0.001 {
    use utf8;
    use v5.28;
    use strict;
    use warnings;

    use feature 'signatures';
    no warnings 'experimental::signatures';

    use parent 'CDC::Covid19::Data::Breakthrough::LayoutB';

    use constant date => sprintf(
        'substring-after(normalize-space(string(//h2[contains(normalize-space(text()), "%s")])), "%s")',
        'reported to CDC as of',
        'as of ',
    );

    # Example for the following expressions:
    # > *342 (30%) of 1,136 hospitalizations reported as asymptomatic or not related to COVID-19.
    # > †42 (18%) of 223 fatal cases reported as asymptomatic or not related to COVID-19.
    use constant deaths => sprintf(
        # We want to extract the '223' between 'of' and 'fatal cases' in the example above
        q{
            substring-before(
                substring-after(
                    substring-after(
                        normalize-space(string(//div[contains(normalize-space(text()), "%s")])),
                    "%s"),
                "%s"),
            "%s")
        },
        'reported as asymptomatic or not related to COVID-19',
        '†',
        'of ',
        ' fatal cases',
    );

    use constant hospitalized => sprintf(
        'substring-after(substring-before(normalize-space(string(//div[starts-with(text(), "%s")])), "%s"), "%s")',
        '*',
        'hospitalizations reported',
        'of',
    );

    use constant non_covid19_deaths => sprintf(
        # We want to extract the '42' between the dagger and the opening parenthesis in the example above
        q{
            substring-before(
                substring-after(
                    normalize-space(string(//div[contains(normalize-space(text()), "%s")])),
                "%s"),
            "%s")
        },
        'reported as asymptomatic or not related to COVID-19',
        '†',
        ' (',
    );

    use constant non_covid19_hospitalized => sprintf(
        'substring-after(substring-before(normalize-space(string(//div[starts-with(text(), "%s")])), "%s"), "%s")',
        '*',
        '(',
        '*',
    );

    use constant discriminator => sprintf(
        '//h2[starts-with(normalize-space(text()), "%s")]',
        'Hospitalized or fatal COVID-19 vaccine breakthrough cases reported to CDC as of',
    );

    __PACKAGE__;
}
__END__

