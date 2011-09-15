package XML::IODEF::Simple::Plugin::Contact;

sub prepare {
    my $class   = shift;
    my $info    = shift;

    return(0) unless($info->{'contact'});
    return(1);
}

sub convert {
    my $class = shift;
    my $info = shift;
    my $iodef = shift;
    my $c = $info->{'contact'};

    my $role    = $c->{'role'} || 'creator';
    my $type    = $c->{'type'} || 'person';

    $iodef->add('IncidentContacttype',$type);
    $iodef->add('IncidentContactrole',$role);
    $iodef->add('IncidentContactEmail',$c->{'email'}) if($c->{'email'});
    $iodef->add('IncidentContactContactName',$c->{'name'}) if($c->{'name'});

    return($iodef);
}

1;

