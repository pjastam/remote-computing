# Set up remote machines --------------------------------------------------

# Create two new droplets with Docker pre-installed
# Here I'm using "s-4vcpu-8gb", which has 4 CPUs and 8 GB of RAM.
# Run analogsea::sizes() to see all the available sizes
droplet1 <- docklet_create(region = "sfo2", size = "s-4vcpu-8gb")
droplet2 <- docklet_create(region = "sfo2", size = "s-4vcpu-8gb")

# Pull the docker image with the environment for this project
#
# Here I'm using andrewheiss/docker-donors-ngo-restrictions because it already
# has rstan and friends installed; none of the rocker R images do that
#
# NB: Wait for a minute before running this so that Docker is ready to
# run on the remote machines
droplet(droplet1$id) %>% 
  docklet_pull("andrewheiss/docker-donors-ngo-restrictions")

droplet(droplet2$id) %>% 
  docklet_pull("andrewheiss/docker-donors-ngo-restrictions")

# Get IP addresses
ip1 <- droplet(droplet1$id)$networks$v4[[1]]$ip_address
ip2 <- droplet(droplet2$id)$networks$v4[[1]]$ip_address

ips <- c(ip1, ip2)
