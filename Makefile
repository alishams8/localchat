# Makefile for downloading and running Ollama and Lama 3.1 based on OS

# Define the download URLs from GitHub for different OS for Ollama
OLLAMA_MACOS_URL=https://github.com/ollama/ollama/releases/download/v0.3.0/Ollama-darwin.zip
OLLAMA_LINUX_URL=https://github.com/ollama/ollama/releases/download/v0.3.0/Ollama-linux.tar.gz
OLLAMA_WINDOWS_URL=https://github.com/ollama/ollama/releases/download/v0.3.0/Ollama-windows.zip

# Define the output file names based on OS for Ollama
OLLAMA_MACOS_FILE=Ollama-darwin.zip
OLLAMA_LINUX_FILE=Ollama-linux.tar.gz
OLLAMA_WINDOWS_FILE=Ollama-windows.zip

# Detect the operating system
UNAME_S := $(shell uname -s)

all: download_ollama run_ollama run_lama

download_ollama:
ifeq ($(UNAME_S),Darwin)
	@echo "Detected macOS. Downloading Ollama from $(OLLAMA_MACOS_URL)..."
	curl -L -o $(OLLAMA_MACOS_FILE) $(OLLAMA_MACOS_URL)
	@echo "Download completed: $(OLLAMA_MACOS_FILE)"
else ifeq ($(UNAME_S),Linux)
	@echo "Detected Linux. Downloading Ollama from $(OLLAMA_LINUX_URL)..."
	curl -L -o $(OLLAMA_LINUX_FILE) $(OLLAMA_LINUX_URL)
	@echo "Download completed: $(OLLAMA_LINUX_FILE)"
else ifeq ($(UNAME_S),Windows_NT)
	@echo "Detected Windows. Downloading Ollama from $(OLLAMA_WINDOWS_URL)..."
	curl -L -o $(OLLAMA_WINDOWS_FILE) $(OLLAMA_WINDOWS_URL)
	@echo "Download completed: $(OLLAMA_WINDOWS_FILE)"
else
	@echo "Unsupported operating system: $(UNAME_S)"
	@echo "No download URL provided for this OS."
	@exit 1
endif

run_ollama:
ifeq ($(UNAME_S),Darwin)
	@echo "Running Ollama on macOS..."
	unzip -o $(OLLAMA_MACOS_FILE) -d Ollama_mac
	open Ollama_mac/Ollama.app
else ifeq ($(UNAME_S),Linux)
	@echo "Running Ollama on Linux..."
	tar -xzf $(OLLAMA_LINUX_FILE) -C Ollama_linux
	chmod +x Ollama_linux/Ollama
	./Ollama_linux/Ollama
else ifeq ($(UNAME_S),Windows_NT)
	@echo "Running Ollama on Windows..."
	unzip -o $(OLLAMA_WINDOWS_FILE) -d Ollama_windows
	# Start Ollama executable (modify this according to actual executable name)
	start Ollama_windows/Ollama.exe
else
	@echo "Unsupported operating system: $(UNAME_S)"
	@echo "Cannot run the application on this OS."
	@exit 1
endif

UNAME_S := $(shell uname -s)

run_lama:
ifeq ($(UNAME_S),Darwin)
	@echo "Running Lama 3.1 on macOS as a daemon..."
	@nohup Ollama run llama3.1 &>/dev/null &
else ifeq ($(UNAME_S),Linux)
	@echo "Running Lama 3.1 on Linux as a daemon..."
	@nohup Ollama run llama3.1 &>/dev/null &
else ifeq ($(UNAME_S),Windows_NT)
	@echo "Running Lama 3.1 on Windows as a daemon..."
	@start /B Ollama_windows\\Ollama.exe run llama3.1
else
	@echo "Unsupported operating system: $(UNAME_S)"
	@echo "Cannot run Lama 3.1 on this OS."
	@exit 1
endif

run_frontend:
	@echo "Running frontend as a Docker container..."
	@docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

stop_frontend:
	@echo "Stopping and removing the frontend Docker container..."
	@docker stop open-webui
	@docker rm open-webui