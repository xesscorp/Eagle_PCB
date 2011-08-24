use make_eagle_lib;
use gen_xil_pin_list;

#print make_symbols();

print make_bga_pckg(
    name           => 'Xilinx-FT256',
    title          => 'Xilinx 256-Ball Fine-Pitch Thin BGA Package',
    desc           => '',
    units          => mm,
    pad_diameter   => 0.40,
    pad_spacing    => 1.00,
    num_rows       => 16,
    num_cols       => 16,
    chip_x         => 17,
    chip_y         => 17,
    add_fiducials  => 0,
);

##############################################################################################
##############################################################################################

%device = (
    name  => 'XC3S1400A-FT256',
    title =>
      'Xilinx Spartan 3A 1400K-gate FPGA in FT256 package',
    desc  => '',
    pckgs => [
        {
            name       => 'Xilinx-FT256',
            variant    => '',
            num_rows   => 16,
            num_cols   => 16,
        },
    ],
);
%pins = gen_xil_pin_list_3( 'XC3S1400AFT256.csv', 'XC3S1400AFT256' );
print make_device( device => \%device, pins => \%pins );
