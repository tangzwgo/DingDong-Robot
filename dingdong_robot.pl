#!/usr/bin/perl 

##### 全局变量不好吗？ 不就是为了你们设置方便一点吗 #####
# curl command(Steam App) 安装Stream抓包，获得https://maicai.api.ddxq.mobi/order/getMultiReserveTime 接口的参数
# 监控运力
$curl_string = "TODO:复制getMultiReserveTime CURL链接";
# 监控购物车
$curl_cart_string = "TODO:复制cart购物车的 CURL链接";
# chanify token，安装chanify做消息推送，获取token
$token = "TODO: 复制chanify token";


sub get_effective_products(){
	$cart_result =`$curl_cart_string`;
	#print($cart_result );
	$cart_result  =~m/"effective"(.*)"invalid"/;
	$product_raw = $1;
	$effective_products = "";
	$index = 1;
	while($product_raw =~m/"product_name":"([^"]+)"/g){
		$effective_products = $effective_products."($index)".$1;
		$index += 1;
	}
	return $effective_products;
}

sub push_message(){
	my($msg) = @_;
	print("msg: $msg\n");

	# sound=1 会有声音播报
	`curl --data "text=$msg&sound=1" "https://api.chanify.net/v1/sender/$token"`;
}

sub get_reserve_time(){
	$result = `$curl_string`;
	print($result);

	if($result=~m/"is_invalid":false/){
		print("\n运力空\n");
		return 1;
	}else{
		print("\n运力满\n");
		return 0;
	}	
}

while(TRUE){
	if(1 == &get_reserve_time()) {
		$products = &get_effective_products();
		if(not "" eq $products) {
			$message = "叮咚运力有空余, 有货：$products";
			&push_message($message);
		}else{
			print("叮咚运力有空余, 但购物车没货")
		}
		
	}
	sleep(15);
}


