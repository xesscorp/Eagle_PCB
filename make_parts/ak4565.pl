use make_eagle_lib;

print make_symbols();

print make_qfp_pckg(
    name           => 'AKM-VSOP28',
    title          => 'AKM VSOP-28',
    desc           => '',
    units          => mm,
    contact_width  => 0.32,
    pad_width      => 0.32,
    contact_length => 0.50,
    front_porch    => 0.20,
    back_porch     => 0.10,
    pad_spacing    => 0.65,
    num_pads_y     => 14,
    num_pads_x     => 0,
    chip_x         => 7.6,
    chip_y         => 10,
);


%device = (
    name  => 'AK4565VF',
    title =>
      'AKM 20-bit Audio Codec',
    desc  => '',
    pckgs => [
        {
            name       => 'AKM-VSOP28',
            variant    => 'VSOP28',
            num_pads_x => 0,
            num_pads_y => 14
        },
    ],
);
%pins = (
    default_swap_level => 0,
    properties         => {
        1  => { name => LOUT,  type => OUT },
        2  => { name => ROUT,  type => OUT },
        3  => { name => INTL1, type => IN },
        4  => { name => INTR1, type => IN },
        5  => { name => INTL0, type => IN },
        6  => { name => INTR0, type => IN },
        7  => { name => EXTL,  type => IN },
        8  => { name => EXTR,  type => IN },
        9  => { name => LIN,   type => IN },
       10  => { name => RIN,   type => IN },
       11  => { name => VCOM,  type => IN },
       12  => { name => AGND,  type => IN },
       13  => { name => VA,    type => IN },
       14  => { name => VREF,  type => IN },
       15  => { name => VD,    type => IN },
       16  => { name => DGND,  type => IN },
       17  => { name => VT,    type => IN },
       18  => { name => SDTO0, type => OUT },
       19  => { name => SDTO1, type => OUT },
       20  => { name => SDTI,  type => IN },
       21  => { name => LRCK,  type => IN },
       22  => { name => MCLK,  type => IN },
       23  => { name => BCLK,  type => IN },
       24  => { name => CDTO,  type => OUT },
       25  => { name => CDTI,  type => IN },
       26  => { name => CSN,   type => IN },
       27  => { name => CCLK,  type => IN },
       28  => { name => PDN,   type => IN },
    }
);
print make_device( device => \%device, pins => \%pins );
