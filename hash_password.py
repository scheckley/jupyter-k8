# hash_password.py
import os
from jupyter_server.auth import passwd

# Get password from environment variable
password = os.environ.get("JUPYTER_PASSWORD")

# Check if the password is available
if not password:
    raise ValueError("JUPYTER_PASSWORD environment variable not set.")

# Hash the password
hashed_password = passwd(password)

# Save the hashed password to a file
with open("/opt/app-root/.hashed_password", "w") as f:
    f.write(hashed_password)
