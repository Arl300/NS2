import matplotlib.pyplot as plt

# Function to read time-based throughput data
def read_throughput_data():
    time_points = []
    tcp1_throughput = []
    tcp2_throughput = []
    cbr_throughput = []

    with open("time_based_throughput.txt", 'r') as f:
        lines = f.readlines()[1:]  # Skip header
        for line in lines:
            time, t1, t2, cbr = line.split()
            time_points.append(float(time))
            tcp1_throughput.append(float(t1))
            tcp2_throughput.append(float(t2))
            cbr_throughput.append(float(cbr))

    return time_points, tcp1_throughput, tcp2_throughput, cbr_throughput

# Plot throughput vs time
def plot_throughput(time_points, tcp1_throughput, tcp2_throughput, cbr_throughput, title, output_file):
    plt.figure()
    plt.plot(time_points, tcp1_throughput, label="TCP Flow 1", linestyle='-', marker='o')
    plt.plot(time_points, tcp2_throughput, label="TCP Flow 2", linestyle='-', marker='s')
    plt.plot(time_points, cbr_throughput, label="CBR Flow", linestyle='--', marker='x')
    plt.xlabel("Time (s)")
    plt.ylabel("Throughput (Mbps)")
    plt.title(title)
    plt.legend()
    plt.grid(True)
    plt.savefig(output_file)
    print(f"Plot saved as: {output_file}")
    plt.close()

if __name__ == "__main__":
    time_points, tcp1_throughput, tcp2_throughput, cbr_throughput = read_throughput_data()

    # Plot each experiment
    experiments = [
        ("Throughput vs Time: Tahoe/Reno", "Throughput_vs_Time_Tahoe_Reno.png"),
        ("Throughput vs Time: Reno/Vegas", "Throughput_vs_Time_Reno_Vegas.png"),
        ("Throughput vs Time: Tahoe/Linux", "Throughput_vs_Time_Tahoe_Linux.png"),
        ("Throughput vs Time: Linux/Vegas", "Throughput_vs_Time_Linux_Vegas.png"),
    ]

    for title, output_file in experiments:
        plot_throughput(time_points, tcp1_throughput, tcp2_throughput, cbr_throughput, title, output_file)

