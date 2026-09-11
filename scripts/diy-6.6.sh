#!/bin/bash
set -e -o pipefail
#清除登录密码，root默认无密码
sed -i 's/^root:.*$/root::0:99999:7:::/' package/base-files

# 不拉取istore，不引入golang，不添加任何额外插件
# git clone https://github.com/linkease/istore.git package/istore

# PACKAGES只保留基础LuCI网页界面，其余插件全部移除
PACKAGES="luci luci-base luci-mod-admin-full"
