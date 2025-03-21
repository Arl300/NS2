#!/bin/bash

echo "Current directory: $(pwd)"

# CBR bandwidth rates in Mbps
cbr_rate=(1 2 3 4 5 6 7)

echo "==================== Simulation Start ===================="

# Define TCP variant and queue management combinations
variant_pairs=(
  "Reno DropTail"
  "Reno SFQ"
  "Linux DropTail"
  "Linux SFQ"
)

# Run experiments for each combination of TCP variant and queue management
for pair in "${variant_pairs[@]}"; do
  IFS=' ' read -r tcp variant <<< "$pair"

  # Define result file
  result_file="results_${tcp}_${variant}.txt"
  
  # Print section header to both screen and file
  echo "-------------------- $tcp/$variant --------------------" | tee -a $result_file
  echo -e "Time(s)\tTCP Throughput(Mbps)\tCBR Throughput(Mbps)\tTCP Latency(ms)" | tee -a $result_file

  for i in ${cbr_rate[@]}; do
      # Run simulation and store output in the result file
      /home/ns-allinone-2.35/ns-allinone-2.35/bin/ns expt3.tcl $i $tcp $variant > temp_results.txt

      # Run analysis and append results to the file while also printing to screen
      python3 analysis.py $i | tee -a $result_file
  done

  echo "" | tee -a $result_file  # Blank line for separation in file
done

echo "==================== Simulation End ===================="

# Create plots after all simulations
echo "==================== Generating Plots ===================="

# Call Python scripts to generate plots
python3 plot_throughput.py results_*.txt   # Plot throughput data
python3 plot_latency.py results_*.txt      # Plot latency data
python3 plot_pdratio.py results_*.txt      # Plot packet drop ratio data

echo "==================== Plots Generated ===================="

