# Use a lightweight base image with Python support
FROM python:3.11-slim

# Set environment variables for JupyterLab
ENV HOME=/opt/app-root \
    PATH=/opt/app-root/.local/bin:$PATH

# Create necessary directories and adjust permissions for OpenShift non-root execution
RUN mkdir -p /opt/app-root/.local/share/jupyter/runtime && \
    mkdir -p /opt/app-root/.local/bin && \
    chmod -R 777 /opt/app-root/.local

# Set the working directory
WORKDIR /opt/app-root

# Install JupyterLab and jupyter-server into the user's local directory
RUN pip install --no-cache-dir --user jupyterlab jupyter-server

# Ensure JupyterLab is installed correctly by building the application assets
RUN /opt/app-root/.local/bin/jupyter lab build

# Generate JupyterLab configuration without any authentication setup
RUN /opt/app-root/.local/bin/jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> /opt/app-root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> /opt/app-root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.port = 8888" >> /opt/app-root/.jupyter/jupyter_server_config.py

# Expose the default JupyterLab port
EXPOSE 8888

# Set the entry point to launch JupyterLab
ENTRYPOINT ["/opt/app-root/.local/bin/jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
