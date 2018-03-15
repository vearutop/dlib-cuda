@echo off
echo Downloading CUDA toolkit 9
appveyor DownloadFile  https://developer.nvidia.com/compute/cuda/9.0/prod/local_installers/cuda_9.0.176_windows-exe -FileName cuda_9.0.176_windows.exe
echo Installing CUDA toolkit 9
cuda_9.0.176_windows.exe -s compiler_9.0 ^
                           cublas_9.0 ^
                           cublas_dev_9.0 ^
                           cudart_9.0 ^
                           curand_9.0 ^
                           curand_dev_9.0
echo Downloading cuDNN
appveyor DownloadFile https://github.com/vearutop/builds/releases/download/secret1/nddcu.7z -FileName cudnn7.7z
7z x -p%pass% cudnn7.7z -ocudnn

cd cudnn\cuda
dir bin
dir lib 
dir include
rem move the directories
for /d %%i in (*) do move "%%i" "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0"
cd ../..

dir .

dir "%ProgramFiles%"
dir "C:\Program Files"
dir "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA"
dir "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0"
dir "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0\bin"

if NOT EXIST "%ProgramFiles%\NVIDIA GPU Computing Toolkit\CUDA\v9.0\bin\cudart64_90.dll" ( 
echo "Failed to install CUDA"
exit /B 1
)

set PATH=%ProgramFiles%\NVIDIA GPU Computing Toolkit\CUDA\v9.0\bin;%ProgramFiles%\NVIDIA GPU Computing Toolkit\CUDA\v9.0\libnvvp;%PATH%

nvcc -V
set CUDA_TOOLKIT_ROOT_DIR="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0"
set CUDA_NVCC_EXECUTABLE="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0\bin\nvcc.exe"
set CUDA_INCLUDE_DIRS="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0\include"
set CUDA_CUDART_LIBRARY="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.0\bin\cudart64_90.dll"

git clone https://github.com/davisking/dlib.git
cd dlib
git checkout v19.9

set PYTHON="C:\\Python36-x64"
%PYTHON%\python.exe -m pip install wheel
%PYTHON%\python.exe setup.py build --yes USE_AVX_INSTRUCTIONS
dir build