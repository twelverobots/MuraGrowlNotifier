jQuery(document).ready(function($){
	$('#title').change(function(e){
		$("#preview div.jGrowl-header").html(e.target.value);
	});
	
	$('#message').change(function(e){
		$("#preview div.jGrowl-message").html(e.target.value);
	});
	
	$('#icon,#iconLink').click(function(e){
		e.preventDefault();
		$('#iconBox').slideDown();
		
		var iconBoxTimeout = setTimeout(function(){
			$('#iconBox').slideUp("fast");
		}, 2000);
		
		$('#iconBox').mouseenter(function(e){
			clearTimeout(iconBoxTimeout);
		});
		
		$('#iconBox').mouseleave(function(e){
			$('#iconBox').slideUp("fast");
		});
	});
	
	$('#iconBox img').click(function(e){
		var $img = $(e.target);

		$('#iconDisplay').attr({'src':$img.attr('src')})
		$('#icon').val($img.attr('src'));
		
		$(".jGrowl-notification").css({
			'background-image':"url(" + $img.attr('src') + ")",
			'background-repeat':'no-repeat',
			'background-position':'10px 10px',
			'padding-left':'60px'
		});				
	});
	
	$("#backgroundColor,#borderColor,#textColor").minicolors({
		change: function(hex, rgb) { 
			currentID = $(this).attr("id");
			if (currentID == "backgroundColor") {
				$(".jGrowl-notification").css({'background-color':hex});
			} else if (currentID == "borderColor") {
				$(".jGrowl-notification").css({'border':'1px solid ' + hex});
			} else if (currentID == "textColor") {
				$(".jGrowl-notification").css({'color': hex});
			}
		}
	});
	
	$('.deleteButton').bind('click', function(e){
		e.preventDefault();
		
		var confirm = confirmDialog('Delete Message?', function(){
			$.ajax({
				type: 'POST',
				url: '#pluginPath#/RemoteProxy.cfm',
				data: {
					messageid: e.target.id.split("_")[1],
					action: "deleteMessage"
				},
				success: function(data, textStatus){
					if (data.success == true) {
						$('.success').html(data.message).fadeIn();
						
						setTimeout(function(){
							$('.success').fadeOut();
						}, 3000);
						$(e.target).parent().parent().slideUp(1000);
					} else {

						$.each(data.errors, function(i, n){
							$('.error').append(n.MESSAGE + "<br />");
						})
						$('.error').fadeIn();
						
						setTimeout(function(){
							$('.error').fadeOut();
						}, 3000);
					}
				}
			});
		});
	})

	$('.editButton').bind('click', function(e){
		e.preventDefault();
		
		var id = e.target.id.split("_")[1];
		
		$('#messageid').val(id);
		
		$.ajax({
			url: '#pluginPath#/RemoteProxy.cfm?messageid=' + id,
			type: 'GET',
			dataType: 'json',
			success: function(data, textStatus) {
				$('#title').val(data.title);
				$('#message').val(data.message);
				$('#startToDisplay').val(dateFormat(data.startToDisplay));
				$('#displayUntil').val(dateFormat(data.displayUntil));
				$('input[value="' + data.theme + '"]').attr("checked", true);
				$('#backgroundColor').val(data.backgroundColor);
				$('#borderColor').val(data.borderColor);
				$('#textColor').val(data.textColor);
				$('img[src="' + data.icon + '"]').click();
				$('#active').children().filter(function(index){
					return $(this).val() == data.active;
				}).attr("selected", true);
				
				$('input[name="theme"]').filter(':checked').change();
				$('#title,#message').change();
				
				if (data.theme == "custom") {
					$('#backgroundColor').minicolors("value", data.backgroundColor);
					$('#borderColor').minicolors("value", data.borderColor);
					$('#textColor').minicolors("value", data.textColor);
				}
			}
		})
						
		
		$('#submit').val("Edit Motifier Message");
	})
	
	$('.resetButton').bind('click', function(e){
		e.preventDefault();
		
		clearForm();
		
		$('#submit').val("Add Notifier Message");
	});
	$('#messageid').val(0);
	$("#OKMsg").fadeOut(2000);
	
	var currentStyle = "";
	
	$('input[name="theme"]').change(function(e){
		var $notifier = $('.jGrowl-notification');
		var newStyle = $(e.target).val();
		
		if (newStyle == "custom") {
			$('#customSettings').slideDown();
			$('#backgroundColor').attr("required", true);
			$('#borderColor').attr("required", true);$
			$('#textColor').attr("required", true);
			$("#backgroundColor,#borderColor").minicolors("value", "#000000");
			$("#textColor").minicolors("value", "#ffffff");
		} else {
			clearStyles();	
			$('#backgroundColor').attr("required", false);
			$('#borderColor').attr("required", false);$
			$('#textColor').attr("required", false);
			$('#customSettings').slideUp();
		}
		
		$notifier.removeClass(currentStyle);
		$notifier.addClass(newStyle)
		currentStyle = newStyle;
	})
	
	$('input[name="theme"]').filter(':checked').change();
	$('#title,#message').change();
});

function clearStyles($notifier) {
	jQuery("#backgroundColor,#borderColor,#textColor").minicolors('value','#ffffff');
	
	jQuery('.jGrowl-notification').css({
		'background-image':'',
		'background-color':'',
		'background-position':'',
		'color':'',
		'padding-left':'',
		'background-repeat':'',
		'border':''
	});
	

	jQuery('#backgroundColor,#borderColor,#textColor').val('');
	jQuery('#iconDisplay').replaceWith('<img id="iconDisplay" src="" />');
	jQuery('#icon').val('');
	
}

function clearForm() {
	
	jQuery('#title,#message,#startToDisplay,#displayUntil').val('').change();
	jQuery("#defaultTheme").attr("checked", true).change();
	jQuery('#active').children().filter(function(index){
		return jQuery(this).val() == 1;
	}).attr("selected", true);
	
	jQuery('#messageid').val(0);
	
	clearStyles();
	
	jQuery('.error').fadeOut();

}

function dateFormat(date) {
	var oldDate = new Date(date);
	var newDate = "";
	
	newDate = newDate + oldDate.getMonth()+1 + "/" + oldDate.getDate() + "/" + oldDate.getFullYear();
	
	return newDate;
}