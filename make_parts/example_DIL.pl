use make_eagle_lib; # Import the Eagle part-making library.

print make_symbols(); # Instantiate the schematic pin symbols.

# Create a dual in-line footprint. 
print make_dil_pckg(
    # Create the footprint name, title and description to display in the Eagle library.
    name           => 'Microchip-8_PDIP',
    title          => 'Microchip 8-Lead Plastic Dual In-Line Package - 300 mil',
    desc           => '',      # Description of package.
    # The rest defines the actual footprint.
    units          => mil,     # All units are in 1/1000 inch.
    pad_size       => 50,      # Pad width. (Dim. "b")
    pad_drill      => 25,      # Drill diameter. (a few mils bigger than dim. "b")
    pad_shape      => octagon, # Round, square, octagon, long pad shape.
    pad_spacing    => 100,     # Lead pitch. (Dim. "e")
    num_pads       => 8,       # Total number of package pins.
    chip_x         => 400,     # Overall length. (Dim. "D")
    chip_y         => 300,     # Space between pin rows.
    add_fiducials  => 'no',    # Add fiducial marks for placement, yes or no.
    outline        => inside,  # Put chip silkscreen outline inside or outside the pin rows.
    mark_pin1      => yes      # Put a silkscreen mark by pin 1, yes or no.
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
            name       => 'Microchip-8_PDIP', # Footprint name from above.
            variant    => '-PDIP8', # Package variant label (could be '' if only one footprint).
            num_pads_x => 4, # Two rows of 4 pins totals to the number of pins specified above..
            num_pads_y => 0  # It's a DIP! No pins along the top or bottom, only the sides.
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
