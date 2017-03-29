# To Run: perl invert.perl input.pdf output.pdf
use strict;
use warnings;
use PDF::API2;
use PDF::API2::Basic::PDF::Utils;
# There is a dependency here, to install PDF::API2 (or other PERL modules) use:
# cpan
# install PDF::API2


# quit unless we have the correct number of command-line args
my $num_args = $#ARGV + 1;
if ($num_args != 2) {
    print "\nUsage: invert.perl input.pdf output.pdf\n";
    exit;
}


# takes a pdf, inverts the colors and outputs a new pdf
my $pdf = PDF::API2->open($ARGV[0]);
for my $n (1..$pdf->pages()) {
    my $p = $pdf->openpage($n);

    $p->{Group} = PDFDict();
    $p->{Group}->{CS} = PDFName('DeviceRGB');
    $p->{Group}->{S} = PDFName('Transparency');

    my $gfx = $p->gfx(1);  # prepend
    $gfx->fillcolor('white');
    $gfx->rect($p->get_mediabox());
    $gfx->fill();

    $gfx = $p->gfx();  # append
    $gfx->egstate($pdf->egstate->blendmode('Difference'));
    $gfx->fillcolor('white');
    $gfx->rect($p->get_mediabox());
    $gfx->fill();
}
$pdf->saveas($ARGV[1]);

