sudo apt update -y
sudo apt full-upgrade -y

sudo apt-get install clang llvm -y

sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng-dev -y

sudo apt-get install libgl1-mesa-dev -y
sudo apt install libtbb-dev -y
sudo apt-get install libeigen3-dev -y
sudo apt-get install libxml2-dev -y

mkdir ~/Dev
mkdir ~/Dev/src
cd ~/Dev/src

git clone https://github.com/halide/Halide.git --branch release_2019_08_27
success=$?
echo "git clone Exit status"
echo $success
if [[ $success -eq 0 ]];
then
	mkdir ~/Dev/install
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
