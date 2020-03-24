cd ~

mov=$1
if [[ $mov =~ ^.+/movie/([^/.]+)\..+$ ]]; then
  name=${BASH_REMATCH[1]}
else
  echo 'usage: ~/movie/<name>.<ext>'
  exit 1
fi

input_path=DensePose/docker/input/
output_path=DensePose/docker/output/

# mov to img
filename_ffmpeg=${input_path}${name}_%05d.jpg
ffmpeg -i $mov -vcodec mjpeg $filename_ffmpeg

# DensePose
sudo docker build -t densepose -f ~/DensePose/docker/Dockerfile .
sudo nvidia-docker run -v ~/${output_path}:/densepose/DensePoseData/output/ -it densepose bash main.sh
cp ${input_path}* volume/datasets/pose/test_img/
cp ${output_path}*_IUV.png volume/datasets/pose/test_densepose/

# vid2vid
sudo docker build -t vid2vid -f ~/vid2vid/docker/Dockerfile .
sudo nvidia-docker run -v ~/volume:/vid2vid/volume -it vid2vid python test.py \
  --name pose2body_256p --dataroot volume/datasets/pose --dataset_mode pose \
  --ngf 64 --input_nc 3 --resize_or_crop scaleHeight --loadSize 256 \
  --no_first_img --densepose_only --results_dir volume/results \
  --checkpoints_dir volume/checkpoints

# clean
zip ${name} volume/results/pose2body_256p/test_latest/test_img/*
zip ${name}_dense ${output_path}*

rm ${input_path}*
rm -f ${output_path}*
rm volume/datasets/pose/test_img/*
rm volume/datasets/pose/test_densepose/*
sudo rm -rf volume/results/*
