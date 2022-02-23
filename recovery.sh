dir
apt install rclone
mkdir -p ~/.config/rclone
echo "$rcloneconfig" > ~/.config/rclone/rclone.conf
cd ..
rm -rf recovery_xiaomi_vince
mkdir -p ~/.bin
PATH="${HOME}/.bin:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo

#-sync-#
mkdir twrp
cd twrp
repo init --depth=1 --no-repo-verify -u git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-9.0 -g default,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync
rm -rf device/xiaomi/vince 
git clone https://github.com/PitchBlackRecoveryProject/android_device_xiaomi_vince-pbrp.git -b android-9.0-new device/xiaomi/vince
. build/envsetup.sh && lunch omni_vince-eng && export ALLOW_MISSING_DEPENDENCIES=true && mka recoveryimage
cd $(pwd)/out/target/product/vince
rclone copy $(pwd)/recovery.img ccache:vince
