#!/usr/bin/perl

print <<'EOF';
; bekernel.inc
; THIS FILE IS AUTOMATICALLY GENERATED

EOF

%apicall = ();
$size = 0;
$text_segment = 0;
while(defined($line = <STDIN>)) {
	chomp $line;
	$text_segment = 1 if $line =~ /SEGMENT\s*.text/;
	$text_segment = 0 if $line =~ /SEGMENT\s*.data/;
	$text_segment = 0 if $line =~ /SEGMENT\s*.bss/;
	next if not $text_segment;

	$lino = substr($line, 0, 7);	# in decimal
	$offs = substr($line, 7, 8);	# in hex
	$code = substr($line, 16, 24);	# in hex
	$src  = substr($line, 40);

	if ($src =~ /^(\w+)\:/) {
		$apicall{$1} = substr($offs, 4, 4);
	}
}

for $call (sort keys %apicall) {
	printf "\t%-30s\tEQU\t%4sh\n", 'BefOS_' . $call, $apicall{$call};
}
