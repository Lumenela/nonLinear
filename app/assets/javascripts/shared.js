$(function(){
	$('.nav>li>a').live('click', function(){
		$('.nav>li').removeClass('active');
		$(this).parent().addClass('active');
		var li=$(this).parent().attr('id');
		window.localStorage.setItem('li',li);

	});
	var nav = window.location.href.match(/\w+\.?\w*.$/).toString();
	$li = window.localStorage.getItem('li');

	if(nav.match($li)!= null){
		$('#'+$li).addClass("active");
	}


})
