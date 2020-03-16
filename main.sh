cd ~

mov=$1
if [[ $mov =~ ^.+/movie/([^/.]+)\..+$ ]]; then
  name=${BASH_REMATCH[1]}
else
  echo 'usage: ~/movie/<name>.<ext>'
fi

# mov to img
filename=DensePose/docker/input/${name}_%05d.jpg
ffmpeg -i $mov -vcodec mjpeg $filename

# DensePose
# sudo docker build -t densepose -f ~/DensePose/docker/Dockerfile .
# sudo nvidia-docker run -v ~/DensePose/docker/output:/densepose/DensePoseData/output/ -it densepose bash main.sh
# move

# vid2vid

