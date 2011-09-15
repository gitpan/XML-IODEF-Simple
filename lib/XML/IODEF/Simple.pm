package XML::IODEF::Simple;

use 5.008008;
use strict;
use warnings;

our $VERSION = '0.00_02';
$VERSION = eval $VERSION;  # see L<perlmodstyle>

require XML::IODEF;
use Module::Pluggable require => 1;

# Preloaded methods go here.

sub new {
    my ($class,$info) = @_;
    
    my $description                 = lc($info->{'description'});
    my $confidence                  = $info->{'confidence'};
    my $severity                    = $info->{'severity'};
    my $restriction                 = $info->{'restriction'} || 'private';
    my $source                      = $info->{'source'} || 'localhost';
    my $relatedid                   = $info->{'relatedid'};
    my $alternativeid               = $info->{'alternativeid'};
    my $alternativeid_restriction   = $info->{'alternativeid_restriction'} || 'private';
    my $purpose                     = $info->{'purpose'} || 'mitigation';
    my $guid                        = $info->{'guid'};

    my $dt = $info->{'detecttime'};
    # default it to the hour
    unless($dt){
        require DateTime;
        $dt = DateTime->from_epoch(epoch => time());
        $dt = $dt->ymd().'T'.$dt->hour().':00:00Z';
    }
    $info->{'detecttime'} = $dt;

    my $iodef = XML::IODEF->new();
    $iodef->add('Incidentpurpose',$purpose);
    $iodef->add('IncidentIncidentIDname',$source) if($source);
    $iodef->add('IncidentDetectTime',$dt) if($dt);
    $iodef->add('IncidentRelatedActivityIncidentID',$relatedid) if($relatedid);
    if($guid){
        $iodef->add('IncidentAdditionalDatameaning','guid') if($guid);
        $iodef->add('IncidentAdditionalDatadtype','string') if($guid);
        $iodef->add('IncidentAdditionalData',$guid) if($guid);
    }
    if($alternativeid){
        $iodef->add('IncidentAlternativeIDIncidentID',$alternativeid);
        $iodef->add('IncidentAlternativeIDIncidentIDrestriction',$alternativeid_restriction);
    }
    $iodef->add('Incidentrestriction',$restriction);
    $iodef->add('IncidentDescription',$description) if($description);
    if($confidence){
        $iodef->add('IncidentAssessmentConfidencerating','numeric');
        $iodef->add('IncidentAssessmentConfidence',$confidence);
    }
    if($severity && $severity =~ /(low|medium|high)/){
        $iodef->add('IncidentAssessmentImpactseverity',$severity);
    }

    foreach($class->plugins()){
        if($_->prepare($info)){
            $iodef = $_->convert($info,$iodef);
        }        
    }
    my $impact = $info->{'impact'};
    $iodef->add('IncidentAssessmentImpact',$impact) if($impact);
    return $iodef;
}


1;
__END__
=head1 NAME

XML::IODEF::Simple - Perl extension for easier IODEF message generation

=head1 SYNOPSIS

  use XML::IODEF::Simple;
  my $report = XML::IODEF::Simple->new({
        guid        => 'mygroup',
        source      => 'example.com',
        restriction => 'need-to-know',
        description => 'spyeye',
        impact      => 'botnet',
        address     => '1.2.3.4',
        protocol    => 'tcp',
        portlist    => '8080',
        contact     => {
            name        => 'root',
            email       => 'root@localhost',
        },
        purpose                     => 'mitigation',
        confidence                  => '85',
        alternativeid               => 'https://example.com/rt/Ticket/Display.html?id=1234',
        alternativeid_restriction   => 'private',
    });
    my $xml = $report->out(); 
    my $hash = $report->to_tree();

=head1 DESCRIPTION

This module makes it a bit simpler to crank out XML+IODEF messages. It uses what it finds under XML/IODEF/Simple/Plugin/ to adapt "defaults" to the keypairs it takes in. To allow for other default settings / manipulations, create XML::IODEF::Simple::Plugin::MyPlugin and Module::Pluggable will pick it up on the fly. See XML::IODEF::Simple::Plugin::Ipv4 as an example.

=head1 SEE ALSO

XML::IODEF, http://code.google.com/p/collective-intelligence-framework/

=head1 AUTHOR

Wes Young, E<lt>wes@barely3am.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Wes Young

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
