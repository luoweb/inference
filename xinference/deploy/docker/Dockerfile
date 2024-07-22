# FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-devel
FROM pytorch/pytorch:2.1.2-cuda11.8-cudnn8-devel
# ARG BASE_TAG=main-base
# FROM winglian/axolotl-base:$BASE_TAG
# FROM registry.cn-hangzhou.aliyuncs.com/roweb/axolotl-base:$BASE_TAG
# FROM vllm/vllm-openai:latest
# FROM python:3.11-slim 

COPY . /opt/inference
WORKDIR /opt/inference

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.21.1

RUN apt-get -y update \
  && apt install -y curl procps git libgl1 ffmpeg \
  && mkdir -p $NVM_DIR \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
  # && curl -o- https://mirror.ghproxy.com/https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
  # && curl -o- https://mirror.ghproxy.com/https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | \
  #  sed -e 's#https://github.com/#https://mirror.ghproxy.com/https://github.com/#g'| \
  # sed -e 's#https://raw.githubusercontent.com/#https://mirror.ghproxy.com/https://raw.githubusercontent.com/#g'| bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && apt-get -yq clean

ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib/python3.10/dist-packages/nvidia/cublas/lib

ARG PIP_INDEX=https://pypi.org/simple
RUN pip install --upgrade -i "$PIP_INDEX" pip && \
    pip install -i "$PIP_INDEX" "diskcache>=5.6.1" "jinja2>=2.11.3" && \
    # use pre-built whl package for llama-cpp-python, otherwise may core dump when init llama in some envs
    # pip install "llama-cpp-python" -i https://abetlen.github.io/llama-cpp-python/whl/cu121 && \
    pip install llama-cpp-python --prefer-binary --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu118 && \
    CMAKE_ARGS="-DGGML_CUBLAS=ON" pip install -i "$PIP_INDEX" -U "chatglm-cpp<0.4.0" && \
    cd /opt/inference && \
    python3 setup.py build_web && \
    git restore . && \
    pip install -i "$PIP_INDEX" --no-deps "." && \
    # clean packages
    pip cache purge

ENTRYPOINT []
