#sudo apt update -y
#sudo apt full-upgrade -y

sudo apt-get install clang llvm -y
sudo apt-get install build-essential cmake pkg-config -y
sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng-dev -y

sudo apt-get install libgl1-mesa-dev -y
sudo apt install libtbb-dev -y
sudo apt-get install libeigen3-dev -y
sudo apt-get install libxml2-dev -y

mkdir ~/Dev
mkdir ~/Dev/src
mkdir ~/Dev/install
cd ~/Dev/src

git clone https://github.com/halide/Halide.git --branch release_2019_08_27
success=$?
if [[ $success -eq 0 ]];
then
	mkdir ~/Dev/install/halide
	cd ~/Dev/src/Halide
	mkdir build
	cd build
	
	cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_DIR=/usr/bin -DCMAKE_INSTALL_PREFIX:PATH=~/Dev/install/halide/Release ..
	success=$?
	if [[ $success -eq 0 ]];
	then
		echo "cmake successfull"
		make -j4
		success=$?
		if [[ $success -eq 0 ]];
		then
			echo "MAKE -J4 SUCCESSFULL"
			make install
			success=$?
			if [[ $success -eq 0 ]];
			then
				echo "HALIDE setup complete"
			else
				echo "ERROR::HALIDE::make install failed"
				exit 1
			fi
		else
			echo "ERROR::HALIDE::make -j4 failed"
			exit 1
		fi
	else
		echo "ERROR::HALIDE::cmake failed"
		exit 1
	fi
fi

sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y
sudo apt-get install libxvidcore-dev libx264-dev -y
sudo apt-get install libfontconfig1-dev libcairo2-dev -y
sudo apt-get install libgdk-pixbuf2.0-dev libpango1.0-dev -y
sudo apt-get install libgtk2.0-dev libgtk-3-dev -y
sudo apt-get install libatlas-base-dev gfortran -y
sudo apt-get install python3-dev -y

wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py
sudo rm -rf ~/.cache/pip

pip3 install "picamera[array]" -y
pip3 install numpy -y

mkdir ~/Dev/install/opencv
mkdir ~/Dev/install/opencv/Release
mkdir ~/Dev/install/opencv/Debug
cd ~/Dev/src/

git clone https://github.com/opencv/opencv.git --branch 4.3.0
success=$?
if [[ $success -eq 0 ]];
then
	git clone https://github.com/opencv/opencv_contrib.git --branch 4.3.0
	success=$?
	if [[ $success -eq 0 ]];
	then	
		cd ~/Dev/src/opencv
		mkdir build_release
		mkdir build_debug
		cd build_release
		
		cmake -D CMAKE_BUILD_TYPE=RELEASE \
			-D CMAKE_INSTALL_PREFIX=~/Dev/install/opencv/Release \
			-D OPENCV_EXTRA_MODULES_PATH=~/Dev/src/opencv_contrib/modules \
			-D ENABLE_CXX11=ON \
			-D WITH_HALIDE=ON \
			-D HALIDE_ROOT_DIR=~/Dev/install/halide/Release \
			-D HALIDE_INCLUDE_DIR=~/Dev/install/halide/Release/include \
			-D HALIDE_LIBRARY=~/Dev/install/halide/Release/bin/libHalide.so \
			-D ENABLE_NEON=ON \
			-D ENABLE_VFPV3=ON \
			-D WITH_TBB=ON \
			-D BUILD_TBB=ON \
			-D BUILD_TESTS=OFF \
			-D INSTALL_PYTHON_EXAMPLES=OFF \
			-D OPENCV_ENABLE_NONFREE=ON \
			-D CMAKE_SHARED_LINKER_FLAGS=-latomic \
			-D BUILD_EXAMPLES=OFF ..
		success=$?
		if [[ $success -eq 0 ]];
		then	
			make -j4
			success=$?
			if [[ $success -eq 0 ]];
			then
				make install
				success=$?
				if [[ $success -ne 0 ]];
				then
					echo "ERROR::OPENCV::RELEASE:: make install failed"
					exit 1
				fi
			else
				echo "ERROR::OPENCV::RELEASE:: make -j4 failed"
				exit 1
			fi
		else
			echo "ERROR::OPENCV::RELEASE:: cmake failed"
			exit 1
		fi
	
		cd ../build_debug
		cmake -D CMAKE_BUILD_TYPE=DEBUG \
			-D CMAKE_INSTALL_PREFIX=~/Dev/install/opencv/Debug \
			-D OPENCV_EXTRA_MODULES_PATH=~/Dev/src/opencv_contrib/modules \
			-D ENABLE_CXX11=ON \
			-D WITH_HALIDE=ON \
			-D HALIDE_ROOT_DIR=~/Dev/install/halide/Release \
			-D HALIDE_INCLUDE_DIR=~/Dev/install/halide/Release/include \
			-D HALIDE_LIBRARY=~/Dev/install/halide/Release/bin/libHalide.so \
			-D ENABLE_NEON=ON \
			-D ENABLE_VFPV3=ON \
			-D WITH_TBB=ON \
			-D BUILD_TBB=ON \
			-D BUILD_TESTS=OFF \
			-D INSTALL_PYTHON_EXAMPLES=OFF \
			-D OPENCV_ENABLE_NONFREE=ON \
			-D CMAKE_SHARED_LINKER_FLAGS=-latomic \
			-D BUILD_EXAMPLES=OFF ..
		success=$?
		if [[ $success -eq 0 ]];
		then	
			make -j4
			success=$?
			if [[ $success -eq 0 ]];
			then
				make install
				success=$?
				if [[ $success -ne 0 ]];
				then
					echo "ERROR::OPENCV::DEBUG:: make install failed"
					exit 1
				fi
			else
				echo "ERROR::OPENCV::DEBUG:: make -j4 failed"
				exit 1
			fi
		else
			echo "ERROR::OPENCV::DEBUG:: cmake failed"
			exit 1
		fi
	else
		echo "ERROR::OPENCV git clone opencv_contrib failed"
		exit 1
	fi
else
	echo "ERROR::OPENCV git clone opencv failed"
	exit 1
fi	
