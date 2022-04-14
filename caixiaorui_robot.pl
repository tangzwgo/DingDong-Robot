#!/usr/bin/perl 

# 菜小睿 库存监控

##### 全局变量不好吗？ 不就是为了你们设置方便一点吗 #####

# 菜小睿的商品比较少且固定，直接将商品ID写死，抓包找到getHomePageInfo或者getHomePageModuleData可以找到商品ID
%goodsList = (
	'1410462850132'=>'美天菜小睿优选方便菜套餐', 
	'1406012590132'=>'美天菜小睿蔬菜60元套餐', 
	'1401831840132'=>'美天菜小睿优选调料组合包'
);

# 复制skuInfo的curl，然后将里面的goodsId参数值用占位符替换 如：'\"goodsId\":1410462850132' => '\"goodsId\":'.$flag
$flag = '!GOODS_ID!';
$curl_string = 'TODO:复制skuInfo CURL链接';

# chanify token，安装chanify做消息推送，获取token
$token = "TODO: 复制chanify token";

sub push_message(){
	my($msg) = @_;
	print("\n[msg: $msg]\n");

	# sound=1 会有声音播报
	`curl --data "text=$msg&sound=1" "https://api.chanify.net/v1/sender/$token"`;
}

sub check_stock(){
	while( my ($goodsId, $goodsName) = each %goodsList ) {
		print("\n================$goodsName================\n");
		# 监控库存的接口
		$real_curl_string = $curl_string;
		$real_curl_string =~ s/$flag/$goodsId/;
		$result = `$real_curl_string`;
		print($result);
		if($result=~m/"errmsg":"处理成功"/ && $result=~m/"spuShowStock":[1-9]\d*/) {
			&push_message($goodsName . " 有库存")
		}

		sleep(5);
	}
}

while(TRUE){
	&check_stock();
}