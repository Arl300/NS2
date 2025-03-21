#!/bin/bash

# Array of CBR rates (in Mbps)
crb_rate=(1 2 3 4 5 6 7)

echo "==================== Simulation Start ===================="

# Run for Tahoe
echo "-------------------- Tahoe --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
for i in ${crb_rate[@]}; do
    /home/ns-allinone-2.35/ns-allinone-2.35/bin/ns expt1.tcl $i Tahoe
    python3 analysis.py $i > results_tahoe_$i.txt  # Redirect output to a file
done

# Run for Reno
echo "-------------------- Reno --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
for i in ${crb_rate[@]}; do
    /home/ns-allinone-2.35/ns-allinone-2.35/bin/ns expt1.tcl $i Reno
    python3 analysis.py $i > results_reno_$i.txt  # Redirect output to a file
done

# Run for NewRenot
echo "-------------------- NewReno --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
for i in ${crb_rate[@]}; do
    /home/ns-allinone-2.35/ns-allinone-2.35/bin/ns expt1.tcl $i Newreno
    python3 analysis.py $i > results_newreno_$i.txt  # Redirect output to a file
done

# Run for Vegas
echo "-------------------- Vegas --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
for i in ${crb_rate[@]}; do
    /home/ns-allinone-2.35/ns-allinone-2.35/bin/ns expt1.tcl $i Vegas
    python3 analysis.py $i > results_vegas_$i.txt  # Redirect output to a file
done

# Run for Linux
echo "-------------------- Linux --------------------"
echo "CBR(Mbps)    Throughput(Mbps)    Latency(ms)    Packet Drop Rate(%)"
for i in ${crb_rate[@]}; do
    /home/ns-allinone-2.35/ns-allinone-2.35/bin/ns expt1.tcl $i Linux
    python3 analysis.py $i > results_linux_$i.txt  # Redirect output to a file
done

echo "---------------Generating plots-------------------"
python3 plot_data.py
python3 plot_latency.py
python3 plot_pdr.py
python3 plot_pdratio.py
echo "---------------Generation ended-------------------"
