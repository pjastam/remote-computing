# Make remote cluster -----------------------------------------------------

# Command to run on each remote machine
# The script loads the docker-donors-ngo-restrictions Docker image
# --net=host allows it to communicate back to this computer
rscript <- c("sudo", "docker", "run", "--net=host", 
             "andrewheiss/docker-donors-ngo-restrictions", "Rscript")

# Connect and create a cluster
cl <- makeClusterPSOCK(
  ips,

  # User name; DO droplets use root by default
  user = "root",

  # Use private SSH key registered with DO
  rshopts = c(
    "-o", "StrictHostKeyChecking=no",
    "-o", "IdentitiesOnly=yes",
    "-i", ssh_private_key_file
  ),

  rscript = rscript,

  # Things to run each time the remote instance starts
  rscript_args = c(
    # Set up .libPaths() for the root user and install future/purrr/furrr packages
    # Technically future and furrr are already installed on 
    # andrewheiss/docker-donors-ngo-restrictions, so these won't do anything
    "-e", shQuote("local({p <- Sys.getenv('R_LIBS_USER'); dir.create(p, recursive = TRUE, showWarnings = FALSE); .libPaths(p)})"),
    "-e", shQuote("if (!requireNamespace('furrr', quietly = TRUE)) install.packages('furrr')"),
    # Make sure the remote computer uses all CPU cores with Stan
    "-e", shQuote("options(mc.cores = parallel::detectCores())")
  ),

  dryrun = FALSE
)

# Use the cluster of computers as the backend for future and furrr functions
plan(cluster, workers = cl)
