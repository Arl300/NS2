proc expt1 {cbr_rate tcp_variant queue_type} {
    global ns tf nf

    # Create a simulator object
    set ns [new Simulator]

    # save data to a trace file
    set tf [open expt3.tr w]
    $ns trace-all $tf

     # finish procedure function
    proc finish {} {
        global ns tf nf
        $ns flush-trace
        # Close the trace
        close $tf
        exit 0
    }


    # Create 8 nodes
    set n1 [$ns node]
    set n2 [$ns node]
    set n3 [$ns node]
    set n4 [$ns node]
    set n5 [$ns node]
    set n6 [$ns node]
    set n7 [$ns node]
    set n8 [$ns node]

    # Create duplex links with the specified queue type
    $ns duplex-link $n1 $n2 6Mb 10ms $queue_type
    $ns duplex-link-op $n1 $n2 orient down

    $ns duplex-link $n2 $n3 6Mb 10ms $queue_type
    $ns duplex-link-op $n2 $n3 orient right

    $ns duplex-link $n3 $n4 6Mb 10ms $queue_type
    $ns duplex-link-op $n3 $n4 orient right

    $ns duplex-link $n4 $n5 6Mb 10ms $queue_type
    $ns duplex-link-op $n4 $n5 orient up

    $ns duplex-link $n5 $n6 6Mb 10ms $queue_type
    $ns duplex-link-op $n5 $n6 orient down

    $ns duplex-link $n6 $n7 6Mb 10ms $queue_type
    $ns duplex-link-op $n6 $n7 orient left

    $ns duplex-link $n7 $n8 6Mb 10ms $queue_type
    $ns duplex-link-op $n7 $n8 orient right

    # Set queue size limit
    $ns queue-limit $n2 $n3 10

    # Configure TCP flow from N1 to N6 (Linux and Reno)
    if {$tcp_variant == "Linux"} {
        set tcp [new Agent/TCP/Linux]
    } else {
        set tcp [new Agent/TCP/Reno]
    }
    $ns attach-agent $n1 $tcp
    # Set TCP sink at N6
    set sink [new Agent/TCPSink]
    $ns attach-agent $n6 $sink
    
    # Connect TCP flow
    $ns connect $tcp $sink
    $tcp set fid_ 1
    
    # Setup FTP over TCP flow (N1 to N6)
    set ftp [new Application/FTP]
    $ftp attach-agent $tcp
    $ftp set type_ FTP

    # Configure UDP flow from N2 to N6 (CBR source to null sink)
    set udp [new Agent/UDP]
    $ns attach-agent $n2 $udp
    # Set null sink at N6
    set null [new Agent/Null]
    $ns attach-agent $n6 $null

    # Connect UDP flow
    $ns connect $udp $null
    $udp set fid_ 2

    # Setup CBR over UDP
    set cbr [new Application/Traffic/CBR]
    $cbr attach-agent $udp
    $cbr set type_ CBR
    $cbr set packet_size_ 1000
    $cbr set rate_ ${cbr_rate}mb
    $cbr set random_ false

    # Schedule events for the CBR and FTP agents
    $ns at 0.1 "$cbr start"
    $ns at 1.0 "$ftp start"
    $ns at 6.0 "$ftp stop"
    $ns at 6.5 "$cbr stop"

    # Call the finish procedure after 7s simulation
    $ns at 7.0 "finish"

    # Run the simulation
    $ns run
}

# Pass parameters from command line
    expt1 [lindex $argv 0] [lindex $argv 1] [lindex $argv 2]
