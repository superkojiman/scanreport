scanreport
==========

Nmap is a favorite tool when it comes to running port scans. The output can be a bit much however, especially when you’re dealing with many targets with many services. Nmap is capable of producing reports in text, grepable, and XML formats. I wanted a lightweight tool that could quickly parse my Nmap reports and display clean results. I couldn’t find one that did what I wanted, so I hacked something together. The end result, is a script called scanreport.sh

scanreport.sh reads an Nmap grepable output file and displays the results based on IP address, port number, or service. The tool is most helpful when you’ve got several machines that you’ve scanned, so as an example, we’ll scan five machines and examine the output. This works well with [onetwopunch](https://github.com/superkojiman/onetwopunch). For more details, see [http://blog.techorganic.com/2012/09/15/parsing-nmaps-output/](http://blog.techorganic.com/2012/09/15/parsing-nmaps-output/) 
