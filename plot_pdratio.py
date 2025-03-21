import matplotlib.pyplot as plt
import sys

# List of CBR rates (in Mbps)
cbr_rates = [1, 2, 3, 4, 5, 6, 7]

# Initialize lists to store Packet Delivery Ratio for each variant
pdr_tahoe = []
pdr_reno = []
pdr_newreno = []
pdr_vegas = []
pdr_linux = []

# Function to extract Packet Drop Rate and calculate Packet Delivery Ratio (PDR)
def extract_pdr(file_path):
    packet_delivery_ratio = 0  # Initialize Packet Delivery Ratio to 0

    with open(file_path, "r") as file:
        for line in file:
            print(f"Reading line: {line}")  # Debug: print the line
            parts = line.split()  # Split line by whitespace
            if len(parts) >= 4:  # Ensure we have at least 4 parts
                try:
                    # The last column seems to indicate the Packet Drop Rate (PDR)
                    packet_drop_rate = float(parts[3])  # PDR is in the last column
                    packet_delivery_ratio = 100 - packet_drop_rate  # Calculate PDR
                except ValueError:
                    print(f"Skipping invalid PDR value in line: {line}")
                    continue
            else:
                print(f"Skipping line with insufficient parts: {line}")  # Debug: print skipped line

    return packet_delivery_ratio

# Extract Packet Delivery Ratio for each CBR rate and each variant
for cbr in cbr_rates:
    pdr_tahoe_value = extract_pdr(f"results_tahoe_{cbr}.txt")
    pdr_reno_value = extract_pdr(f"results_reno_{cbr}.txt")
    pdr_newreno_value = extract_pdr(f"results_newreno_{cbr}.txt")
    pdr_vegas_value = extract_pdr(f"results_vegas_{cbr}.txt")
    pdr_linux_value = extract_pdr(f"results_linux_{cbr}.txt")
    
    print(f"CBR: {cbr}, Tahoe: {pdr_tahoe_value}, Reno: {pdr_reno_value}, "
          f"NewReno: {pdr_newreno_value}, Vegas: {pdr_vegas_value}, Linux: {pdr_linux_value}")
    
    pdr_tahoe.append(pdr_tahoe_value)
    pdr_reno.append(pdr_reno_value)
    pdr_newreno.append(pdr_newreno_value)
    pdr_vegas.append(pdr_vegas_value)
    pdr_linux.append(pdr_linux_value)

# Plot the Packet Delivery Ratio (PDR) data
plt.figure(figsize=(10, 6))

plt.plot(cbr_rates, pdr_tahoe, marker='o', label='Tahoe', linestyle='-', color='blue')
plt.plot(cbr_rates, pdr_reno, marker='o', label='Reno', linestyle='-', color='green')
plt.plot(cbr_rates, pdr_newreno, marker='o', label='NewReno', linestyle='-', color='red')
plt.plot(cbr_rates, pdr_vegas, marker='o', label='Vegas', linestyle='-', color='purple')
plt.plot(cbr_rates, pdr_linux, marker='o', label='Linux', linestyle='-', color='orange')

# Customize the plot
plt.xlabel('CBR Rate (Mbps)')
plt.ylabel('Packet Delivery Ratio (%)')
plt.title('Packet Delivery Ratio vs CBR Rate for Different TCP Variants')
plt.legend()
plt.grid(True)

# Show the plot
plt.tight_layout()
plt.savefig('pdratio_plot.png')
plt.show()

