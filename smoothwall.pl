#!/usr/bin/perl -w

use strict;
use warnings;

### Add modules needed for Smoothwall task
use Chart::Plotly;
use Chart::Plotly::Trace::Bar;
use Chart::Plotly::Plot;
use DateTime;
use Data::Dumper;
use Socket;
use Log::Log4perl qw(:easy);
###

# Setup Log4perl for debugging and error statements for writing debug/error statements to log files
Log::Log4perl->easy_init( {
		file  => ">> smoothwall_error.log",
		level => $ERROR,
	},
	{
		file  => ">> smoothwall_debug.log",
		level => $DEBUG,
	}
);

### Initialize the associative arrays for storing apache access log data and counting IP addresses
my %apache_data;
my %domain_count;

### Use the DateTime module to get the current date and time
my $dt   = DateTime->now;
my $date = $dt->dmy; 
my $time = $dt->hms; 
DEBUG ("DATETIME $date $time");

### Open the sample apache log file that for parsing - this fake apache log was generated using python script taken from https://github.com/kiritbasu/Fake-Apache-Log-Generator
my $apache_log_file = "access.log";
if ( ! -e $apache_log_file) { # Check if the log file exists (currently hard coded for coding test)
	ERROR("Apache log file does not exist");
	die("Apache log file does not exist");
}

my $apache_log_line_count = 0; # Initialize counter for indexing apache log rows

# Parse the apache log file
open ( APACHE, $apache_log_file );
while ( <APACHE> ) {
	$apache_log_line_count++;
	# Use regex to get the apache log data (I tried to use a cpan module for this but it wouldn't work with the fake apache log file)
	my ($client_address, $rfc1413, $user_name, $local_time, $http_request, $status_code, $bytes_sent_to_client, $referer, $client_software) = /^(\S+) (\S+) (\S+) \[(.+)\] \"(.+)\" (\S+) (\S+) \"(.*)\" \"(.*)\"/o;
	my ($get_post, $uri, $junk) = split(' ', $http_request, 3);

	# Initialize host_name string then use Socket module to try and resolve the hostname from the IP address
	my $host_name = "";
	if ( my $host = gethostbyaddr( inet_aton($client_address), AF_INET )) {
        $host_name = $host;
    }
    else {
    	ERROR("No hostname resolved for $client_address");
    }

	### Initialize variables that may not be present from parsing the apache access log so that default text can be set
	if ( $client_address eq '' ) { # Set default for when no client IP is available
		$client_address = "No client IP available";
	}
	if ( $user_name eq '-' ) { # Set default for when no username is available
		$user_name = "No username available";
	}
	if ( $host_name eq '' ) { # Set default for when no hostname can be resolved
		$host_name = "No hostname available";
	}
	if ( $local_time eq '' ) { # Set default for when no localtime is avaiable
		$local_time = "No localtime available";
	}
	if ( $http_request eq '' ) { # Set default for when no http_request is avaiable
		$http_request = "No site request available";
	}

	if ( $status_code == 200 ) { # Check the URL returns http 200 status code and then add the apache log data to the hash (defaults above will be present if no data)
			$apache_data{$apache_log_line_count}{"client_address"} = $client_address;
			$apache_data{$apache_log_line_count}{"host_name"} = $host_name;
			$apache_data{$apache_log_line_count}{"user_name"} = $user_name;
			$apache_data{$apache_log_line_count}{"local_time"} = $local_time;
			$domain_count{$client_address}++; # Increment the count of the IP address
	}
	else { # If site doesn't return 200 status throw error to log file
		ERROR("ERROR no 200 http status code for $client_address - status returned $status_code");
	}
}

# Open domain count text file for write
my $domain_count_outfile = 'domain_count.txt';
open(my $dc, '>', $domain_count_outfile) or die "Could not open file '$domain_count_outfile' $!";

my @x = ();
my @y = ();

# Loop through the count of domains hash
foreach my $key ( sort keys %domain_count ) {
	print $dc "$key\t$domain_count{$key}\n";

	# Add the IP and counts to the x and y arrays that will be used for Plotly bar chart for visualization
	push @x, $key; #
	push @y, $domain_count{$key};

}

# Create array references as this is needed for the Plotly barchart x and y values
my $x_ref  = \@x;
my $y_ref  = \@y;
my $domain_count_barchart = Chart::Plotly::Trace::Bar->new( x    => $x_ref,
                                              y    => $y_ref,
                                              name => "sample1"
);

# Generate the domain count barchart
my $plot = Chart::Plotly::Plot->new( traces => [ $domain_count_barchart ] );
Chart::Plotly::show_plot($plot);

# Open apache data text file for write
my $apache_data_outfile = 'apache_data.txt';
open(my $ap, '>', $apache_data_outfile) or die "Could not open file '$apache_data_outfile' $!";

# Loop through the apache data multi-dimensional hash
foreach my $key ( sort keys %apache_data ) {
	foreach my $key1 (keys %{ $apache_data{$key} }) {
		print $ap "$key\t$key1\t$apache_data{$key}{$key1}\n";
	}
}
