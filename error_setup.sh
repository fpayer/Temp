#!/bin/bash

CONFIG_FILE=/etc/nginx/sites-available/proxy

# Immediately exit if not run on challenge server
if [[ $(hostname) != *"challenge"* ]]; then
  echo "Must run on challenge server"
  exit
fi

# Enable write to config
sudo chmod +w $CONFIG_FILE

# Create error page
echo "<html><body><center><h1>502 Bad Gateway</h1></center><hr><center>You may need to wait a few minutes for the challenge server to boot up.</center></body></html>" > /home/user/challengeServer/src/static/502.html

# Add config for error page
if ! grep -q "error_page 502 /502.html" "$CONFIG_FILE"; then
	sudo sed -i '105i \
	error_page 502 /502.html;\n\
	location /502.html {\
		root /home/user/challengeServer/src/static/;\
	}\n' "$CONFIG_FILE"
fi

# Reboot nginx
sudo service nginx restart

echo "Done"
