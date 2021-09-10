package CDC::Covid19::Data::Breakthrough 0.001 {
    use utf8;
    use v5.28;
    use strict;
    use warnings;

    use feature 'signatures';
    no warnings 'experimental::signatures';

    use Carp qw( croak );
    use Const::Fast qw( const );
    use JSON::MaybeXS qw();

    # Until I figure out something that matches C but not D, put D before C.
    use constant LAYOUTS => qw(
        CDC::Covid19::Data::Breakthrough::LayoutA
        CDC::Covid19::Data::Breakthrough::LayoutB
        CDC::Covid19::Data::Breakthrough::LayoutD
        CDC::Covid19::Data::Breakthrough::LayoutC
    );

    BEGIN {
        for my $layout (LAYOUTS) {
            my $ret = eval "require $layout; 1";
            croak $@ unless $ret;
        }
    }

    # Use $VAR{xyz} instead of 'xyz'. Because `%VAR` is constant, typos manifest
    # as loud errors rather than silent problems that pop out much later.

    const my %VAR => map +($_ => $_), qw(
        deaths
        deaths_from_covid19
        hospitalized
        hospitalized_from_covid19
        date
        date_updated
        non_covid19_deaths
        non_covid19_hospitalized
        public_sources
        vaccinated
    );

    # Read only accessors for the properties in %VAR

    for my $v (keys %VAR) {
        no strict 'refs';
        *{$v} = sub { $_[0]->{data}{$v} };
    }

    sub new ($class, $tree) {
        my $self = {};

        $self->{layout} = $class->_detect($tree);

        bless $self => $class;

        $self->_extract($tree);

        return $self;
    }

    sub columns ($class) {
        [ grep !/public_sources/, keys %VAR ];
    }

    sub layout ($self) {
        $self->{layout};
    }

    sub to_json($self, %options) {
        my $json = JSON::MaybeXS->new(%options);
        $json->encode($self->{data});
    }

    sub _detect ($class, $tree) {
        my ($detected) = grep scalar $tree->findnodes($_->discriminator), $class->LAYOUTS;
        return $detected;
    }

    sub _extract ($self, $tree) {
        $self->_extract_date($tree);
        $self->_extract_date_updated($tree);
        $self->_extract_deaths($tree);
        $self->_extract_hospitalized($tree);
        $self->_extract_public_sources($tree);
        $self->_extract_vaccinated($tree);

        return;
    }

    sub _extract_date($self, $tree) {
        my $var = $VAR{date};
        $self->{data}{$var} = _yyyymmdd_of($tree->findvalue($self->layout->date));

        return;
    }

    sub _extract_date_updated ($self, $tree) {
        my $var = $VAR{date_updated};
        my $val = $tree->findnodes($self->layout->$var)->[0]->attr('content');

        $self->{data}{$var} = _yyyymmdd_of($val);
        return;
    }

    sub _extract_severe_cases ($self, $tree, $case_type) {
        my $var = $VAR{$case_type};
        my $non_covid19 = $VAR{"non_covid19_${case_type}"};

        for my $v ($var, $non_covid19) {
            $self->{data}{$v} = $tree->findvalue($self->layout->$v);
            $self->{data}{$v} =~ s/[^0-9]+//g;
            $self->{data}{$v} += 0;
        }

        $self->{data}{$VAR{"${case_type}_from_covid19"}} = $self->$case_type - $self->$non_covid19;

        return;
    }

    sub _extract_deaths ($self, $tree) {
        $self->_extract_severe_cases($tree, 'deaths');
    }

    sub _extract_hospitalized ($self, $tree) {
        $self->_extract_severe_cases($tree, 'hospitalized');
    }

    sub _extract_public_sources ($self, $tree) {
        my $var = $VAR{public_sources};

        $self->{data}{$var} = [
            map [
                map(s/external icon//r, $_->as_text),
                $_->attr('href')
            ], $tree->findnodes($self->layout->$var)
        ];

        return;
    }

    sub _extract_vaccinated ($self, $tree) {
        my $var = $VAR{vaccinated};

        $self->{data}{$var} = $tree->findvalue($self->layout->$var);
        $self->{data}{$var} =~ s/[^0-9]+//g;
        $self->{data}{$var} += 0;

        return;
    }

    sub _yyyymmdd_of ($val) {
        state %months = map {
            my $m = $_;
            map +($m->[$_] => 1 + $_), 0 .. $#$m;
        } [
            qw(
                January
                February
                March
                April
                May
                June
                July
                August
                September
                October
                November
                December
            )
        ];

        state $pat = qr{
            (?<month> @{[join '|', sort keys %months]}) \s+
            (?<day> [123]?[0-9]), \s+
            (?<year> 2021)
        }x;

        if ($_[0] =~ /^([^T]+)T/) {
            return $1;
        }

        if ($_[0] =~ $pat) {
            return sprintf '%04d-%02d-%02d', $+{year}, $months{$+{month}}, $+{day};
        }

        croak "Failed to parse date string '$_[0]'";
    }
=pod

=head1 NAME

CDC::Covid19::Data::Breakthrough - Extract and store Covid19 breakthrough hospitalizations/deaths data provided by the U.S. CDC

=head1 VERSION

Version 0.001

=head1 SYNOPSIS

This module provides a uniform interface to extract and store Covid-19 breakthrough hospitalization and death data provided by the U.S. CDC. The CDC updates the contents of the page L<COVID-19 Vaccine Breakthrough Case Investigation and Reporting|https://www.cdc.gov/vaccines/covid-19/health-departments/breakthrough-cases.html>. Since updates overwrite previous information, producing the time series relies on L<snapshots stored on archive.today|https://archive.is/https://www.cdc.gov/vaccines/covid-19/health-departments/breakthrough-cases.html>.

The constructor takes a single argument which specifies the URL or path to a snapshot of that URL. The module then invokes the correct extractor to read the data from the page and store it in a simple object that can be serialized as desired.

    use CDC::Covid19::Data::Breakthrough;

    my $data = CDC::Covid19::Data::Breakthrough->new($snapshot_file);
    ...

=head1 METHODS

=head2 C<new ($snapshot_file)>

This is the constructor. Invoke it with the path to a snapshot file.

=head2 C<columns>

List of data columns.

=head2 C<layout>

Detected layout for the snapshot file.

=head2 C<to_json>

Serialize to JSON.

=head2 C<date>

The end date of the period to which the data refer.

=head2 C<date_updated>

Contains archival date for snapshots obtained from L<archive.today|https://archive.today/https://www.cdc.gov/vaccines/covid-19/health-departments/breakthrough-cases.html>. Otherwise, the C<YYYY-MM-DD> formatted contents of the C<cdc:last_updated> meta tag.

=head2 C<deaths>

Number of fully vaccinated people who died with a positive Covid-19 test result.

=head2 C<deaths_from_covid19>

C<deaths> - C<non_covid19_deaths>.

=head2 C<hospitalized>

Number of fully vaccinated people who are hospitalized with a positive Covid-19 test result.

=head2 C<hospitalized_from_covid19>

C<hospitalized> - C<non_covid19_hospitalized>.

=head2 C<non_covid19_deaths>

Number of people who had no symptoms of COVID-19 or whose death was not COVID-related.

=head2 C<non_covid19_hospitalized>

Number of people who had no symptoms of COVID-19 or whose hospitalization was not COVID-related.

=head2 C<public_sources>

States and jurisdictions that are publicly reporting vaccine breakthrough cases identified by CDC.

=head2 C<vaccinated>

Number of people who received their second vaccine dose at least two weeks prior in millions.

=head1 AUTHOR

L<A. Sinan Unur|https://www.unur.com/contact.html>

=head1 BUGS

Please report any bugs or feature requests using L<GitHub issues|https://github.com/nanis/cdc-covid19-breakthrough-data/issues>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CDC::Covid19::Data::Breakthrough

=head1 ACKNOWLEDGEMENTS

I ❤️ Perl and owe thanks to both Perl5 porters and the developers who maintain libraries on L<CPAN|https://metacpan.org>. As always, all errors and bugs are mine.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2021 by A. Sinan Unur.

This is free software, licensed under:

  The Apache License version 2.0

=cut
    __PACKAGE__;
}
__END__
