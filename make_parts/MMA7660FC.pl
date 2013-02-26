use make_eagle_lib;

print make_symbols();

print make_qfp_pckg(
    name           => 'Freescale-10_DFN',
    title          => 'Freescale 10-pad DFN',
    desc           => '',
    units          => mm,
    contact_width  => 0.3,
    pad_width      => 0.3,
    contact_length => 0.4125,
    front_porch    => 1.4125,
    back_porch     => 0,
    pad_spacing    => 0.5,
    num_pads_y     => 0,
    num_pads_x     => 5,
    chip_x         => 3,
    chip_y         => 2.48,
    outline        => outside,
);

print make_qfp_pckg(
    name           => 'Freescale-14_LGA',
    title          => 'Freescale 14-pad LGA',
    desc           => '',
    units          => mm,
    contact_width  => 0.5,
    pad_width      => 0.5,
    contact_length => 0.9,
    front_porch    => 1.0,
    back_porch     => 0,
    pad_spacing    => 0.8,
    num_pads_y     => 6,
    num_pads_x     => 1,
    chip_x         => 3,
    chip_y         => 5,
    outline        => outside,
);


%device = (
    name  => 'MMA7660FC',
    title => 'Freescale MMA7660FC',
    desc  => 'Freescale 3-axis orientation/motion sensor.',
    pckgs => [
        {
            name       => 'Freescale-10_DFN',
            variant    => '-DFN-10',
            num_pads_x => 5,
            num_pads_y => 0
        },
    ],
);
%pins = (
    default_swap_level => 0,
    properties         => {
        1  => { name => 'AVSS', type => IN },
        2  => { name => 'NC',   type => NC },
        3  => { name => 'AVDD', type => IN },
        4  => { name => 'AVSS', type => IN },
        5  => { name => 'INT#', type => IN },
        6  => { name => 'SCL',  type => IN },
        7  => { name => 'SDA',  type => IN },
        8  => { name => 'DVSS', type => IN },
        9  => { name => 'DVDD', type => IN },
        10 => { name => 'NC',   type => NC },
    }
);
print make_device( device => \%device, pins => \%pins );

%device = (
    name  => 'MMA7455L',
    title => 'Freescale MMA7455L',
    desc  => 'Freescale 3-axis low-g digital output accelerometer.',
    pckgs => [
        {
            name       => 'Freescale-14_LGA',
            variant    => '-LGA-14',
            num_pads_x => 1,
            num_pads_y => 6
        },
    ],
);
%pins = (
    default_swap_level => 0,
    properties         => {
        1  => { name => 'DVDD_IO',   type => IN },
        2  => { name => 'GND',       type => IN },
        3  => { name => 'NC',        type => NC },
        4  => { name => 'IADDR0',    type => IN },
        5  => { name => 'GND',       type => IN },
        6  => { name => 'AVDD',      type => IN },
        7  => { name => 'CS#',       type => IN },
        8  => { name => 'INT1/DRDY', type => OUT },
        9  => { name => 'INT2',      type => OUT },
        10 => { name => 'NC',        type => NC },
        11 => { name => 'NC',        type => NC },
        12 => { name => 'SDO',       type => OUT },
        13 => { name => 'SDI',       type => IN },
        14 => { name => 'SCL',       type => IN },
    }
);
print make_device( device => \%device, pins => \%pins );
