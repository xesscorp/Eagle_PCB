use make_eagle_lib;

print make_symbols();

print make_qfp_pckg(
    name           => 'Microchip-28_SOIC',
    title          => 'Microchip 28-lead SOIC',
    desc           => '',
    units          => mm,
    contact_width  => 0.6,
    pad_width      => 0.6,
    contact_length => 1,
    front_porch    => 1,
    back_porch     => 0,
    pad_spacing    => 1.27,
    num_pads_y     => 14,
    num_pads_x     => 0,
    chip_x         => 9.4,
    chip_y         => 17.9,
);

print make_qfp_pckg(
    name           => 'Microchip-28_SSOP',
    title          => 'Microchip 28-lead SSOP',
    desc           => '',
    units          => mm,
    contact_width  => 0.45,
    pad_width      => 0.45,
    contact_length => 1.75/2.0,
    front_porch    => 1.75/2.0,
    back_porch     => 0,
    pad_spacing    => 0.65,
    num_pads_y     => 14,
    num_pads_x     => 0,
    chip_x         => 7.2,
    chip_y         => 10.5,
);


%device = (
    name  => 'PIC18F27J53',
    title => 'Microchip PIC18F27J53',
    desc  => 'Microchip PIC18F27J53',
    pckgs => [
        {
            name       => 'Microchip-28_SOIC',
            variant    => 'SOIC28',
            num_pads_x => 0,
            num_pads_y => 14
        },
        {
            name       => 'Microchip-28_SSOP',
            variant    => 'TSSOP28',
            num_pads_x => 0,
            num_pads_y => 14
        },
    ],
);
%pins = (
    default_swap_level => 0,
    properties         => {
        1  => { name => 'MCLR#',   type => IN },
        2  => { name => 'RA0/AN0/C1INA/ULPWU/RP0',   type => IO },
        3  => { name => 'RA1/AN1/C2INA/VBG/RP1',   type => IO },
        4  => { name => 'RA2/AN2/C2INB/C1IND/C3INB/VREF-/CVREF', type => IO },
        5  => { name => 'RA3/AN3/C1INB/VREF+', type => IO },
        6  => { name => 'VDDCORE/VCAP', type => OUT },
        7  => { name => 'RA5/AN4/C1INC/SS1/HLVDIN/RCV/RP2',   type => IO },
        8  => { name => 'VSS1',   type => IN },
        9  => { name => 'OSC1/CLKI/RA7',   type => IO },
        10 => { name => 'OSC2/CLKO/RA6',   type => IO },
        11 => { name => 'RC0/T1OSO/T1CKI/RP11',  type => IO  },
        12 => { name => 'RC1/CCP8/T1OSI/UOE/RP12',    type => IO  },
        13 => { name => 'RC2/AN11/C2IND/CTPLS/RP13',    type => IO  },
        14 => { name => 'VUSB',     type => IN  },
        15 => { name => 'RC4/D-/VM',     type => IO  },
        16 => { name => 'RC5/D+/VP',     type => IO  },
        17 => { name => 'RC6/CCP9/TX1/CK1/RP17',     type => IO  },
        18 => { name => 'RC7/CCP10/RX1/DT1/SDO1/RP18',     type => IO  },
        19 => { name => 'VSS2',   type => IN },
        20 => { name => 'VDD',   type => IN },
        21 => { name => 'RB0/AN12/C3IND/INT0/RP3',     type => IO  },
        22 => { name => 'RB1/AN10/C3INC/RTCC/RP4',     type => IO  },
        23 => { name => 'RB2/AN8/C2INC/CTED1/VMO/REFO/RP5',     type => IO  },
        24 => { name => 'RB3/AN9/C3INA/CTED2/VPO/RP6',     type => IO  },
        25 => { name => 'RB4/CCP4/KBI0/SCK1/SCL1/RP7',     type => IO  },
        26 => { name => 'RB5/CCP5/KBI1/SDI1/SDA1/RP8',  type => IO },
        27 => { name => 'RB6/CCP6/KBI2/PGC/RP9',   type => IO },
        28 => { name => 'RB7/CCP7/KBI3/PGD/RP10',    type => IO },
    }
);
print make_device( device => \%device, pins => \%pins );
