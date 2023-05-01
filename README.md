Sui SDK for Unity

sui client publish --gas-budget 3000000000

COINPKG="0xa86234649f92eef9d463689fc5c4b47abebbba252a812d5bd40294d83685aecb"
CNYA="0xa86234649f92eef9d463689fc5c4b47abebbba252a812d5bd40294d83685aecb::cnya::CNYA"
CNYW="0xa86234649f92eef9d463689fc5c4b47abebbba252a812d5bd40294d83685aecb::cnyw::CNYW"
CNYACAP="0x628641f5b085ced2daaf371c87dfe52370236381310b14cab7c0c2440423b495"
CNYWCAP="0xe6fa78186075f9819d637af85ebf9f0aac487df72dbe91e144bcd7b70b472969"


sui client call --package $COINPKG \
--module cnya \
--function mint_coin \
--gas-budget 1000000000 \
--args $CNYACAP 100000000000

sui client call --package $COINPKG \
--module cnyw \
--function mint_coin \
--gas-budget 1000000000 \
--args $CNYWCAP 100000000000

AMMPKG="0x0566335a3003d85daaddeb9530ccb04da641e8d2316716a39013ffc883929548"

sui client call --package $AMMPKG \
--module interface \
--function create_pocket \
--gas-budget 1000000000

sui client call --package $AMMPKG \
--module interface \
--function generate_pool \
--gas-budget 1000000000 \
--type-args $CNYA $CNYW

POCKETID="0x1b63352990ba9a31994a4995360f94ffab729ef12c5f902ce27eec5af142e224"
POOLID="0xcf3a58a707f96ed78609e69aefbf1f3912b6b1ef10fd349221c3a1571683f427"

sui client call --package $AMMPKG \
--module interface \
--function deposit_totally \
--gas-budget 1000000000 \
--type-args $CNYA $CNYW \
--args $POOLID \
0x4ed8ebb365d82203ab33c7b3768ae6cf6a0c93a80891995b9a3df130c14792cf \
0x4e85afa70e9c8b09b41fdd181c7bf0772e4185ad69c110eff2cbbf7dd6de4ba6 \
$POCKETID


sui client call --package $AMMPKG \
--module interface \
--function deposit_partly \
--gas-budget 1000000000 \
--type-args $CNYA $CNYW \
--args $POOLID \
'["0x0d6fab6c80e36d2f827b2f3d55968c15d931a269","0x11ba673b62c81cfda7ec1cb57aad019d4d2884d6"]' \
'["0x5179f3173aae19f325631a88ba091b7dedd84a71","0x973dbc2b802f69901c84cb68bf5fe73f8e81797b"]' \
\"1500\" \"1400\" $POCKETID

sui client call --package $AMMPKG \
--module interface \
--function remove_liquidity_totally \
--gas-budget 1000000000 \
--type-args $CNYA $CNYW \
--args $POOLID \
0x65282e65c9c7a26e58662efec3f1ddbf7c09d6d0 \
$POCKETID

sui client call --package $AMMPKG \
--module interface \
--function withdraw_out \
--gas-budget 1000000000 \
--type-args $CNYA $CNYW \
--args $POOLID \
'["0x698525352089c408cfb68c5b1c52e320ad58d382f87049348b186f228145e267"]' \
\"170000000\" \"180000000\" $POCKETID

sui client call --package $AMMPKG \
--module liquidity \
--function swap_x_to_y \
--gas-budget 1000000000 \
--type-args $CNYA $CNYW \
--args $POOLID \
'["0x7f9d80bdbfef59100c6e9ba4185d8c01b986da99"]' \
2000000000


