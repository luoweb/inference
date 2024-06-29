FROM continuumio/miniconda3:23.10.0-1

COPY . /opt/inference

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.21.1

RUN apt-get -y update \
  && apt install -y build-essential curl procps git libgl1 \
  && mkdir -p $NVM_DIR \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && apt-get -yq clean

ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

ARG PIP_INDEX=https://pypi.org/simple
RUN python -m pip install --upgrade -i "$PIP_INDEX" pip && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    pip install -i "$PIP_INDEX" \
      "xoscar>=0.3.0" \
      "gradio==4.26.0" \
      "typer[all]<0.12.0" \
      pillow \
      click \
      "tqdm>=4.27" \
      tabulate \
      requests \
      pydantic \
      "fastapi==0.110.3" \
      uvicorn \
      "huggingface-hub>=0.19.4" \
      typing_extensions \
      "fsspec==2023.10.0" \
      "s3fs==2023.10.0" \
      "boto3>=1.28.55,<1.28.65" \
      "tensorizer~=2.9.0" \
      "modelscope>=1.10.0" \
      "sse_starlette>=1.6.5" \
      "openai>1" \
      "python-jose[cryptography]" \
      "passlib[bcrypt]" \
      "aioprometheus[starlette]>=23.12.0" \
      pynvml \
      async-timeout \
      "transformers>=4.34.1" \
      "accelerate>=0.20.3" \
      sentencepiece \
      transformers_stream_generator \
      bitsandbytes \
      protobuf \
      einops \
      tiktoken \
      "sentence-transformers>=2.3.1" \
      FlagEmbedding \
      diffusers \
      controlnet_aux \
      orjson \
      auto-gptq \
      optimum \
      peft \
      timm \
      opencv-contrib-python-headless && \
    pip install -i "$PIP_INDEX" -U chatglm-cpp && \
    pip install "llama-cpp-python>=0.2.25,!=0.2.58" --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cpu && \
    cd /opt/inference && \
    python setup.py build_web && \
    git restore . && \
    pip install -i "$PIP_INDEX" --no-deps "."
