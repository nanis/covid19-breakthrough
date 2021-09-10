package CDC::Covid19::Data::Breakthrough::LayoutA 0.001 {
    use utf8;
    use v5.28;
    use strict;
    use warnings;

    use feature 'signatures';
    no warnings 'experimental::signatures';

    use constant date => '//li[starts-with(normalize-space(text()), "As of")]';

    use constant date_updated => '/html/head/meta[@property="article:modified_time"]';

    use constant deaths => sprintf(
        'substring-before(substring-after(normalize-space(string(//li[contains(text(), "%s")])), "%s"), "%s")',
        'people with breakthrough infections were known to be hospitalized',
        'and',
        ' (',
    );

    use constant hospitalized => sprintf(
        'substring-before(normalize-space(string(//li[contains(text(), "%s")])), "%s")',
        'people with breakthrough infections were known to be hospitalized',
        ' ',
    );

    use constant non_covid19_deaths => sprintf(
        # Example: We want to extract the '9' in the following sentence:
        # > Of the 74 fatal cases, 9 (12%) were reported as asymptomatic or the patient died due to a cause not related to COVID-19.
        'substring-before(substring-after(normalize-space(string(//li[contains(text(), "%s")])), "%s"), "%s")',
        'died due to a cause not related to COVID-19',
        'fatal cases, ',
        ' (',
    );

    use constant non_covid19_hospitalized => sprintf(
        # Example: We want to extract the '133' in the following sentence:
        # > Of the 396 hospitalized patients, 133 (34%) were reported as asymptomatic or hospitalized for a reason not related to COVID-19.
        'substring-before(substring-after(normalize-space(string(//li[contains(text(), "%s")])), "%s"), "%s")',
        'hospitalized for a reason not related to COVID-19',
        'hospitalized patients, ',
        ' (',
    );

    use constant vaccinated => sprintf(
        'substring-before(substring-after(normalize-space(string(//a[contains(text(), "%s")])), "%s"), "%s")',
        'million people',
        'more than',
        'million people',
    );

    use constant public_sources => '/doesnotexist';

    use constant discriminator => sprintf(
        '//h2[normalize-space(text())="%s"]',
        'COVID-19 vaccine breakthrough infections reported to CDC',
    );

    __PACKAGE__;
}
__END__

