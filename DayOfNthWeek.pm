package Date::DayOfNthWeek;

our $VERSION = '0.01';

use 5.008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(week_day last_week first_week) ]  );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

sub week_day($$) {

	my $day = shift;
	my $week = shift;

	die "your day is out of the range 0 - 6 Sunday==0\n" unless ((0 <= $day) && ( $day <= 6));

	my $low = 0;

	if    ($week == 1) { $low = 1;  }
	elsif ($week == 2) { $low = 8;  }
	elsif ($week == 3) { $low = 15; }
	elsif ($week == 4) { $low = 22; }
	elsif ($week == 5) { $low = 29; }
	else { die "Your week of the month is out of range\n";}

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;

	if ($wday == $day) {
		if (($low <= $mday) && ( $mday <= ($low+7)) ) {
			return 1;
		}
	}
	return 0;
}

sub last_week($) {

	my $day  = shift;

	die "your day is out of the range 0 - 6 Sunday==0\n" unless ((0 <= $day) && ( $day <= 6));

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;

	my $low = 0;

	# are there 31 days in the month?
	if    ($mon == 0 || 2 || 4 || 6 || 7 || 9 || 11 ) { $low = 25;}
	# are there 30 days in the month?
	elsif ($mon == 3 || 5 || 8 || 10) {$low=24; }

	# if the month is February is it a leap year?
	elsif ($mon == 2 ) {                            # This is to account for leap
		if ( $year % 4 ) { $low = 22; }             # years.  Which works like this:
		else {                                      # if year%4 != 0  it is a
			if  ( $year % 100 ) { $low = 22; }      # non-leap year, so Feb has 28 days
			else { $low = 23; }                     # if year%4 == 0 it could be a leap
		}                                           # year.  If the year ends in 00,
	}                                               # Feb has 28 days, otherwise it
                                                    # has 29 days and is a leap year.
	if ($wday == $day) {
		if (($low <= $mday) && ( $mday <= ($low+7)) ) {
			return 1;
		}
	}
	return 0;
}

sub first_week($) {

	my $day = shift;

	die "your day is out of the range 0 - 6 Sunday==0\n" unless ((0 <= $day) && ( $day <= 6));

	my $low = 1;

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;

	if ($wday == $day) {
		if (($low <= $mday) && ( $mday <= ($low+7)) ) {
			return 1;
		}
	}
	return 0;
}


1;
__END__


=head1 NAME

Date::DayOfNthWeek - Simple Perl module for finding the first, last or
the Nth Tuesday (or any other day) of the month.

=head1 SYNOPSIS

  use Date::DayOfNthWeek;

  # Sunday = 0, just like in localtime()

  my $wday = 2;

  # See if today is first Tuesday of the month
  my $first = first_week($wday);

  # See if today is last Tuesday of the month 
  my $last  = last_week($wday);

  # See if today is 3rd Tuesday of the month 

  my $week = 3;
  my $last  = week_day($wday,$week);


=head1 ABSTRACT

Date::DayOfNthWeek - Simple Perl module for finding out if today is
the first, last or the Nth Tuesday (or any other day) of the month.

Has three functions:
	last_week($);  # today is in the last week of the month
	first_week($); # today is in the first week of the month
	week_day($,$); # today is in the Nth week of the month

I wrote this to send out use in a cron job to send out reminders about
the Morris County Perl Mongers monthly meetings.  Using Date::Calc and
Date::Manip where more than what I needed.

This only works for finding information about TODAY, no future
calculations.  If you want that use Date::Calc or Date::Manip.  This is meant to 


=head1 DESCRIPTION

Date::DayOfNthWeek - Simple Perl module for finding the first, last or
the Nth Tuesday (or any other day) of the month.

Has three functions:

	first_week($); # day is in the first week of the month

Takes an int between 0 and 6 and returns 1 if today is the first [Sun - Sat] of the month 

	last_week($);  # day is in the last week of the month

Takes an int between 0 and 6 and returns 1 if today is the last [Sun - Sat] of the month 

	week_day($,$); # day is in the Nth week of the month

Takes an int between 0 and 6 [Sun - Sat] and an int for week of the
month [1-5].  Returns 1 if today is the that day of the Nth week of
the month.

I wrote this to send out use in a cron job to send out reminders about
the Morris County Perl Mongers monthly meetings.  Using Date::Calc and
Date::Manip were more than what I needed.



I am using this to send out a reminder about the Morris County Perl
Mongers meetings.  We meet in a local Irish Pub on the 3rd Tuesday of
the month.

#!/usr/local/bin/perl

use Date::DayOfNthWeek qw(week_day);

my $d = 2; # set to the day of week I want SUNDAY=0
my $w = 2; # set to the week PRIOR to the meeting so I can send out the reminder

my $ok = week_day($d,$w);

if ($ok) { &nextweek; }
else     {
    my $ww = $w+1;             # keeps me from changing the value of $w 
	if ($ww > 5) { $ww = 1; }  # fixes range input errors for wrapping to next week
	$ok = week_day($d,$ww);
	if ($ok) { &tonight; }
	else {
		$d--;                   # see if this is the day before the meeting
		if ($d < 0) { $d = 6; } # fixes range input error for wrapping to previous week day
		$ok = week_day($d,$w);
		&tomorrow if $ok;		
	}
} 

sub nextweek { print "Meeting is next week\n"; }
sub tomorrow { print "Meeting is tomorrow\n";  }
sub tonight  { print "Meeting is tonight\n";   }


=head2 EXPORT

None by default

=head1 SEE ALSO

localtime()

=head1 AUTHOR

Andy Murren, E<lt>andy@murren.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2002 by Andy Murren

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
