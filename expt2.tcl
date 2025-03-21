proc expt1 {cbr_rate tcp_variant1 tcp_variant2} {
        global ns tf
        # create a simulator object
        set ns [new Simulator]

        # Save data to a trace file
        set tf [open expt2.tr w]
        $ns trace-all $tf

        # Finish procedure function
        proc finish {} {
            global ns tf
            $ns flush-trace
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

        # set tcp from n2 to n6 (first TCP variant, could be Tahoe or other)
         if {$tcp_variant1 == "Tahoe"} {
       	 set tcp1 [new Agent/TCP]
   	 } else {
       	  set tcp1 [new Agent/TCP/$tcp_variant1]
    	}
      	$ns attach-agent $n2 $tcp1

        # set tcp sink
        set sink1 [new Agent/TCPSink]
        $ns attach-agent $n6 $sink1

        # setup connection
        $ns connect $tcp1 $sink1
        $tcp1 set fid_ 1

        # setup a FTP over the TCP connection
        set ftp1 [new Application/FTP]
        $ftp1 attach-agent $tcp1
        $ftp1 set type_ FTP

        # set tcp from n4 to n6 (second TCP variant)
        set tcp2 [new Agent/TCP/$tcp_variant2]
        $ns attach-agent $n4 $tcp2

        # set tcp sink
        set sink2 [new Agent/TCPSink]
        $ns attach-agent $n6 $sink2

        # setup connection
        $ns connect $tcp2 $sink2
        $tcp2 set fid_ 2

        # setup a FTP over the TCP connection
        set ftp2 [new Application/FTP]
        $ftp2 attach-agent $tcp2
        $ftp2 set type_ FTP

        # set udp from n1 to n6
        set udp [new Agent/UDP]
        $ns attach-agent $n1 $udp

        # set udp sink
        set null [new Agent/Null]
        $ns attach-agent $n6 $null

        # set udp flow direction
        $ns connect $udp $null
        $udp set fid_ 3

        # setup CBR over UDP
        set cbr [new Application/Traffic/CBR]
        $cbr attach-agent $udp
        $cbr set type_ CBR
        $cbr set packet_size_ 1000
        $cbr set rate_ ${cbr_rate}mb
        $cbr set random_ false

        # schedule events for the CBR and FTP agents
        $ns at 0.1 "$cbr start"
        $ns at 1.0 "$ftp1 start"
        $ns at 1.0 "$ftp2 start"
        $ns at 6.0 "$ftp2 stop"
        $ns at 6.0 "$ftp1 stop"
        $ns at 6.5 "$cbr stop"

        # call the finish procedure after 7s simulation
        $ns at 7.0 "finish"

        $ns run
}

# pass parameters (for example: Tahoe for first TCP variant and Reno for the second)
expt1 [lindex $argv 0] [lindex $argv 1] [lindex $argv 2]

