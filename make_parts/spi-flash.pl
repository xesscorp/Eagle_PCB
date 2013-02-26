use make_eagle_lib;
use gen_xil_pin_list;

print make_symbols();

print make_qfp_pckg(
    name           => 'SPI-8_SOIC_150',
    title          => '8-Lead 150-Mil Plastic Small Outline Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.51,
    pad_width      => 0.51,
    contact_length => 1.27,
    front_porch    => 0.4,
    back_porch     => 0.4,
    pad_spacing    => 1.27,
    num_pads_y     => 4,
    num_pads_x     => 0,
    chip_x         => 6.2,
    chip_y         => 5.0,
);

print make_qfp_pckg(
    name           => 'SPI-8_SOIC_208',
    title          => '8-Lead 208-Mil Plastic Small Outline Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.51,
    pad_width      => 0.51,
    contact_length => 0.8,
    front_porch    => 0.4,
    back_porch     => 0.2,
    pad_spacing    => 1.27,
    num_pads_y     => 4,
    num_pads_x     => 0,
    chip_x         => 7.9,
    chip_y         => 5.3,
);

print make_qfp_pckg(
    name           => 'SPI-8_SOIC_150_208',
    title          => '8-Lead 150/208-Mil Plastic Small Outline Package',
    desc           => 'Compatible with both 150 and 208 mil chips.',
    units          => mm,
    contact_width  => 0.51,
    pad_width      => 0.51,
    contact_length => 0.001,
    front_porch    => 0.4,
    back_porch     => 2.52,
    pad_spacing    => 1.27,
    num_pads_y     => 4,
    num_pads_x     => 0,
    chip_x         => 7.9,
    chip_y         => 5.3,
);

%device = (
    name  => 'SPI_FLASH',
    title =>
      'SPI Flash',
    desc  => '',
    pckgs => [
        {
            name       => 'SPI-8_SOIC_150',
            variant    => '-SOIC_150',
            num_pads_x => 0,
            num_pads_y => 4
        },
        {
            name       => 'SPI-8_SOIC_208',
            variant    => '-SOIC_208',
            num_pads_x => 0,
            num_pads_y => 4
        },
        {
            name       => 'SPI-8_SOIC_150_208',
            variant    => '-SOIC_150_208',
            num_pads_x => 0,
            num_pads_y => 4
        },
    ],
);
%pins = (
    default_name       => '',
    default_swap_level => 0,
    properties         => {
        1 => { name => 'CS#',   type => IN  },
        2 => { name => 'DO',    type => OUT },
        3 => { name => 'WP#',   type => IN  },
        4 => { name => 'GND',   type => IN  },
        5 => { name => 'DI',    type => IN  },
        6 => { name => 'CLK',   type => IN  },
        7 => { name => 'HOLD#', type => IN  },
        8 => { name => 'VCC',   type => IN  },
    }
);
print make_device( device => \%device, pins => \%pins );
