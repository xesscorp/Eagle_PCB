use make_eagle_lib; # Import the Eagle part-making library.

print make_symbols(); # Instantiate the schematic pin symbols.

# Create a BGA package footprint. 
print make_bga_pckg(
    name           => 'FT64',
    title          => '64-Ball Fine-Pitch Thin BGA Package',
    desc           => '',   # Description of package.
    units          => mm,   # All units are in millimeters.
    pad_diameter   => 0.40, # Pad diameter (just a bit less than ball diameter).
    pad_spacing    => 1.00, # Lead pitch. (Dim. "e")
    num_rows       => 8,   # Number of rows in the array (A, B, C...).
    num_cols       => 8,   # Number of columns in the array (1, 2, 3...).
    chip_x         => 9,   # Overall length. (Dim. "D")
    chip_y         => 9,   # Overall width. (Dim "E")
    add_fiducials  => 'no', # Add fiducial marks for placement, yes or no.
    knockouts      => { D => [4, 5], E => [4,5] }, # Knockout some pins in the array.
);

# Create a device that uses the footprint.
%device = (
    # Create the device name, title and description to display in the Eagle library.
    name  => 'SomeChip',
    title => 'Some 64-pin chip',
    desc  => 'Just some random junk.',
    # Now link the footprint with the device.
    pckgs => [
        {
            name       => 'FT64', # Footprint name from above.
            variant    => '-FT64', # Package variant label (could be '' if only one footprint).
            num_rows   => 8, # Same number of rows & columns as above.
            num_cols   => 8,
        },
    ],
);

# Create the device pins.
%pins = (
    # Assume most pins are generic I/O that are interchangeable, so set the
    # default name, type and swap-level for these.
    default_name       => 'IO',
    default_type       => 'INOUT',
    default_swap_level => 1,
    # Now specify the name, type and swap-level for the pins that are not generic I/O.
    properties         => {
        # JTAG pins.
        A1 => { name => 'TCK',    type => IN,  swap => 0 },
        A2 => { name => 'TDI',    type => IN,  swap => 0 },
        H1 => { name => 'TDO',    type => OUT, swap => 0 },
        A3 => { name => 'TMS',    type => IN,  swap => 0 },
        # Power supply pins.
        C4 => { name => 'VCCAUX', type => IN,  swap => 0 },
        C5 => { name => 'VCC',    type => IN,  swap => 0 },
        D1 => { name => 'VCCIO1', type => IN,  swap => 0 },
        E8 => { name => 'VCCIO2', type => IN,  swap => 0 },
        # Ground pins.
        F4 => { name => 'GND',    type => IN,  swap => 0 },
        F5 => { name => 'GND',    type => IN,  swap => 0 },
        H5 => { name => 'GND',    type => IN,  swap => 0 },
    },
    # Specify the missing pins in the array.
    knockouts => { D => [4, 5], E => [4,5] }, # Knockout some pins in the array.
);

# Now combine the device and pin descriptions into a complete device.
print make_device( device => \%device, pins => \%pins );
