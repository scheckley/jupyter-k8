# hash_password.py
import os
from notebook.auth.security import passwd

# Get password from environment variable
password = os.environ.get("JUPYTER_PASSWORD")

# Hash the password
hashed_password = passwd(password)

# Save the hashed password to a file
with open("/opt/app-root/.hashed_password", "w") as f:
    f.write(hashed_password)
