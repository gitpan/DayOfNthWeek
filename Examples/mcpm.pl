#!/usr/local/bin/perl

use Date::DayOfNthWeek qw(week_day);

my $d = 3; # set to the day of week I want -- SUNDAY=0
my $w = 5; # set to the week PRIOR to the meeting so I can send out the reminder

my $ok = week_day($d,$w);

if ($ok) { &nextweek; }
else     {
    my $ww = $w+1;             # keeps me from changing the value of $w 
	if ($ww > 6) { $ww = 1; }  # fixes range input errors for wrapping to next week
	$ok = week_day($d,$ww);
	if ($ok) { &tonight; }
	else {
		$d--;                   # see if this is the day before the meeting
		if ($d < 0) { $d = 6; } # fixes range input error for wrapping to previous week day
		$ok = week_day($d,$ww);
		&tomorrow if $ok;		
	}
} 

sub nextweek { print "Meeting is next week\n"; }
sub tomorrow { print "Meeting is tomorrow\n";  }
sub tonight  { print "Meeting is tonight\n";   }
