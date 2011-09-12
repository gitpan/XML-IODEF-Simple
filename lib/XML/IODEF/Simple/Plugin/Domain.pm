package XML::IODEF::Simple::Plugin::Domain;

sub prepare {
    my $class   = shift;
    my $info    = shift;

    my $address = $info->{'address'};
    return(1) if($address && $address =~ /^[a-zA-Z0-9.-]+\.[a-z]{2,5}$/);
    return(0);
}

sub convert {
    my $self = shift;
    my $info = shift;
    my $iodef = shift;

    my $address = lc($info->{'address'});

    $iodef->add('IncidentEventDataFlowSystemNodeAddresscategory','ext-value');
    $iodef->add('IncidentEventDataFlowSystemNodeAddressext-category','domain');
    $iodef->add('IncidentEventDataFlowSystemNodeAddress',$address);

    if($info->{'tld'}){
        $iodef->add('IncidentEventDataFlowSystemAdditionalDatadtype','string');
        $iodef->add('IncidentEventDataFlowSystemAdditionalDatameaning','tld');
        $iodef->add('IncidentEventDataFlowSystemAdditionalData',$_);
    }

    if($info->{'rdata'}){
        $iodef->add('IncidentEventDataFlowSystemAdditionalDatadtype','string');
        $iodef->add('IncidentEventDataFlowSystemAdditionalDatameaning','rdata');
        $iodef->add('IncidentEventDataFlowSystemAdditionalData',$info->{'rdata'} || '');
        $iodef = XML::IODEF::Simple::Plugin::Bgp->convert($_,$iodef);
    }
    $iodef->add('IncidentEventDataFlowSystemAdditionalDatadtype','string');
    $iodef->add('IncidentEventDataFlowSystemAdditionalDatameaning','type');
    $iodef->add('IncidentEventDataFlowSystemAdditionalData',$info->{'type'} || 'A');

    my $impact = $info->{'impact'};
    return($iodef) if($impact =~ /domain/);
    $info->{'impact'} .= ' domain';


    return($iodef);
}
1;
