package XML::IODEF::Simple::Plugin::TLP;

my $map = {
    amber   => 'need-to-know',
    red     => 'private',
    white   => 'public',
    green   => 'need-to-know',
    default => 'private',
};

sub prepare {
    my $class   = shift;
    my $info    = shift;
    return unless($info->{'restriction'});
    return unless(exists($map->{lc($info->{'restriction'})}));
    return(1);
}

sub convert {
    my $class = shift;
    my $info = shift;
    my $iodef = shift;
    my $r = lc($info->{'restriction'});
    
    $iodef->add('Incidentrestriction',$map->{$r}); 

    return($iodef);
}

1;

