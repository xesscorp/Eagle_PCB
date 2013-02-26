use make_eagle_lib;

print make_symbols();

print make_qfp_pckg(
    name           => 'Xilinx-QFG48',
    title          => 'Xilinx QFG 48',
    desc           => '',
    units          => mm,
    contact_width  => 0.40,
    pad_width      => 0.30,
    contact_length => 0.40,
    front_porch    => 0.20,
    back_porch     => 0.05,
    pad_spacing    => 0.50,
    num_pads_y     => 12,
    num_pads_x     => 12,
    chip_x         => 7.0,
    chip_y         => 7.0,
    extra_pads => {HS=>{x=>0, y=>0, h=>4.7, l=>4.7, use_copper=>yes}},
);


%device = (
    name  => 'XC2C64A',
    title =>
      'Xilinx Coolrunner-II 64-Macrocell CPLD',
    desc  => '',
    pckgs => [
        {
            name       => 'Xilinx-QFG48',
            variant    => '-I/SO',
            num_pads_x => 12,
            num_pads_y => 12
        },
    ],
);
%pins = (
    default_name       => 'IO',
    default_type       => 'INOUT',
    default_swap_level => 1,
    properties         => {
        23 => { name => 'TCK',              type => IN, swap => 0 },
        21 => { name => 'TDI',              type => IN, swap => 0 },
        40 => { name => 'TDO',              type => OUT, swap => 0 },
        22 => { name => 'TMS',              type => IN, swap => 0 },
         3 => { name => 'VCCAUX',           type => IN, swap => 0 },
        29 => { name => 'VCC',              type => IN, swap => 0 },
        19 => { name => 'VCCIO1',           type => IN, swap => 0 },
        42 => { name => 'VCCIO2',           type => IN, swap => 0 },
        16 => { name => 'GND',              type => IN, swap => 0 },
        31 => { name => 'GND',              type => IN, swap => 0 },
        41 => { name => 'GND',              type => IN, swap => 0 },
    }
);
print make_device( device => \%device, pins => \%pins );
