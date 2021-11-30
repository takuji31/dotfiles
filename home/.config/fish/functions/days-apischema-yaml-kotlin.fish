# Defined in /var/folders/9g/2zbs6ph55vb5bbtfdtn0pdk40000gn/T//fish.yOWCWR/days-apischema-yaml-kotlin.fish @ line 2
function days-apischema-yaml-kotlin
  cd /Users/takuji31/project/github.com/takuji31/APISchema-YAML-Converter
  carton exec -- perl -Ilib script/apischema2yaml.pl \
    --config ../../hatena/Giga-Usagi/config/core-apischema-yaml/config.yml \
    --schema ../../hatena/Giga-Usagi/config/core-apischema.pl \
    --out ../../hatena/Giga-Usagi/config/core-apischema-yaml/
  cd /Users/takuji31/project/ghe.admin.h/takuji31/APISchema-YAML
  make gen-kotlin  IN=../../../github.com/hatena/Giga-Usagi/config/core-apischema-yaml/ \
    OUT=./ TEMPLATE=../../../github.com/hatena/comicdays-android/apischema-yaml-template/
  chmod 644 GeneratedModels.kt
  cp GeneratedModels.kt ../../../github.com/hatena/comicdays-android/data/src/main/kotlin/network/
  rm GeneratedModels.kt
end
