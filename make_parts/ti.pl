use make_eagle_lib;
use gen_xil_pin_list;

#print make_symbols();

print make_qfp_pckg(
    name           => 'TI-R-PDSO-G6-DBV',
    title          => '6-Lead Plastic Small-Outline Package',
    desc           => '',
    units          => 'mm',
    pad_width      => 0.6,
    contact_width  => 0.6,
    contact_length => 1.05,
    front_porch    => 0,
    back_porch     => 0,
    pad_spacing    => 0.95,
    num_pads_x     => 0,
    num_pads_y     => 3,
    chip_x         => 3.7,
    chip_y         => 3.05,
);

print make_qfp_pckg(
    name           => 'TI-R-PDSO-G6-DCK',
    title          => '6-Lead Plastic Small-Outline Package',
    desc           => '',
    units          => 'mm',
    pad_width      => 0.4,
    contact_width  => 0.4,
    contact_length => 1.0,
    front_porch    => 0,
    back_porch     => 0,
    pad_spacing    => 0.65,
    num_pads_x     => 0,
    num_pads_y     => 3,
    chip_x         => 3.2,
    chip_y         => 2.15,
);

print make_qfp_pckg(
    name           => 'TI-R-PDSO-N6-DRL',
    title          => '6-Lead Plastic Small-Outline Package',
    desc           => '',
    units          => 'mm',
    pad_width      => 0.3,
    contact_width  => 0.3,
    contact_length => 0.45,
    front_porch    => 0,
    back_porch     => 0,
    pad_spacing    => 0.50,
    num_pads_x     => 0,
    num_pads_y     => 3,
    chip_x         => 1.8,
    chip_y         => 1.7,
);

%device = (
    name  => 'SN74LVC1T45',
    title =>
'TI Single-Bit Dual-Supply Bus Transceiver with Configurable Voltage Translation and 3-State Outputs',
    desc  => '',
    pckgs => [
        {
            name       => 'TI-R-PDSO-G6-DBV',
            variant    => '-DBV',
            num_pads_x => 0,
            num_pads_y => 3
        },
        {
            name       => 'TI-R-PDSO-G6-DCK',
            variant    => '-DCK',
            num_pads_x => 0,
            num_pads_y => 3
        },
        {
            name       => 'TI-R-PDSO-N6-DRL',
            variant    => '-DRL',
            num_pads_x => 0,
            num_pads_y => 3
        },
    ],
);
%pins = (
    default_name       => '',
    default_swap_level => 0,
    properties         => {
        1 => { name => 'VCCA', type => IN },
        2 => { name => 'GND',  type => IN },
        3 => { name => 'A',    type => INOUT },
        4 => { name => 'B',    type => INOUT },
        5 => { name => 'DIR',  type => IN },
        6 => { name => 'VCCB', type => IN },
    }
);
print make_device( device => \%device, pins => \%pins );
