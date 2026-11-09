#!/bin/bash
# 43: JupyterLab in /opt/jupyter, with two kernels (R, and Python with GDAL from /opt/gdal-py) and an RStudio launcher
# (jupyter-rsession-proxy, which starts rserver per user). Also jupyterhub-singleuser, which Binder and JupyterHubs run.
# Usage (as root), after 40-r.sh and 41-rstudio.sh. The container image always runs it; a VM with launch.sh --jupyter
# (JUPYTER=1). On a VM, each user starts their own server on localhost and reaches it through the SSH tunnel, as for
# RStudio:  ssh -L 8888:localhost:8888 ...  then  jupyter lab --no-browser   (JupyterLab listens on localhost by default)
set -euo pipefail
J=/opt/jupyter
export UV_PYTHON_DOWNLOADS=never PATH="$J/bin:$PATH"

echo "== JupyterLab in $J"
[ -x "$J/bin/python" ] || uv venv -q --python /usr/bin/python3 "$J"
uv pip install -q --python "$J/bin/python" jupyterlab notebook jupyterhub jupyter-server-proxy jupyter-rsession-proxy
echo "export PATH=\"$J/bin:\$PATH\"" > /etc/profile.d/jupyter.sh

echo "== kernels: Python (GDAL), R"
uv pip install -q --python /opt/gdal-py/bin/python ipykernel
/opt/gdal-py/bin/python -m ipykernel install --prefix "$J" --name gdal-py --display-name "Python (GDAL)"
# hide the venv's own GDAL-less Python kernel: one Python, the one with GDAL
mkdir -p "$J/etc/jupyter"
echo '{"KernelSpecManager": {"ensure_native_kernel": false}}' > "$J/etc/jupyter/jupyter_server_config.json"
rm -rf "$J/share/jupyter/kernels/python3"
Rscript -e 'if (!requireNamespace("IRkernel", quietly = TRUE)) install.packages("IRkernel", lib = "/usr/local/lib/R/site-library")
            IRkernel::installspec(user = FALSE, prefix = "/opt/jupyter", displayname = "R")'

echo "== checks"
jupyter --version | grep -E 'jupyterlab|jupyter_server'
jupyterhub-singleuser --version
jupyter kernelspec list
jupyter server extension list 2>&1 | grep -E 'jupyter_server_proxy.*enabled'
