use make_eagle_lib;

print make_symbols();

print make_qfp_pckg(
    name           => 'Microchip-44_PQFP',
    title          => 'Microchip 44-lead plastic flat pack',
    desc           => '',
    units          => mm,
    contact_width  => 0.45,
    pad_width      => 0.45,
    contact_length => 0.75,
    front_porch    => 1,
    back_porch     => 0,
    pad_spacing    => 0.8,
    num_pads_y     => 11,
    num_pads_x     => 11,
    chip_x         => 12,
    chip_y         => 12,
);

%device = (
    name  => 'PIC32MX250F128D',
    title => 'Microchip PIC32MX250F128D',
    desc  => 'Microchip PIC32MX250F128D',
    pckgs => [
        {
            name       => 'Microchip-44_PQFP',
            variant    => 'PQFP44',
            num_pads_x => 11,
            num_pads_y => 11
        },
    ],
);
%pins = (
    default_swap_level => 0,
    properties         => {
        1  => { name => 'RPB9/SDA1',   type => IO },
        2  => { name => 'RPC6',   type => IO },
        3  => { name => 'RPC7',   type => IO },
        4  => { name => 'RPC8', type => IO },
        5  => { name => 'RPC9', type => IO },
        6  => { name => 'VSS', type => IN },
        7  => { name => 'VCAP',   type => IN },
        8  => { name => 'RPB10/D+',   type => IO },
        9  => { name => 'RPB11/D-',   type => IO },
        10 => { name => 'VUSB3V3',   type => IN },
        11 => { name => 'RPB13/AN11',  type => IO  },
        12 => { name => 'PGED/TMS/RA10',    type => IO  },
        13 => { name => 'PGEC/TCK/RA7',    type => IO  },
        14 => { name => 'RPB14/SCK1/AN10',     type => IO  },
        15 => { name => 'RPB15/SCK2/AN9',     type => IO  },
        16 => { name => 'AVSS',     type => IN  },
        17 => { name => 'AVDD',     type => IN  },
        18 => { name => 'MCLR#',     type => IN  },
        19 => { name => 'RPA0/AN0',   type => IO },
        20 => { name => 'RPA1/AN1',   type => IO },
        21 => { name => 'RPB0/AN2',   type => IO  },
        22 => { name => 'RPB1/AN3',     type => IO  },
        23 => { name => 'RPB2/AN4',     type => IO  },
        24 => { name => 'RPB3/AN5',     type => IO  },
        25 => { name => 'RPC0/AN6',     type => IO  },
        26 => { name => 'RPC1/AN7',  type => IO },
        27 => { name => 'RPC2/AN8',   type => IO },
        28 => { name => 'VDD',    type => IN },
        29 => { name => 'VSS',    type => IN },
        30 => { name => 'OSC1/CLKI/RPA2',    type => IO },
        31 => { name => 'OSC2/CLKO/RPA3',    type => IO },
        32 => { name => 'RPA8/TDO',    type => IO },
        33 => { name => 'RPB4',    type => IO },
        34 => { name => 'RPA4',    type => IO },
        35 => { name => 'RPA9/TDI',    type => IO },
        36 => { name => 'RPC3/AN12',    type => IO },
        37 => { name => 'RPC4',    type => IO },
        38 => { name => 'RPC5',    type => IO },
        39 => { name => 'VSS',    type => IN },
        40 => { name => 'VDD',    type => IN },
        41 => { name => 'RPB5/USBID',    type => IO },
        42 => { name => 'VBUS',    type => IN },
        43 => { name => 'RPB7/INT0',    type => IO },
        44 => { name => 'RPB8/SCL1',    type => IO },
    }
);
print make_device( device => \%device, pins => \%pins );
