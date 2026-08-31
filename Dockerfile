FROM ubuntu:24.04

# Setup environment variables
ENV LC_ALL=C.UTF-8 LANG=C.UTF-8 TZ=Etc/UTC PATH="/root/.local/bin:${PATH}"

# Setup base system
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
        antiword \
        apparmor-utils \
        build-essential \
        exiftool \
        ffmpeg \
        flac \
        lame \
        libcairo2-dev \
        libharfbuzz0b \
        libjpeg-dev \
        libmad0 \
        libpango-1.0-0 \
        libpangoft2-1.0-0 \
        libreoffice-nogui \
        libsox-fmt-mp3 \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        pipx \
        poppler-utils \
        python3-dev \
        sox \
        swig \
        tesseract-ocr \
        unrar \
        unrtf && \
    sed '/^profile libreoffice-soffice \/usr\/lib\/libreoffice\/program\/soffice.bin/a owner @{HOME}\/pandora\/tasks\/\*\* rwk,/' /etc/apparmor.d/usr.lib.libreoffice.program.soffice.bin -i && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /pandora

# Setup Poetry
RUN pipx install poetry

# Copy project files
COPY . .

# Finalize setup
RUN mkdir -p tasks && \
    echo 'PANDORA_HOME="/pandora"' > .env && \
    poetry install --without=dev && \
    poetry run tools/3rdparty.py