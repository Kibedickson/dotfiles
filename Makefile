dns:
	valet install
	echo "nameserver 8.8.8.8\nnameserver 8.8.1.1\nnameserver 1.1.1.1" | sudo tee /opt/valet-linux/dns-servers
