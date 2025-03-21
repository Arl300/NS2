import matplotlib.pyplot as plt
import os

def plot_results(tcp1, tcp2, results_file):
    # Data containers
    cbr_rates = []
    throughput1 = []
    throughput2 = []
    latency1 = []
    latency2 = []
    drop_rate1 = []
    drop_rate2 = []

    # Read results file
    with open(results_file, 'r') as file:
        next(file)  # Skip header
        for line in file:
            data = line.split()
            cbr_rates.append(float(data[0]))
            throughput1.append(float(data[1]))
            throughput2.append(float(data[2]))
            latency1.append(float(data[3]))
            latency2.append(float(data[4]))
            drop_rate1.append(float(data[5]))
            drop_rate2.append(float(data[6]))

    # Plot throughput
    plt.figure()
    plt.plot(cbr_rates, throughput1, label=f'{tcp1} Throughput (N2->N6)', marker='o')
    plt.plot(cbr_rates, throughput2, label=f'{tcp2} Throughput (N4->N6)', marker='x')
    plt.xlabel("CBR Rate (Mbps)")
    plt.ylabel("Throughput (Mbps)")
    plt.title(f"Throughput vs CBR Rate ({tcp1}/{tcp2})")
    plt.legend()
    plt.grid()
    plt.savefig(f"throughput_{tcp1}_{tcp2}.png")
    # Show the plot
    plt.tight_layout()
    # Display the plot
    plt.show()

    # Plot packet drop rate
    plt.figure()
    plt.plot(cbr_rates, drop_rate1, label=f'{tcp1} Packet Drop (N2->N6)', marker='o')
    plt.plot(cbr_rates, drop_rate2, label=f'{tcp2} Packet Drop (N4->N6)', marker='x')
    plt.xlabel("CBR Rate (Mbps)")
    plt.ylabel("Packet Drop Rate (%)")
    plt.title(f"Packet Drop Rate vs CBR Rate ({tcp1}/{tcp2})")
    plt.legend()
    plt.grid()
    plt.savefig(f"packet_loss_{tcp1}_{tcp2}.png")
    # Show the plot
    plt.tight_layout()
    # Display the plot
    plt.show()

if __name__ == "__main__":
    # TCP variant pairs
    variant_pairs = [
        ("Tahoe", "Reno"),
        ("Reno", "Vegas"),
        ("Tahoe", "Linux"),
        ("Linux", "Vegas")
    ]

    results_dir = "./results"
    for tcp1, tcp2 in variant_pairs:
        results_file = os.path.join(results_dir, f"results_{tcp1}_{tcp2}.txt")
        if os.path.exists(results_file):
            plot_results(tcp1, tcp2, results_file)
        else:
            print(f"Results file {results_file} not found!")

