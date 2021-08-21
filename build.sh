#!/usr/bin/env sh

curl https://raw.githubusercontent.com/jcarr132/cv2/main/public/index.html > ./static/docs/jcarr_cv.html
curl https://raw.githubusercontent.com/jcarr132/cv2/main/public/jcarr_cv.pdf > ./static/docs/jcarr_cv.pdf
hugo
