#!/usr/bin/env bash

# The usage of the script is "sh run_all.sh <power_log> <layerID>" 
# For instance, "sh run_all.sh power_log/matmul_200.log 0" will generate
# a heatmap figure "layer0.png" in the current directory for the log.

# convert power log to file 'powerlog.ptrace'
python3 ptrace.py $1
echo "Converting PowerLog To Ptrace Done"

# Apply HotSpot to generate map

# Remove results from previous simulations
rm -f *.init
rm -f outputs/*

# Create outputs directory if it doesn't exist
mkdir outputs
echo "Creating 'outputs' Directory Done"

echo "Begin HotSpot Simulation"
HotSpot/hotspot -c fermi.config -p powerlog.ptrace -grid_layer_file fermi.lcf -materials_file fermi.materials -model_type grid -detailed_3D on -steady_file outputs/fermi.steady -grid_steady_file outputs/fermi.grid.steady

# Copy steady-state results over to initial temperatures
cp outputs/fermi.steady fermi.init

# Transient simulation
HotSpot/hotspot -c fermi.config -p powerlog.ptrace -grid_layer_file fermi.lcf -materials_file fermi.materials -model_type grid -detailed_3D on -o outputs/fermi.ttrace -grid_transient_file outputs/fermi.grid.ttrace

echo "Begin Heatmap Generation"
# Visualize Heat Map of Layer 0 with Perl and with Python script
HotSpot/scripts/split_grid_steady.py outputs/fermi.grid.steady 4 8 8
HotSpot/scripts/grid_thermal_map.py fermi_floorplan$2.flp outputs/fermi_layer$2.grid.steady 8 8 layer$2.png
HotSpot/scripts/grid_thermal_map.pl fermi_floorplan$2.flp outputs/fermi_layer$2.grid.steady 8 8 > layer$2.svg

echo "The Heatmap Has Been Generated."

