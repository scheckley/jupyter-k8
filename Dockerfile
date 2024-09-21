# Use a lightweight base image with Python support
FROM python:3.11-slim

# Set environment variables for non-root execution
ENV USER=jupyter \
    HOME=/home/jupyter \
    JUPYTERLAB_DIR=$HOME/.jupyterlab

# Create necessary directories and adjust permissions for OpenShift non-root execution
RUN mkdir -p $HOME/.local/share/jupyter/runtime && \
    mkdir -p $JUPYTERLAB_DIR && \
    chmod -R 777 $HOME/.local/share/jupyter && \
    chmod -R 777 $JUPYTERLAB_DIR

# Install JupyterLab into the user's local directory
RUN pip install --no-cache-dir --user jupyterlab

# Use the full path to Jupyter executable to ensure it is found
RUN $HOME/.local/bin/jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> $HOME/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> $HOME/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.port = 8888" >> $HOME/.jupyter/jupyter_server_config.py

# Expose the default JupyterLab port
EXPOSE 8888

# Set the entry point to launch JupyterLab
ENTRYPOINT ["$HOME/.local/bin/jupyter", "lab", "--no-browser", "--ip=0.0.0.0"]

