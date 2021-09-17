package CDC::Covid19::Data::Breakthrough::LayoutE 0.001 {
    use utf8;
    use v5.28;
    use strict;
    use warnings;

    use feature 'signatures';
    no warnings 'experimental::signatures';

    use parent 'CDC::Covid19::Data::Breakthrough::LayoutD';

    use constant deaths => '//td[@headers="total deaths"]';

    use constant hospitalized => '//td[@headers="total hospitalized"]';

    use constant discriminator => '//table[@class="table table-bordered"]//th[@id="total"]';

    __PACKAGE__;
}
__END__
