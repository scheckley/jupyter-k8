# Use a lightweight base image with Python support
FROM python:3.11-slim

# Set environment variables for non-root execution
ENV USER=jupyter \
    HOME=/home/jupyter \
    JUPYTERLAB_DIR=$HOME/.jupyterlab \
    PATH=$HOME/.local/bin:$PATH

# Create a non-root user and the necessary directories
RUN useradd -m -s /bin/bash $USER && \
    mkdir -p $JUPYTERLAB_DIR && \
    chown -R $USER:$USER $HOME

# Switch to the non-root user
USER $USER

# Install JupyterLab and set the working directory
WORKDIR $HOME
RUN pip install --no-cache-dir --user jupyterlab && \
    jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> $HOME/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> $HOME/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.port = 8888" >> $HOME/.jupyter/jupyter_server_config.py

# Expose the default JupyterLab port
EXPOSE 8888

# Set the entry point to launch JupyterLab
ENTRYPOINT ["jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root"]

