<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅</title>
</head>
<body>
	<h1>채팅</h1>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

	<script>
		function Chat__addMessage(form) {
			form.writer.value = form.writer.value.trim();
			if (form.writer.value.length == 0) {
				alert('작성자를 입력해주세요.');
				form.writer.focus();
				return false;
			}
			form.body.value = form.body.value.trim();
			if (form.body.value.length == 0) {
				alert('내용을 입력해주세요.');
				form.body.focus();
				return false;
			}
			$.post(
				'./addMessage',
				{
					writer: form.writer.value,
					body: form.body.value
				},
				function(data) {
					
				},
				'json'
			);
			form.body.value = '';
			form.body.focus();
		}
		var Chat__lastReceivedMessageId = -1;
		function Chat__loadNewMessages() {
			$.get(
				'./getMessages',
				{
					from:Chat__lastReceivedMessageId + 1
				},
				function(data) {
					for ( var i = 0; i < data.length; i++ ) {
						var message = data[i];
						Chat__lastReceivedMessageId = message.id;
						Chat__drawMessage(message);
					}
					setTimeout(Chat__loadNewMessages, 100);
				},
				'json'
			);
		}
		function Chat__drawMessage(message) {
			var html = '[' + message.id + '번](' + message.writer + ') : ' + message.body;
			$('.chat-messages').prepend('<div>' + html + '</div>');
		}
		$(function() {
			/*
			var chatMessage = {};
			chatMessage.id = 0;
			chatMessage.writer = '홍길동';
			chatMessage.body = '안녕!!!';
			Chat__drawMessage(chatMessage);
			chatMessage.id = 1;
			chatMessage.writer = '홍길순';
			chatMessage.body = '반가워';
			Chat__drawMessage(chatMessage);
			*/
			Chat__loadNewMessages();
		});
	</script>

	<form onsubmit="Chat__addMessage(this); return false;">
		<input autocomplete="off" type="text" name="writer" placeholder="작성자" /> <input
			type="text" name="body" placeholder="내용" autocomplete="off" /> <input type="submit"
			value="작성" />
	</form>

	<div class="chat-messages"></div>
</body>
</html>