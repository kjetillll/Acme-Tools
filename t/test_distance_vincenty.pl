use strict;
use warnings;
use Math::Trig qw(atan tan);
use List::Util qw(min max sum);
#use Acme::Tools;

# -----------------------------------------------------------------------------
# distance_vincenty
#
#   Calculates geodesic distance between two lat/lon points using Vincenty's
#   inverse formula on the WGS-84 ellipsoid.
#
#   Input:
#       $lat1, $lon1    - latitude & longitude of point 1 (decimal degrees)
#       $lat2, $lon2    - latitude & longitude of point 2 (decimal degrees)
#
#   Returns:
#       Distance in meters (or undef on failure / antipodal / non-convergence)
#
#   Example:
#       my $d = distance_vincenty(48.8566, 2.3522, 51.5074, -0.1278);
# -----------------------------------------------------------------------------
my @iter;
our $Deg2rad_factor = 3.141592653589793238462643383279502884197169399375105820974944592307816406286 / 180;
sub distance_vincenty {
    my ($lat1, $lon1, $lat2, $lon2) = @_;
    return 0 if $lat1 == $lat2 and $lon1 == $lon2;

    my $a = 6378137.0;          # equatorial radius [m], WGS-84 ellipsoid constants
    my $f = 1 / 298.257223563;  # flattening
    my $b = (1 - $f) * $a;      # polar radius [m]

    my($phi1, $phi2, $L) = map $Deg2rad_factor * $_, $lat1, $lat2, $lon2-$lon1;
    my($U1, $U2) = map atan( (1 - $f) * tan($_) ), $phi1, $phi2; # reduced latitudes
    my($sinU1, $cosU1, $sinU2, $cosU2) = ( sin($U1), cos($U1),  sin($U2), cos($U2) ); #speedup

    my $lambda = $L;            # initial guess for longitude difference
    my($iter, $iter_limit) = (0, 100);
    my($cos2_alpha, $sigma, $cos_sigma, $cos_2sigma_m, $sin_alpha);
    
    while ( 1 ) {
        $iter++;
        return undef if $iter > $iter_limit;  # did not converg

        my $sin_lambda = sin($lambda);
        my $cos_lambda = cos($lambda);

        my $sin_sigma = sqrt( # sigma = angular distance on auxiliary sphere
            ($cosU2 * $sin_lambda)**2 +
            ($cosU1 * $sinU2 - $sinU1 * $cosU2 * $cos_lambda)**2
        );

        return undef if $sin_sigma == 0;  # coincident points

        $cos_sigma  = $sinU1 * $sinU2 + $cosU1 * $cosU2 * $cos_lambda;
        $sigma      = atan2($sin_sigma, $cos_sigma);
        $sin_alpha  = $cosU1 * $cosU2 * $sin_lambda / $sin_sigma;
        $cos2_alpha = 1 - $sin_alpha**2;

        return 0 if $cos2_alpha == 0;     # equatorial line case

        $cos_2sigma_m = $cos_sigma - 2 * $sinU1 * $sinU2 / $cos2_alpha;
        my $C = $f / 16 * $cos2_alpha * (4 + $f * (4 - 3 * $cos2_alpha));

        my $lambda_prev = $lambda;
        $lambda = $L + (1 - $C) * $f * $sin_alpha *
                  ($sigma + $C * $sin_sigma *
                   ($cos_2sigma_m + $C * $cos_sigma *
                    (-1 + 2 * $cos_2sigma_m**2)));

        last if abs($lambda - $lambda_prev) < 1e-12;
    }
    push @iter, $iter;

    my $u2   = $cos2_alpha * ($a**2 - $b**2) / ($b**2);
    my $A    = 1 + $u2/16384 * (4096 + $u2 * (-768 + $u2 * (320 - 175 * $u2)));
    my $B    = $u2/1024 * (256 + $u2 * (-128 + $u2 * (74 - 47 * $u2)));

    my $delta_sigma = $B * sin($sigma) *
                      ($cos_2sigma_m + $B/4 * ($cos_sigma *
                       (-1 + 2 * $cos_2sigma_m**2) -
                       $B/6 * $cos_2sigma_m *
                       (-3 + 4 * sin($sigma)**2) *
                       (-3 + 4 * $cos_2sigma_m**2)));

    $b * $A * ($sigma - $delta_sigma);   # return distance in meters
}
sub distance_haversine {
  my($lat1,$lon1,$lat2,$lon2)=map $Deg2rad_factor * $_, @_;
  return 0 if $lat1==$lat2 and $lon1==$lon2;
  my $a= sin(($lat2-$lat1)/2)**2
       + sin(($lon2-$lon1)/2)**2 * cos($lat1) * cos($lat2);
  my $sqrt_a  =sqrt($a);    $sqrt_a  =1 if $sqrt_a  >1;
  my $sqrt_1ma=sqrt(1-$a);  $sqrt_1ma=1 if $sqrt_1ma>1;
  my $c=2*atan2($sqrt_a,$sqrt_1ma);
  my($Re,$Rp)=( 6378137.0, 6356752.3 ); #earth equatorial and polar radius
  my $R=$Re-($Re-$Rp)*sin(abs($lat1+$lat2)/2); #approx
  return $c*$R;
}


my @p = my %p = (
    London               => [ 51.5074,     -0.1278  ],
    New_York             => [ 40.7128,    -74.0060  ],
    Eiffel_Tower         => [ +48.8583,    +2.2945  ],
    Statue_of_Liberty    => [ +40.68925,  -74.04450 ],
    Sphinx_Giza          => [ +29.9753,   +31.1377  ],
    Christ_Statue_Rio    => [ -22.95191,  -43.21044 ],
    North_Cape           => [ +71.17094,  +25.78302 ],
    North_Pole           => [ +90,       +180       ],
    South_Pole           => [ -90,       -180       ],
    Leon_Spain           => [ +42.605,     -5.603   ],
    );
@p = @p[grep$_%2<1,0..$#p];
my(@diff, @diffm);
for my $from (@p){
for my $to   (@p){
    next if $from ge $to;
    my @from_to = map @{$p{$_}}, $from, $to;
    my $dh = distance_haversine(@from_to);
    my $dv = distance_vincenty(@from_to);
    my $diff = $dv ? 100*($dv-$dh)/$dv : 0;
    printf "%-20s - %-20s   Acme-Tools: %10.1f m (%7.1f km)   Vincenty: %10.1f m (%7.1f km)   Diff: %6.3f%%\n",
	$from, $to,
	$dh, $dh/1000,
	$dv, $dv/1000,  $diff;
    push @diff, abs($diff);
    push @diffm, abs($dh-$dv);
}}
sub avg { sum(@_)/@_ }
printf "max diff:  %6.3f m   avg diff:  %6.3f%%   min diff: %6.3f%%\n", max(@diff), avg(@diff), min(@diff);
printf "max diffm: %6.3f m   avg diffm: %6.3f m   min diff: %6.3f m\n", max(@diffm), avg(@diffm), min(@diffm);
printf "max iter: %d   avg iter: %.2f\n", max(@iter), avg(@iter);
# https://grok.com/share/c2hhcmQtNQ_180ca968-c8fb-4d19-90d6-070ecd58055f
