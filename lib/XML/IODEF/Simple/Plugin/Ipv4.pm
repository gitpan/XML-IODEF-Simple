package XML::IODEF::Simple::Plugin::Ipv4;

use Regexp::Common qw/net/;

sub prepare {
    my $class   = shift;
    my $info    = shift;

    my $address = $info->{'address'};
    return(1) if($address && $address =~ /^$RE{'net'}{'IPv4'}/);
    return(0);
}

sub convert {
    my $class = shift;
    my $info = shift;
    my $iodef = shift;

    my $cat = ($info->{'address'} =~ /^$RE{'net'}{'IPv4'}$/) ? 'ipv4-addr' : 'ipv4-net';
    $iodef->add('IncidentEventDataFlowSystemNodeAddresscategory',$cat);
    $iodef->add('IncidentEventDataFlowSystemNodeAddress',$info->{'address'});

    return($iodef);
}

1;

