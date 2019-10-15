# Smoothwall Coding Test

## Getting Started

The main script is called smoothwall.pl (run on command line with "perl ./smoothwall.pl")

The main input is a hardcoded fake apache log file (access.log) that was generated using a Python script (https://github.com/kiritbasu/Fake-Apache-Log-Generator)- Error and debug logs are also created along with other outputs

The apache log file is parsed and relevant data is collected and counts of IP addresses calculated

The apache data and IP addresses count are outputted to output text files

Chart::Plotly cpan module is used to graphically visualize the counts of IP addresses with an interactive bar chart (which should open in the browser when the script is run)

### Prerequisites

DateTime<br/>
Data::Dumper<br/>
Socket<br/>
Log::Log4perl<br/>

### Installing

Unzip the archive, example apache log for the input, main script (smoothwall.pl) and previously run outputs are present already

## Running the script

```
perl ./smoothwall.pl
```

### Outputs

2 log files:<br/>
```
smoothwall_debug.log
smoothwall_error.log
```

2 main output text files for main apache data parsed and the other for domain counts:<br/>
```
apache_data.txt
domain_count.txt
```

Plotly graph for visualization of domain count (auto-generated and should open in browser)<br/>

## Authors

* **Owen Lancaster** - *Initial work* - [Personal website](http://owenlancaster.co.uk)
