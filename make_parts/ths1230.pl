use make_eagle_lib;

print make_symbols();

print make_qfp_pckg(
    name           => 'TI-SOIC28',
    title          => 'TI SOIC-28',
    desc           => '',
    units          => mil,
    contact_width  => 20,
    pad_width      => 20,
    contact_length => 50,
    front_porch    => 20,
    back_porch     => 20,
    pad_spacing    => 50,
    num_pads_y     => 14,
    num_pads_x     => 0,
    chip_x         => 419,
    chip_y         => 713,
    add_fiducials  => 0,
);

print make_qfp_pckg(
    name           => 'TI-TSSOP28',
    title          => 'TI TSSOP-28',
    desc           => '',
    units          => mm,
    contact_width  => 0.3,
    pad_width      => 0.3,
    contact_length => 0.75,
    front_porch    => 0.2,
    back_porch     => 0.2,
    pad_spacing    => 0.65,
    num_pads_y     => 14,
    num_pads_x     => 0,
    chip_x         => 6.6,
    chip_y         => 9.8,
    add_fiducials  => 0,
);


%pins = (
    default_swap_level => 0,
    properties         => {
        1  => { name => AGND,   type => IN },
        2  => { name => CON1,   type => IN },
        3  => { name => CON0,   type => IN },
        4  => { name => EXTREF, type => IN },
        5  => { name => 'AIN+', type => IN },
        6  => { name => 'AIN-', type => IN },
        7  => { name => AGND,   type => IN },
        8  => { name => AVDD,   type => IN },
        9  => { name => REFT,   type => IO },
        10 => { name => REFB,   type => IO },
        11 => { name => OVRNG,  type => HIZ },
        12 => { name => D11,    type => HIZ },
        13 => { name => D10,    type => HIZ },
        14 => { name => D9,     type => HIZ },
        15 => { name => D8,     type => HIZ },
        16 => { name => D7,     type => HIZ },
        17 => { name => D6,     type => HIZ },
        18 => { name => D5,     type => HIZ },
        19 => { name => DGND,   type => IN },
        20 => { name => DVDD,   type => IN },
        21 => { name => D4,     type => HIZ },
        22 => { name => D3,     type => HIZ },
        23 => { name => D2,     type => HIZ },
        24 => { name => D1,     type => HIZ },
        25 => { name => D0,     type => HIZ },
        26 => { name => 'OE#',  type => IN },
        27 => { name => AVDD,   type => IN },
        28 => { name => CLK,    type => IN },
    }
);

%device = (
    name  => 'THS1230',
    title => 'TI 12-bit, 30 MSPS ADC',
    desc  => '',
    pckgs => [
        {
            name       => 'TI-SOIC28',
            variant    => 'SOIC28',
            num_pads_x => 0,
            num_pads_y => 14
        },
        {
            name       => 'TI-TSSOP28',
            variant    => 'TSSOP28',
            num_pads_x => 0,
            num_pads_y => 14
        },
    ],
);
print make_device( device => \%device, pins => \%pins );

%device = (
    name  => 'THS1215',
    title => 'TI 12-bit, 15 MSPS ADC',
    desc  => '',
    pckgs => [
        {
            name       => 'TI-SOIC28',
            variant    => 'SOIC28',
            num_pads_x => 0,
            num_pads_y => 14
        },
        {
            name       => 'TI-TSSOP28',
            variant    => 'TSSOP28',
            num_pads_x => 0,
            num_pads_y => 14
        },
    ],
);
print make_device( device => \%device, pins => \%pins );
