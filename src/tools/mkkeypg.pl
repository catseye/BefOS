#!/usr/bin/perl

my %binding = ();
while(defined($line = <STDIN>)) {
    chomp $line;
    if ($line =~ /^\s*dw\s+(\S+)\s*\;\s*(\S+)\s*(\S+).*?$/) {
        my $command = $1;
        my $scancode = $2;
        my $key = $3;
        $binding{$key} = $command;
    }
}

foreach $key (sort keys %binding) {
    next if $binding{$key} eq 'Unimp';
    printf "%-10s => %s\n", $key, $binding{$key};
}
