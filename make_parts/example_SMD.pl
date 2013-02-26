use make_eagle_lib; # Import the Eagle part-making library.

print make_symbols(); # Instantiate the schematic pin symbols.

# Create a leaded SMD package footprint. 
print make_qfp_pckg(
    # Create the footprint name, title and description to display in the Eagle library.
    name           => 'Microchip-8_MSOP',
    title          => 'Microchip 8-Lead Plastic Micro Small Outline Package',
    desc           => '',   # Description of package.
    # The rest defines the actual footprint.
    units          => mm,   # All units are in millimeters.
    contact_width  => 0.4,  # Lead width. (Dim. "b")
    pad_width      => 0.4,  # Pad width. (Dim. "b")
    # Total pad length = contact_length + back_porch + front_porch.
    contact_length => 0.8,  # Foot length. (Dim. "L")
    front_porch    => 1.0,  # Outward extension of pad. 
    back_porch     => 0.0,  # Inward extension of pad.
    pad_spacing    => 0.65, # Lead pitch. (Dim. "e")
    num_pads_x     => 4,    # Number of pads along the horizontal sides (MSOP package).
    num_pads_y     => 0,    # Number of pads along the vertical sides.
    chip_x         => 3.0,  # Overall length. (Dim. "D")
    chip_y         => 4.9,  # Overall width. (Dim "E")
    add_fiducials  => 'no', # Don't add fiducial marks for placement.
);

# Create the device that uses the footprint.
%device = (
    # Create the device name, title and description to display in the Eagle library.
    name  => 'MCP48X1',
    title => 'Microchip MCP4801/4811/4821 DAC',
    desc  => 'Microchip 8, 10 and 12-bit DACs with SPI interface.',
    # Now link the footprint with the device.
    pckgs => [
        {
            name       => 'Microchip-8_MSOP', # Footprint name from above.
            variant    => '-E/MS', # Package variant label (could be '' if only one footprint).
            num_pads_x => 4, # Same number of pads as above.
            num_pads_y => 0
        },
    ],
);

# Create the device pins.
%pins = (
    default_swap_level => 0, # By default, pins are not swappable.
    properties         => {
        # Specify the name and I/O type for each pin of the device.
        1 => { name => 'VDD',   type => IN  },
        2 => { name => 'CS#',   type => IN  },
        3 => { name => 'SCK',   type => IN  },
        4 => { name => 'SDI',   type => IN  },
        5 => { name => 'LDAC#', type => IN  },
        6 => { name => 'SHDN#', type => IN  },
        7 => { name => 'VSS',   type => IN  },
        8 => { name => 'VOUT',  type => OUT },
    }
);

# Now combine the device and pin descriptions into a complete device.
print make_device( device => \%device, pins => \%pins );
