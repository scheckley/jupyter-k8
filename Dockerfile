# Use a lightweight base image with Python and FIPS support
FROM python:3.12-slim-bullseye

# Set environment variables for JupyterLab
ENV HOME=/opt/app-root \
    PATH=/opt/app-root/.local/bin:$PATH

# Install Node.js (version 20.x) and npm
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p $HOME/.local/share/jupyter/runtime && \
    mkdir -p $HOME/.local/bin && \
    mkdir -p $HOME/workspace && \
    chmod -R 777 $HOME/.local && \
    chmod -R 777 $HOME/workspace

# Change ownership of the workspace directory to ensure write access
RUN chown -R 1000:1000 $HOME

# Set the working directory to a writable location
WORKDIR $HOME/workspace

# Install JupyterLab and jupyter-server into the user's local directory
RUN pip install --no-cache-dir --user jupyterlab jupyter-server matplotlib seaborn pandas polars numpy scipy && \
    ls $HOME/.local/bin  # List installed binaries for verification

# Ensure JupyterLab is installed correctly by building the application assets
RUN $HOME/.local/bin/jupyter lab build

# Generate JupyterLab configuration without any authentication setup
RUN $HOME/.local/bin/jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> $HOME/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> $HOME/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.port = 8888" >> $HOME/.jupyter/jupyter_server_config.py

# Expose the default JupyterLab port
EXPOSE 8888

# Set the entry point to launch JupyterLab
ENTRYPOINT ["sh", "-c", "$HOME/.local/bin/jupyter lab --no-browser --ip=0.0.0.0 --port=8888 --notebook-dir=$HOME/workspace"]
