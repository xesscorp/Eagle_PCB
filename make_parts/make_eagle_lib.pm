use Data::Dumper;
use List::Util qw[min max];

BEGIN {

#############################################################################################
    # Static variables for these subroutines.
#############################################################################################

    # Common constants.
    use constant DIR_X => 1;    # x increases going right
    use constant DIR_Y => 1;    # y increases going up

    use constant DEFAULT_PIN_NAME   => 'I/O';
    use constant DEFAULT_PIN_TYPE   => IO;
    use constant DEFAULT_SWAP_LEVEL => 0;

    # Symbol constants and definitions.
    use constant SYM_SYMBOL_LAYER    => 94;
    use constant SYM_NAME_LAYER      => 95;
    use constant SYM_VALUE_LAYER     => 96;
    use constant SYM_OUTLINE_WIDTH   => 12;
    use constant SYM_OUTLINE         => "(200 -50) (200 50)";
    use constant SYM_FONT_SIZE       => 70;
    use constant SYM_PV_NAME         => "PV_GATE";
    use constant SYM_PV_PART_OFFSET  => 0;
    use constant SYM_PV_VALUE_OFFSET => -100;
    use constant SYM_PG_NAME         => "PIN_GATE";
    use constant SYM_PG_IO_NAME      => "PIN_GATE_IO";
    use constant SYM_PG_IN_NAME      => "PIN_GATE_IN";
    use constant SYM_PG_OUT_NAME     => "PIN_GATE_OUT";
    use constant SYM_PG_NC_NAME      => "PIN_GATE_NC";
    use constant SYM_PG_OC_NAME      => "PIN_GATE_OC";
    use constant SYM_PG_HIZ_NAME     => "PIN_GATE_HIZ";
    use constant SYM_PG_PAS_NAME     => "PIN_GATE_PAS";
    use constant SYM_PG_PWR_NAME     => "PIN_GATE_PWR";
    use constant SYM_PG_OPTIONS      => 'None Middle R0 Pad 0 (0 0)';
    use constant SYM_PG_GATE_OFFSET  => 'R0 (225 -40)';

    # Hash for the pin gate symbols associated with each pin function.
    my %pin_gates = (
        IO    => SYM_PG_IO_NAME,
        INOUT => SYM_PG_IO_NAME,
        IN    => SYM_PG_IN_NAME,
        OUT   => SYM_PG_OUT_NAME,
        NC    => SYM_PG_NC_NAME,
        OC    => SYM_PG_OC_NAME,
        HIZ   => SYM_PG_HIZ_NAME,
        PAS   => SYM_PG_PAS_NAME,
        PWR   => SYM_PG_PWR_NAME,
    );

    # Package constants and definitions.
    use constant PCKG_KEEPOUT_LAYER        => 39;
    use constant PCKG_OUTLINE_LAYER        => 21;
    use constant PCKG_NAME_LAYER           => 25;
    use constant PCKG_DOC_LAYER            => 51;
    use constant PCKG_BGA_PAD_LAYER        => 1;
    use constant PCKG_BGA_PAD_ROUNDNESS    => "-100";    # round pad
    use constant PCKG_QFP_PAD_LAYER        => 1;
    use constant PCKG_QFP_SM_LAYER         => 29;
    use constant PCKG_QFP_PAD_ROUNDNESS    => "-0";      # rect pad
    use constant PCKG_FIDUCIAL_DIAM        => 30;
    use constant PCKG_OUTLINE_WIDTH        => 12;
    use constant PCKG_MIN_SOLDERMASK_WIDTH => 20;
    use constant PCKG_KEEPOUT_WIDTH        => 0;
    use constant PCKG_FONT_SIZE            => 70;
    use constant PCKG_DIAGONAL             =>
      50;    # length of silkscreen diagonal demarking pin 1
    use constant PCKG_PIN1_SIZE => 15;    # radius of circle denoting pin #1

    # Device constants and definitions.
    use constant DVC_DEFAULT_PREFIX => 'U';
    use constant DVC_GATE_SPACING   => 100;
    use constant DVC_GATE_SPACING_X => 16 * DVC_GATE_SPACING;
    use constant DVC_GATE_SPACING_Y => 1 * DVC_GATE_SPACING;
    use constant DVC_MAX_X          => 33000;
    use constant DVC_MAX_Y          => 33000;

    # Standard row ID labels for BGA packages.
    my @bga_row_ids = (
        'A',  'B',  'C',  'D',  'E',  'F',  'G',  'H',  'J',  'K',
        'L',  'M',  'N',  'P',  'R',  'T',  'U',  'V',  'W',  'Y',
        'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AJ', 'AK',
        'AL', 'AM', 'AN', 'AP', 'AR', 'AT', 'AU', 'AV', 'AW', 'AY'
    );

    # Create a hash that provides the row number when given the row ID.
    my %bga_row_nums;
    for ( my $i = 0 ; $i <= $#bga_row_ids ; $i++ ) {
        $bga_row_nums{ $bga_row_ids[$i] } = $i;
    }

#############################################################################################
    # Create symbols for
    #    1) the device name/value, and
    #    2) for a single-pin gate that will be used for each device pin.
#############################################################################################
    sub make_symbols {
        my ($eagle_script) = "
		Grid mil;

		Edit " . SYM_PV_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Change Size " . SYM_FONT_SIZE . ";
		Change Font Proportional;
		Text '>PART' R0 (0 " . SYM_PV_PART_OFFSET . ");
		Text '>VALUE' R0 (0 " . SYM_PV_VALUE_OFFSET . ");

		Edit " . SYM_PG_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Pin '1' I/O " . SYM_PG_OPTIONS . ";
		Text '>GATE' " . SYM_PG_GATE_OFFSET . ";
		Layer " . SYM_SYMBOL_LAYER . ";
		Wire " . SYM_OUTLINE_WIDTH . " " . SYM_OUTLINE . ";

		Edit " . SYM_PG_IO_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Pin '1' I/O " . SYM_PG_OPTIONS . ";
		Text '>GATE' " . SYM_PG_GATE_OFFSET . ";
		Layer " . SYM_SYMBOL_LAYER . ";
		Wire " . SYM_OUTLINE_WIDTH . " " . SYM_OUTLINE . ";
		Layer " . SYM_NAME_LAYER . ";

		Edit " . SYM_PG_IN_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Pin '1' In " . SYM_PG_OPTIONS . ";
		Text '>GATE' " . SYM_PG_GATE_OFFSET . ";
		Layer " . SYM_SYMBOL_LAYER . ";
		Wire " . SYM_OUTLINE_WIDTH . " " . SYM_OUTLINE . ";

		Edit " . SYM_PG_OUT_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Pin '1' Out " . SYM_PG_OPTIONS . ";
		Text '>GATE' " . SYM_PG_GATE_OFFSET . ";
		Layer " . SYM_SYMBOL_LAYER . ";
		Wire " . SYM_OUTLINE_WIDTH . " " . SYM_OUTLINE . ";

		Edit " . SYM_PG_NC_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Pin '1' NC " . SYM_PG_OPTIONS . ";
		Text '>GATE' " . SYM_PG_GATE_OFFSET . ";
		Layer " . SYM_SYMBOL_LAYER . ";
		Wire " . SYM_OUTLINE_WIDTH . " " . SYM_OUTLINE . ";

		Edit " . SYM_PG_OC_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Pin '1' OC " . SYM_PG_OPTIONS . ";
		Text '>GATE' " . SYM_PG_GATE_OFFSET . ";
		Layer " . SYM_SYMBOL_LAYER . ";
		Wire " . SYM_OUTLINE_WIDTH . " " . SYM_OUTLINE . ";

		Edit " . SYM_PG_HIZ_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Pin '1' Hiz " . SYM_PG_OPTIONS . ";
		Text '>GATE' " . SYM_PG_GATE_OFFSET . ";
		Layer " . SYM_SYMBOL_LAYER . ";
		Wire " . SYM_OUTLINE_WIDTH . " " . SYM_OUTLINE . ";

		Edit " . SYM_PG_PAS_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Pin '1' Pas " . SYM_PG_OPTIONS . ";
		Text '>GATE' " . SYM_PG_GATE_OFFSET . ";
		Layer " . SYM_SYMBOL_LAYER . ";
		Wire " . SYM_OUTLINE_WIDTH . " " . SYM_OUTLINE . ";

		Edit " . SYM_PG_PWR_NAME . ".sym;
		Layer " . SYM_NAME_LAYER . ";
		Pin '1' Pwr " . SYM_PG_OPTIONS . ";
		Text '>GATE' " . SYM_PG_GATE_OFFSET . ";
		Layer " . SYM_SYMBOL_LAYER . ";
		Wire " . SYM_OUTLINE_WIDTH . " " . SYM_OUTLINE . ";
		
		Grid $units;
		";

        #############################################################################################
# Override the previous pin gate symbols using these hand-drawn ones that were exported.
        #############################################################################################
        $eagle_script = "
Set Wire_Bend 2;
Grid mm;
Layer   1 Top;
Layer   2 Route2;
Layer   3 Route3;
Layer   4 Route4;
Layer   5 Route5;
Layer   6 Route6;
Layer   7 Route7;
Layer   8 Route8;
Layer   9 Route9;
Layer  10 Route10;
Layer  11 Route11;
Layer  12 Route12;
Layer  13 Route13;
Layer  14 Route14;
Layer  15 Route15;
Layer  16 Bottom;
Layer  17 Pads;
Layer  18 Vias;
Layer  19 Unrouted;
Layer  20 Dimension;
Layer  21 tPlace;
Layer  22 bPlace;
Layer  23 tOrigins;
Layer  24 bOrigins;
Layer  25 tNames;
Layer  26 bNames;
Layer  27 tValues;
Layer  28 bValues;
Layer  29 tStop;
Layer  30 bStop;
Layer  31 tCream;
Layer  32 bCream;
Layer  33 tFinish;
Layer  34 bFinish;
Layer  35 tGlue;
Layer  36 bGlue;
Layer  37 tTest;
Layer  38 bTest;
Layer  39 tKeepout;
Layer  40 bKeepout;
Layer  41 tRestrict;
Layer  42 bRestrict;
Layer  43 vRestrict;
Layer  44 Drills;
Layer  45 Holes;
Layer  46 Milling;
Layer  47 Measures;
Layer  48 Document;
Layer  49 Reference;
Layer  51 tDocu;
Layer  52 bDocu;
Layer  91 Nets;
Layer  92 Busses;
Layer  93 Pins;
Layer  94 Symbols;
Layer  95 Names;
Layer  96 Values;
Layer 151 PinDoc;
Description 'Pin Gate Symbols';

Edit PV_GATE.sym;
Layer 95;
Change Size 1.778;
Change Ratio 8;
Change Font Proportional;
Text '>PART' R0 (0 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>VALUE' R0 (0 -2.54);

Edit PIN_GATE.sym;
Pin '1' I/O None Middle R0 Pad 0 (0 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>GATE' R0 (5.715 -1.016);
Layer 151;
Change Spacing 1.27;
Change Pour Solid;
Change Rank 0;
Polygon 0  (3.81 -0.508) (5.08 0) (3.81 0.508) (3.81 -0.508);
Layer 151;
Change Spacing 1.27;
Change Pour Solid;
Change Rank 0;
Polygon 0  (3.048 0.508) (1.778 0) (3.048 -0.508) (3.048 0.508);

Edit PIN_GATE_IO.sym;
Pin '1' I/O None Middle R0 Pad 0 (0 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>GATE' R0 (5.715 -1.016);
Layer 151;
Change Spacing 1.27;
Change Pour Solid;
Change Rank 0;
Polygon 0  (3.81 -0.508) (5.08 0) (3.81 0.508) (3.81 -0.508);
Layer 151;
Change Spacing 1.27;
Change Pour Solid;
Change Rank 0;
Polygon 0  (3.048 0.508) (1.778 0) (3.048 -0.508) (3.048 0.508);

Edit PIN_GATE_IN.sym;
Pin '1' In None Middle R0 Pad 0 (0 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>GATE' R0 (5.715 -1.016);
Layer 151;
Change Spacing 1.27;
Change Pour Solid;
Change Rank 0;
Polygon 0  (3.81 -0.508) (5.08 0) (3.81 0.508) (3.81 -0.508);

Edit PIN_GATE_OUT.sym;
Pin '1' Out None Middle R0 Pad 0 (0 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>GATE' R0 (5.715 -1.016);
Layer 151;
Change Spacing 1.27;
Change Pour Solid;
Change Rank 0;
Polygon 0  (3.048 0.508) (1.778 0) (3.048 -0.508) (3.048 0.508);

Edit PIN_GATE_NC.sym;
Pin '1' NC None Short R0 Pad 0 (2.04 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>GATE' R0 (5.715 -1.016);

Edit PIN_GATE_OC.sym;
Pin '1' OC None Middle R0 Pad 0 (0 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>GATE' R0 (5.715 -1.016);
Layer 151;
Wire  0.127 (3.302 0.254) (4.318 0.254);
Layer 151;
Change Spacing 1.27;
Change Pour Solid;
Change Rank 0;
Polygon 0  (3.81 1.27) (3.302 0.762) (3.81 0.254) (4.318 0.762) \
      (3.81 1.27);

Edit PIN_GATE_HIZ.sym;
Pin '1' Hiz None Middle R0 Pad 0 (0 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>GATE' R0 (5.715 -1.016);
Layer 151;
Change Spacing 1.27;
Change Pour Solid;
Change Rank 0;
Polygon 0  (3.302 1.016) (3.81 0) (4.318 1.016) (3.302 1.016);

Edit PIN_GATE_PAS.sym;
Pin '1' Pas None Middle R0 Pad 0 (0 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>GATE' R0 (5.715 -1.016);

Edit PIN_GATE_PWR.sym;
Pin '1' Pwr None Middle R0 Pad 0 (0 0);
Layer 95;
Change Size 1.778;
Change Ratio 8;
Text '>GATE' R0 (5.715 -1.016);
";

        #############################################################################################
        # Remove spaces and tabs from script.
        #############################################################################################
        $eagle_script =~ s/^\s+//g;
        $eagle_script =~ s/\s+\n\s+/\n/g;

        return $eagle_script;
    }

#############################################################################################
    # Create BGA package.
    # Arguments:
    #	name
    #	title
    #	desc
    #	units: 'mm' or 'mil'
    #	pad_diameter
    #	pad_spacing
    #	num_rows
    #	num_cols
    #	chip_x
    #	chip_y
    #	add_fiducials
    #	knockouts
    #	relabel
#############################################################################################
    sub make_bga_pckg {
        my (%args) = @_;
        for ( keys %args ) {
            $$_ = $args{$_};
        }
		$knockouts = $args{knockouts};

        #############################################################################################
        # Predefined parameters.
        #############################################################################################
        my ($keepout_layer)     = PCKG_KEEPOUT_LAYER;
        my ($outline_layer)     = PCKG_OUTLINE_LAYER;
        my ($name_layer)        = PCKG_NAME_LAYER;
        my ($doc_layer)         = PCKG_DOC_LAYER;
        my ($pad_layer)         = PCKG_BGA_PAD_LAYER;
        my ($roundness)         = PCKG_BGA_PAD_ROUNDNESS;
        my ($dir_x)             = DIR_X;
        my ($dir_y)             = DIR_Y;
        my ($fiducial_diameter) = PCKG_FIDUCIAL_DIAM;
        my ($outline_width)     = PCKG_OUTLINE_WIDTH;
        my ($keepout_width)     = PCKG_KEEPOUT_WIDTH;
        my ($font_size)         = PCKG_FONT_SIZE;
        my ($diagl)             = PCKG_DIAGONAL;
        if ( $units eq "mm" ) {
            $fiducial_diameter *= 0.0254;
            $outline_width     *= 0.0254;
            $keepout_width     *= 0.0254;
            $diagl             *= 0.0254;
        }

        #############################################################################################
        # Clear script.
        #############################################################################################
        my ($eagle_script) = "";

        #############################################################################################
        # Set origin and spacing of pads.
        #############################################################################################
        my ($row_spacing) = $pad_spacing;
        my ($col_spacing) = $pad_spacing;
        my ( $origin_x, $origin_y ) = ( 0, 0 );    # place pad 1 at origin

        #############################################################################################
        # Create a hash of pads that are knocked out.
        #############################################################################################
        my (%is_knockout);
        foreach my $row_lbl ( keys %$knockouts ) {
            foreach my $col_lbl ( @{ $knockouts->{$row_lbl} } ) {
                $is_knockout{ $row_lbl . $col_lbl } = 1;
            }
        }

        #############################################################################################
        # Start the package definition.
        #############################################################################################
        my ($eagle_script) .= "
		Set Wire_Bend 2;
		Grid $units;
		Edit $name.pac;
		Description '<b>$title</b><p>$desc</p>';
		";

        #############################################################################################
        # Create the array of BGA pads.
        #############################################################################################
        for my $row ( 0 .. $num_rows - 1 ) {
            my ($y)      = $origin_y - $row_spacing * $row * $dir_y;
            my ($row_id) = $bga_row_ids[$row];
            for my $col ( 1 .. $num_cols ) {
                my ($x) = $origin_x + $col_spacing * ( $col - 1 ) * $dir_x;

                # Create pads only in the populated positions.
                next if $is_knockout{ $row_id . $col };
                my $pad_num = $row_id . $col;
                my $label   = $$relabel{$pad_num};
                !defined $label && ( $label = $pad_num );
                $eagle_script .= "
					Layer $pad_layer;
					Smd '$label' $pad_diameter $pad_diameter $roundness ($x $y);
					";

                # Create pad outline in the document layer.
                my ($c2x) = $x + $pad_diameter / 2.0;
                $eagle_script .= "
					Layer $doc_layer;
					circle 0 ($x $y) ($c2x $y);
					";
            }
        }

        #############################################################################################
        # Determine the corner points for the box around the pads.
        #############################################################################################
        my ($pads_y)     = ( $num_rows - 1 ) * $row_spacing;
        my ($overhang_y) = ( $chip_y - $pads_y ) / 2.0;
        my ($pads_x)     = ( $num_cols - 1 ) * $col_spacing;
        my ($overhang_x) = ( $chip_x - $pads_x ) / 2.0;

        # Corner points for the box around the pads.
        my ($c1x) = $origin_x - $overhang_x * $dir_x;
        my ($c2x) = $c1x + $chip_x * $dir_x;
        my ($c1y) = $origin_y + $overhang_y * $dir_y;
        my ($c2y) = $c1y - $chip_y * $dir_y;

        # Intersection points for the triangle that indicates pin 1.
        my ($diagx) = $c1x + $diagl * $dir_x;
        my ($diagy) = $c1y - $diagl * $dir_y;

        #############################################################################################
        # Generate the BGA silkscreen outline and keepout area.
        #############################################################################################
        $eagle_script .= "
		Layer $outline_layer;
		Wire $outline_width ($c1x $c1y) ($c2x $c1y) ($c2x $c2y) ($c1x $c2y) ($c1x $c1y);
		Polygon ($c1x $c1y) ($c1x $diagy) ($diagx $c1y) ($c1x $c1y);
		Layer $keepout_layer;
		Wire $keepout_width ($c1x $c1y) ($c2x $c1y) ($c2x $c2y) ($c1x $c2y) ($c1x $c1y);
		";

        #############################################################################################
    # Place fiducials at diagonal corners of the package.
    # (c1x,c1y should still hold the location of the box corner near pin 1.)
    # (c2x,c2y should still hold the location of the box corner opposite pin 1.)
        #############################################################################################
        if ($add_fiducials) {
            my ($f1x) =
              $c1x - ( $fiducial_diameter + $outline_width ) / 2.0 * $dir_x;
            my ($f1y) =
              $c2y - ( $fiducial_diameter + $outline_width ) / 2.0 * $dir_y;
            my ($f2x) = $f1x + $fiducial_diameter / 2.0 * $dir_x;
            my ($f2y) = $f1y;
            $eagle_script .= "
			Layer 1;
			Circle 0 ($f1x $f1y) ($f2x $f2y);
			";
            $f1x =
              $c2x + ( $fiducial_diameter + $outline_width ) / 2.0 * $dir_x;
            $f1y =
              $c1y + ( $fiducial_diameter + $outline_width ) / 2.0 * $dir_x;
            $f2x = $f1x - $fiducial_diameter / 2.0 * $dir_x;
            $f2y = $f1y;
            $eagle_script .= "
			Circle 0 ($f1x $f1y) ($f2x $f2y);
			";
        }

        #############################################################################################
        # Generate the placeholder for the device label.
        # (c1x,c1y should still hold the location of the box corner near pin 1.)
        #############################################################################################
        my ($label_x) = $c1x;
        my ($label_y) = $c1y + $row_spacing * $dir_y;
        $eagle_script .= "
		Layer $name_layer;
		Grid mil;
		Change Size $font_size;
		Grid $units;
		Change Font Proportional;
		Text '>NAME' R0 ($label_x $label_y);
		";

        #############################################################################################
        # Remove spaces and tabs from script.
        #############################################################################################
        $eagle_script =~ s/^\s+//g;
        $eagle_script =~ s/\s+\n\s+/\n/g;

        #############################################################################################
        # Undefine variables made from passed arguments.
        #############################################################################################
        for ( keys %args ) {
           undef $$_;
        }

        return $eagle_script;
    }

#############################################################################################
# Helper function for determining how many soldermask windows to cut into a large pad.
#############################################################################################
    sub find_num_windows {
        my ( $pad_size, $min_window_size, $max_window_size ) = @_;
        my ($min_num_windows) = int( $pad_size / $max_window_size );
        my ($max_num_windows) = int( $pad_size / $min_window_size );
        return max( 1, $max_num_windows );

        #	return max(1,int(($min_num_windows + $max_num_windows)/2));
    }

#############################################################################################
    # Create QFP package.
    # Arguments:
    #	name
    #	title
    #	desc
    #	units
    #	pad_width, b
    #	contact_length, L
    #	front_porch, fp
    #	back_porch, bp
    #	pad_spacing, e
    #	N
    #	num_pads_x, ND
    #	num_pads_y, NE
    #	chip_x, D
    #	chip_y, E
    #	E1
    #	D1
	#	pin_name_prefix
    #	add_fiducials
    #	knockouts
    #	relabel
    #	extra_pads
    #	outline: 'inside' (default) or 'outside'
    #	mark_pin1: 'no' (default) or 'yes'
#############################################################################################
    sub make_qfp_pckg {
        my (%args) = @_;
        for ( keys %args ) {
            $$_ = $args{$_};
        }
		$mark_pin1 = $args{mark_pin1};
		$outline = $args{outline};

        my ($is_quad) = ( defined($D1) && defined($E1) )
          || ( defined($ND) && defined($NE) );
        my ($is_dil) = !$is_quad;

        !defined $num_pads_x && ( $num_pads_x = $ND );
        !defined $num_pads_y && ( $num_pads_y = $NE );

        if ( $is_quad && ( !defined $num_pads_x && !defined $num_pads_y ) ) {
            $num_pads_x = $N / 4;
            $num_pads_y = $N / 4;
        }
        if ( $is_dil && ( !defined $num_pads_x && !defined $num_pads_y ) ) {
            $num_pads_x = $N / 2;
            $num_pads_y = 0;
        }

        !defined $chip_x         && ( $chip_x         = $D );
        !defined $chip_y         && ( $chip_y         = $E );
        !defined $pad_spacing    && ( $pad_spacing    = $e );
        !defined $pad_width      && ( $pad_width      = $b );
        !defined $contact_length && ( $contact_length = $L );
        !defined $front_porch    && ( $front_porch    = $fp );
        !defined $back_porch     && ( $back_porch     = $bp );

        my ($pad_length) = $contact_length + $front_porch + $back_porch;

        my ( $pin1x, $pin1y );

        #############################################################################################
        # Predefined parameters.
        #############################################################################################
        my ($keepout_layer)    = PCKG_KEEPOUT_LAYER;
        my ($outline_layer)    = PCKG_OUTLINE_LAYER;
        my ($name_layer)       = PCKG_NAME_LAYER;
        my ($doc_layer)        = PCKG_DOC_LAYER;
        my ($pad_layer)        = PCKG_QFP_PAD_LAYER;
        my ($soldermask_layer) = PCKG_QFP_SM_LAYER;
        my ($roundness)        = PCKG_QFP_PAD_ROUNDNESS;
        $roundness = '-100' if ( $pad_shape eq 'round' );
        my ($dir_x)             = DIR_X;
        my ($dir_y)             = DIR_Y;
        my ($fiducial_diameter) = PCKG_FIDUCIAL_DIAM;
        my ($outline_width)     = PCKG_OUTLINE_WIDTH;
        my ($keepout_width)     = PCKG_KEEPOUT_WIDTH;
        my ($font_size)         = PCKG_FONT_SIZE;
        my ($diagl)             = PCKG_DIAGONAL;
        my ($pin1_rad)          = PCKG_PIN1_SIZE;

        if ( $units eq "mm" ) {
            $fiducial_diameter *= 0.0254;
            $outline_width     *= 0.0254;
            $keepout_width     *= 0.0254;
            $diagl             *= 0.0254;
            $pin1_rad          *= 0.0254;
        }

        #############################################################################################
        # Clear script.
        #############################################################################################
        my ($eagle_script) = "";

        #############################################################################################
        # Orient a DIL chip so pins run along left and right sides.
		# And don't rotate chip if extra pads are defined because they have absolute coordinates.
        #############################################################################################
        if ( $num_pads_y == 0 and !defined($extra_pads) ) {
            ( $num_pads_x, $num_pads_y ) = ( $num_pads_y, $num_pads_x );
            ( $chip_x,     $chip_y )     = ( $chip_y,     $chip_x );
        }

        #############################################################################################
        # Set origin of pads.
        #############################################################################################
        my ( $origin_x, $origin_y ) = ( 0, 0 );

        #############################################################################################
        # Create a hash of pads that are knocked out.
        #############################################################################################
        my (%is_knockout);
        foreach my $pad_num (@$knockouts) {
            $is_knockout{$pad_num} = 1;
        }

        #############################################################################################
        # Start the package definition.
        #############################################################################################
        my ($eagle_script) .= "
		Set Wire_Bend 2;
		Grid $units;
		Edit $name.pac;
		Description '<b>$title</b><p>$desc</p>';
		";

        #############################################################################################
 # Compute the lengths of the top/bottom and left/right rows of pads.
 # Also compute the overhang of the chip bounding box past the bbox of the pads.
        #############################################################################################
        my ($pads_y)     = max( 0, $num_pads_y - 1 ) * $pad_spacing;
        my ($overhang_y) = ( $chip_y - $pads_y ) / 2.0;
        my ($pads_x)     = max( 0, $num_pads_x - 1 ) * $pad_spacing;
        my ($overhang_x) = ( $chip_x - $pads_x ) / 2.0;

        #############################################################################################
        # Create the left-side column of QFP pads.
        #############################################################################################
        my ($pad_num) = 1;
        my ( $x, $y ) = ( $origin_x, $origin_y );
        $x += ( ( $back_porch - $front_porch ) / 2.0 ) * $dir_x;
        my ( $c1x, $c1y, $c2x, $c2y );    # corner points of pad rectangles
        for (
            ;
            $pad_num <= $num_pads_y ;
            $pad_num++, $y -= $pad_spacing * $dir_y
          )
        {

            # Create pads only in the populated positions.
            next if $is_knockout{$pad_num};
            my $label = $$relabel{$pad_num};
            !defined $label && ( $label = $pad_num );
			my $pinlabel = $pin_name_prefix . $label;
            $eagle_script .= "
			Layer $pad_layer;
			Smd '$pinlabel' $pad_length $pad_width $roundness ($x $y);
			";

            # Pad outline on document layer.
            $c1x = $x - $pad_length / 2.0 * $dir_x;
            $c2x = $c1x + $pad_length * $dir_x;
            $c1y = $y - $pad_width / 2.0 * $dir_y;
            $c2y = $c1y + $pad_width * $dir_y;
            $eagle_script .= "
			Layer $doc_layer;
			Rect ($c1x $c1y) ($c2x $c2y);
			";

            # keep location of pin 1 so we can mark it later on the silkscreen
            if ( $label eq '1' ) {
                ( $pin1x, $pin1y ) =
                  ( $c1x - ( $pin1_rad + $outline_width ) * $dir_x, $y );
            }
        }

        #############################################################################################
        # Create the bottom row of QFP pads.
        #############################################################################################
        $x = $origin_x + ( $overhang_x - $contact_length / 2.0 ) * $dir_x;
        $y = $origin_y - ( $pads_y + $overhang_y - $contact_length / 2.0 ) *
          $dir_y;
        $y += ( ( $back_porch - $front_porch ) / 2.0 ) * $dir_y;
        for (
            ;
            $pad_num <= $num_pads_y + $num_pads_x ;
            $pad_num++, $x += $pad_spacing * $dir_x
          )
        {

            # Create pads only in the populated positions.
            next if $is_knockout{$pad_num};
            my $label = $$relabel{$pad_num};
            !defined $label && ( $label = $pad_num );
			my $pinlabel = $pin_name_prefix . $label;
            $eagle_script .= "
			Layer $pad_layer;
			Smd '$pinlabel' $pad_width $pad_length $roundness ($x $y);
			";

            # Pad outline on document layer.
            $c1x = $x - $pad_width / 2.0 * $dir_x;
            $c2x = $c1x + $pad_width * $dir_x;
            $c1y = $y - $pad_length / 2.0 * $dir_y;
            $c2y = $c1y + $pad_length * $dir_y;
            $eagle_script .= "
			Layer $doc_layer;
			Rect ($c1x $c1y) ($c2x $c2y);
			";

            # keep location of pin 1 so we can mark it later on the silkscreen
            if ( $label eq '1' ) {
                ( $pin1x, $pin1y ) =
                  ( $x, $c1y - ( $pin1_rad + $outline_width ) * $dir_y );
            }
        }

        #############################################################################################
        # Create the right-side column of QFP pads.
        #############################################################################################
        $x = $origin_x + ( $chip_x - $contact_length ) * $dir_x;
        $y = $origin_y - $pads_y * $dir_y;
        $x -= ( ( $back_porch - $front_porch ) / 2.0 ) * $dir_x;
        for (
            ;
            $pad_num <= 2 * $num_pads_y + $num_pads_x ;
            $pad_num++, $y += $pad_spacing * $dir_y
          )
        {

            # Create pads only in the populated positions.
            next if $is_knockout{$pad_num};
            my $label = $$relabel{$pad_num};
            !defined $label && ( $label = $pad_num );
			my $pinlabel = $pin_name_prefix . $label;
            $eagle_script .= "
			Layer $pad_layer;
			Smd '$pinlabel' $pad_length $pad_width $roundness ($x $y);
			";

            # Pad outline on document layer.
            $c1x = $x - $pad_length / 2.0 * $dir_x;
            $c2x = $c1x + $pad_length * $dir_x;
            $c1y = $y - $pad_width / 2.0 * $dir_y;
            $c2y = $c1y + $pad_width * $dir_y;
            $eagle_script .= "
			Layer $doc_layer;
			Rect ($c1x $c1y) ($c2x $c2y);
			";

            # keep location of pin 1 so we can mark it later on the silkscreen
            if ( $label eq '1' ) {
                ( $pin1x, $pin1y ) =
                  ( $c2x + ( $pin1_rad + $outline_width ) * $dir_x, $y );
            }
        }

        #############################################################################################
        # Create the top row of QFP pads.
        #############################################################################################
        $x = $origin_x + ( $chip_x - $overhang_x - $contact_length / 2.0 ) *
          $dir_x;
        $y = $origin_y + ( $overhang_y - $contact_length / 2.0 ) * $dir_y;
        $y -= ( ( $back_porch - $front_porch ) / 2.0 ) * $dir_y;
        for (
            ;
            $pad_num <= 2 * ( $num_pads_x + $num_pads_y ) ;
            $pad_num++, $x -= $pad_spacing * $dir_x
          )
        {

            # Create pads only in the populated positions.
            next if $is_knockout{$pad_num};
            my $label = $$relabel{$pad_num};
            !defined $label && ( $label = $pad_num );
			my $pinlabel = $pin_name_prefix . $label;
            $eagle_script .= "
			Layer $pad_layer;
			Smd '$pinlabel' $pad_width $pad_length $roundness ($x $y);
			";

            # Pad outline on document layer.
            $c1x = $x - $pad_width / 2.0 * $dir_x;
            $c2x = $c1x + $pad_width * $dir_x;
            $c1y = $y - $pad_length / 2.0 * $dir_y;
            $c2y = $c1y + $pad_length * $dir_y;
            $eagle_script .= "
			Layer $doc_layer;
			Rect ($c1x $c1y) ($c2x $c2y);
			";

            # keep location of pin 1 so we can mark it later on the silkscreen
            if ( $label eq '1' ) {
                ( $pin1x, $pin1y ) =
                  ( $x, $c1y + ( $pin1_rad + $outline_width ) * $dir_y );
            }
        }

        #############################################################################################
        # Create any extra pads in addition to the regular QFP pads.
        #############################################################################################
        foreach my $label ( keys %$extra_pads ) {
            my $extra_pad_width  = $$extra_pads{$label}->{h};
			$extra_pad_width = $pad_width if !defined($extra_pad_width);
            my $extra_pad_length = $$extra_pads{$label}->{l};
			$extra_pad_length = $pad_length if !defined($extra_pad_length);
            my $x          = $$extra_pads{$label}->{x};
            my $y          = $$extra_pads{$label}->{y};
            my $use_copper = $$extra_pads{$label}->{use_copper};
            my $center_x   = $x + $chip_x / 2.0 - $contact_length / 2.0;
            my $center_y   = $y + $overhang_y - $chip_y / 2.0;
            my $new_label  = $$relabel{$label};
            defined $new_label && ( $label = $new_label );

            if ( defined $use_copper and $use_copper ) {
                $eagle_script .= "
					Layer $pad_layer;
					Smd '$label' 0.025 0.025 -0 ($center_x $center_y);
					";

                my $c1x = $center_x - $extra_pad_length / 2.0;
                my $c1y = $center_y + $extra_pad_width / 2.0;
                my $c2x = $center_x + $extra_pad_length / 2.0;
                my $c2y = $center_y - $extra_pad_width / 2.0;
                $eagle_script .= "
					Layer $pad_layer;
					Polygon 0 ($c1x $c1y) ($c1x $c2y) ($c2x $c2y) ($c2x $c1y) ($c1x $c1y);
					";

                # create array of soldermask-free windows into copper pad
                $eagle_script .= "Layer $soldermask_layer;";
                my ($min_mask_width) = PCKG_MIN_SOLDERMASK_WIDTH;
                my ($min_window)     =
                  2.41 * $min_mask_width;  # 2.41 = 1 + sqrt(2) for 50% coverage
                my ($max_window) = 8.47 *
                  $min_mask_width;    # 8.47 = 4 + 2*sqrt(5) for 80% coverage
                if ( $units eq "mm" ) {
                    $min_window     *= 0.0254;
                    $max_window     *= 0.0254;
                    $min_mask_width *= 0.0254;
                }
                my ($num_x) = find_num_windows(
                    $extra_pad_length,
                    $min_window + $min_mask_width,
                    $max_window + $min_mask_width
                );
                my ($step_x)   = $extra_pad_length / $num_x;
                my ($window_x) = $extra_pad_length / $num_x - $min_mask_width;
                my ($start_x)  = $c1x + $step_x / 2.0;
                my ($num_y)    = find_num_windows(
                    $extra_pad_width,
                    $min_window + $min_mask_width,
                    $max_window + $min_mask_width
                );
                my ($step_y)   = $extra_pad_width / $num_y;
                my ($window_y) = $extra_pad_width / $num_y - $min_mask_width;
                my ($start_y)  = $c2y + $step_y / 2.0;

                for ( my $row = 0 ; $row < $num_y ; $row++ ) {
                    $c2y = $start_y + $row * $step_y - $window_y / 2.0;
                    $c1y = $c2y + $window_y;
                    for ( my $col = 0 ; $col < $num_x ; $col++ ) {
                        $c1x = $start_x + $col * $step_x - $window_x / 2.0;
                        $c2x = $c1x + $window_x;
                        $eagle_script .= "Rect ($c1x $c1y) ($c2x $c2y)\n";
                    }
                }
            }
            else {
                $eagle_script .= "
					Layer $pad_layer;
					Smd '$label' $extra_pad_length $extra_pad_width $roundness ($center_x $center_y);
					";
            }

            # Pad outline on document layer.
            $c1x = $center_x - $extra_pad_length / 2.0 * $dir_x;
            $c2x = $c1x + $extra_pad_length * $dir_x;
            $c1y = $center_y - $extra_pad_width / 2.0 * $dir_y;
            $c2y = $c1y + $extra_pad_width * $dir_y;
            $eagle_script .= "
			Layer $doc_layer;
			Rect ($c1x $c1y) ($c2x $c2y);
			";

            # keep location of pin 1 so we can mark it later on the silkscreen
            if ( $label eq '1' ) {
                if ( $x < 0 ) {
                    ( $pin1x, $pin1y ) =
                      ( $c1x - ( $pin1_rad + $outline_width ) * $dir_x, $center_y );
                }
                else {
                    ( $pin1x, $pin1y ) =
                      ( $c2x + ( $pin1_rad + $outline_width ) * $dir_x, $center_y );
                }
            }
        }

        #############################################################################################
        # Generate the QFP silkscreen outline.
        #############################################################################################
        my ( $name_x, $name_y );
        if ( $outline eq 'outside' ) {
            $c1x = $origin_x - $contact_length / 2.0 * $dir_x;
            $c2x = $c1x + $chip_x * $dir_x;
            $c1x -= ( $front_porch + $outline_width ) * $dir_x;
            $c2x += ( $front_porch + $outline_width ) * $dir_x;
            if ( $num_pads_x == 0 ) {    # DIL chip
                $c1y = $origin_y + $overhang_y * $dir_y;
                $c2y = $c1y - $chip_y * $dir_y;
            }
            else {                       # QFP chip
                $c1y =
                  $origin_y + ( $overhang_y + $front_porch + $outline_width ) *
                  $dir_y;
                $c2y = $origin_y +
                  ( -$pads_y - $overhang_y - $front_porch - $outline_width ) *
                  $dir_y;
            }
            ( $name_x, $name_y ) = ( $c1x, $c1y + $outline_width * $dir_y );
        }
        else {
            $c1x = $origin_x - $contact_length / 2.0 * $dir_x;
            $c2x = $c1x + $chip_x * $dir_x;
            $c1x += ( $contact_length + $back_porch + $outline_width ) * $dir_x;
            $c2x -= ( $contact_length + $back_porch + $outline_width ) * $dir_x;
            if ( $num_pads_x == 0 ) {    # DIL chip
                $c1y = $origin_y + $overhang_y * $dir_y;
                $c2y = $c1y - $chip_y * $dir_y;
            }
            else {                       # QFP chip
                $c1y =
                  $origin_y + ( $overhang_y - $contact_length - $back_porch -
                      $outline_width ) * $dir_y;
                $c2y = $origin_y +
                  ( -$pads_y - $overhang_y + $contact_length + $back_porch +
                      $outline_width ) * $dir_y;
            }
        }
        $diagl =
          min( abs( $c1y - $c2y ) / 2.0, abs( $c1x - $c2x ) / 2.0, $diagl );
        my $diagx = $c1x + $diagl * $dir_x;
        my $diagy = $c1y - $diagl * $dir_y;
        $eagle_script .= "
			Layer $outline_layer;
			Wire $outline_width ($c1x $c1y) ($c1x $c2y) ($c2x $c2y) ($c2x $c1y) ($c1x $c1y);
			";
        if ( $is_quad or $outline ne 'outside' ) {
            $eagle_script .= "
			Layer $outline_layer;
			Polygon ($c1x $c1y) ($c1x $diagy) ($diagx $c1y) ($c1x $c1y);
			";
        }
        else {
            $mark_pin1 = 'yes';
        }
        if ( $mark_pin1 eq 'yes' ) {
            my $radx = $pin1x + $pin1_rad;
            $eagle_script .= "
				Layer $outline_layer;
				Circle 0 ($pin1x $pin1y) ($radx $pin1y);
			";
        }

        #############################################################################################
        # Generate the QFP keepout area.
        #############################################################################################
        $c1x = $origin_x - ( $contact_length / 2.0 + $front_porch ) * $dir_x;
        $c2x = $origin_x + ( $chip_x - $contact_length / 2.0 + $front_porch ) *
          $dir_x;
        if ( $num_pads_x == 0 ) {    # DIL chip
            $c1y = $origin_y + $overhang_y * $dir_y;
            $c2y = $c1y - $chip_y * $dir_y;
        }
        else {                       # QFP chip
            $c1y = $origin_y + ( $overhang_y + $front_porch ) * $dir_y;
            $c2y =
              $origin_y + ( -$pads_y - $overhang_y - $front_porch ) * $dir_y;
        }
        $eagle_script .= "
			Layer $keepout_layer;
			Wire $keepout_width ($c1x $c1y) ($c1x $c2y) ($c2x $c2y) ($c2x $c1y) ($c1x $c1y);
			";
        if ( $outline ne 'outside' ) {
            ( $name_x, $name_y ) = ( $c1x, $c1y );
        }

        #############################################################################################
# Generate the placeholder for the device label.
# (c1x,c1y should still hold the location of the keepout box corner near pin 1.)
        #############################################################################################
        $eagle_script .= "
			Layer $name_layer;
			Grid mil;
			Change Size $font_size;
			Grid $units;
			Change Font Proportional;
			Text '>NAME' R0 ($name_x $name_y);
			";

        #############################################################################################
       # Place fiducials at pin 1 corner and the diagonal corner of the package.
        #############################################################################################
        if ($add_fiducials) {
            $c1x = $origin_x;
            $c2x = $c1x + $fiducial_diameter / 2.0 * $dir_x;
            if ( $num_pads_x == 0 ) {    # DIL chip
                $c1y = $origin_y + ( $pad_width + $fiducial_diameter ) * $dir_y;
                $c2y = $c1y;
            }
            else {                       # QFP chip
                $c1y =
                  $origin_y + ( $overhang_y - $contact_length / 2.0 ) * $dir_y;
                $c2y = $c1y;
            }
            $eagle_script .= "
				Layer 1;
				Circle 0 ($c1x $c1y) ($c2x $c2y);
				";
            if ( $num_pads_x == 0 ) {    # DIL chip
                $c1x = $c1x + ( $chip_x - $contact_length ) * $dir_x;
                $c2x = $c1x + $fiducial_diameter / 2.0 * $dir_x;
                $c1y =
                  $origin_y - ( $pads_y + $pad_width + $fiducial_diameter ) *
                  $dir_y;
                $c2y = $c1y;
            }
            else {                       # QFP chip
                $c1x = $c1x + ( $chip_x - $contact_length ) * $dir_x;
                $c2x = $c1x - $fiducial_diameter / 2.0 * $dir_x;
                $c1y = $c1y - ( $chip_y - $contact_length ) * $dir_y;
                $c2y = $c1y;
            }
            $eagle_script .= "
				Circle 0 ($c1x $c1y) ($c2x $c2y);
				";
        }

        #############################################################################################
        # Remove spaces and tabs from script.
        #############################################################################################
        $eagle_script =~ s/^\s+//g;
        $eagle_script =~ s/\s+\n\s+/\n/g;

        #############################################################################################
        # Undefine variables made from passed arguments.
        #############################################################################################
        for ( keys %args ) {
            undef $$_;
        }

        return $eagle_script;
    }

#############################################################################################
    # Create DIL package.
    # Arguments:
    #	name
    #	title
    #	desc
    #	units
    #	pad_size
    #	pad_drill
    #	pad_shape
    #	pad_spacing
    #	num_pads
    #	chip_x
    #	chip_y
    #	add_fiducials
    #	knockouts
    #	relabel
    #	extra_pads
    #	outline: 'inside' (default) or 'outside'
    #	mark_pin1: 'no' (default) or 'yes'
#############################################################################################
    sub make_dil_pckg {
        my (%args) = @_;
        for ( keys %args ) {
            $$_ = $args{$_};
        }
		$args{mark_pin1} = $args{mark_pin1};
		$args{outline} = $args{outline};

        my ( $pin1x, $pin1y );

        #############################################################################################
        # Predefined parameters.
        #############################################################################################
        my ($keepout_layer)     = PCKG_KEEPOUT_LAYER;
        my ($outline_layer)     = PCKG_OUTLINE_LAYER;
        my ($name_layer)        = PCKG_NAME_LAYER;
        my ($doc_layer)         = PCKG_DOC_LAYER;
        my ($dir_x)             = DIR_X;
        my ($dir_y)             = DIR_Y;
        my ($font_size)         = PCKG_FONT_SIZE;
        my ($fiducial_diameter) = PCKG_FIDUCIAL_DIAM;
        my ($outline_width)     = PCKG_OUTLINE_WIDTH;
        my ($keepout_width)     = PCKG_KEEPOUT_WIDTH;
        my ($diagl)             = PCKG_DIAGONAL;
        my ($pin1_rad)          = PCKG_PIN1_SIZE;
        if ( $units eq "mm" ) {
            $fiducial_diameter *= 0.0254;
            $outline_width     *= 0.0254;
            $keepout_width     *= 0.0254;
            $diagl             *= 0.0254;
            $pin1_rad          *= 0.0254;
        }

        #############################################################################################
        # Clear script.
        #############################################################################################
        my ($eagle_script) = "";

        #############################################################################################
        # Set origin of pads.
        #############################################################################################
        my ( $origin_x, $origin_y ) = ( 0, 0 );

        #############################################################################################
        # Create a hash of pads that are knocked out.
        #############################################################################################
        my (%is_knockout);
        foreach my $pad_num (@$knockouts) {
            $is_knockout{$pad_num} = 1;
        }

        #############################################################################################
        # Start the package definition.
        #############################################################################################
        my ($eagle_script) .= "
		Set Wire_Bend 2;
		Grid $units;
		Edit $name.pac;
		Description '<b>$title</b><p>$desc</p>';
		";

        #############################################################################################
 # Compute the lengths of the left/right rows of pads.
 # Also compute the overhang of the chip bounding box past the bbox of the pads.
        #############################################################################################
        my ($pads_y)     = max( 0, $num_pads / 2 - 1 ) * $pad_spacing;
        my ($overhang_y) = ( $chip_y - $pads_y ) / 2.0;

        #############################################################################################
        # Set the pad drill size.
        #############################################################################################
        $eagle_script .= "Change drill $drill_size;\n";

        #############################################################################################
        # Create the left-side column of DIL pads.
        #############################################################################################
        my ($pad_num)    = 1;
        my ($first_flag) = "FIRST";
        my ( $x, $y ) = ( $origin_x, $origin_y );
        my ( $c1x, $c1y, $c2x, $c2y );    # corner points of pad rectangles
        for (
            ;
            $pad_num <= $num_pads / 2 ;
            $pad_num++, $y -= $pad_spacing * $dir_y
          )
        {

            # Create pads only in the populated positions.
            next if $is_knockout{$pad_num};
            my $label = $$relabel{$pad_num};
            !defined $label && ( $label = $pad_num );
            $eagle_script .= "
			  Change Drill $pad_drill
              Pad '$label' $pad_size $pad_shape $first_flag ($x $y);\n
			  ";
            $first_flag = "";

            # Pad outline on document layer.
            $c1x = $x - $pad_size / 2.0 * $dir_x;
            $c2x = $c1x + $pad_size * $dir_x;
            $c1y = $y - $pad_size / 2.0 * $dir_y;
            $c2y = $c1y + $pad_size * $dir_y;
            $eagle_script .= "
			Layer $doc_layer;
			Rect ($c1x $c1y) ($c2x $c2y);
			";

            # keep location of pin 1 so we can mark it later on the silkscreen
            if ( $label eq '1' ) {
                ( $pin1x, $pin1y ) =
                  ( $c1x - ( $pin1_rad + $outline_width ) * $dir_x, $y );
            }
        }

        #############################################################################################
        # Create the right-side column of DIL pads.
        #############################################################################################
        $x = $origin_x + $chip_x * $dir_x;
        $y = $origin_y - ( $num_pads / 2 - 1 ) * $pad_spacing * $dir_y;
        for ( ;
            $pad_num <= $num_pads ; $pad_num++, $y += $pad_spacing * $dir_y )
        {

            # Create pads only in the populated positions.
            next if $is_knockout{$pad_num};
            my $label = $$relabel{$pad_num};
            !defined $label && ( $label = $pad_num );
            $eagle_script .= "
			  Change Drill $pad_drill
              Pad '$label' $pad_size $pad_shape $first_flag ($x $y);\n
			  ";
            $first_flag = "";

            # Pad outline on document layer.
            $c1x = $x - $pad_size / 2.0 * $dir_x;
            $c2x = $c1x + $pad_size * $dir_x;
            $c1y = $y - $pad_size / 2.0 * $dir_y;
            $c2y = $c1y + $pad_size * $dir_y;
            $eagle_script .= "
			Layer $doc_layer;
			Rect ($c1x $c1y) ($c2x $c2y);
			";

            # keep location of pin 1 so we can mark it later on the silkscreen
            if ( $label eq '1' ) {
                ( $pin1x, $pin1y ) =
                  ( $c2x + ( $pin1_rad + $outline_width ) * $dir_x, $y );
            }
        }

        #############################################################################################
        # Create any extra pads in addition to the regular DIL pads.
        #############################################################################################
        foreach my $label ( keys %$extra_pads ) {
            my $extra_pad_size = $$extra_pads{$label}->{pad_size};
            $extra_pad_size = $pad_size if !defined($extra_pad_size);
            my $extra_pad_drill = $$extra_pads{$label}->{pad_drill};
            $extra_pad_drill = $pad_drill if !defined($extra_pad_drill);
            my $center_x    = $chip_x / 2.0;
            my $center_y    = $overhang_y - $chip_y / 2.0;
            my $x           = $center_x + $$extra_pads{$label}->{x};
            my $y           = $center_y + $$extra_pads{$label}->{y};
            my $extra_label = $$relabel{$label};
            $extra_label = $label if !defined($extra_label);
            $eagle_script .= "
			  Change Drill $extra_pad_drill;
              Pad '$extra_label' $extra_pad_size $pad_shape $first_flag ($x $y);\n
			  ";

            # Pad outline on document layer.
            $c1x = $x - $extra_pad_size / 2.0;
            $c2x = $c1x + $extra_pad_size;
            $c1y = $y - $extra_pad_size / 2.0;
            $c2y = $c1y + $extra_pad_size;
            $eagle_script .= "
			Layer $doc_layer;
			Rect ($c1x $c1y) ($c2x $c2y);
			";

            # keep location of pin 1 so we can mark it later on the silkscreen
            if ( $extra_label eq '1' ) {
                if ( $$extra_pads{$label}->{x} < 0 ) {
                    ( $pin1x, $pin1y ) =
                      ( $c1x - ( $pin1_rad + $outline_width ) * $dir_x, $y );
                }
                else {
                    ( $pin1x, $pin1y ) =
                      ( $c2x + ( $pin1_rad + $outline_width ) * $dir_x, $y );
                }
            }
        }

        #############################################################################################
        # Generate the DIL silkscreen outline.
        #############################################################################################
        my ( $name_x, $name_y );
        if ( $num_pads == 0 ) {
            $c1x = $origin_x;
            $c2x = $c1x + $chip_x * $dir_x;
            $c1y = $origin_y + $overhang_y * $dir_y;
            $c2y = $c1y - $chip_y * $dir_y;
            ( $name_x, $name_y ) = ( $c1x, $c1y + $outline_width * $dir_y );
        }
        elsif ( $outline eq 'outside' ) {
            $c1x = $origin_x;
            $c2x = $c1x + $chip_x * $dir_x;
            $c1x -= ( $pad_size / 2.0 + $outline_width ) * $dir_x;
            $c2x += ( $pad_size / 2.0 + $outline_width ) * $dir_x;
            $c1y = $origin_y + $overhang_y * $dir_y;
            $c2y = $c1y - $chip_y * $dir_y;
            ( $name_x, $name_y ) = ( $c1x, $c1y + $outline_width * $dir_y );
        }
        else {
            $c1x = $origin_x;
            $c2x = $c1x + $chip_x * $dir_x;
            $c1x += ( $pad_size / 2.0 + $outline_width ) * $dir_x;
            $c2x -= ( $pad_size / 2.0 + $outline_width ) * $dir_x;
            $c1y = $origin_y + $overhang_y * $dir_y;
            $c2y = $c1y - $chip_y * $dir_y;
        }
        $diagl =
          min( abs( $c1y - $c2y ) / 2.0, abs( $c1x - $c2x ) / 2.0, $diagl );
        my $diagx = $c1x + $diagl * $dir_x;
        my $diagy = $c1y - $diagl * $dir_y;
        $eagle_script .= "
			Layer $outline_layer;
			Wire $outline_width ($c1x $c1y) ($c1x $c2y) ($c2x $c2y) ($c2x $c1y) ($c1x $c1y);
			";
        if ( $outline ne 'outside' ) {
            $eagle_script .= "
			Layer $outline_layer;
			Polygon ($c1x $c1y) ($c1x $diagy) ($diagx $c1y) ($c1x $c1y);
			";
        }
        else {
            $mark_pin1 = 'yes';
        }
        if ( $mark_pin1 eq 'yes' ) {
            my $radx = $pin1x + $pin1_rad;
            $eagle_script .= "
				Layer $outline_layer;
				Circle 0 ($pin1x $pin1y) ($radx $pin1y);
			";
        }

        #############################################################################################
        # Generate the DIL keepout area.
        #############################################################################################
        $c1x = $origin_x;
        $c2x = $origin_x + $chip_x * $dir_x;
        $c1y = $origin_y + $overhang_y * $dir_y;
        $c2y = $c1y - $chip_y * $dir_y;
        $eagle_script .= "
			Layer $keepout_layer;
			Wire $keepout_width ($c1x $c1y) ($c1x $c2y) ($c2x $c2y) ($c2x $c1y) ($c1x $c1y);
			";
        if ( $outline ne 'outside' ) {
            ( $name_x, $name_y ) = ( $c1x, $c1y );
        }

        #############################################################################################
# Generate the placeholder for the device label.
# (c1x,c1y should still hold the location of the keepout box corner near pin 1.)
        #############################################################################################
        $eagle_script .= "
			Layer $name_layer;
			Grid mil;
			Change Size $font_size;
			Grid $units;
			Change Font Proportional;
			Text '>NAME' R0 ($name_x $name_y);
			";

        #############################################################################################
       # Place fiducials at pin 1 corner and the diagonal corner of the package.
        #############################################################################################
        if ($add_fiducials) {
            $c1x = $origin_x;
            $c2x = $c1x + $fiducial_diameter / 2.0 * $dir_x;
            $c1y = $origin_y + ( $pad_size + $fiducial_diameter ) * $dir_y;
            $c2y = $c1y;
            $eagle_script .= "
				Layer 1;
				Circle 0 ($c1x $c1y) ($c2x $c2y);
				";
            $c1x = $c1x + $chip_x * $dir_x;
            $c2x = $c1x + $fiducial_diameter / 2.0 * $dir_x;
            $c1y =
              $origin_y - ( $pads_y + $pad_size + $fiducial_diameter ) * $dir_y;
            $c2y = $c1y;
            $eagle_script .= "
				Circle 0 ($c1x $c1y) ($c2x $c2y);
				";
        }

        #############################################################################################
        # Remove spaces and tabs from script.
        #############################################################################################
        $eagle_script =~ s/^\s+//g;
        $eagle_script =~ s/\s+\n\s+/\n/g;

        #############################################################################################
        # Undefine variables made from passed arguments.
        #############################################################################################
        for ( keys %args ) {
            undef $$_;
        }

        return $eagle_script;
    }

#############################################################################################
    # Create device.
    #	device
    #		name
    #		prefix
    #		title
    #		desc
    #		pckgs
    #	pins
    #		default_name
    #		default_swap_level
    #		default_type
    #		properties
    #		knockouts
#############################################################################################
    sub make_device {
        my (%args) = @_;
        for ( keys %args ) {
            $$_ = $args{$_};
        }

        my ($default_pin_name) = $$pins{default_name};
        !defined($default_pin_name) && ( $default_pin_name = DEFAULT_PIN_NAME );
        my ($default_swap_level) = $$pins{default_swap_level};
        !defined($default_swap_level)
          && ( $default_swap_level = DEFAULT_SWAP_LEVEL );
        my ($default_pin_type) = $$pins{default_type};
        !defined($default_pin_type) && ( $default_pin_type = DEFAULT_PIN_TYPE );
        my ($pin_properties) = $$pins{properties};
        my ($knockouts)      = $$pins{knockouts};

        my ($device_name)   = $$device{name};
        my ($device_prefix) =
          $$device{prefix} ? $$device{prefix} : DVC_DEFAULT_PREFIX;
        my ($device_title) = $$device{title};
        my ($device_desc)  = $$device{desc};
        my ($pckgs)        = $$device{pckgs};

        print STDERR "$device_name\n";

        #############################################################################################
        # Determine the type of package used by the device.
        #############################################################################################
        my ( $is_dil, $is_qfp, $is_bga ) = ( 0, 0, 0 );
        my $num_pins = 0;    # for DIL packages
        my ( $num_pins_x, $num_pins_y ) = ( 0, 0 );    # for QFP packages
        my ( $num_rows,   $num_cols )   = ( 0, 0 );    # for BGA packages
        for (@$pckgs) {
            my %pckg = %$_;
            if ( $pckg{num_pads} > 0 ) {
                $is_dil     = 1;
                $num_pins   = $pckg{num_pads};
                $num_pins_x = 0;
                $num_pins_y = $num_pins / 2;
            }
            elsif ( $pckg{num_pads_x} > 0 || $pckg{num_pads_y} > 0 ) {
                $is_qfp     = 1;
                $num_pins_x = $pckg{num_pads_x};
                $num_pins_y = $pckg{num_pads_y};
            }
            elsif ( $pckg{num_rows} > 0 || $pckg{num_cols} > 0 ) {
                $is_bga   = 1;
                $num_rows = $pckg{num_rows};
                $num_cols = $pckg{num_cols};
            }
        }

        #############################################################################################
        # Predefined parameters.
        #############################################################################################
        my ( $origin_x, $origin_y ) = ( 0, 0 );
        my ($dir_x) = DIR_X;
        my ($dir_y) = DIR_Y;

        #############################################################################################
# Compute the spacing between the gates that are associated with the device pins.
# (The following are always in mils.)
        #############################################################################################
        my ($gate_spacing_x) = DVC_GATE_SPACING_X;
        my ($gate_spacing_y) = DVC_GATE_SPACING_Y;
        my ( $min_part_x, $min_part_y ) = ( $origin_x, $origin_y );
        my ( $max_part_x, $max_part_y ) = ( DVC_MAX_X, DVC_MAX_Y );
        if ( $num_cols * $gate_spacing_x > $max_part_x - $min_part_x ) {
            $gate_spacing_x = ( $max_part_x - $min_part_x ) / $num_cols;
        }
        if ( $num_rows * $gate_spacing_y > $max_part_y - $min_part_y ) {
            $gate_spacing_y = ( $max_part_y - $min_part_y ) / $num_rows;
        }

        #############################################################################################
        # Clear script.
        #############################################################################################
        my ($eagle_script) = "";

        #############################################################################################
        # Pull apart the pin properties into separate arrays.
        #############################################################################################
        my ( %pin_names, %pin_swap_levels, %pin_types, %pin_extras );
        foreach my $pin_num ( keys %$pin_properties ) {
            $pin_names{$pin_num}       = ${ $$pin_properties{$pin_num} }{name};
            $pin_swap_levels{$pin_num} =
              ${ $$pin_properties{$pin_num} }{swap_level};
            $pin_types{$pin_num} = ${ $$pin_properties{$pin_num} }{type};
            $pin_types{$pin_num} =~ tr/a-z/A-Z/;
            $pin_extras{$pin_num} = ${ $$pin_properties{$pin_num} }{extra};
        }

        #############################################################################################
  # Differentiate pins with the same name by adding '@n' to the end of the name.
        #############################################################################################
        my (%name_cnt);
        foreach my $pin_name ( values %pin_names ) {
            $name_cnt{$pin_name}++;
        }
        foreach my $pin_name ( keys %name_cnt ) {
            if ( $name_cnt{$pin_name} == 1 ) {
                $name_cnt{$pin_name} = 0; # Count for unique names becomes zero.
            }
        }
        foreach my $pin_num ( keys %pin_names ) {
            if ( $name_cnt{ $pin_names{$pin_num} } > 0 ) {

# Iterate through pins with the same name appending @1, @2, ... to the pin name.
                $name_cnt{ $pin_names{$pin_num} }--;
                $pin_names{$pin_num} =
                  $pin_names{$pin_num} . '@'
                  . ( $name_cnt{ $pin_names{$pin_num} } + 1 );
            }
        }

        #############################################################################################
        # Create a hash of pins that are knocked out.
        #############################################################################################
        my (%is_knockout);
        if ( $is_dil or $is_qfp ) {
            my (%is_knockout);
            foreach my $pin_num (@$knockouts) {
                $is_knockout{$pin_num} = 1;
            }
        }
        elsif ($is_bga) {
            foreach my $row_lbl ( keys %$knockouts ) {
                foreach my $col_lbl ( @{ $knockouts->{$row_lbl} } ) {
                    $is_knockout{ $row_lbl . $col_lbl } = 1;
                }
            }
        }
        else {
            ;
        }

        #############################################################################################
        # Append a "_" to any BGA pin name that matches a row,col pin id.
        #############################################################################################
        if ($is_bga) {
            foreach my $pin_num ( keys %pin_names ) {
                foreach my $row_id (@bga_row_ids) {
                    if ( $pin_names{$pin_num} =~ /^$row_id/ ) {
                        foreach my $i ( 1 .. $num_cols ) {
                            if ( $pin_names{$pin_num} eq ( $row_id . $i ) ) {
                                $pin_names{$pin_num} .= "_";
                                last;
                            }
                        }
                    }
                }
            }
        }

        #############################################################################################
        # Create the device.
        #############################################################################################
        $eagle_script .= "
		Edit $device_name.dev;
		Grid mil;
		Prefix $device_prefix;
		Description '<b>$device_title</b><p>$device_desc</p>';
		Value Off;
		";

        #############################################################################################
        # Create the name/value gate for the device.
        #############################################################################################
        my ( $pinlength, $gate_pin_spacing ) = ( 1, 100 );
        my $x = DVC_GATE_SPACING_X * $dir_x;
        my $y = 3 * DVC_GATE_SPACING_Y * $dir_y;
        $eagle_script .= "Add PV_GATE 'PART' Must 0 ($x $y);\n";
#        $eagle_script .= "Add PV_GATE 'PART_VALUE' Must 0 ($x $y);\n";

        #############################################################################################
        # Create a gate for each pin of a QFP or DIL device.
        #############################################################################################
        ( $x, $y ) = ( $origin_x, $origin_y );
        for (
            my $pin_num = 1 ;
            $pin_num <= 2 * ( $num_pins_x + $num_pins_y ) ;
            $pin_num++
          )
        {
            if ( !defined $is_knockout{$pin_num} ) {
                my $swap_level = $default_swap_level;
                if ( defined $pin_swap_levels{$pin_num} ) {
                    $swap_level = $pin_swap_levels{$pin_num};
                }
                my $pin_type = $default_pin_type;
                if ( defined $pin_types{$pin_num} ) {
                    $pin_type = $pin_types{$pin_num};
                }
                if ( defined $pin_names{$pin_num} ) {
                    $eagle_script .=
"Add $pin_gates{$pin_type} '$pin_names{$pin_num}' Always $swap_level ($x $y);\n";
                }
                else {
                    $eagle_script .=
"Add $pin_gates{$pin_type} '$default_pin_name\@$pin_num' Always $swap_level ($x $y);\n";
                }
            }
            $y -= $gate_spacing_y * $dir_y;
            if (   $pin_num == $num_pins_y
                || $pin_num == ( $num_pins_y + $num_pins_x )
                || $pin_num == ( 2 * $num_pins_y + $num_pins_x ) )
            {
                $x += $gate_spacing_x * $dir_x;
                $y = $origin_y;
            }
        }

        #############################################################################################
        # Create a gate for each pin of the BGA device.
        #############################################################################################
        $y = $origin_y;
        for ( my $row = 0 ; $row < $num_rows ; $row++ ) {
            $row_id = $bga_row_ids[$row];
            $x      = $origin_x;
            for ( my $col = 1 ; $col <= $num_cols ; $col++ ) {
                my $pin_id = $row_id . $col;
                if ( !defined $is_knockout{$pin_id} ) {
                    my $swap_level = $default_swap_level;
                    if ( defined $pin_swap_levels{$pin_id} ) {
                        $swap_level = $pin_swap_levels{$pin_id};
                    }
                    my $pin_type = $default_pin_type;
                    if ( defined $pin_types{$pin_num} ) {
                        $pin_type = $pin_types{$pin_num};
                    }
                    if ( defined $pin_names{$pin_id} ) {
                        $eagle_script .=
"Add $pin_gates{$pin_type} '$pin_names{$pin_id}' Always $swap_level ($x $y);\n";
                    }
                    else {
                        $eagle_script .=
"Add $pin_gates{$pin_type} '$default_pin_name\@$pin_id' Always $swap_level ($x $y);\n";
                    }
                }
                $x += $gate_spacing_x * $dir_x;
            }
            $y -= $gate_spacing_y * $dir_y;
        }

        #############################################################################################
        # Create a gate for each extra pin of the device.
        #############################################################################################
        $x = $origin_x - $gate_spacing_x * $dir_x;
        $y = $origin_y;
        foreach my $pin_num ( keys %pin_extras ) {
            next if !defined $pin_extras{$pin_num};
            if ( !defined $is_knockout{$pin_num} ) {
                my $swap_level = $default_swap_level;
                if ( defined $pin_swap_levels{$pin_num} ) {
                    $swap_level = $pin_swap_levels{$pin_num};
                }
                my $pin_type = $default_pin_type;
                if ( defined $pin_types{$pin_num} ) {
                    $pin_type = $pin_types{$pin_num};
                }
                if ( defined $pin_names{$pin_num} ) {
                    $eagle_script .=
"Add $pin_gates{$pin_type} '$pin_names{$pin_num}' Always $swap_level ($x $y);\n";
                }
                else {
                    $eagle_script .=
"Add $pin_gates{$pin_type} '$default_pin_name\@$pin_num' Always $swap_level ($x $y);\n";
                }
            }
            $y -= $gate_spacing_y * $dir_y;
        }

        #############################################################################################
        # Connect the device pins to the package pins.
        #############################################################################################
        for (@$pckgs) {
            my %pckg = %$_;
            $eagle_script .= "
		Package '$pckg{name}' '$pckg{variant}';
		Technology  '';
		";

            if ( defined $pckg{num_pins} ) {

                # DIL package
                $num_pins_x = 0;
                $num_pins_y = $pckg{num_pads} / 2;
                $num_rows   = 0;
                $num_cols   = 0;
            }
            elsif ( defined $pckg{num_pads_x} ) {

                # QFP package
                $num_pins_x = $pckg{num_pads_x};
                $num_pins_y = $pckg{num_pads_y};
                $num_rows   = 0;
                $num_cols   = 0;
            }
            elsif ( defined $pckg{num_rows} ) {

                # BGA package
                $num_pins_x = 0;
                $num_pins_y = 0;
                $num_rows   = $pckg{num_rows};
                $num_cols   = $pckg{num_cols};
            }
            else {

                # unknown package (do nothing)
                $num_pins_x = 0;
                $num_pins_y = 0;
                $num_rows   = 0;
                $num_cols   = 0;
            }
			my $pin_name_prefix = $pckg{pin_name_prefix};

            # Connect a single gate to each pin of the QFP, DIL or BGA package.
            foreach my $pin_num ( keys %pin_names ) {
                next if defined $is_knockout{$pin_num};
				my $pin_label = $pckg{pin_name_prefix} . $pin_num;
                if ( defined $pin_names{$pin_num} ) {
                    $eagle_script .=
                      "Connect '$pin_names{$pin_num}.1' '$pin_label';\n";
                }
                else {
                    $eagle_script .=
                      "Connect '$default_pin_name\@$pin_num.1' '$pin_label';\n";
                }
            }
        }

        #############################################################################################
        # Remove spaces and tabs from script.
        #############################################################################################
        $eagle_script =~ s/^\s+//g;
        $eagle_script =~ s/\s+\n\s+/\n/g;

        #############################################################################################
        # Undefine variables made from passed arguments.
        #############################################################################################
        for ( keys %args ) {
            undef $$_;
        }

        return $eagle_script;
    }

}    # End of scope for static variables.

1;

