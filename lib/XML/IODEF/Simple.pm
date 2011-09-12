package XML::IODEF::Simple;

use 5.008008;
use strict;
use warnings;

our $VERSION = '0.00_01';
$VERSION = eval $VERSION;  # see L<perlmodstyle>

require XML::IODEF;
use Module::Pluggable require => 1;


# Preloaded methods go here.

sub new {
    my ($class,$info) = @_;
    
    my $address                     = $info->{'address'};
    my $description                 = lc($info->{'description'});
    my $confidence                  = $info->{'confidence'};
    my $severity                    = $info->{'severity'};
    my $restriction                 = $info->{'restriction'} || 'private';
    my $source                      = $info->{'source'} || 'localhost';
    my $relatedid                   = $info->{'relatedid'};
    my $alternativeid               = $info->{'alternativeid'};
    my $alternativeid_restriction   = $info->{'alternativeid_restriction'} || 'private';
    my $protocol                    = $info->{'protocol'};
    my $portlist                    = $info->{'portlist'};
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
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

XML::IODEF::Simple - Perl extension for blah blah blah

=head1 SYNOPSIS

  use XML::IODEF::Simple;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for XML::IODEF::Simple, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Wes Young, E<lt>wes@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Wes Young

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
