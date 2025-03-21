proc expt1 {cbr_rate tcp_variant} {
    global ns tf nf
    # create a simulator object
    set ns [new Simulator]

    # save data to a trace file
    set tf [open expt1.tr w]
    $ns trace-all $tf

     # finish procedure function
    proc finish {} {
        global ns tf nf
        $ns flush-trace
        # Close the trace
        close $tf
        exit 0
    }

    # create 8 nodes
    set n1 [$ns node]
    set n2 [$ns node]
    set n3 [$ns node]
    set n4 [$ns node]
    set n5 [$ns node]
    set n6 [$ns node]
    set n7 [$ns node]
    set n8 [$ns node]

    # create duplex links with orientations
    $ns duplex-link $n1 $n3 6Mb 10ms DropTail
    $ns duplex-link-op $n1 $n3 orient down

    $ns duplex-link $n2 $n3 6Mb 10ms DropTail
    $ns duplex-link-op $n2 $n3 orient right

    $ns duplex-link $n3 $n5 6Mb 10ms DropTail
    $ns duplex-link-op $n3 $n5 orient right

    $ns duplex-link $n5 $n6 6Mb 10ms DropTail
    $ns duplex-link-op $n5 $n6 orient up

    $ns duplex-link $n5 $n8 6Mb 10ms DropTail
    $ns duplex-link-op $n5 $n8 orient down

    $ns duplex-link $n4 $n3 6Mb 10ms DropTail
    $ns duplex-link-op $n4 $n3 orient left

    $ns duplex-link $n5 $n7 6Mb 10ms DropTail
    $ns duplex-link-op $n5 $n7 orient right
    

    # set queue size limit
    $ns queue-limit $n2 $n3 10

    	# Set TCP variant
	if {$tcp_variant == "Tahoe"} {
	    set tcp [new Agent/TCP]
	} elseif {$tcp_variant == "Linux"} {
	    # Use Linux TCP
	    set tcp [new Agent/TCP/Linux]
	} else {
	    set tcp [new Agent/TCP/$tcp_variant]
	}
	$ns attach-agent $n1 $tcp

    # set tcp sink
    set sink [new Agent/TCPSink]
    $ns attach-agent $n6 $sink

    # setup TCP connection (stream from N1 to N6)
    $ns connect $tcp $sink
    $tcp set fid_ 1

    # setup a FTP over the TCP connection (N1 to N6)
    set ftp [new Application/FTP]
    $ftp attach-agent $tcp
    $ftp set type_ FTP

    # set udp from n2 to n6 (CBR source to null sink)
    set udp [new Agent/UDP]
    $ns attach-agent $n2 $udp

    # set udp sink
    set null [new Agent/Null]
    $ns attach-agent $n6 $null

    # set udp flow direction for CBR stream
    $ns connect $udp $null
    $udp set fid_ 2

    # setup CBR over UDP
    set cbr [new Application/Traffic/CBR]
    $cbr attach-agent $udp
    $cbr set type_ CBR
    $cbr set packet_size_ 1000
    $cbr set rate_ ${cbr_rate}mb
    $cbr set random_ false

    # schedule events for the CBR and FTP agents
    $ns at 0.1 "$cbr start"
    $ns at 1.0 "$ftp start"
    $ns at 6.0 "$ftp stop"
    $ns at 6.5 "$cbr stop"

    # call the finish procedure after 7s simulation
    $ns at 7.0 "finish"

    $ns run
}

# pass parameters
expt1 [lindex $argv 0] [lindex $argv 1]

