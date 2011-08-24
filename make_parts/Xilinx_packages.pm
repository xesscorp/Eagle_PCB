use make_eagle_lib;

%qfp_pcb_dims = (
	VQ44  => { Mid => 9.8, Mie => 9.8, e => 0.8, b => 0.4, I => 1.6 },
	VQ64  => { Mid => 9.8, Mie => 9.8, e => 0.5, b => 0.3, I => 1.6 },
	PQ100 => { Mid => 20.4, Mie => 14.4, e => 0.65, b => 0.3, I => 1.8 },
	HQ160  => { Mid => 28.4, Mie => 28.4, e => 0.65, b => 0.3, I => 1.8 },
	PQ160  => { Mid => 28.4, Mie => 28.4, e => 0.65, b => 0.3, I => 1.8 },
	HQ208  => { Mid => 28.4, Mie => 28.4, e => 0.65, b => 0.3, I => 1.8 },
);

#######################################################################################
# Very Thin Quad Flat Packages - 44, 64 and 100-lead.
#######################################################################################

print make_qfp_pckg(
    name           => 'VQ44',
    title          => 'Xilinx 44-Lead Very Thin Quad Flat Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.4,
    pad_width      => 0.4,
    contact_length => 1.6,
    front_porch    => 0,
    back_porch     => 0,
    pad_spacing    => 0.80,
    num_pads_y     => 11,
    num_pads_x     => 11,
    chip_x         => 13,
    chip_y         => 13,
    add_fiducials  => 0,
);

print make_qfp_pckg(
    name           => 'VQ64',
    title          => 'Xilinx 64-Lead Very Thin Quad Flat Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.3,
    pad_width      => 0.3,
    contact_length => 1.6,
    front_porch    => 0,
    back_porch     => 0,
    pad_spacing    => 0.50,
    num_pads_y     => 16,
    num_pads_x     => 16,
    chip_x         => 13,
    chip_y         => 13,
    add_fiducials  => 0,
);

print make_qfp_pckg(
    name           => 'VQ100',
    title          => 'Xilinx 100-Lead Very Thin Quad Flat Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.27,
    pad_width      => 0.27,
    contact_length => 0.75,
    front_porch    => 0.37,
    back_porch     => 0.37,
    pad_spacing    => 0.50,
    num_pads_y     => 25,
    num_pads_x     => 25,
    chip_x         => 16,
    chip_y         => 16,
    add_fiducials  => 0,
);

#######################################################################################
# Thin Quad Flat Packages - 100, 144 and 176-lead.
#######################################################################################

print make_qfp_pckg(
    name           => 'TQ100',
    title          => 'Xilinx 100-Lead Thin Quad Flat Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.27,
    pad_width      => 0.27,
    contact_length => 0.75,
    front_porch    => 0.37,
    back_porch     => 0.37,
    pad_spacing    => 0.50,
    num_pads_y     => 25,
    num_pads_x     => 25,
    chip_x         => 16,
    chip_y         => 16,
    add_fiducials  => 0,
);

print make_qfp_pckg(
    name           => 'HT100',
    title          => 'Xilinx 100-Lead Thermally Enhanced Thin Quad Flat Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.27,
    pad_width      => 0.27,
    contact_length => 0.75,
    front_porch    => 0.37,
    back_porch     => 0.37,
    pad_spacing    => 0.50,
    num_pads_y     => 25,
    num_pads_x     => 25,
    chip_x         => 16,
    chip_y         => 16,
    add_fiducials  => 0,
    extra_pads     =>
      { EP => { x => 0, y => 0, h => 10, l => 10, use_copper => 1 } },
);

print make_qfp_pckg(
    name           => 'TQ144',
    title          => 'Xilinx 144-Lead Thin Quad Flat Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.27,
    pad_width      => 0.27,
    contact_length => 0.75,
    front_porch    => 0.37,
    back_porch     => 0.37,
    pad_spacing    => 0.50,
    num_pads_y     => 36,
    num_pads_x     => 36,
    chip_x         => 22,
    chip_y         => 22,
    add_fiducials  => 0,
);

print make_qfp_pckg(
    name           => 'HT144',
    title          => 'Xilinx 144-Lead Thermally Enhanced Thin Quad Flat Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.27,
    pad_width      => 0.27,
    contact_length => 0.75,
    front_porch    => 0.37,
    back_porch     => 0.37,
    pad_spacing    => 0.50,
    num_pads_y     => 36,
    num_pads_x     => 36,
    chip_x         => 22,
    chip_y         => 22,
    add_fiducials  => 0,
    extra_pads     =>
      { EP => { x => 0, y => 0, h => 15.5, l => 15.5, use_copper => 1 } },
);

print make_qfp_pckg(
    name           => 'TQ176',
    title          => 'Xilinx 176-Lead Thin Quad Flat Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.27,
    pad_width      => 0.27,
    contact_length => 0.75,
    front_porch    => 0.37,
    back_porch     => 0.37,
    pad_spacing    => 0.50,
    num_pads_y     => 44,
    num_pads_x     => 44,
    chip_x         => 26,
    chip_y         => 26,
    add_fiducials  => 0,
);

print make_qfp_pckg(
    name           => 'HT176',
    title          => 'Xilinx 176-Lead Thermally Enhanced Thin Quad Flat Package',
    desc           => '',
    units          => mm,
    contact_width  => 0.27,
    pad_width      => 0.27,
    contact_length => 0.75,
    front_porch    => 0.37,
    back_porch     => 0.37,
    pad_spacing    => 0.50,
    num_pads_y     => 44,
    num_pads_x     => 44,
    chip_x         => 26,
    chip_y         => 26,
    add_fiducials  => 0,
    extra_pads     =>
      { EP => { x => 0, y => 0, h => 19.4, l => 19.4, use_copper => 1 } },
);

#######################################################################################
# Fine-Pitch Thin BGA Packages - 256, 320, 400, 484 and 676-ball.
#######################################################################################

print make_bga_pckg(
    name           => 'FT256',
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

print make_bga_pckg(
    name           => 'FG320',
    title          => 'Xilinx 320-Ball Fine-Pitch BGA Package',
    desc           => '',
    units          => mm,
    pad_diameter   => 0.40,
    pad_spacing    => 1.00,
    num_rows       => 18,
    num_cols       => 18,
    chip_x         => 19,
    chip_y         => 19,
    add_fiducials  => 0,
	knockouts      => {J=>[9,10], K=>[9,10]},
);

print make_bga_pckg(
    name           => 'FG400',
    title          => 'Xilinx 400-Ball Fine-Pitch BGA Package',
    desc           => '',
    units          => mm,
    pad_diameter   => 0.40,
    pad_spacing    => 1.00,
    num_rows       => 20,
    num_cols       => 20,
    chip_x         => 21,
    chip_y         => 21,
    add_fiducials  => 0,
);

print make_bga_pckg(
    name           => 'FG484',
    title          => 'Xilinx 484-Ball Fine-Pitch BGA Package',
    desc           => '',
    units          => mm,
    pad_diameter   => 0.40,
    pad_spacing    => 1.00,
    num_rows       => 22,
    num_cols       => 22,
    chip_x         => 23,
    chip_y         => 23,
    add_fiducials  => 0,
);

print make_bga_pckg(
    name           => 'FG676',
    title          => 'Xilinx 676-Ball Fine-Pitch BGA Package',
    desc           => '',
    units          => mm,
    pad_diameter   => 0.40,
    pad_spacing    => 1.00,
    num_rows       => 26,
    num_cols       => 26,
    chip_x         => 27,
    chip_y         => 27,
    add_fiducials  => 0,
);

1;