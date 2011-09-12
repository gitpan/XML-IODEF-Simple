#!/usr/bin/perl -w

use strict;

use lib './lib';
require XML::IODEF::Simple;

my $hash = {
    impact      => 'hijacked',
    confidence  => 95,
    address     => '1.1.1.0/24',
    portlist    => '2222',
    protocol    => 'udp',
    description => 'zeus',
    contact     => {
        role    => 'irt',
        type    => 'person',
        name    => 'root',
        email   => 'root@localhost',
    },
};

my $iodef = XML::IODEF::Simple->new($hash);

warn $iodef->out();
