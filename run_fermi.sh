#!/usr/bin/env bash

# Remove results from previous simulations
rm -f *.init
rm -f matmul_200_outputs/*

# Create outputs directory if it doesn't exist
mkdir matmul_200_outputs

# HotSpot's grid model is capable of modeling stacked 3-D chips. To be
# able to do that, one has to specify what is called the 'Layer
# Configuration File' (LCF). An LCF specifies the set of vertical layers
# to be modeled including its physical properties (thickness,
# conductivity etc.) and the floorplan of the die in that layer.

# Let us now look at an example of how to model stacked 3-D chips. Let
# us use a simple, 3-block floorplan file 'floorplan1.flp' in addition to
# the more detailed original 'floorplan2.flp'. In the chip we will model, layer 0 is
# power dissipating silicon with a floorplan of 'floorplan1.flp', followed
# by a layer of non-dissipating (passive) TIM. This is then followed by
# another layer of active silicon with a floorplan of 'floorplan2.flp' and
# another layer of passive TIM. Such a layer configuration is described
# in 'example.lcf'. Note that the floorplan files of all layers are specified
# in the LCF instead of via the command line

HotSpot/hotspot -c fermi.config -p matmul_200.ptrace -grid_layer_file fermi.lcf -materials_file fermi.materials -model_type grid -detailed_3D on -steady_file matmul_200_outputs/fermi.steady -grid_steady_file matmul_200_outputs/fermi.grid.steady

# Copy steady-state results over to initial temperatures
cp matmul_200_outputs/fermi.steady fermi.init

# Transient simulation
HotSpot/hotspot -c fermi.config -p matmul_200.ptrace -grid_layer_file fermi.lcf -materials_file fermi.materials -model_type grid -detailed_3D on -o matmul_200_outputs/fermi.ttrace -grid_transient_file matmul_200_outputs/fermi.grid.ttrace

# Visualize Heat Map of Layer 0 with Perl and with Python script
HotSpot/scripts/split_grid_steady.py matmul_200_outputs/fermi.grid.steady 4 8 8
HotSpot/scripts/grid_thermal_map.py fermi_floorplan2.flp matmul_200_outputs/fermi_layer2.grid.steady 8 8 malmul_200_layer2.png
HotSpot/scripts/grid_thermal_map.pl fermi_floorplan2.flp matmul_200_outputs/fermi_layer2.grid.steady 8 8 > malmul_200_layer2.svg