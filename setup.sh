cd ~

sudo apt install -y ffmpeg zip
mkdir ~/movie
mkdir ~/volume
mkdir ~/volume/datasets
mkdir ~/volume/datasets/pose
mkdir ~/volume/datasets/pose/test_img
mkdir ~/volume/datasets/pose/test_densepose
mkdir ~/volume/results

# DensePose
git clone https://github.com/nishio-kun/DensePose.git
mkdir ~/DensePose/docker/input
mkdir ~/DensePose/docker/output

# vid2vid
git clone https://github.com/nishio-kun/vid2vid.git
