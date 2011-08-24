
use make_eagle_lib;

print make_symbols();

print make_qfp_pckg(
        name         => 'TSOPII-54',
        title        => 'TSOPII-54',
        desc         => '54-lead TSOP II 400 mil wide package.',
        units        => mm,
        b            => 0.45,
        L            => 0.6,
        fp           => 0.3,
        bp           => 0.3,
        e            => 0.8,
        N            => 54,
        D            => 22.35,
        E            => 11.96,
        do_fiducials => 0,
);

%pins = (
    default_name       => "",
    default_swap_level => 0,
    properties         => {
        1  => { name => VDD,      swap_level => 0, type => IN },
        2  => { name => DQ0,      swap_level => 3, type => INOUT },
        3  => { name => VDDQ,     swap_level => 0, type => IN },
        4  => { name => DQ1,      swap_level => 3, type => INOUT },
        5  => { name => DQ2,      swap_level => 3, type => INOUT },
        6  => { name => VSSQ,     swap_level => 0, type => IN },
        7  => { name => DQ3,      swap_level => 3, type => INOUT },
        8  => { name => DQ4,      swap_level => 3, type => INOUT },
        9  => { name => VDDQ,     swap_level => 0, type => IN },
        10 => { name => DQ5,      swap_level => 3, type => INOUT },
        11 => { name => DQ6,      swap_level => 3, type => INOUT },
        12 => { name => VSSQ,     swap_level => 0, type => IN },
        13 => { name => DQ7,      swap_level => 3, type => INOUT },
        14 => { name => VDD,      swap_level => 0, type => IN },
        15 => { name => LDQM,     swap_level => 0, type => IN },
        16 => { name => "WE#",    swap_level => 0, type => IN },
        17 => { name => "CAS#",   swap_level => 0, type => IN },
        18 => { name => "RAS#",   swap_level => 0, type => IN },
        19 => { name => "CS#",    swap_level => 0, type => IN },
        20 => { name => BS0,      swap_level => 2, type => IN },
        21 => { name => BS1,      swap_level => 2, type => IN },
        22 => { name => "A10/AP", swap_level => 1, type => IN },
        23 => { name => A0,       swap_level => 1, type => IN },
        24 => { name => A1,       swap_level => 1, type => IN },
        25 => { name => A2,       swap_level => 1, type => IN },
        26 => { name => A3,       swap_level => 1, type => IN },
        27 => { name => VDD,      swap_level => 0, type => IN },
        28 => { name => VSS,      swap_level => 0, type => IN },
        29 => { name => A4,       swap_level => 1, type => IN },
        30 => { name => A5,       swap_level => 1, type => IN },
        31 => { name => A6,       swap_level => 1, type => IN },
        32 => { name => A7,       swap_level => 1, type => IN },
        33 => { name => A8,       swap_level => 1, type => IN },
        34 => { name => A9,       swap_level => 1, type => IN },
        35 => { name => A11,      swap_level => 1, type => IN },
        36 => { name => NC,       swap_level => 0, type => NC },
        37 => { name => CKE,      swap_level => 0, type => IN },
        38 => { name => CLK,      swap_level => 0, type => IN },
        39 => { name => UDQM,     swap_level => 0, type => IN },
        40 => { name => NC,       swap_level => 0, type => NC },
        41 => { name => VSS,      swap_level => 0, type => IN },
        42 => { name => DQ8,      swap_level => 3, type => INOUT },
        43 => { name => VDDQ,     swap_level => 0, type => IN },
        44 => { name => DQ9,      swap_level => 3, type => INOUT },
        45 => { name => DQ10,     swap_level => 3, type => INOUT },
        46 => { name => VSSQ,     swap_level => 0, type => IN },
        47 => { name => DQ11,     swap_level => 3, type => INOUT },
        48 => { name => DQ12,     swap_level => 3, type => INOUT },
        49 => { name => VDDQ,     swap_level => 0, type => IN },
        50 => { name => DQ13,     swap_level => 3, type => INOUT },
        51 => { name => DQ14,     swap_level => 3, type => INOUT },
        52 => { name => VSSQ,     swap_level => 0, type => IN },
        53 => { name => DQ15,     swap_level => 3, type => INOUT },
        54 => { name => VSS,      swap_level => 0, type => IN }
    }
);

%device = (
    name  => 'W9812G6JH',
    title => '8M x 16 SDRAM',
    desc  => '128Mb synchronous DRAM.',
    pckgs => [
        {
            name       => 'TSOPII-54',
            variant    => '',
            num_pads_y => 27,
            num_pads_x => 0
        },
    ],
);
print make_device( device => \%device, pins => \%pins );

%device = (
    name  => 'W9864G6JH',
    title => '4M x 16 SDRAM',
    desc  => '64Mb synchronous DRAM.',
    pckgs => [
        {
            name       => 'TSOPII-54',
            variant    => '',
            num_pads_y => 27,
            num_pads_x => 0
        },
    ],
);
print make_device( device => \%device, pins => \%pins );
