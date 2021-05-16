#!/bin/bash
source hadk.env
cd $ANDROID_ROOT
source build/envsetup.sh 2>&1
virtualenv --python 2.7 ~/python27
source ~/python27/bin/activate
breakfast $DEVICE

echo "clean .repo folder"
rm -rf $ANDROID_ROOT/.repo

# hack for droidmedia
#echo 'DROIDMEDIA_32 := true' >> external/droidmedia/env.mk
echo 'FORCE_HAL:=1' >> external/droidmedia/env.mk
echo 'MINIMEDIA_AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk
echo 'AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk

make -j$(nproc --all) hybris-hal $(external/droidmedia/detect_build_targets.sh $PORT_ARCH $(gettargetarch)) \
 $(external/audioflingerglue/detect_build_targets.sh $PORT_ARCH $(gettargetarch))

# Add vince lost libs
cp device/xiaomi/vince/lostlibs/*.so out/target/product/vince/system/lib/
