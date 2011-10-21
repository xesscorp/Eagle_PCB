####################################################################################
# Generate a pin list from a Xilinx FPGA CSV file
# (This is for one format of the Xilinx CSV files.)
####################################################################################
sub gen_xil_pin_list {
    my ( $pin_file, $fpga_type ) = @_;

    # read the entire CSV file
    open( FP, $pin_file ) || die( $pin_file . ": " . $! );
    my @lines = <FP>;
    close(FP);

    my $header = shift(@lines);           # remove header line;
    my @fields = split( /,/, $header );
    my ( $pin_name_column, $pin_type_column, $pin_number_column );
    for ( my $i = 0 ; $i < $#fields ; $i++ ) {
        $_ = $fields[$i];
        (/^$fpga_type _PIN$/ix)  && ( $pin_name_column   = $i, next );
        (/^$fpga_type _TYPE$/ix) && ( $pin_type_column   = $i, next );
        (/^PIN_NUMBER$/i)        && ( $pin_number_column = $i, next );

        #        (/^SORT_PIN$/i) && ($pin_number_column = $i, next);
    }

    my %swap_levels = (
        "N.C."       => 0,
        "GND"        => 0,
        "VCCAUX"     => 0,
        "VCCO"       => 0,
        "VCCINT"     => 0,
        "CONFIG"     => 0,
        "JTAG"       => 0,
        "DUAL"       => 0,
        "DUAL/GCLK"  => 0,
        "INPUT"      => 0,
        "I/O"        => 1,
        "VREF"       => 1,
        "DCI"        => 1,
        "GCLK"       => 2,
        "LHCLK"      => 3,
        "LHCLK/DUAL" => 3,
        "RHCLK"      => 4,
        "RHCLK/DUAL" => 4,
        "PWRMGT"     => 5,
    );

    my %pin_list;
    my $err = 0;
    foreach (@lines) {
        my ( $pin_number, $pin_name, $pin_type ) =
          ( split( /,/, $_ ) )
          [ $pin_number_column, $pin_name_column, $pin_type_column ];
        if ( exists( $swap_levels{$pin_type} ) ) {
            $pin_list{$pin_number} = "$pin_name, $swap_levels{$pin_type}";
        }
        else {
            print STDERR "Unknown pin type: $pin_type\n";
            $err = 1;
        }
    }

    if ($err) {
        die("\nUnknown pin types!\n");
    }

    return %pin_list;
}

####################################################################################
# Generate a pin list from a Xilinx FPGA CSV file
# (This is for another format of the Xilinx CSV files.)
####################################################################################
sub gen_xil_pin_list_2 {
    my ( $pin_file, $fpga_type ) = @_;

    # read the entire CSV file
    open( FP, $pin_file ) || die( $pin_file . ": " . $! );
    my @lines = <FP>;
    close(FP);

    my $header = shift(@lines);    # remove header line;
    chomp($header);
    my @fields = split( /,/, $header );
    my ( $pin_name_column, $pin_type_column, $pin_number_column, $pin_column,
        $row_column, $col_column );
    for ( my $i = 0 ; $i <= $#fields ; $i++ ) {
        $_ = $fields[$i];
        (/^$fpga_type$/ix) && ( $pin_name_column   = $i, next );
        (/^TYPE$/ix)       && ( $pin_type_column   = $i, next );
        (/^PIN_#$/ix)      && ( $pin_number_column = $i, next );
        (/^PIN$/ix)        && ( $pin_column        = $i, next );
        (/^ROW$/ix)        && ( $row_column        = $i, next );
        (/^COLUMN$/ix)     && ( $col_column        = $i, next );
        (/^COL$/ix)        && ( $col_column        = $i, next );
    }

    my %swap_levels = (
        "N.C."       => 1,
        "GND"        => 2,
        "VCCAUX"     => 3,
        "VCCO"       => 4,
        "VCCINT"     => 5,
        "PWRMGMT"    => 0,
        "CONFIG"     => 0,
        "PROG"       => 0,
        "JTAG"       => 0,
        "DUAL"       => 7,
        "DUAL/GCLK"  => 7,
        "INPUT"      => 7,
        "IP"         => 7,
        "I/O"        => 7,
        "IO"         => 7,
        "VREF"       => 7,
        "DCI"        => 7,
        "CLK"        => 7,
        "GCLK"       => 7,
        "LHCLK"      => 7,
        "LHCLK/DUAL" => 7,
        "RHCLK"      => 7,
        "RHCLK/DUAL" => 7,
    );

    my %pin_types = (
        "N.C."       => NC,
        "GND"        => IN,
        "VCCAUX"     => IN,
        "VCCO"       => IN,
        "VCCINT"     => IN,
        "PWRMGMT"    => IN,
        "CONFIG"     => IO,
        "PROG"       => IO,
        "JTAG"       => IO,
        "DUAL"       => IO,
        "DUAL/GCLK"  => IO,
        "INPUT"      => IN,
        "IP"         => IN,
        "I/O"        => IO,
        "IO"         => IO,
        "VREF"       => IN,
        "DCI"        => IN,
        "CLK"        => IO,
        "GCLK"       => IO,
        "LHCLK"      => IO,
        "LHCLK/DUAL" => IO,
        "RHCLK"      => IO,
        "RHCLK/DUAL" => IO,
    );

    my %pin_list;
    my $err = 0;
    $pin_list{default_name}       = '';
    $pin_list{default_swap_level} = 0;
    if ( $row_column != undef && $col_column != undef ) {
        $pin_number_column = $pin_column;
    }
    foreach (@lines) {
        chomp;
        my ( $pin_number, $pin_name, $pin_type ) =
          ( split( /,/, $_ ) )
          [ $pin_number_column, $pin_name_column, $pin_type_column ];
        if ( exists( $swap_levels{$pin_type} ) ) {
            $pin_list{properties}{$pin_number}{name} = $pin_name;
            $pin_list{properties}{$pin_number}{type} = $pin_types{$pin_type};
            $pin_list{properties}{$pin_number}{swap_level} =
              $swap_levels{$pin_type};
        }
        else {
            print STDERR "Unknown pin type: $pin_type\n";
            $err = 1;
        }
    }

    if ($err) {
        die("\nUnknown pin types!\n");
    }

    return %pin_list;
}

####################################################################################
# Generate a pin list from a Xilinx FPGA CSV file
# (This is for another format of the Xilinx CSV files.)
####################################################################################
sub gen_xil_pin_list_3 {
    my ( $pin_file, $fpga_type ) = @_;

    # read the entire CSV file
    open( FP, $pin_file ) || die( $pin_file . ": " . $! );
    my @lines = <FP>;
    close(FP);

    my $header = shift(@lines);    # remove header line;
    chomp($header);
    my @fields = split( /,/, $header );
    my ( $pin_name_column, $pin_type_column, $pin_number_column, $pin_column,
        $row_column, $col_column );
    for ( my $i = 0 ; $i <= $#fields ; $i++ ) {
        $_ = $fields[$i];
        (/^$fpga_type$/ix) && ( $pin_name_column   = $i, next );
        (/^TYPE$/ix)       && ( $pin_type_column   = $i, next );
        (/^PIN_#$/ix)      && ( $pin_number_column = $i, next );
        (/^PIN$/ix)        && ( $pin_column        = $i, next );
        (/^ROW$/ix)        && ( $row_column        = $i, next );
        (/^COLUMN$/ix)     && ( $col_column        = $i, next );
        (/^COL$/ix)        && ( $col_column        = $i, next );
    }

    my %swap_levels = (
        "^N.C."    => 1,
        "^GND"     => 2,
        "^VCCAUX"  => 3,
        "^VCCO"    => 4,
        "^VCCINT"  => 5,
        "^PWRMGMT" => 6,
        "^PWRMGT"  => 6,
        "^SUSPEND" => 6,
        "^PROG"    => 0,
        "^DONE"    => 0,
        "^TCK\$"   => 0,
        "^TMS\$"   => 0,
        "^TDI\$"   => 0,
        "^TDO\$"   => 0,
        "^IP"      => 7,
        "^IO"      => 8,
        "^VREF"    => 9,
        "^DCI"     => 10,
        "^CLK"     => 11,
        "^GCLK"    => 12,
        "^LHCLK"   => 13,
        "^RHCLK"   => 14,
    );

    my %pin_types = (
        "^N.C."    => NC,
        "^GND"     => IN,
        "^VCCAUX"  => IN,
        "^VCCO"    => IN,
        "^VCCINT"  => IN,
        "^PWRMGMT" => IN,
        "^PWRMGT"  => IN,
        "^SUSPEND" => IN,
        "^PROG"    => IN,
        "^DONE"    => OUT,
        "^TCK\$"   => IN,
        "^TMS\$"   => IN,
        "^TDI\$"   => IN,
        "^TDO\$"   => OUT,
        "^IP"      => IN,
        "^IO"      => IO,
        "^VREF"    => IN,
        "^DCI"     => IN,
        "^CLK"     => IN,
        "^GCLK"    => IN,
        "^LHCLK"   => IN,
        "^RHCLK"   => IO,
    );

    my %pin_list;
    my $err = 0;
    $pin_list{default_name}       = '';
    $pin_list{default_swap_level} = 0;
    if ( $row_column != undef && $col_column != undef ) {
        $pin_number_column = $pin_column;
    }
    foreach (@lines) {
        chomp;
        my ( $pin_number, $pin_name ) =
          ( split( /,/, $_ ) )[ $pin_number_column, $pin_name_column ];
        my $found = 0;
        my $pin_type;
        foreach $pin_type ( keys %pin_types ) {
            if ( $pin_name =~ /$pin_type/ ) {
                $pin_list{properties}{$pin_number}{name} = $pin_name;
                $pin_list{properties}{$pin_number}{type} =
                  $pin_types{$pin_type};
                $pin_list{properties}{$pin_number}{swap_level} =
                  $swap_levels{$pin_type};
                $found = 1;
            }
        }
        if ( !$found ) {
            print STDERR "Unknown pin type: $pin_type $pin_name\n";
            $err = 1;
        }
    }

    if ($err) {
        die("\nUnknown pin types!\n");
    }

    return %pin_list;
}

####################################################################################
# Generate a pin list from a Xilinx FPGA pin TXT file.
####################################################################################
sub gen_xil_pin_list_4 {
    my ($pin_file) = @_;

    # read the entire CSV file
    open( FP, $pin_file ) || die( $pin_file . ": " . $! );
    my @lines = <FP>;
    close(FP);

    shift(@lines);    # remove header lines;
    shift(@lines);
    shift(@lines);
    shift(@lines);

    my %pin_types = (
        "NC\$"          => [ 'NC',  1 ],
        "GND\$"         => [ 'IN',  2 ],
        "VCCAUX\$"      => [ 'IN',  3 ],
        "VCCO_[0-9]+\$" => [ 'IN',  4 ],
        "VCCINT\$"      => [ 'IN',  5 ],
        "PROGRAM"       => [ 'IN',  6 ],
        "DONE"          => [ 'OUT', 7 ],
        "CMPCS_B"       => [ 'IN',  8 ],
        "SUSPEND\$"     => [ 'IN',  9 ],
        "TCK\$"         => [ 'IN',  10 ],
        "TMS\$"         => [ 'IN',  11 ],
        "TDI\$"         => [ 'IN',  12 ],
        "TDO\$"         => [ 'OUT', 13 ],
        "IO_"           => [ 'IO',  14 ],
    );

    my $pin_number_column = 0;
    my $pin_name_column   = 3;
    my %pin_list;
    my $err = 0;
    $pin_list{default_name}       = '';
    $pin_list{default_swap_level} = 0;
    foreach (@lines) {
        chomp;
        /^\s*$/ && last;
        my ( $pin_number, $pin_name ) =
          ( split( /\s+/, $_ ) )[ $pin_number_column, $pin_name_column ];
        my $found = 0;
        my $pin_type;
        foreach $pin_type ( keys %pin_types ) {
            if ( $pin_name =~ /^$pin_type/ or $pin_name =~ /_$pin_type/ ) {
                $pin_list{properties}{$pin_number}{name} = $pin_name;
                $pin_list{properties}{$pin_number}{'type'} =
                  $pin_types{$pin_type}[0];
                $pin_list{properties}{$pin_number}{swap_level} =
                  $pin_types{$pin_type}[1];
                $found = 1;
            }
        }
        if ( !$found ) {
            print STDERR "Unknown pin type: $pin_type $pin_name\n";
            $err = 1;
        }
    }

    if ($err) {
        die("\nUnknown pin types!\n");
    }

    return %pin_list;
}

1;
