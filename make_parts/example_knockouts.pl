use make_eagle_lib; # Import the Eagle part-making library.

# Knockout pins on a DIL package. 
print make_dil_pckg(
    # Create the footprint name, title and description to display in the Eagle library.
    name           => '16_PDIP',
    title          => '16-Lead Plastic Dual In-Line Package - 300 mil',
    desc           => '',      # Description of package.
    # The rest defines the actual footprint.
    units          => mil,     # All units are in 1/1000 inch.
    pad_size       => 50,      # Pad width. (Dim. "b")
    pad_drill      => 25,      # Drill diameter. (a few mils bigger than dim. "b")
    pad_shape      => octagon, # Round, square, octagon, long pad shape.
    pad_spacing    => 100,     # Lead pitch. (Dim. "e")
    num_pads       => 16,      # Total number of package pins.
    chip_x         => 800,     # Overall length. (Dim. "D")
    chip_y         => 300,     # Space between pin rows.
    add_fiducials  => 'no',    # Add fiducial marks for placement, yes or no.
    outline        => inside,  # Put chip silkscreen outline inside or outside the pin rows.
    mark_pin1      => yes,     # Put a silkscreen mark by pin 1, yes or no.
    knockouts      => [3, 7, 8, 12, 16],
);

# Knockout pins on a QFP. 
print make_qfp_pckg(
    # Create the footprint name, title and description to display in the Eagle library.
    name           => 'QFG48',
    title          => 'QFG48 Package',
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
    knockouts      => [6, 24, 25, 44, 48],
);

# Knockout pins on a BGA. 
print make_bga_pckg(
    name           => 'FT256',
    title          => '256-Ball Fine-Pitch Thin BGA Package',
    desc           => '',
    units          => mm,
    pad_diameter   => 0.40,
    pad_spacing    => 1.00,
    num_rows       => 16,
    num_cols       => 16,
    chip_x         => 17,
    chip_y         => 17,
    knockouts      => { G=>[7..10], H=>[7..10], J=>[7..10], K=>[7..10], },
);
