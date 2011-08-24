use make_eagle_lib;
use gen_xil_pin_list;

#print make_symbols();

print make_qfp_pckg(
	name => 'TI-TSSOP48',
	title => '48-pin plastic small outline package',
	desc => '',
	units => 'mm',
	pad_width => 0.22,
	contact_width => 0.22,
	contact_length => 0.8,
	front_porch => 0.4,
	back_porch => 0.4,
	pad_spacing => 0.5,
	num_pads_x => 0,
	num_pads_y => 24,
	chip_x => 8.3,
	chip_y => 12.6,
);

%device = (
    name  => '74LVCH16T245',
    title =>
'16-Bit Dual-Supply Bus Transceiver with Configurable Voltage Translation and 3-State Outputs',
    desc  => '',
    pckgs => [
        {
            name       => 'TI-TSSOP48',
            variant    => '-DGG',
            num_pads_x => 0,
            num_pads_y => 24
        },
    ],
);
%pins = (
    default_name       => '',
    default_swap_level => 0,
    properties         => {
        1 => { name => '1DIR', type => IN },
        2 => { name => '1B0',  type => INOUT, swap_level => 1 },
        3 => { name => '1B1',  type => INOUT, swap_level => 1 },
        4 => { name => 'GND',  type => IN },
        5 => { name => '1B2',  type => INOUT, swap_level => 1 },
        6 => { name => '1B3',  type => INOUT, swap_level => 1 },
        7 => { name => 'VCCB',  type => IN },
        8 => { name => '1B4',  type => INOUT, swap_level => 1 },
        9 => { name => '1B5',  type => INOUT, swap_level => 1 },
        10 => { name => 'GND',  type => IN },
        11 => { name => '1B6',  type => INOUT, swap_level => 1 },
        12 => { name => '1B7',  type => INOUT, swap_level => 1 },
        13 => { name => '2B0',  type => INOUT, swap_level => 2 },
        14 => { name => '2B1',  type => INOUT, swap_level => 2 },
        15 => { name => 'GND',  type => IN },
        16 => { name => '2B2',  type => INOUT, swap_level => 2 },
        17 => { name => '2B3',  type => INOUT, swap_level => 2 },
        18 => { name => 'VCCB',  type => IN },
        19 => { name => '2B4',  type => INOUT, swap_level => 2 },
        20 => { name => '2B5',  type => INOUT, swap_level => 2 },
        21 => { name => 'GND',  type => IN },
        22 => { name => '2B6',  type => INOUT, swap_level => 2 },
        23 => { name => '2B7',  type => INOUT, swap_level => 2 },
        24 => { name => '2DIR', type => IN },
        25 => { name => '2OE#', type => IN },
        26 => { name => '2A7',  type => INOUT, swap_level => 3 },
        27 => { name => '2A6',  type => INOUT, swap_level => 3 },
        28 => { name => 'GND',  type => IN },
        29 => { name => '2A5',  type => INOUT, swap_level => 3 },
        30 => { name => '2A4',  type => INOUT, swap_level => 3 },
        31 => { name => 'VCCA',  type => IN },
        32 => { name => '2A3',  type => INOUT, swap_level => 3 },
        33 => { name => '2A2',  type => INOUT, swap_level => 3 },
        34 => { name => 'GND',  type => IN },
        35 => { name => '2A1',  type => INOUT, swap_level => 3 },
        36 => { name => '2A0',  type => INOUT, swap_level => 3 },
        37 => { name => '1A7',  type => INOUT, swap_level => 4 },
        38 => { name => '1A6',  type => INOUT, swap_level => 4 },
        39 => { name => 'GND',  type => IN },
        40 => { name => '1A5',  type => INOUT, swap_level => 4 },
        41 => { name => '1A4',  type => INOUT, swap_level => 4 },
        42 => { name => 'VCCA',  type => IN },
        43 => { name => '1A3',  type => INOUT, swap_level => 4 },
        44 => { name => '1A2',  type => INOUT, swap_level => 4 },
        45 => { name => 'GND',  type => IN },
        46 => { name => '1A1',  type => INOUT, swap_level => 4 },
        47 => { name => '1A0',  type => INOUT, swap_level => 4 },
        48 => { name => '1OE#', type => IN },
    }
);
print make_device( device => \%device, pins => \%pins );
