#!/usr/bin/perl -w

BEGIN {
	use FindBin;
	use lib "${FindBin::Bin}/lib";
}

use strict;
use warnings;
use Getopt::Declare;
use English qw(-no_match_vars);
use JSON;
use Data::Dumper;
use Hash::Merge qw( merge );
Hash::Merge::set_behavior('RIGHT_PRECEDENT');

sub eval_to_file {
	my $file   = shift;
	my $string = shift;
	my $spec   = shift;
	my $args   = shift;

	if ($file) {
		if (-e $file) {
			unlink $file or die "Cannot delete $file: $!";
		}
		open my $OU, '>>', $file or die "Cannot open $file: $OS_ERROR";
		eval $string;
		close $OU or die "Cannot close $file: $OS_ERROR";
		if ($args->{'-v'}) {
			print "output:        $file\n";
		}
	} else {
		eval $string;
	}
}

sub write_to_file {
	my $file   = shift;
	my $string = shift;
	my $args   = shift;
	return unless $file;
	if (-e $file) {
		unlink $file or die "Cannot delete $file: $!";
	}
	open my $OU, '>>', $file or die "Cannot open $file: $OS_ERROR";
	print {$OU} $string or die "Cannot write to $file: $OS_ERROR";
	close $OU or die "Cannot close $file: $OS_ERROR";
	if ($args->{'-v'}) {
		print "intermediate:  $file\n";
	}
}

sub children {
	my $ref = shift;

	my $ret = []; # array reference
	if (ref($ref) eq 'ARRAY') {
		my $i = 0;
		for my $e (@{$ref}) {
			if ($i > 0) {
				push (@{$ret}, $e);
			}
			$i++;
		}
	}
	return $ret;
}

{
	my $opt_spec = q(
	-v	Verbose mode
	-s <json>...	Specifcation JSON file name
	-t <template>	Template file name [required]
	-p <plfile>	Intermediate Perl filename
	-o <oufile>	Output filename
	);
	my $args = Getopt::Declare->new($opt_spec);
	my $spec = {};
	my $val;

	if ($args->{'-v'}) {
		print "--------------------------------\n";
	}
	if ($args->{'-s'}) {
		my @jsons = @{$args->{'-s'}};
		if ($args->{'-v'}) {
			print "specifications: " . join("\n", @jsons) . "\n";
		}
		for my $json (@jsons) {
			(-e $json)     or die "Could not find specification file: $! $json";
			open (SPEC, "<$json") or die "Could not open spec file: $!";
			my $spec_text = join '', <SPEC>;
			close (SPEC);
			$spec = merge ($spec, from_json ($spec_text));
		}
	}
	{
		my @Aval;
		my $template   = $args->{'-t'};
		($template)    or die "template is not defined";
		if ($args->{'-v'}) {
			print "template:      $template\n";
		}
		(-e $template) or die "Could not find template file: $!";
		open (TMP, "<$template") or die "Could not open template file: $!";
		my $state = 0; # 0 = perl mode; 1 = source mode
		while (<TMP>) {
			chomp;
			if ($_ =~ m/^\/\/;/) { # perl mode
				if ($state == 1) {
					$_ =~ s/^\/\/;//g;
					$_ = "EOD\n$_";
				} else {
					$_ =~ s/^\/\/;//g;
				}
				$state = 0;
			} elsif ($_ =~ m/^\#\%/) { # perl mode
				if ($state == 1) {
					$_ =~ s/^\#\%//g;
					$_ = "EOD\n$_";
				} else {
					$_ =~ s/^\#\%//g;
				}
				$state = 0;

			} else { # source mode
				if ($state == 0) {
					$_ = "print \$OU \<\<EOD;\n$_";
					$state = 1;
				}
			}
			push @Aval, $_;
		}
		if ($state == 1) { push @Aval, "EOD\n"; }
		close (TMP);

		$val = join("\n", @Aval);
	}
	write_to_file ($args->{'-p'}, $val,        $args);
	eval_to_file  ($args->{'-o'}, $val, $spec, $args);
}
