FROM buildpack-deps:focal-scm

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV NB_USER jovyan
ENV NB_UID 1000

ENV CONDA_DIR /opt/conda

ENV PATH ${CONDA_DIR}/bin:$PATH

RUN adduser --disabled-password --gecos "Default Jupyter user" ${NB_USER}

# Install these without 'recommended' packages to keep image smaller.
# Useful utils that folks sort of take for granted
RUN apt-get update -qq --yes && \
    apt-get install --yes --no-install-recommends -qq \
        htop \
        less \
        man \
        nano \
        screen \
        tar \
        tmux \
        wget \
        vim \
        locales > /dev/null

RUN echo "${LC_ALL} UTF-8" > /etc/locale.gen && \
    locale-gen

# for nbconvert & notebook-to-pdf
RUN apt-get update -qq --yes && \
    apt-get install --yes -qq \
        pandoc \
        texlive-xetex \
        texlive-fonts-recommended \
        > /dev/null

WORKDIR /home/jovyan

COPY install-miniforge.bash /tmp/install-miniforge.bash
RUN /tmp/install-miniforge.bash

USER ${NB_USER}

COPY environment.yml /tmp/

RUN conda env update -p ${CONDA_DIR} -f /tmp/environment.yml

COPY install-jupyter-extensions.bash /tmp/install-jupyter-extensions.bash
RUN /tmp/install-jupyter-extensions.bash

# Set bash as shell in terminado.
ADD jupyter_notebook_config.py  ${CONDA_PREFIX}/etc/jupyter/
# Disable history.
ADD ipython_config.py ${CONDA_PREFIX}/etc/ipython/
