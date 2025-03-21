import matplotlib.pyplot as plt

def extract_data(file_path):
    cbr_values = []
    latencies = []

    with open(file_path, 'r') as f:
        for line in f:
            print(f"Reading line: {line.strip()}")
            parts = line.split()
            
            if len(parts) >= 4:
                try:
                    cbr = float(parts[0])  # CBR value is the first element
                    latency = float(parts[2])  # Latency is the third element
                    cbr_values.append(cbr)
                    latencies.append(latency)
                except ValueError:
                    print(f"Skipping line with invalid data: {line}")
    return cbr_values, latencies

# List of variants
variants = ['tahoe', 'reno', 'newreno', 'vegas', 'linux']

# Create a figure for plotting
plt.figure(figsize=(10, 6))

# Loop through each TCP variant
for variant in variants:
    cbr_values = []
    latencies = []
    
    # Loop through CBR rates (adjust as necessary)
    for cbr_rate in [1, 2, 3, 4, 5, 6, 7]:
        file_name = f"results_{variant}_{cbr_rate}.txt"  # File naming pattern
        print(f"Processing file: {file_name}")
        
        cbr_data, latency_data = extract_data(file_name)
        
        # Add data for plotting (only plotting for the current variant)
        cbr_values.extend(cbr_data)
        latencies.extend(latency_data)

    # Plot Latency vs CBR for the current variant
    plt.plot(cbr_values, latencies, label=f"{variant.capitalize()} Latency")

# Customize the plot
plt.title("Latency over CBR for All Variants")
plt.xlabel("CBR (Mbps)")
plt.ylabel("Latency (ms)")
plt.legend()
plt.grid(True)

plt.savefig('latency_plot.png')
# Show the plot
plt.show()





