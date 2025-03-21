#!/bin/bash

# CBR bandwidth rates in Mbps
cbr_rates=(1 2 3 4 5 6 7)

# TCP variant pairs
variant_pairs=(
  "Tahoe Reno"
  "Reno Vegas"
  "Tahoe Linux"
  "Linux Vegas"
)

# Output directory
results_dir="./results"
mkdir -p $results_dir

echo "==================== Simulation Start ===================="

for pair in "${variant_pairs[@]}"; do
  IFS=' ' read -r tcp1 tcp2 <<< "$pair"
  echo "Running simulations for $tcp1/$tcp2"

  # Create a result file for the pair
  result_file="$results_dir/results_${tcp1}_${tcp2}.txt"
  echo -e "CBR(Mbps)\tThroughput1(Mbps)\tThroughput2(Mbps)\tLatency1(ms)\tLatency2(ms)\tDropRate1(%)\tDropRate2(%)" > $result_file

  for rate in "${cbr_rates[@]}"; do
    # Run simulation
    ns expt2.tcl $rate $tcp1 $tcp2 > expt2.tr

    # Analyze the trace file and append results
    python3 analysis.py $rate >> $result_file

    # Clean up trace file
    rm -f expt2.tr
  done
done

echo "==================== Simulation Complete ===================="

echo "-------------------- Generating plots ---------------------"

python3 plot_results.py

echo " ------------------- Generation finished -----------------"

