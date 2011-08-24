use make_eagle_lib;
use gen_xil_pin_list;
use xilinx_packages;



print make_symbols();

#######################################################################################
# Spartan 3A Devices.
#######################################################################################

%device = (
    name  => 'XC3S50A-XVQ100',
    title =>
      'Xilinx Spartan 3A 50K-gate FPGA in VQ100 package',
    desc  => '',
    pckgs => [
        {
            name       => 'VQ100XS',
            variant    => '',
            num_pads_x => 25,
            num_pads_y => 25,
        },
        {
            name       => 'VQ100@xilinx_devices',
            variant    => 'X',
            num_pads_x => 25,
            num_pads_y => 25,
			pin_name_prefix => P,
        },
    ],
);
%pins = gen_xil_pin_list_2( 'XC3S50AVQ100.csv', 'XC3S50AVQ100' );
print make_device( device => \%device, pins => \%pins );

%device = (
    name  => 'XC3S50A-XTQ144',
    title =>
      'Xilinx Spartan 3A 50K-gate FPGA in TQ144 package',
    desc  => '',
    pckgs => [
        {
            name       => 'TQ144',
            variant    => '',
            num_pads_x => 36,
            num_pads_y => 36,
        },
        {
            name       => 'TQ144@xilinx_devices',
            variant    => 'X',
            num_pads_x => 36,
            num_pads_y => 36,
			pin_name_prefix => P,
        },
    ],
);
%pins = gen_xil_pin_list_2( 'XC3S50ATQ144.csv', 'XC3S50ATQ144' );
print make_device( device => \%device, pins => \%pins );

%device = (
    name  => 'XC3S50A-XFT256',
    title =>
      'Xilinx Spartan 3A 50K-gate FPGA in FT256 package',
    desc  => '',
    pckgs => [
        {
            name       => 'FT256',
            variant    => '',
            num_rows => 16,
            num_cols => 16,
        },
        {
            name       => 'FT256@xilinx_devices',
            variant    => 'X',
            num_rows => 16,
            num_cols => 16,
        },
    ],
);
%pins = gen_xil_pin_list_2( 'XC3S50AFT256.csv', 'XC3S50AFT256' );
print make_device( device => \%device, pins => \%pins );
