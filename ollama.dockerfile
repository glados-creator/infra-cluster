version: '3.8'

services:
  ollama:
    image: docker.io/ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    # This is the correct way to pass the GPU in Podman
    devices:
      - nvidia.com/gpu=all
    # Often needed for rootless Podman or SELinux
    security_opt:
      - label=disable

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    restart: unless-stopped
    ports:
      - "3000:8080"
    environment:
      - 'OLLAMA_BASE_URL=http://ollama:11434'
    volumes:
      - open_webui_data:/app/backend/data

volumes:
  ollama_data:
  open_webui_data: