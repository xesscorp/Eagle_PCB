use make_eagle_lib; # Import the Eagle part-making library.

# Import subroutines for creating pin structures directly from Xilinx documentation. 
use gen_xil_pin_list;

print make_symbols(); # Instantiate the schematic pin symbols.

print make_bga_pckg(
    name           => 'Xilinx-FT256',
    title          => 'Xilinx 256-Ball Fine-Pitch Thin BGA Package',
    desc           => '',   # Description of package.
    units          => mm,   # All units are in millimeters.
    pad_diameter   => 0.40, # Pad diameter (just a bit less than ball diameter).
    pad_spacing    => 1.00, # Lead pitch. (Dim. "e")
    num_rows       => 16,   # Number of rows in the array (A, B, C...).
    num_cols       => 16,   # Number of columns in the array (1, 2, 3...).
    chip_x         => 17,   # Overall length. (Dim. "D")
    chip_y         => 17,   # Overall width. (Dim "E")
    add_fiducials  => 'no', # Add fiducial marks for placement, yes or no.
);

# Create a device that uses the footprint.
%device = (
    # Create the device name, title and description to display in the Eagle library.
    name  => 'XC6SLX9-FT256',
    title => 'Xilinx Spartan 6 9-KLUT FPGA in FT256 package',
    desc  => '',
    # Now link the footprint with the device.
    pckgs => [
        {
            name       => 'Xilinx-FT256', # Footprint name from above.
            variant    => '-FT256', # Package variant label (could be '' if only one footprint).
            num_rows   => 16, # Same number of rows & columns as above.
            num_cols   => 16,
        },
    ],
);

# Create the device pins directly from the Xilinx pin documentation.
%pins = gen_xil_pin_list_4( '6slx9ftg256pkg.txt' );

# Now combine the device and pin descriptions into a complete device.
print make_device( device => \%device, pins => \%pins );
