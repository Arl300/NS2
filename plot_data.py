import matplotlib.pyplot as plt

# Define the list of CBR rates (in Mbps)
cbr_rates = [1, 2, 3, 4, 5, 6, 7]

# Initialize dictionaries to store throughput for each variant
throughput_tahoe = []
throughput_reno = []
throughput_newreno = []
throughput_vegas = []
throughput_linux = []

# Function to extract throughput from the result files
def extract_throughput(file_path):
    with open(file_path, "r") as file:
        for line in file:
            parts = line.split()  # Split line by whitespace
            if len(parts) >= 4:  # Ensure there are enough parts
                return float(parts[1])  # Extract throughput (second value in the line)
    return None

# Extract throughput for each CBR rate and each variant
for cbr in cbr_rates:
    throughput_tahoe_value = extract_throughput(f"results_tahoe_{cbr}.txt")
    throughput_reno_value = extract_throughput(f"results_reno_{cbr}.txt")
    throughput_newreno_value = extract_throughput(f"results_newreno_{cbr}.txt")
    throughput_vegas_value = extract_throughput(f"results_vegas_{cbr}.txt")
    throughput_linux_value = extract_throughput(f"results_linux_{cbr}.txt")
    
    print(f"CBR: {cbr}, Tahoe: {throughput_tahoe_value}, Reno: {throughput_reno_value}, "
          f"NewReno: {throughput_newreno_value}, Vegas: {throughput_vegas_value}, Linux: {throughput_linux_value}")
    
    throughput_tahoe.append(throughput_tahoe_value)
    throughput_reno.append(throughput_reno_value)
    throughput_newreno.append(throughput_newreno_value)
    throughput_vegas.append(throughput_vegas_value)
    throughput_linux.append(throughput_linux_value)

# Plot the throughput data
plt.figure(figsize=(10, 6))

plt.plot(cbr_rates, throughput_tahoe, marker='o', label='Tahoe', linestyle='-', color='blue')
plt.plot(cbr_rates, throughput_reno, marker='o', label='Reno', linestyle='-', color='green')
plt.plot(cbr_rates, throughput_newreno, marker='o', label='NewReno', linestyle='-', color='red')
plt.plot(cbr_rates, throughput_vegas, marker='o', label='Vegas', linestyle='-', color='purple')
plt.plot(cbr_rates, throughput_linux, marker='o', label='Linux', linestyle='-', color='orange')

# Customize the plot
plt.xlabel('CBR Rate (Mbps)')
plt.ylabel('Throughput (Mbps)')
plt.title('Throughput over CBR Rate for Different TCP Variants')
plt.legend()
plt.grid(True)

# Show the plot
plt.tight_layout()

#Save the plot
plt.savefig('throughput_plot.png')

#Display the plot
plt.show()

