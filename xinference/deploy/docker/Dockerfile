# FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-devel
FROM pytorch/pytorch:2.1.2-cuda11.8-cudnn8-devel
# ARG BASE_TAG=main-base
# FROM winglian/axolotl-base:$BASE_TAG
# FROM registry.cn-hangzhou.aliyuncs.com/roweb/axolotl-base:$BASE_TAG

COPY . /opt/inference

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.21.1

RUN apt-get -y update \
  && apt install -y curl procps git libgl1 \
  && mkdir -p $NVM_DIR \
  # && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
  # && curl -o- https://mirror.ghproxy.com/https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
  && curl -o- https://mirror.ghproxy.com/https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | \
   sed -e 's#https://github.com/#https://mirror.ghproxy.com/https://github.com/#g'| \
  sed -e 's#https://raw.githubusercontent.com/#https://mirror.ghproxy.com/https://raw.githubusercontent.com/#g'| bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && apt-get -yq clean

ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

ARG PIP_INDEX=https://pypi.org/simple
RUN python -m pip install --upgrade -i "$PIP_INDEX" pip && \
    # uninstall builtin torchvision, and let xinference decide which version to be installed
    pip uninstall -y torchvision torchaudio && \
    pip install -i "$PIP_INDEX" "diskcache>=5.6.1" "jinja2>=2.11.3" && \
    # use pre-built whl package for llama-cpp-python, otherwise may core dump when init llama in some envs
    # pip install "llama-cpp-python" -i https://abetlen.github.io/llama-cpp-python/whl/cu121 && \
    pip install "llama-cpp-python" && \
    CMAKE_ARGS="-DGGML_CUBLAS=ON" pip install -i "$PIP_INDEX" -U "chatglm-cpp<0.4.0" && \
    cd /opt/inference && \
    python setup.py build_web && \
    git restore . && \
    pip install -i "$PIP_INDEX" ".[all]" && \
    pip uninstall -y opencv-contrib-python && \
    pip install -i "$PIP_INDEX" opencv-contrib-python-headless && \
    # clean packages
    pip cache purge && \
    conda clean --force-pkgs-dirs -y
