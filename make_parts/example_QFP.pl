use make_eagle_lib; # Import the Eagle part-making library.

# This instantiates the schematic pin symbols. If you already have these in your
# Eagle library (and you will if you've previously imported a part made with this
# perl script), then you can omit calling this function.
print make_symbols();

# Create a QFG package footprint.
print make_qfp_pckg(
    # Create the footprint name, title and description to display in the Eagle library.
    name           => 'Xilinx-QFG48',
    title          => 'Xilinx QFG48 Package',
    desc           => 'Quad Flat No Lead 48-Contact Package',
    # The rest defines the actual footprint.
    units          => mm,     # All units are in millimeters.
    contact_width  => 0.3,    # Lead width. (Dim. "b")
    pad_width      => 0.3,    # Pad width. (Dim. "b")
    # Total pad length = contact_length + back_porch + front_porch.
    contact_length => 0.5,    # Foot length. (Dim. "L")
    front_porch    => 1.0,    # Outward extension of pad (so we can get a soldering iron on it). 
    back_porch     => 0.0,    # Inward extension of pad.
    pad_spacing    => 0.50,   # Lead pitch. (Dim. "e")
    num_pads_x     => 12,     # Number of pads along the horizontal sides (MSOP package).
    num_pads_y     => 12,     # Number of pads along the vertical sides.
    chip_x         => 7.0,    # Overall length. (Dim. "D")
    chip_y         => 7.0,    # Overall width. (Dim "E")
    outline        => inside, # Put chip silkscreen outline inside or outside the pin rows.
    add_fiducials  => 'no',   # Add fiducial marks for placement.
    extra_pads     => {
                         # This describes the heatsink pad on the bottom of the QFG48.
                         HS => {
                               x=>0,     y=> 0,   # Offset from the chip's centroid.
                               h=>4.7,   l=> 4.7, # Dim. D2 & E2.
                               use_copper => yes  # Build the pad using a polygon, not SMD pad. 
                               }
                      },
);

# Create the device that uses the footprint.
%device = (
    # Create the device name, title and description to display in the Eagle library.
    name  => 'XC2C64A',
    title => 'Xilinx Coolrunner-II 64-Macrocell CPLD',
    desc  => '',
    # Now link the footprint with the device.
    pckgs => [
        {
            name       => 'Xilinx-QFG48', # Footprint name from above.
            variant    => '-I/SO', # Package variant label (could be '' if only one footprint).
            num_pads_x => 12, # Same number of pads as above.
            num_pads_y => 12
        },
    ],
);

# Create the device pins.
%pins = (
    # Most CPLD pins are generic I/O that are interchangeable, so set the
    # default name, type and swap-level for these.
    default_name       => 'IO',
    default_type       => 'INOUT',
    default_swap_level => 1,
    # Now specify the name, type and swap-level for the pins that are not generic I/O.
    properties         => {
        # JTAG pins.
        23 => { name => 'TCK',    type => IN,  swap => 0 },
        21 => { name => 'TDI',    type => IN,  swap => 0 },
        40 => { name => 'TDO',    type => OUT, swap => 0 },
        22 => { name => 'TMS',    type => IN,  swap => 0 },
        # Power supply pins.
         3 => { name => 'VCCAUX', type => IN,  swap => 0 },
        29 => { name => 'VCC',    type => IN,  swap => 0 },
        19 => { name => 'VCCIO1', type => IN,  swap => 0 },
        42 => { name => 'VCCIO2', type => IN,  swap => 0 },
        # Ground pins.
        16 => { name => 'GND',    type => IN,  swap => 0 },
        31 => { name => 'GND',    type => IN,  swap => 0 },
        41 => { name => 'GND',    type => IN,  swap => 0 },
    },
);

# Now combine the device and pin descriptions into a complete device.
print make_device( device => \%device, pins => \%pins );
