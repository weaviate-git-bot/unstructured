FROM cgr.dev/chainguard/wolfi-base:latest

WORKDIR /app

USER root

COPY ./docker-packages/*.apk packages/
COPY ./requirements/*.txt requirements/
COPY unstructured unstructured
COPY test_unstructured test_unstructured
COPY example-docs example-docs

RUN apk update && apk add py3.11-pip mesa-gl glib cmake && \
  apk add --allow-untrusted packages/pandoc-3.1.8-r0.apk && \
  apk add --allow-untrusted packages/poppler-23.09.0-r0.apk && \
  apk add --allow-untrusted packages/leptonica-1.83.0-r0.apk && \
  apk add --allow-untrusted packages/tesseract-5.3.2-r0.apk && \
  apk add --allow-untrusted packages/libreoffice-7.6.5-r0.apk && \
  apk add bash && \
  apk add libmagic && \
  mv /share/tessdata/configs /usr/local/share/tessdata/ && \
  mv /share/tessdata/tessconfigs /usr/local/share/tessdata/ && \
  ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/local/bin/libreoffice && \
  ln -s /usr/local/lib/libreoffice/program/soffice.bin /usr/local/bin/soffice && \
  chmod +x /usr/local/lib/libreoffice/program/soffice.bin && \
  chmod +x /usr/local/bin/libreoffice && \
  chmod +x /usr/local/bin/soffice

RUN chown -R nonroot:nonroot /app

USER nonroot

RUN pip3.11 install --no-cache-dir --user -r requirements/base.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/test.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/extra-csv.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/extra-docx.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/extra-epub.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/extra-markdown.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/extra-msg.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/extra-odt.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/extra-pdf-image.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/extra-pptx.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/extra-xlsx.txt && \
  pip3.11 install --no-cache-dir --user -r requirements/huggingface.txt && \
  pip3.11 install unstructured.paddlepaddle

RUN python3.11 -c "import nltk; nltk.download('punkt')" && \
  python3.11 -c "import nltk; nltk.download('averaged_perceptron_tagger')" && \
  python3.11 -c "from unstructured.partition.model_init import initialize; initialize()" && \
  python3.11 -c "from unstructured_inference.models.tables import UnstructuredTableTransformerModel; model = UnstructuredTableTransformerModel(); model.initialize('microsoft/table-transformer-structure-recognition')"

ENV PATH="${PATH}:/home/nonroot/.local/bin"
ENV TESSDATA_PREFIX=/usr/local/share/tessdata

CMD ["/bin/bash"]
