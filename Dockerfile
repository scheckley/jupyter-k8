# Use a lightweight base image with Python support
FROM python:3.11-slim

# Set environment variables for JupyterLab
ENV HOME=/opt/app-root \
    JUPYTERLAB_DIR=$HOME/.jupyterlab \
    PATH=$HOME/.local/bin:$PATH

# Create necessary directories and adjust permissions for OpenShift non-root execution
RUN mkdir -p $HOME/.local/share/jupyter/runtime && \
    mkdir -p $JUPYTERLAB_DIR && \
    chmod -R 777 $HOME/.local && \
    chmod -R 777 $JUPYTERLAB_DIR

# Set the working directory
WORKDIR $HOME

# Install JupyterLab and jupyter-server into the user's local directory
RUN pip install --no-cache-dir --user jupyterlab jupyter-server

# Ensure JupyterLab is installed correctly
RUN $HOME/.jupyter/jupyter lab build

# Generate JupyterLab config and set server options
RUN $HOME/.local/bin/jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> $HOME/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> $HOME/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.port = 8888" >> $HOME/.jupyter/jupyter_server_config.py

# Expose the default JupyterLab port
EXPOSE 8888

# Set the entry point to launch JupyterLab
ENTRYPOINT ["/opt/app-root/.local/bin/jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--port=8888"]

