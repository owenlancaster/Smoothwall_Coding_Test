# Smoothwall Coding Test

## Getting Started

The main script is called smoothwall.pl (run on command line with "perl ./smoothwall.pl")- Main input is a test hardcoded fake apache log file (access.log) that I generated using a Python script (https://github.com/kiritbasu/Fake-Apache-Log-Generator)- Error and debug logs are created- Parse apache log file and collect data and calculate counts of IP addresses- Print apache data and IP addresses to output text files- Also use Chart::Plotly cpan module to graphically visualize the counts of IP addresses with an interactive bar chart (which should open in the browser when the script is run)

### Prerequisites

DateTime
Data::Dumper
Socket;
Log::Log4perl

### Installing

Unzip the archive, example apache log for the input, main script (smoothwall.pl) and previously run outputs are present already

## Running the script

```
perl ./smoothwall.pl
```

### Outputs

2 log files:
```
smoothwall_debug.log
smoothwall_error.log
```

2 main output text files for main apache data parsed and the other for domain counts:
```
apache_data.txt
domain_count.txt
```

Plotly graph for visualization of domain count (auto-generated and should open in browser)

## Authors

* **Owen Lancaster** - *Initial work* - [Personal website](http://owenlancaster.co.uk)
