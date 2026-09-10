#!/bin/bash
set -e -o pipefail
git clone https://github.com/linkease/istore.git package/istore

#清除登录密码
sed -i 's/^root:.*$/root:::0:99999:7:::/' package/base-files/files/etc/shadow
#更新golang
rm -rf feeds/packages/lang/golang
git clone --depth=1 -b 26.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
./scripts/feeds install -a

# 同步仓库内维护的 patches 目录到 OpenWrt 源码树
if [ -d "$GITHUB_WORKSPACE/patches/6.6" ]; then
  echo "[diy] 同步自定义 patches/6.6 目录到源码树"
  cp -rf "$GITHUB_WORKSPACE/patches/6.6/." ./
else
  echo "[diy] patches/6.6 目录不存在，跳过"
fi
# 添加自定义软件包
EXTRA_PACKAGES="kmod-usb-storage kmod-usb-ohci kmod-usb-uhci kmod-fs-exfat kmod-fs-ntfs ntfs-3g kmod-wireguard wireguard-tools luci-app-wireguard luci-app-samba4 samba4 luci-app-sqm luci-app-statistics luci-app-ddns"
echo "EXTRA_PACKAGES+=\"$EXTRA_PACKAGES\"" >> .config
